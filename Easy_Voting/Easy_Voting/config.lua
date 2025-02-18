Config = {}

Config.Parties = {  -- List of parties players can vote for
    {name = "Example A", description = "Description A"},
    {name = "Example B", description = "Description B"},
    {name = "Example C", description = "Description C"},
    {name = "Example D", description = "Description D"},

}

Config.VoteLocations = {
    vector3(-545.4446, -203.8230, 37.2152)
}

Config.Language = "de"  -- Language: "de" for German, "en" for English

-- Date in Format TT.MM.JJJJ
Config.VoteStartDate = "18.02.2025"    -- Start date of the election
Config.ResultsDate   = "19.02.2025"    -- Date when results will be released

-- Marker configs
Config.Marker = {
    type = 1,          -- Marker-Typ (z.B. 1)
    scale = vector3(1.0, 1.0, 1.0), 
    color = {r = 255, g = 255, b = 0, a = 150}
}

Config.Debug = false -- Setze auf false, um Debug-Logs zu deaktivieren



