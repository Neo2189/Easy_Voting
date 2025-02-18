ESX = exports["es_extended"]:getSharedObject()

function ConvertDateToTimestamp(dateString)
    local day, month, year = dateString:match("(%d+)%.(%d+)%.(%d+)")
    return os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = 0, min = 0, sec = 0})
end

local voteStartTimestamp = ConvertDateToTimestamp(Config.VoteStartDate)
local resultsTimestamp   = ConvertDateToTimestamp(Config.ResultsDate)

ESX.RegisterServerCallback('wahl:checkVoteStatus', function(source, cb)
    local currentTime = os.time()
    local language = Config.Language or "de"
    
    if not voteStartTimestamp or not resultsTimestamp then
        cb(false, "Fehler: Ungültige Wahl-Daten!")
        return
    end

    if currentTime < voteStartTimestamp then
        cb(false, string.format(vote_not_started, Config.VoteStartDate))
    elseif currentTime > resultsTimestamp then
        cb(false, vote_ended)
    else
        cb(true, "")
    end
end)

RegisterNetEvent("wahl:vote")
AddEventHandler("wahl:vote", function(party)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then
        if Config.Debug then
            print("[DEBUG] [Wahl] Kein Spieler gefunden für source: " .. tostring(_source))
        end
        return
    end

    local identifier = xPlayer.identifier
    if Config.Debug then
        print(string.format("[DEBUG] [Wahl] Spieler %s (ID: %s) wählt Partei: %s", identifier, _source, party))
    end

    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM votes WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(count)
        if Config.Debug then
            print("[DEBUG] [Wahl] Abfrage für Spieler " .. identifier .. " ergab: " .. tostring(count))
        end
        if count and count > 0 then
            TriggerClientEvent("esx:showNotification", _source, "You already voted!")
        else
            MySQL.Async.execute('INSERT INTO votes (identifier, party) VALUES (@identifier, @party)', {
                ['@identifier'] = identifier,
                ['@party'] = party
            }, function(affectedRows)
                if Config.Debug then
                    if affectedRows and affectedRows > 0 then
                        print("[DEBUG] [Wahl] Stimme für " .. identifier .. " erfolgreich gespeichert (" .. affectedRows .. " betroffene Zeilen).")
                    else
                        print("[DEBUG] [Wahl] Fehler beim Speichern der Stimme für " .. identifier)
                    end
                end
                TriggerClientEvent("esx:showNotification", _source, affectedRows and affectedRows > 0 and "Deine Stimme wurde gezählt!" or "Fehler beim Speichern der Stimme!")
            end)
        end
    end)
end)

RegisterNetEvent("wahl:checkResultsAvailability")
AddEventHandler("wahl:checkResultsAvailability", function()
    local _source = source
    local currentTime = os.time()
    if currentTime >= resultsTimestamp then
        local totalVotes = {}
        for _, party in ipairs(Config.Parties) do
            totalVotes[party.name] = 0
        end

        MySQL.Async.fetchAll('SELECT party, COUNT(*) as count FROM votes GROUP BY party', {}, function(result)
            local total = 0
            for _, row in ipairs(result) do
                if totalVotes[row.party] ~= nil then
                    totalVotes[row.party] = tonumber(row.count)
                    total = total + tonumber(row.count)
                end
            end

            local results = {}
            for party, count in pairs(totalVotes) do
                local percentage = (total > 0) and math.floor((count / total) * 100) or 0
                table.insert(results, {name = party, percentage = percentage})
            end

            if Config.Debug then
                print("[DEBUG] [Wahl] Wahlergebnisse gesendet an Spieler " .. _source)
            end

            TriggerClientEvent("wahl:showResults", _source, {results = results})
        end)
    else
        TriggerClientEvent("wahl:showResults", _source, {results = {}, releaseDate = Config.ResultsDate})
    end
end)
