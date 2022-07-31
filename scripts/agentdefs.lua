local util = include( "modules/util" )
local commondefs = include( "sim/unitdefs/commondefs" )
local simdefs = include("sim/simdefs")
local speechdefs = include("sim/speechdefs")

local DOC_SOUNDS =
{	  
	bio = nil,
    escapeVo = nil,
	speech="SpySociety/Agents/dialogue_player",  
	step = simdefs.SOUNDPATH_FOOTSTEP_MALE_HARDWOOD_NORMAL, 
	stealthStep = simdefs.SOUNDPATH_FOOTSTEP_MALE_HARDWOOD_SOFT,  

	wallcover = "SpySociety/Movement/foley_suit/wallcover",
	crouchcover = "SpySociety/Movement/foley_suit/crouchcover",
	fall = "SpySociety/Movement/foley_suit/fall",	
	fall_knee = "SpySociety/Movement/bodyfall_agent_knee_hardwood",
	fall_kneeframe = 9,
	fall_hand = "SpySociety/Movement/bodyfall_agent_hand_hardwood",
	fall_handframe = 20,
	land = "SpySociety/Movement/deathfall_agent_hardwood",
	land_frame = 35,						
	getup = "SpySociety/Movement/foley_suit/getup",	
	grab = "SpySociety/Movement/foley_suit/grab_guard",	
	pin = "SpySociety/Movement/foley_suit/pin_guard",
	pinned = "SpySociety/Movement/foley_suit/pinned",
	peek_fwd = "SpySociety/Movement/foley_suit/peek_forward",	
	peek_bwd = "SpySociety/Movement/foley_suit/peek_back",					
	move = "SpySociety/Movement/foley_suit/move",		
	hit = "SpySociety/HitResponse/hitby_ballistic_flesh",	
}

local agent_templates =
{
	doc=
	{
		type = "simunit",
		agentID = "Momo-R6-Doc",
		name = STRINGS.MOD_DOC.AGENTS.DOC.NAME,
		fullname = STRINGS.MOD_DOC.AGENTS.DOC.FULLNAME,
		codename = STRINGS.MOD_DOC.AGENTS.DOC.FULLNAME,
		loadoutName = STRINGS.UI.ON_FILE,
		file = STRINGS.MOD_DOC.AGENTS.DOC.FILE,
		yearsOfService = STRINGS.MOD_DOC.AGENTS.DOC.ALT_1.YEARS_OF_SERVICE,
		age = STRINGS.MOD_DOC.AGENTS.DOC.ALT_1.AGE,
		homeTown =  STRINGS.MOD_DOC.AGENTS.DOC.HOMETOWN,
		gender = "male",
		toolTip = STRINGS.MOD_DOC.AGENTS.DOC.ALT_1.TOOLTIP,
		onWorldTooltip = commondefs.onAgentTooltip,
		
		profile_icon_36x36= "gui/profile_icons/sharpshooter_36.png",
		profile_icon_64x64= "gui/profile_icons/shalem_64x64.png",		
		splash_image = "gui/agents/shalem_1024.png",
		profile_anim = "portraits/sharpshooter_face",
		team_select_img = {
			"gui/agents/team_select_1_shalem.png",
		},
		
		kanim = "kanim_sharpshooter_male",
		hireText =  STRINGS.MOD_DOC.AGENTS.DOC.RESCUED,
		traits = util.extend( commondefs.DEFAULT_AGENT_TRAITS ) { mp=8, mpMax =8, },
		skills = util.extend( commondefs.DEFAULT_AGENT_SKILLS ) {}, 
		startingSkills = { inventory = 2 },
		abilities = util.tconcat( {  "sprint",  }, commondefs.DEFAULT_AGENT_ABILITIES ),
		children = {},
		sounds = DOC_SOUNDS ,
		speech = STRINGS.MOD_DOC.AGENTS.DOC.BANTER,
		blurb = STRINGS.MOD_DOC.AGENTS.DOC.ALT_1.BIO,
		upgrades = { "doc_augment_monitor", "item_tazer", "item_drug_pistol", "item_stim_3", },
	},
}

return agent_templates
