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
		
		executeAbility = function( self, sim, unit, userUnit, targetUnitID )
			local sim = unit:getSim()
			local targetUnit = sim:getUnit( targetUnitID )

			local x0,y0 = userUnit:getLocation()
			local x1,y1 = targetUnit:getLocation()
		
			local oldFacing = userUnit:getFacing()
			local newFacing = simquery.getDirectionFromDelta(x1-x0, y1-y0)
			simquery.suggestAgentFacing(userUnit, newFacing)

			if userUnit:isValid() and not userUnit:getTraits().interrupted then
				if (userUnit:getID() ~= targetUnitID) then
					local oldWeapon = simquery.getEquippedGun( userUnit )
					unit:getTraits().slot = "gun"
					inventory.equipItem( userUnit, unit )
					sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = userUnit } )
					
					local pinning, pinnee = simquery.isUnitPinning(userUnit:getSim(), userUnit)
					
					sim:dispatchEvent( simdefs.EV_UNIT_START_SHOOTING, { unitID = userUnit:getID(), newFacing=newFacing, oldFacing=oldFacing, targetUnitID = targetUnit:getID(), pinning=pinning } )

					local dmgt = abilityutil.createShotDamage( unit, userUnit )
					local evData = { unitID = userUnit:getID(), x0 = x0, y0 = y0, x1=x1, y1=y1, dmgt = dmgt } 	
		
					sim:dispatchEvent( simdefs.EV_UNIT_SHOT, evData )
					sim:dispatchEvent( simdefs.EV_UNIT_STOP_SHOOTING, { unitID = userUnit:getID(), facing=newFacing, pinning=pinning} )

					inventory.unequipItem( userUnit, unit )
					unit:getTraits().slot = nil
					
					if (oldWeapon) then
						inventory.equipItem( userUnit, oldWeapon )
						oldWeapon = nil
					end

					sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = userUnit } )
					
					sim:processReactions()
				else
					sim:dispatchEvent( simdefs.EV_UNIT_HEAL, { unit = userUnit, target = targetUnit, revive = false, facing = newFacing } )
					sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit = targetUnit  } )
				end

				--Functionalities
				targetUnit:getTraits().drugpistoldose = first_stim.unitData.name

				if first_stim:getTraits().disposable then 
					inventory.trashItem( sim, userUnit, first_stim )
				else
					inventory.useItem( sim, userUnit, first_stim )
				end
			end
			if userUnit:isValid() and not userUnit:getTraits().interrupted then
				simquery.suggestAgentFacing(userUnit, newFacing)
			end
		end,
	}
return shoot_stim
