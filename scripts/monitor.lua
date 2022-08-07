local array = include( "modules/array" )
local util = include( "modules/util" )
local cdefs = include( "client_defs" )
local simdefs = include("sim/simdefs")
local simquery = include("sim/simquery")
local abilityutil = include( "sim/abilities/abilityutil" )

local monitor =
{
	name = STRINGS.MOD_DOC.ABILITIES.ABILITY_MONITOR,

	getName = function( self, sim, abilityOwner, abilityUser, targetUnitID )
		return self.name
	end,

	onSpawnAbility = function( self, sim, unit )
		self.abilityOwner = unit
		sim:addTrigger( simdefs.TRG_START_TURN, self )
		sim:addTrigger( simdefs.TRG_END_TURN, self )
	end,
		
	onDespawnAbility = function( self, sim, unit )
		sim:removeTrigger( simdefs.TRG_START_TURN, self )
		sim:removeTrigger( simdefs.TRG_END_TURN, self )
		self.abilityOwner = nil
	end,
	
	profile_icon = nil,

	canUseAbility = function( self, sim, abilityOwner, unit )
		return abilityutil.checkRequirements( abilityOwner, abilityUser )
	end,
	
	onTrigger = function( self, sim, evType, evData )
		if self.abilityOwner and evData and evData:isPC() and not self.abilityOwner:isKO() then
			local player = self.abilityOwner:getPlayerOwner()
			for _, unit in pairs( sim:getAllUnits() ) do
				if unit:isKO() and not unit:getTraits().noghost then
					newcell = sim:getCell( unit:getLocation() )
					if not sim:canPlayerSee( player, newcell.x, newcell.y ) then
						sim:getPC():glimpseUnit( sim, unit:getID() )
					end
				end
			end
		end
	end,
}
return monitor