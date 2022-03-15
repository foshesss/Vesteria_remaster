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
    Default_Stats = {

    },
    Attack_Enums = {
        Physical = 1,
        Projectile = 2
    }
}

-- Object:
local Monster = { -- setting up some base stats
    healthMulti = 1,
    bonusXPMulti = 1,
    damageMulti = 1,
    goldMulti = 1,
    bonusLootMulti = 1,

    IsAggressive = true,
        --[[ 
        isAggressive Key:
            true:   attacks regardless
            false:  attacks only when attacked
        --]]
    AggressionRange = 35, -- how close before monster aggros
    AttackRange = 10, -- how close a monster will try to get near you
    AttackSpeed = 10, -- time in seconds between each attack

    VisionAngle = math.rad(75), -- eyesight angle PogU
    SightRange = 200, -- how close a player must be for monster to continue tracking
    AttackType = SETTINGS.Attack_Enums.Physical
    Level = 1, -- default level of monsters
    PlayerFollowDistance = 50, -- furthest a monster will travel from first player interaction
    WalkSpeed = 10
}
Monster.__index = Monster

----- Services -----
local Lighting = game:GetService("Lighting")
local ServerStorage = game:GetService("ServerStorage")

local EntityService = require("EntityService")

----- Folder -----
local Buffs_Folder = script.Buffs_Folder

----- Private variables -----
local Buffs = {

}

----- Private functions -----
local function isNightTime()
    return Lighting.ClockTime < 5.9 or Lighting.ClockTime > 18.6
end

----- Utils -----

----- Global methods -----
function Monster.new(id, location, spawnRegionCollection, spawnRegion, other_stats, post_init_callback)
    local monster = EntityService.GetEntityByID(id)

    local self = setmetatable({
        id = id
    }, Monster)

    self:_init(
        monster, 
        location, 
        spawnRegionCollection, 
        spawnRegion, 
        other_stats, 
        post_init_callback
    )

    return self
end

function Monster:_init(monster, location, spawnRegionCollection, spawnRegion, other_stats, post_init_callback)
    if self._initialized == true then
        return
    end
    self._initialized = true

    local stats = monster.Stats or SETTINGS.Default_Stats -- replace with default stats
    local client_render, hitbox

    do -- create render/hitbox
        client_render = Encyclopedia.TraversePath(
            ServerStorage, 
            monster.File.Model
        )

        hitbox = client_render.Hitbox
        hitbox.Name = monster.id
        hitbox:SetAttribute("id", id)

        self.client_render = client_render
        self.hitbox = hitbox
    end

    -- set stats to our boy
    for k, v in pairs(stats) do
        self[k] = v
    end

    --[[
        TODO:
            - Implement a state machine for this dude. Use Encyclopedia,
            not a remake of their bootleg ass one
    --]]

    do -- handle nighttime spawns
        if isNightTime() == true then
            self.nightBoosted = true
            self.Level += 1
    
            for k, v in pairs(Buffs.Nighttime) do
                self[k] *= v
            end
        end
    end

    do -- handle giants (all giants are mutually exclusive)
        -- set to giga giant
        if monster.GigaGiant == true then
            monster.ENRAGED = true

            -- adjust level/scale
            monster.Scale = 5
            monster.Level += 3

            -- adjust multipliers
            monster.bonusLootMulti = 30
            for k, v in pairs(Buffs.GigaGiant) do
                self[k] *= v
            end

        elseif monster.CanBeScaled == true and monster.Boss == false then
            -- set to supergiant
            if monster.SuperGiant == true and rand:NextInteger(1, 7500) == 7 then
                monster.SuperGiant = true
                monster.ENRAGED = true

                -- adjust level/scale
                monster.Scale = 3
                monster.Level += 2

                -- adjust multipliers
                monster.bonusLootMulti = 20
                for k, v in pairs(Buffs.SuperGiant) do
                    self[k] *= v
                end

            -- set to giant
            elseif monster.Giant == true and rand:NextInteger(1, 750) == 7 then
                monster.Giant = true
                monster.ENRAGED = true

                -- adjust level/scale
                monster.Scale = 2
                monster.Level += 1

                -- adjust multipliers
                monster.bonusLootMulti = 10
                for k, v in pairs(Buffs.Giant) do
                    self[k] *= v
                end
            end
        end

        if monster.Giant == true or monster.SuperGiant == true or monster.GigaGiant == true then
            hitBox:SetAttribute("Resilient", true)
        end
    end
    
    do -- adjust stats basic on labeled conditions
        if monster.Scale == nil then
            monster.Scale = 1 + rand:NextInteger(-5,5)/100
        end
    
        monster.AttackRange *= monster.Scale
    
        hitbox.Size *= monster.Scale
        hitbox:SetAttribute("Scale", monster.Scale)
    
        monster.MaxHealth *= monster.healthMulti
        monster.Health = monster.MaxHealth
        monster.Damage *= monster.damageMulti
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

function Monster:HasAttribute(attribute)
    if attribute == "Enraged" then
        return self.ENRAGED
    end

    return true
end

-- Initialize:
Monster.DetectionFromOutOfVisionRange = Monster.AttackRange * 1.5
for _, v in ipairs(Buffs_Folder:GetChildren()) do
    Buffs[v.Name] = require(v)
end

return Monster