local array = include( "modules/array" )
local util = include( "modules/util" )
local mathutil = include( "modules/mathutil" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local inventory = include("sim/inventory")
local speechdefs = include("sim/speechdefs")
local abilityutil = include( "sim/abilities/abilityutil" )
local mathutil = include( "modules/mathutil" )
local unitdefs = include("sim/unitdefs")
local simfactory = include( "sim/simfactory" )
local itemdefs = include("sim/unitdefs/itemdefs")
local guarddefs = include("sim/unitdefs/guarddefs")
local propdefs = include("sim/unitdefs/propdefs")

local activate_injected_dose =
	{
		name = STRINGS.MOD_DOC.ABILITIES.ABILITY_ACTIVATE_INJECTED_DOSE_NAME,

		getName = function( self, sim, unit, userUnit )
			return self.name
		end,

        unitDataHasAbility = function( unitData, abilityID )
            if unitData.abilities then
                for i,ability in ipairs(unitData.abilities) do
                    if ability:getID() == abilityID then
                        return true
                    end
                end
            end
        
            return false
        end,
	
		createToolTip = function( self, sim, abilityOwner, abilityUser, targetUnitID )
            local targetUnit = sim:getUnit( targetUnitID )
            local unitData = targetUnit:getTraits().drugpistoldose
            if self:unitDataHasAbility(unitData, "use_medgel") then self.profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_stim_small.png"
            elseif self:unitDataHasAbility(unitData, "use_aggression") then self.profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_defibulator_small.png"
            else self.profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_stim_small.png"
            end
			return (STRINGS.MOD_DOC.ABILITIES.ABILITY_ACTIVATE_INJECTED_DOSE_ACTIVATE .. unitData.name)
		end,
	
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_stim_small.png",
        canUseWhileDragging = true,
        proxy=true,

		isTarget = function( self, sim, userUnit, targetUnit )
			if targetUnit:getTraits().drugpistoldose then
                return true
            end
		end,

		acquireTargets = function( self, targets, game, sim, unit, userUnit )
			local units = {}
			for _, unit in pairs( sim:getAllUnits() ) do
				if self:isTarget( sim, userUnit, unit ) then
					table.insert( units, unit )
				end
			end
	
			return targets.unitTarget( game, units, self, unit, userUnit )
		end, 

		canUseAbility = function( self, sim, unit, userUnit, targetCell )
			return true
		end,
		
		executeAbility = function( self, sim, unit, userUnit, targetUnitID )
            local targetUnit = sim:getUnit( targetUnitID )
            local unitData = targetUnit:getTraits().drugpistoldose
            --newUnit = simfactory.createUnit( unitData, sim )
            --sim:spawnUnit( newUnit )
            --self:doInjection( sim, newUnit, userUnit, targetUnitID )
        end
	}
return activate_injected_dose
