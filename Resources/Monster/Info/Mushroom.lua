return table.freeze({
    id = 1,

    Name = "Mushroom",
    Level = 1,
	
    Stats = {
        Range = 2.5,
        WalkSpeed = 12,
        AttackSpeed = 4,
        MaxHealth = 6,
        Damage = 2,
        Defense = 0
    },
	
    -- Rewards on death, always occurs
	Rewards = {
        XP = 3,
        Gold = 5
    },

    -- Drops on death, chance-by-chance basis
    Drops = {
        {
            id = 1,
            Rate = 1/2
        }
    },

	-- no idea what this does OMEGALUL
	damageHitboxCollection = {
		{partName = "Cap"; castType = "box"; originOffset = CFrame.new(0, 0.5, 0)};
	},

    File = {
        Model = "Resources.Monster.Model"
    }
})