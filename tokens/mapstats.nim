{.emit: """
#include "groupMetaMinimap.h"
ParseTable parse_ArchitectMapComponentPlace[] =
{
	{ "ArchitectMapComponentPlace", 	TOK_IGNORE | TOK_PARSETABLE_INFO, sizeof(ArchitectMapComponentPlace), 0, NULL, 0 },
	{ "X",							TOK_F32(ArchitectMapComponentPlace, x, 0), NULL },
	{ "Y",							TOK_F32(ArchitectMapComponentPlace, y, 0), NULL },
	{ "Z",							TOK_F32(ArchitectMapComponentPlace, z, 0), NULL },
	{ "XScale",						TOK_F32(ArchitectMapComponentPlace, scX, 0), NULL },
	{ "YScale",						TOK_F32(ArchitectMapComponentPlace, scY, 0), NULL },
	{ "Angle",						TOK_F32(ArchitectMapComponentPlace, angle, 0), NULL },
	{ "Color",						TOK_AUTOINT(ArchitectMapComponentPlace, color, 0), NULL },
	{ "TextBackgroundColor",		TOK_AUTOINT(ArchitectMapComponentPlace, color2, 0), NULL },
	{ "Additive",					TOK_BIT, 0, 8, NULL},
	{ "End",						TOK_END, 0 },
	{ "", 0, 0 }
};

ParseTable parse_ArchitectMapComponent[] =
{
	{ "ArchitectMapComponent", 	TOK_IGNORE | TOK_PARSETABLE_INFO, sizeof(ArchitectMapComponent), 0, NULL, 0 },
	{ "MapImage",				TOK_STRING(ArchitectMapComponent, name, 0), NULL },
	{ "TextNotImage",			TOK_AUTOINT(ArchitectMapComponent, isText, 0), NULL },
	{ "defaultXScale",			TOK_F32(ArchitectMapComponent, defaultScX, 0), NULL },
	{ "defaultYScale",			TOK_F32(ArchitectMapComponent, defaultScY, 0), NULL },
	{ "ImageLocation",			TOK_STRUCT(ArchitectMapComponent, places, parse_ArchitectMapComponentPlace) },
	{ "End",					TOK_END, 0 },
	{ "", 0, 0 }
};

ParseTable parse_ArchitectMapSubMap[] =
{
	{ "ArchitectMapSubMap", 	TOK_IGNORE | TOK_PARSETABLE_INFO, sizeof(ArchitectMapSubMap), 0, NULL, 0 },
	{ "Floor",				TOK_AUTOINT(ArchitectMapSubMap, id, 0), NULL },
	{ "defaultXScale",		TOK_F32(ArchitectMapSubMap, defaultScX, 0), NULL },
	{ "defaultYScale",		TOK_F32(ArchitectMapSubMap, defaultScY, 0), NULL },
	{ "MapImage",			TOK_STRUCT(ArchitectMapSubMap, components, parse_ArchitectMapComponent) },
	{ "End",				TOK_END, 0 },
	{ "", 0, 0 }
};

ParseTable parse_ArchitectMapHeader[] =
{
	{ "ArchitectMapHeader", 	TOK_IGNORE | TOK_PARSETABLE_INFO, sizeof(ArchitectMapHeader), 0, NULL, 0 },
	{ "{",					TOK_START, 0 },
	{ "Map",				TOK_STRING(ArchitectMapHeader, mapName, 0), NULL },
	{ "FloorMap",			TOK_STRUCT(ArchitectMapHeader, mapFloors, parse_ArchitectMapSubMap) },
	{ "ItemMap",			TOK_STRUCT(ArchitectMapHeader, mapItems, parse_ArchitectMapSubMap) },
	{ "SpawnMap",			TOK_STRUCT(ArchitectMapHeader, mapSpawns, parse_ArchitectMapSubMap) },
	{ "}",					TOK_END, 0 },
	{ "", 0, 0 }
};

StaticDefineInt ParseMissionPlaceEnum[] =
{
	DEFINE_INT
	{"(Undefined)",			MISSION_NONE},
	{"Front",				MISSION_FRONT},
	{"Back",				MISSION_BACK},
	{"Middle",				MISSION_MIDDLE},
	{"Objective",			MISSION_OBJECTIVE},
	{"Any",					MISSION_ANY},
	{"ScriptControlled",	MISSION_SCRIPTCONTROLLED},
	{"ReplaceGeneric",		MISSION_REPLACEGENERIC},
	{"Lobby",			MISSION_LOBBY},
	DEFINE_END
};

#include "missionMapCommon.h"
// *********************************************************************************
//  Mission map sets
// *********************************************************************************

// map sets
StaticDefineInt ParseMapSetEnum[] =
{
	DEFINE_INT
	{ "Office",							MAPSET_OFFICE },
	{ "AbandonedOffice",				MAPSET_ABANDONEDOFFICE },
	{ "FloodedOffice",					MAPSET_FLOODEDOFFICE },
	{ "Warehouse",						MAPSET_WAREHOUSE },
	{ "AbandonedWarehouse",				MAPSET_ABANDONEDWAREHOUSE },
	{ "5thColumn",						MAPSET_5THCOLUMN },
	{ "Sewers",							MAPSET_SEWERS },
	{ "Caves",							MAPSET_CAVES },
	{ "CircleOfThorns",					MAPSET_CIRCLEOFTHORNS },
	{ "Tech",							MAPSET_TECH },
	{ "Test",							MAPSET_TEST },
	{ "SmoothCaves",					MAPSET_SMOOTHCAVES },
	{ "SS_SmoothCaves",					MAPSET_SHADOWSHARD_SMOOTHCAVES },
	{ "Council",						MAPSET_COUNCIL },
	{ "CargoShip",						MAPSET_CARGOSHIP },
	{ "VillainAbandonedOffice",			MAPSET_VILLAINABANDONEDOFFICE },
	{ "VillainAbandonedWarehouse",		MAPSET_VILLAINABANDONEDWAREHOUSE },
	{ "VillainCaves",					MAPSET_VILLAINCAVES },
	{ "VillainCircleOfThorns",			MAPSET_VILLAINCIRCLEOFTHORNS },
	{ "VillainOffice",					MAPSET_VILLAINOFFICE },
	{ "VillainSewers",					MAPSET_VILLAINSEWERS },
	{ "VillainWarehouse",				MAPSET_VILLAINWAREHOUSE },
	{ "VillainSmoothCaves",				MAPSET_VILLAINSMOOTHCAVES },
	{ "Arachnos",						MAPSET_ARACHNOS },
	{ "Longbow",						MAPSET_LONGBOW },
	{ "LongbowUnderwater",				MAPSET_LONGBOWUNDERWATER },
	{ "CargoShipOutdoor",				MAPSET_CARGOSHIPOUTDOOR },
	{ "VillainUniqueWarehouse_Arachnos",MAPSET_VILLAINARACHNOSWAREHOUSE },
	{ "VillainUniqueWarehouse_Longbow",	MAPSET_VILLAINLONGBOWWAREHOUSE },
	{ "VillainArachnoidTech",			MAPSET_VILLAINARACHNOIDTECH },
	{ "VillainArachnoidCave",			MAPSET_VILLAINARACHNOIDCAVE },
	{ "VillainOfficeToCave",			MAPSET_VILLAINOFFICETOCAVE },
	{ "VillainOfficeToSewer",			MAPSET_VILLAINOFFICETOSEWER },
	{ "VillainSewerToOffice",			MAPSET_VILLAINSEWERTOSEWER },
	{ "VillainMostoSmoothCave",			MAPSET_VILLAINMOSTOSMOOTHCAVE },
	{ "VillainWarehousetoArach",		MAPSET_VILLAINWAREHOUSETOARACH },
	{ "AbandonedTech",					MAPSET_ABANDONEDTECH },
	{ "Rikti",							MAPSET_RIKTI },
	{ "5thColumnFlashback",				MAPSET_5THCOLUMN_FLASHBACK },
	{ "Caves_Mediterranean",			MAPSET_CAVES_MEDITERRANEAN },
	{ "P_Office",						MAPSET_PRAETORIAN_OFFICE },
	{ "P_Office_Solo",					MAPSET_PRAETORIAN_OFFICE_SOLO },
	{ "P_Warehouse",					MAPSET_PRAETORIAN_WAREHOUSE },
	{ "P_Warehouse_Solo",				MAPSET_PRAETORIAN_WAREHOUSE_SOLO },
	{ "P_Tunnels",						MAPSET_PRAETORIAN_TUNNELS },
	{ "P_Tech",							MAPSET_PRAETORIAN_TECH },
	{ "P_PPD",							MAPSET_PRAETORIAN_PPD },
	{ "P_Tech_Bio",						MAPSET_PRAETORIAN_TECH_BIO },
	{ "P_Tech_Power",					MAPSET_PRAETORIAN_TECH_POWER },
	{ "N_Warehouse",					MAPSET_NEW_WAREHOUSE },
	{ "GraniteCaves",					MAPSET_GRANITE_CAVES },
	{ "TalonsCaves",					MAPSET_TALONS_CAVES },
	{ "Random",							MAPSET_RANDOM },
	{ "Specific",						MAPSET_SPECIFIC },

	DEFINE_END
};

TokenizerParseInfo ParseMissionMap[] = {
	{ "", TOK_STRUCTPARAM | TOK_STRING(MissionMap, mapfile,0) },
	{ "\n",				TOK_END,			0 },
	{ "", 0, 0 }
};



TokenizerParseInfo ParseMissionMapTime[] = {
	{ "", TOK_STRUCTPARAM | TOK_INT(MissionMapTime, maptime,0) },
	{ "Map",			TOK_STRUCT(MissionMapTime, maps, ParseMissionMap) },
	{ "{",				TOK_START,		0 },
	{ "}",				TOK_END,		0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseMissionMapSet[] = {
	{ "", TOK_STRUCTPARAM | TOK_INT(MissionMapSet, mapset, MAPSET_NONE),			ParseMapSetEnum },
	{ "DisplayName",	TOK_STRING(MissionMapSet, pchDisplayName,0), },
	{ "RandomDoorType",	TOK_STRINGARRAY(MissionMapSet, randomDoorTypes), },
	{ "Time",			TOK_STRUCT(MissionMapSet, missionmaptimes, ParseMissionMapTime) },
	{ "{",				TOK_START,		0 },
	{ "}",				TOK_END,		0 },
	{ "", 0, 0 }
};



TokenizerParseInfo ParseMissionMapList[] = {
	{ "MissionSet",		TOK_STRUCT(MissionMapList,missionmapsets,ParseMissionMapSet) },
	{ "", 0, 0 }
};

TokenizerParseInfo parse_MissionCustomEncounterStats[] =
{
	{"",	TOK_STRUCTPARAM | TOK_STRING(MissionCustomEncounterStats, type, " ")},
	{"",	TOK_STRUCTPARAM | TOK_INT(MissionCustomEncounterStats, countGrouped, 0)},
	{"",	TOK_STRUCTPARAM | TOK_INT(MissionCustomEncounterStats, countOnly, 0)},
	{"\n",	TOK_STRUCTPARAM | TOK_END, 0},
	{"", 0, 0 }
};

TokenizerParseInfo parse_MissionPlaceStats[] =
{
	{"{",						TOK_START, 0},
	{"place",					TOK_INT(MissionPlaceStats, place, -1), ParseMissionPlaceEnum},
	{"genericEncounterCount",	TOK_INT(MissionPlaceStats, genericEncounterGroupedCount, -1)},
	{"genericEncounterOnlyCount",	TOK_INT(MissionPlaceStats, genericEncounterOnlyCount, 0)},
	{"hostageLocationCount",	TOK_INT(MissionPlaceStats, hostageLocationCount, -1)},
	{"wallObjectiveCount",		TOK_INT(MissionPlaceStats, wallObjectiveCount, -1)},
	{"floorObjectiveCount",		TOK_INT(MissionPlaceStats, floorObjectiveCount, -1)},
	{"roofObjectiveCount",		TOK_INT(MissionPlaceStats, roofObjectiveCount, -1)},
	{"customEncounters",		TOK_STRUCT(MissionPlaceStats, customEncounters, parse_MissionCustomEncounterStats)},
	{"}",						TOK_END, 0},
	{"", 0, 0 }
};

TokenizerParseInfo parse_MissionMapStats[] =
{
	{"{",					TOK_START, 0 },
	{"Name",				TOK_STRING(MissionMapStats, pchMapName, 0) },
	{"roomCount",			TOK_INT(MissionMapStats, roomCount, -1), NULL },
	{"floorCount",			TOK_INT(MissionMapStats, floorCount, 0), NULL},
	{"objectiveRoomCount",	TOK_INT(MissionMapStats, objectiveRoomCount, -1), NULL },
	{"placeCount",			TOK_INT(MissionMapStats, placeCount, -1), NULL },
	{"places",				TOK_STRUCT(MissionMapStats, places, parse_MissionPlaceStats) },
	{"}",					TOK_END, 0 },
	{"", 0, 0 }
};

TokenizerParseInfo parse_MissionMapStatList[] = 
{
	{ "{", TOK_STRUCT(MissionMapStatList, ppStat, parse_MissionMapStats), },
	{0}
};

#ifndef TEST_CLIENT
TokenizerParseInfo parse_ArchitectMapHeaderList[] = 
{
	{ "{", TOK_STRUCT(MinimapHeaderList, ppHeader, parse_ArchitectMapHeader), },
	{0}
};
#endif
""".}