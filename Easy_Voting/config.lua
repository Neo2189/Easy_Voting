Config = {}

Config.Parties = {  -- List of parties players can vote for
    {name = "ParteiA", description = "Beschreibung A"},
    {name = "ParteiB", description = "Beschreibung B"},
    {name = "ParteiC", description = "Beschreibung C"}
}

Config.VoteLocations = {
    vector3(-545.4446, -203.8230, 38.2152)
}

Config.Language = "en"  -- Language: "de" for German, "en" for English

-- Datum im Format TT.MM.JJJJ
Config.VoteStartDate = "18.02.2025"    -- Start date of the election
Config.ResultsDate   = "20.02.2025"    -- Date when results will be released

Config.Debug = false -- Setze auf false, um Debug-Logs zu deaktivieren
