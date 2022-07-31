local function init( modApi )
	modApi:addGenerationOption("OF_RESCUABLE", STRINGS.MOD_DOC.OPTIONS.OF_RESCUABLE, STRINGS.MOD_DOC.OPTIONS.OF_RESCUABLE_DESC, {noUpdate=true} )
	modApi.requirements = {}
end

local function initStrings( modApi )
	local dataPath = modApi:getDataPath()
	local scriptPath = modApi:getScriptPath()
	
	local MOD_STRINGS = include( scriptPath .. "/strings" )
	modApi:addStrings( dataPath, "MOD_DOC", MOD_STRINGS )
end

local function load( modApi, options, params, mod_options )
	local scriptPath = modApi:getScriptPath()
	
   if options["OF_RESCUABLE"].enabled then
       local agentdefs = include( scriptPath .. "/agentdefs" )
       for name, agentDef in pairs(agentdefs) do
           modApi:addAgentDef( name, agentDef, { name } )
       end
       local serverdefs = include( scriptPath .. "/serverdefs" )
       if serverdefs.TEMPLATE_AGENCY and serverdefs.TEMPLATE_AGENCY.unitDefsPotential then
            for i,unitDef in ipairs(serverdefs.TEMPLATE_AGENCY.unitDefsPotential) do
                modApi:addRescueAgent( unitDef )
            end
       end
   end

	local itemdefs = include( scriptPath .. "/itemdefs" )
	for name, itemDef in pairs(itemdefs) do
		modApi:addItemDef( name, itemDef )
   end

	modApi:addAbilityDef( "monitor", scriptPath .."/monitor" )
	modApi:addAbilityDef( "shoot_stim", scriptPath .."/shoot_stim" )
end

return
{
	init = init,
	initStrings = initStrings,
	load = load,
}