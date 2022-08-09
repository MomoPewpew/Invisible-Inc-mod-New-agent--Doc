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
	
		createToolTip = function( self, sim, abilityOwner, abilityUser, targetUnitID )
            local targetUnit = sim:getUnit( targetUnitID )
            local unitData = targetUnit:getTraits().drugpistoldose
			return (STRINGS.MOD_DOC.ABILITIES.ABILITY_ACTIVATE_INJECTED_DOSE_ACTIVATE .. unitData.name)
		end,
	
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_stim_small.png",
        canUseWhileDragging = true,
        proxy=true,

		isTarget = function( self, sim, userUnit, targetUnit )
			if targetUnit:getTraits().drugpistoldose then
                local unitData = targetUnit:getTraits().drugpistoldose

                if unitData.usableWhileDead and targetUnit:isDead() and not simquery.isUnitCellFull( sim, targetUnit ) and not simquery.isUnitDragged( sim, targetUnit ) then
                    return true
                end
                if unitData.usableWhileKO and targetUnit:isKO() and not targetUnit:isDead() and not simquery.isUnitCellFull( sim, targetUnit ) and not simquery.isUnitDragged( sim, targetUnit ) then
                    return true
                end
                if unitData.usableWhileAlive and not targetUnit:isKO() then
                    return true
                end
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
            local x1,y1 = targetUnit:getLocation()
            local unitData = targetUnit:getTraits().drugpistoldose
            local newUnit = simfactory.createUnit( unitData, sim )

            if newUnit:hasAbility("use_medgel") and targetUnit:isKO() then
                if targetUnit:isDead() then
                    assert( targetUnit:getWounds() >= targetUnit:getTraits().woundsMax )
                    targetUnit:getTraits().dead = nil
                    targetUnit:addWounds( targetUnit:getTraits().woundsMax - targetUnit:getWounds() - 1 )			
                end

                sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.UI.FLY_TXT.REVIVED,x=x1,y=y1,color={r=1,g=1,b=1,a=1}} )

                targetUnit:setKO( sim, nil )
                targetUnit:getTraits().mp = math.max( 0, targetUnit:getMPMax() - (targetUnit:getTraits().overloadCount or 0) )

                sim:emitSpeech( targetUnit, speechdefs.EVENT_REVIVED )
            end

            if newUnit:getTraits().mpRestored then
                if targetUnit:isKO() then
                    sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.UI.FLY_TXT.REVIVED,x=x1,y=y1,color={r=1,g=1,b=1,a=1}} )

                    targetUnit:setKO( sim, nil )

                    sim:emitSpeech( targetUnit, speechdefs.EVENT_REVIVED )
                end
            end
                
            if newUnit:getTraits().combatRestored then 
                targetUnit:getTraits().ap = targetUnit:getTraits().apMax	
            end 

            if newUnit:getTraits().unlimitedAttacks then
                sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.UI.FLY_TXT.AMPED,x=x1,y=y1,color={r=1,g=1,b=1,a=1}} ) 
                targetUnit:getTraits().ap = targetUnit:getTraits().apMax
                targetUnit:getTraits().unlimitedAttacks = true
            end 

            if newUnit:getTraits().mpRestored then
                targetUnit:getTraits().mp =targetUnit:getTraits().mp + newUnit:getTraits().mpRestored

                sim:dispatchEvent( simdefs.EV_GAIN_AP, { unit = targetUnit } )
                sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.UI.FLY_TXT.MOVEMENT_BOOSTED,x=x1,y=y1,color={r=1,g=1,b=1,a=1}} )

                local cnt, augments = targetUnit:countAugments( "augment_subdermal_cloak" )
                if cnt > 0 then
                    local pwrCost = augments[1]:getTraits().pwrCost
                    if targetUnit:getPlayerOwner():getCpus() >= pwrCost then
                        targetUnit:setInvisible(true, 1)	
                        targetUnit:getPlayerOwner():addCPUs( -pwrCost, sim, x1, y1)	
                    end
                end
            end

            if newUnit:hasAbility("use_aggression") then
                sim:dispatchEvent( simdefs.EV_UNIT_FLOAT_TXT, {txt=STRINGS.UI.FLY_TXT.VENTRICULAR_PIERCING,x=x1,y=y1,color={r=1,g=1,b=1,a=1}} )

                targetUnit:getTraits().genericPiercing = (targetUnit:getTraits().genericPiercing or 0) + 1
            end

            targetUnit:getTraits().drugpistoldose = nil
            sim:dispatchEvent( simdefs.EV_UNIT_REFRESH, { unit =targetUnit  } )
        end
	}
return activate_injected_dose
