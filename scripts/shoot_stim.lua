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

local first_stim = nil

local shoot_stim =
	{
		name = STRINGS.MOD_DOC.ABILITIES.ABILITY_SHOOT_STIM,

		getName = function( self, sim, unit, userUnit )
			return self.name
		end,
	
		createToolTip = function( self,sim,unit,targetCell)
			return abilityutil.formatToolTip( STRINGS.MOD_DOC.ABILITIES.ABILITY_SHOOT_STIM,  STRINGS.MOD_DOC.ABILITIES.ABILITY_SHOOT_STIM_DESC, 1 )
		end,
	
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_stim_small.png",
		usesAction = true,

		isTarget = function( self, sim, userUnit, targetUnit )
			if simquery.isAgent( targetUnit ) and not targetUnit:isKO() and sim:canUnitSeeUnit( userUnit, targetUnit ) then
				return true
			end
			return false
		end,

		acquireTargets = function( self, targets, game, sim, unit, userUnit )
			local cell = sim:getCell( userUnit:getLocation() )
			local units = {}
			for _, unit in pairs( sim:getAllUnits() ) do
				if self:isTarget( sim, userUnit, unit ) then
					table.insert( units, unit )
				end
			end
	
			return targets.unitTarget( game, units, self, unit, userUnit )
		end, 

		canUseAbility = function( self, sim, unit, userUnit, targetCell )
			for _, item in pairs( userUnit:getChildren() ) do
				if item:hasAbility("use_stim")
				and not (item:getTraits().cooldown and item:getTraits().cooldown >= 1)
				and not (item:getTraits().usesCharges and item:getTraits().charges == 0)
				and not (item:getTraits().ammo and item:getTraits().ammo == 0)
				and not (item:getTraits().pwrCost and userUnit:getPlayerOwner():getCpus() < item:getTraits().pwrCost)
				then
					first_stim = item
					return true
				end
			end

			return false, STRINGS.MOD_DOC.ABILITIES.ABILITY_NO_STIM
		end,
		
		executeAbility = function( self, sim, unit, userUnit, targetCell )
			
		end,
	}
return shoot_stim
