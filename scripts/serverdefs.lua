local serverdefs = include( "modules/serverdefs" )

local TEMPLATE_AGENCY = 
{
	unitDefsPotential = {
		serverdefs.createAgent( "doc", {"doc_augment_monitor", "item_drug_pistol"} ),
	},
}
return
{
	TEMPLATE_AGENCY = TEMPLATE_AGENCY,
}