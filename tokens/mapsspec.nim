{.emit: """
#include "staticMapInfo.h"
typedef struct
{
	StaticMapInfo** staticMapInfos;
} StaticMapInfoList;

StaticMapInfoList staticMapInfoList = {0};
StaticMapInfo** staticMapInfos = 0;

typedef struct MonorailList
{
	MonorailLine**		lines;
} MonorailList;

StaticDefineInt ParseOverridesFor[] =
{
	DEFINE_INT
	{	"Primal",		kOverridesMapFor_PrimalEarth },
	DEFINE_END
};

StaticDefineInt ParseOuroboros[] = {
	DEFINE_INT
	{ "PrimalHero",			MAP_OUROBOROS_HEROES | MAP_OUROBOROS_PRIMAL },
	{ "PrimalVillain",		MAP_OUROBOROS_VILLAINS | MAP_OUROBOROS_PRIMAL },
	{ "Praetorian",			MAP_OUROBOROS_HEROES | MAP_OUROBOROS_VILLAINS | MAP_OUROBOROS_PRAETORIANS },
	DEFINE_END
};

TokenizerParseInfo ParseStaticMapInfo[] =
{
	{	"",					TOK_INT(StaticMapInfo, instanceID, 0)},
	{	"ContainerID",		TOK_STRUCTPARAM | TOK_INT(StaticMapInfo, mapID,-1)},	// Default map container ID is -1
	{	"MapName",			TOK_STRING(StaticMapInfo, name, 0)},
	{	"BaseMapID",		TOK_INT(StaticMapInfo, baseMapID, 0)},
	{	"SafePlayersLow",	TOK_INT(StaticMapInfo, safePlayersLow, 0),			},
	{	"SafePlayersHigh",	TOK_INT(StaticMapInfo, safePlayersHigh, 0),			},
	{	"MaxHeroCount",		TOK_INT(StaticMapInfo, maxHeroCount, 0),			},
	{	"MaxVillainCount",	TOK_INT(StaticMapInfo, maxVillainCount, 0),			},
	{	"MonorailLine",		TOK_INT(StaticMapInfo, monorailLine, 0),			},
	{	"DontTrackGurneys",	TOK_INT(StaticMapInfo, dontTrackGurneys, 0),		},
	{	"DontAutoStart",	TOK_INT(StaticMapInfo, dontAutoStart, 0),			},
	{	"IntroZone",		TOK_INT(StaticMapInfo, introZone, 0),				},
	{	"OpaqueFogOfWar",	TOK_INT(StaticMapInfo, opaqueFogOfWar, 0),			},
	{	"MinCritters",		TOK_INT(StaticMapInfo, minCritters, 0)				},
	{	"MaxCritters",		TOK_INT(StaticMapInfo, maxCritters, 0)				},
	{	"MapKey",			TOK_STRINGARRAY(StaticMapInfo, mapKeys),			},
	{	"ChatRadius",		TOK_INT(StaticMapInfo, chatRadius, 100),			},
	{	"OverridesMapID",	TOK_INT(StaticMapInfo, overridesMapID, 0),			},
	{	"OverridesMapFor",	TOK_INT(StaticMapInfo, overridesMapFor, 0),		ParseOverridesFor	},
	{	"Ouroboros",		TOK_FLAGS(StaticMapInfo, ouroboros, 0), ParseOuroboros},

	{	"ContainerEnd",		TOK_END },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseStaticMapInfoList[] =
{
	{	"Container",	TOK_STRUCT(StaticMapInfoList, staticMapInfos, ParseStaticMapInfo)},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseMonorailStop[] =
{
	{	"",				TOK_STRUCTPARAM | TOK_STRING(MonorailStop, name, 0) },
	{	"{",			TOK_IGNORE },
	{	"Description",	TOK_STRING(MonorailStop, desc, 0) },
	{	"Map",			TOK_INT(MonorailStop, mapID, 0) },
	{	"Spawn",		TOK_STRING(MonorailStop, spawnName, 0) },
	{	"}",			TOK_END },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseMonorailLine[] =
{
	{	"",							TOK_STRUCTPARAM | TOK_STRING(MonorailLine, name, 0) },
	{	"{",						TOK_IGNORE },
	{	"Title",					TOK_STRING(MonorailLine, title, 0) },
	{	"Logo",						TOK_STRING(MonorailLine, logo, 0) },
	{	"Stop",						TOK_STRUCT(MonorailLine, stops, ParseMonorailStop) },
	{	"ZoneTransferDoorTypes",	TOK_STRINGARRAY(MonorailLine, allowedZoneTransferType) },
	{	"}",						TOK_END },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseMonorailList[] =
{
	{	"Monorail",		TOK_STRUCT(MonorailList, lines, ParseMonorailLine) },
	{	"", 0, 0 }
};

StaticDefineInt ParseMissionsAllowed[] =
{
	DEFINE_INT
	{"None",		MA_NONE},
	{"All",			MA_ALL},
	{"Hero",		MA_HERO},
	{"Villain",		MA_VILLAIN},
	DEFINE_END
};

StaticDefineInt ParsePlayersAllowed[] = {
	DEFINE_INT
	{ "Hero",				MAP_ALLOW_HEROES },
	{ "Villain",			MAP_ALLOW_VILLAINS },
	{ "Primal",				MAP_ALLOW_PRIMAL },
	{ "Praetorian",			MAP_ALLOW_PRAETORIANS },
	DEFINE_END
};

StaticDefineInt ParseTeamArea[] =
{
	DEFINE_INT
	{ "Hero",				MAP_TEAM_HEROES_ONLY },
	{ "Villain",			MAP_TEAM_VILLAINS_ONLY },
	{ "PrimalCommon",		MAP_TEAM_PRIMAL_COMMON },
	{ "Praetoria",			MAP_TEAM_PRAETORIANS },
	{ "Everybody",			MAP_TEAM_EVERYBODY },
	DEFINE_END
};

TokenizerParseInfo ParseMapSpec[] =
{
	{	"MapName",			TOK_STRUCTPARAM | TOK_STRING(MapSpec, mapfile, 0),				},
	{	"{",				TOK_START },
	{	"EntryMaxLevel",	TOK_INT(MapSpec, entryLevelRange.max, INT_MAX),		},
	{	"EntryMinLevel",	TOK_INT(MapSpec, entryLevelRange.min, INT_MIN),		},
	{	"MissionMaxLevel",	TOK_INT(MapSpec, missionLevelRange.max, INT_MAX),		},
	{	"MissionMinLevel",	TOK_INT(MapSpec, missionLevelRange.min, INT_MIN),		},
	{	"SpawnOverrideMaxLevel",	TOK_INT(MapSpec, spawnOverrideLevelRange.max, INT_MAX), },
	{	"SpawnOverrideMinLevel",	TOK_INT(MapSpec, spawnOverrideLevelRange.min, INT_MIN), },
	{	"MissionDoors",		TOK_STRINGARRAY(MapSpec, missionDoorTypes),		},
	{	"PersistentNPCs",	TOK_STRINGARRAY(MapSpec, persistentNPCs),		},
	{	"VisitLocations",	TOK_STRINGARRAY(MapSpec, visitLocations),		},
	{	"VillainGroups",	TOK_STRINGARRAY(MapSpec, villainGroups),		},
	{	"EncounterLayouts",	TOK_STRINGARRAY(MapSpec, encounterLayouts),		},
	{	"ZoneScripts",		TOK_STRINGARRAY(MapSpec, zoneScripts),			},
	{	"GlobalAIBehaviors",TOK_STRING(MapSpec, globalAIBehaviors, 0),		},  
	{	"MissionsAllowed",	TOK_INT(MapSpec, missionsAllowed, MA_NONE), ParseMissionsAllowed},
	{	"PlayersAllowed",	TOK_FLAGS(MapSpec, playersAllowed, 0), ParsePlayersAllowed},
	{	"TeamArea",			TOK_INT(MapSpec, teamArea, MAP_TEAM_COUNT), ParseTeamArea},
	{	"DevOnly",			TOK_INT(MapSpec, devOnly, 0),					},
	{	"NPCBeaconRadius",	TOK_F32(MapSpec, NPCBeaconRadius, 0),			},
	{	"DisableBaseHospital",		TOK_INT(MapSpec, disableBaseHospital, 0),		},
	{	"MonorailRequires",	TOK_STRINGARRAY(MapSpec, monorailRequires),		},
	{	"LoadScreenPages",	TOK_STRINGARRAY(MapSpec, loadScreenPages),		},
	{	"}",				TOK_END },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseMapSpecList[] =
{
	{	"Map",	TOK_STRUCT(MapSpecList, mapSpecs, ParseMapSpec)},
	{	"", 0, 0 }
};
""".}