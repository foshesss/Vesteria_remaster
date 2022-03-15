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
local Monster = { -- setting up some base stats
    healthMulti = 1,
    bonusXPMulti = 1,
    damageMulti = 1,
    goldMulti = 1,
    bonusLootMulti = 1,
    attackRange = 1
}
Monster.__index = Monster

----- Services -----
local Lighting = game:GetService("Lighting")
local ServerStorage = game:GetService("ServerStorage")

local EntityService = require("EntityService")

----- Utils -----

----- Global methods -----
function Monster.new(id, location, spawnRegionCollection, spawnRegion, other_stats, post_init_callback)
    local monster = EntityService.GetEntityByID(id)
    local stats = monster.Stats or {} -- replace with default stats
    local client_render = Encyclopedia.TraversePath(ServerStorage, monster.File.Model)

    -- setup hitbox
    local hitbox = client_render.Hitbox
    hitbox.Name = monster.id
    hitbox:SetAttribute("id", id)

    local self = setmetatable({
        id = id,

        -- monster model
        scale = 1,
        client_render = client_render,
        hitbox = hitbox,

        -- monster stats
        health = stats.MaxHealth,
    }, Monster)

    -- set stats to our boy
    for k, v in pairs(stats) do
        self[k] = v
    end

    -- in the original vesteria, they seem to make
    -- some state machine, but it looks extremely confusing

    -- handle nighttime spawns
    if Lighting.ClockTime < 5.9 or Lighting.ClockTime > 18.6 then
        self.nightBoosted = true

        -- adjust multipliers
        self.level += 1
        self.healthMulti *= 1.25
        self.damageMulti *= 1.25
        self.bonusXPMulti *= 1.25
        self.bonusLootMulti *= 1.25
        self.goldMulti *= 1.25

        -- adjust stats
        self.aggressionRange *= 2
        self.attackSpeed *= .8
        self.playerFollowDistance *= 2
        self.baseSpeed *= 1.1
        self.attackRange *= 1,1
        self.detectionFromOutOfVisionRange *= 2
        self.visionAngle *= 1.25
    end


    -- no idea what this might be for, but i'll look for examples
    if other_stats ~= nil then
        for k, v in pairs(other_stats) do
            self[k] = v
        end
    end


    -- potentially used for setting attributes of client model (?)
    -- EX: changing color
    if post_init_callback ~= nil then
        post_init_callback(self)
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