local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
[VESTERIA]
-[EntityService.lua]---------------
    Primarily used for the retrieval of monster information.

--]]

local SETTINGS = {

}

-- Module table:
local EntityService = {

}

----- Services -----
local ReplicatedStorage = game:GetService("ReplicatedStorage")

----- Folders -----
local Resources = ReplicatedStorage.Resources
local Info = Resources.Monster.Info

----- Private variables -----
local info = {

}

----- Global Methods -----
function EntityService.GetEntityByID(id)
    assert(id ~= nil and type(id) == 'number',  "[EntityService] Invalid id provided.")
    assert(#info > 0, "[EntityService] Info has likely not been initialized. (#info == 0)")
    assert(info[id] ~= nil, ("[EntityService] No information found for id '%d'"):format(id))

    return info[id]
end

-- Initialize:
for _, v in ipairs(Info:GetChildren()) do
    v = require(v)

    assert(v.id ~= nil, ("[EntityService] '%s' does not have an id."):format(v.Name))
    assert(info[v.id] == nil, ("[EntityService] ID overlap @ id '%d'."):format(v.id))

    info[v.id] = v
end

return EntityService