local Encyclopedia = _G.Encyclopedia
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

----- Services -----
local EntityService = require("EntityService")
local ServerStorage = game:GetService("ServerStorage")

----- Utils -----

----- Global methods -----
function Monster.new(id, location, spawnRegionCollection, spawnRegion, other_info, post_init_callback)
    local monster = EntityService.GetEntityByID(id)
    local stats = monster.Stats or {} -- replace with default stats
    local client_render = Encyclopedia.TraversePath(ServerStorage, monster.File.Model)

    -- setup hitbox
    local hitbox = client_render.Hitbox
    hitbox.Name = monster.id
    hitbox:SetAttribute("ID", id)

    local self = setmetatable({
        id = id,

        client_render = client_render,
        hitbox = hitbox,

        health = stats.MaxHealth,
        -- TBA, still gotta read how they manage non-read only stats, like health

        _stats = stats -- read-only copy
    }, Monster)

    -- in the original vesteria, they seem to make
    -- some state machine, but it looks extremely confusing

    if post_init_callback ~= nil then
        post_init_callback(self)
        --[[
        Example: post_init_callback function:

            function(monster)
                self.manifest:GetAttributeChangedSignal("Color"):Connect(function()
                    -[
                    set monster's color to something else
                    -]
                end)
            end
        --]]
    end


    -- fire event that monster is spawning
    -- add this to some monster collection

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