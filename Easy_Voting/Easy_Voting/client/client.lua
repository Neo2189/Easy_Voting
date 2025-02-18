ESX = exports["es_extended"]:getSharedObject()

local hasVoted = false
local nuiVisible = false

-- Sprache aus der Config
local language = Config.Language or "de"
local L = Locales[language]

RegisterCommand("vote", function()
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

-- Anzeige des Markers, konfiguriert über Config.Marker
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, location in ipairs(Config.VoteLocations) do
            if #(playerCoords - location) < 5.0 then
                DrawMarker(
                    Config.Marker.type, 
                    location.x, location.y, location.z, 
                    0.0, 0.0, 0.0, 
                    0.0, 0.0, 0.0, 
                    Config.Marker.scale.x, Config.Marker.scale.y, Config.Marker.scale.z, 
                    Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a, 
                    false, false, 2, false, nil, nil, false
                )
                if IsControlJustReleased(0, 38) then -- E drücken
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
        print("[DEBUG] Client triggered vote event with party:", party)
    end

    TriggerServerEvent("wahl:vote", party)
end)
