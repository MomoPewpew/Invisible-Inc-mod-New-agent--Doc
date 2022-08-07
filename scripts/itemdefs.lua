local util = include( "modules/util" )
local commondefs = include( "sim/unitdefs/commondefs" )
local simdefs = include( "sim/simdefs" )

local tool_templates =
{
	doc_augment_monitor = util.extend( commondefs.augment_template )
	{
		name = STRINGS.MOD_DOC.ITEMS.AUGMENT_MONITOR,
		desc = STRINGS.MOD_DOC.ITEMS.AUGMENT_MONITOR_DESC,
		flavor = STRINGS.MOD_DOC.ITEMS.AUGMENT_MONITOR_FLAV,
		traits = util.extend( commondefs.DEFAULT_AUGMENT_TRAITS ){
			installed = true,
		},
		abilities = util.tconcat( commondefs.augment_template.abilities, { "monitor", "activate_injected_dose", }),
		profile_icon = "gui/icons/skills_icons/skills_icon_small/icon-item_augment_internationale_small_alt.png",
    	profile_icon_100 = "gui/icons/skills_icons/icon-item_augment_internationale_alt.png",		
	},
	item_drug_pistol = util.extend( commondefs.item_template )
	{
		name =  STRINGS.MOD_DOC.ITEMS.ITEM_DRUG_PISTOL,
		desc =  STRINGS.MOD_DOC.ITEMS.ITEM_DRUG_PISTOL_DESC,
		flavor = STRINGS.MOD_DOC.ITEMS.ITEM_DRUG_PISTOL_FLAV,
		icon = "itemrigs/FloorProp_Pistol.png",		
		profile_icon = "gui/icons/item_icons/items_icon_small/icon-item_revolver_small.png",	
		profile_icon_100 = "gui/icons/item_icons/icon-item_revolver.png",			
		equipped_icon = "gui/items/equipped_pistol.png",
		sounds = {shoot="SpySociety/Weapons/LowBore/shoot_handgun_silenced", reload="SpySociety/Weapons/LowBore/reload_handgun", use="SpySociety/Actions/item_pickup"},
		weapon_anim = "kanim_light_revolver",
		agent_anim = "anims_1h",
		traits = {
			equipped = false,
			slot = nil,
			baseDamage = 0,
		},
		abilities = { "carryable", "shoot_stim", },
		value = 600,
	},
}
return tool_templates