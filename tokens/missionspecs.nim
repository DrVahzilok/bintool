{.emit: """
#include "missionspec.h"
TokenizerParseInfo ParseEncounterGroupSpec[] =
{
	{	"{",					TOK_START },
	{	"Layouts",				TOK_STRINGARRAY(EncounterGroupSpec, layouts) },
	{	"Number",				TOK_INT(EncounterGroupSpec, count, 1) },
	{	"}",					TOK_END },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseMissionAreaSpec[] =
{
	{	"{",					TOK_START },
	{	"CustomEncounterGroup",	TOK_STRUCT(MissionAreaSpec, encounterGroups, ParseEncounterGroupSpec) },
	{	"MissionEncounters",	TOK_INT(MissionAreaSpec, missionSpawns, 0) },
	{	"Hostages",				TOK_INT(MissionAreaSpec, hostages, 0) },
	{	"ItemWall",				TOK_INT(MissionAreaSpec, wallItems, 0) },
	{	"ItemFloor",			TOK_INT(MissionAreaSpec, floorItems, 0) },
	{	"ItemRoof",				TOK_INT(MissionAreaSpec, roofItems, 0) },
	{	"}",					TOK_END },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseMapMissionSpec[] =
{
	{	"",			TOK_STRUCTPARAM | TOK_FILENAME(MissionSpec, mapFile, 0) },
	{	"{",		TOK_START },
	{	"DisableMissionCheck",	TOK_BOOLFLAG(MissionSpec, disableMissionCheck, 0)	},
	{	"Variable",	TOK_BOOLFLAG(MissionSpec, varMapSpec, 0)					},
	{	"SubMaps",	TOK_STRINGARRAY(MissionSpec, subMapFiles)		},
	{	"Front",	TOK_EMBEDDEDSTRUCT(MissionSpec, front, ParseMissionAreaSpec) },
	{	"Middle",	TOK_EMBEDDEDSTRUCT(MissionSpec, middle,	ParseMissionAreaSpec) },
	{	"Back",		TOK_EMBEDDEDSTRUCT(MissionSpec, back, ParseMissionAreaSpec) },
	{	"Lobby",	TOK_EMBEDDEDSTRUCT(MissionSpec, lobby, ParseMissionAreaSpec) },
	{	"}",		TOK_END },

	// vars from ParseSetMissionSpec have to be here to get written..
	{	"MapSet",			TOK_INT(MissionSpec, mapSet,0), ParseMapSetEnum	},
	{	"MapSetTime",			TOK_INT(MissionSpec, mapSetTime,0)	},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseSetMissionSpec[] =
{
	{	"",			TOK_STRUCTPARAM | TOK_INT(MissionSpec, mapSet, 0),	ParseMapSetEnum },
	{	"",			TOK_STRUCTPARAM | TOK_INT(MissionSpec, mapSetTime, 0) },
	{	"{",		TOK_START },
	{	"Front",	TOK_EMBEDDEDSTRUCT(MissionSpec, front, ParseMissionAreaSpec) },
	{	"Middle",	TOK_EMBEDDEDSTRUCT(MissionSpec, middle,	ParseMissionAreaSpec) },
	{	"Back",		TOK_EMBEDDEDSTRUCT(MissionSpec, back, ParseMissionAreaSpec) },
	{	"Lobby",	TOK_EMBEDDEDSTRUCT(MissionSpec, lobby, ParseMissionAreaSpec) },
	{	"}",		TOK_END },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseMissionSpecFile[] =
{
	// doing kind of a hack to make the spec file look better.. 
	// Map and MissionSet don't actually refer to different structs
	{	"Map",			TOK_STRUCT(MissionSpecFile, missionSpecs, ParseMapMissionSpec) },
	{	"MissionSet",	TOK_REDUNDANTNAME | TOK_STRUCT(MissionSpecFile, missionSpecs, ParseSetMissionSpec) },
	{	"", 0, 0 }
};
""".}