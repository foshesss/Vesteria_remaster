--[[
[VESTERIA]
-[Monster.lua]---------------
    The class representation of Monster. Used in
    monster_manager.lua

    [Definitions]:
        'Monster': In-script class that contains all monster data.
        'Manifest'/'Monster Manifest': Server representation of monster.
        'Client Entity': What the client sees.
        'spawnRegion': Individual parts that make up a region.
        'spawnRegionCollection': Collection of spawnRegions.


--]]

local SETTINGS = {

}

-- Object:
local Monster = {

}
Monster.__index = Monster

----- Utils -----
local EntityService = require("EntityService")

----- Global methods -----
function Monster.new(id, location, spawnRegionCollection, spawnRegion, other_info, init_callback)
    local monster = EntityService.GetEntityByID(id)
    local stats = monster.Stats or {} -- replace with default stats
    local client_render = monster.File.Model:Clone() -- TODO (?)

    local self = setmetatable({
        id = id,

        client_render = client_render,

        health = stats.MaxHealth, 
        -- TBA, still gotta read how they manage non-read only stats, like health

        _stats = stats -- read-only copy







    }, Monster)

    -- in the original vesteria, they seem to make
    -- some state machine, but it looks extremely confusing

    


    return self
end

function Monster:IsTargetEntityInLineOfSight()
    error("Unimplemented method")
end

function Monster:IsTargetEntityValid()
    error("Unimplemented method")
end

function Monster:GetRoamPositionInSpawnRegion()
    error("Unimplemented method")
    -- return GetPositionFromRegion(self._spawn_region)
end

function Monster:DropItem()
    error("Unimplemented method")
end

function Monster:SetTargetEntity()
    error("Unimplemented method")
end

function Monster:SetState()
    error("Unimplemented method")
end

function Monster:GetMass()
    error("Unimplemented method")
end

function Monster:ResetPathfinding()
    error("Unimplemented method")
end

function Monster:DropRewards()
    error("Unimplemented method")
end






return Monster