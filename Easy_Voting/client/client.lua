ESX = exports["es_extended"]:getSharedObject()

local hasVoted = false
local nuiVisible = false

local language = Config.Language or "de"
local L = Locales[language]

RegisterCommand("wahl", function()
    ESX.TriggerServerCallback('wahl:checkVoteStatus', function(voteOpen, message)
        if not voteOpen then
             lib.alertDialog({
                 title = L.dialog_title_hint,
                 content = message,
                 centered = true,
             })
             return
        end

        if not hasVoted then
            local options = {}
            for _, party in ipairs(Config.Parties) do
                table.insert(options, {
                    title = party.name,
                    description = party.description or "",
                    arrow = true,
                    event = 'wahl:vote',
                    args = { party = party.name }
                })
            end

            lib.registerContext({
                id = 'vote_menu',
                title = L.vote_menu_title,
                options = options,
                onSelect = function(selected)
                    TriggerServerEvent("wahl:vote", selected.args.party)
                    hasVoted = true
                end
            })

            lib.showContext('vote_menu')
        else
             lib.alertDialog({
                 title = L.dialog_title_hint,
                 content = L.already_voted
             })
        end
    end)
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, location in ipairs(Config.VoteLocations) do
            if #(playerCoords - location) < 5.0 then
                DrawMarker(1, location.x, location.y, location.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 0, 150, false, false, 2, false, nil, nil, false)
                if IsControlJustReleased(0, 38) then 
                    TriggerServerEvent("wahl:checkResultsAvailability")
                end
            end
        end
    end
end)

RegisterNetEvent("wahl:showResults")
AddEventHandler("wahl:showResults", function(data)
    SendNUIMessage({
        action = "showResults",
        results = data.results or nil,
        releaseDate = data.releaseDate or Config.ResultsDate,
        electionResultsTitle = L.election_results_title,
        resultsAvailableFrom = L.results_available_from
    })
    SetNuiFocus(true, true)
    nuiVisible = true
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    nuiVisible = false
end)

RegisterNetEvent("wahl:vote")
AddEventHandler("wahl:vote", function(party)
    if type(party) == "table" then
        party = party.party
    end

    if Config.Debug then
        print("[DEBUG] Client hat Wahl-Event ausgelöst mit Partei:", party)
    end

    TriggerServerEvent("wahl:vote", party)
end)
