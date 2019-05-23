{.emit: """
//#include "villaindef.c"
#include "villaindef.h"

DefineContext *g_pParseVillainGroups = NULL;
STATIC_DEFINE_WRAPPER(ParseVillainGroups, g_pParseVillainGroups);

typedef struct {
	const VillainGroup **villainGroups;
} VillainGroupList;

TokenizerParseInfo ParsePowerNameRef[] =
{
	{	"PowerCategory",	TOK_STRUCTPARAM | TOK_STRING(PowerNameRef, powerCategory, 0) },
	{	"PowerSet",			TOK_STRUCTPARAM | TOK_STRING(PowerNameRef, powerSet, 0) },
	{	"Power",			TOK_STRUCTPARAM | TOK_STRING(PowerNameRef, power, 0) },
	{	"Level",			TOK_STRUCTPARAM | TOK_INT(PowerNameRef, level, 0) },
	{	"Remove",			TOK_STRUCTPARAM | TOK_INT(PowerNameRef, remove, 0) },
	{	"DontSetStance",	TOK_STRUCTPARAM | TOK_INT(PowerNameRef, dontSetStance, 0)	},
	{	"\n",				TOK_END,								0},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseFakeScriptDef[] = {
	{ "{",				TOK_START,		0},
	{ "ScriptName",		TOK_IGNORE },
	{ "}",				TOK_END,			0},
	{ "var",			TOK_IGNORE },
	{ "vargroup",		TOK_IGNORE },
	{ "", 0, 0 }
};

StaticDefineInt ParseGender[] = {
		DEFINE_INT
		{ "undefined",				GENDER_UNDEFINED			},
		{ "neuter",					GENDER_NEUTER				},
		{ "male",					GENDER_MALE					},
		{ "female",					GENDER_FEMALE				},
		DEFINE_END
	};

StaticDefineInt ParseVillainRankEnum[] =
{
	DEFINE_INT
	{"Small",			VR_SMALL},
	{"Minion",			VR_MINION},
	{"Lieutenant",		VR_LIEUTENANT},
	{"Sniper",			VR_SNIPER},
	{"Boss",			VR_BOSS},
	{"Elite",			VR_ELITE},
	{"ArchVillain",		VR_ARCHVILLAIN},
	{"ArchVillain2",	VR_ARCHVILLAIN2},
	{"BigMonster",		VR_BIGMONSTER},
	{"Pet",				VR_PET},
	{"Destructible",	VR_DESTRUCTIBLE},
	DEFINE_END
};

// this is how the color is level-adjusted
static int villainRankConningAdjust[] =
{
	0,					// VR_NONE
	-1,					// VR_SMALL
	0,					// VR_MINION
	1,					// VR_LIEUTENANT
	1,					// VR_SNIPER
	2,					// VR_BOSS
	3,					// VR_ELITE
	5,					// VR_ARCHVILLAIN
	5,					// VR_ARCHVILLAIN2
	100,				// VR_BIGMONSTER
	1,					// VR_PET
	1,					// VR_DESTRUCTIBLE
};

StaticDefineInt ParseVillainExclusion[] =
{
	DEFINE_INT
	{"CoHOnly",			VE_COH},
	{"CoVOnly",			VE_COV},
	DEFINE_END
};

TokenizerParseInfo ParseVillainLevelDef[] =
{
	{	"Level",		TOK_STRUCTPARAM | TOK_INT(VillainLevelDef, level, 0)},
	{	"DisplayNames",	TOK_STRINGARRAY(VillainLevelDef, displayNames)},
	{	"Costumes",		TOK_STRINGARRAY(VillainLevelDef, costumes)},
	{	"XP",			TOK_INT(VillainLevelDef, experience, 0)},
	{	"{",			TOK_START,		0 },
	{	"}",			TOK_END,			0 },
	{	"", 0, 0 }
};

TokenizerParseInfo ParsePetCommandStrings[] =
{
	{	"{",				TOK_START,		0 },
	{	"Passive",			TOK_STRINGARRAY(PetCommandStrings, ppchPassive) },
	{	"Defensive",		TOK_STRINGARRAY(PetCommandStrings, ppchDefensive) },
	{	"Aggressive",		TOK_STRINGARRAY(PetCommandStrings, ppchAggressive) },

	{	"AttackTarget",		TOK_STRINGARRAY(PetCommandStrings, ppchAttackTarget) },
	{	"AttackNoTarget",	TOK_STRINGARRAY(PetCommandStrings, ppchAttackNoTarget) },
	{	"StayHere",			TOK_STRINGARRAY(PetCommandStrings, ppchStayHere) },
	{	"UsePower",			TOK_STRINGARRAY(PetCommandStrings, ppchUsePower) },
	{	"UsePowerNone",		TOK_STRINGARRAY(PetCommandStrings, ppchUsePowerNone) },
	{	"FollowMe",			TOK_STRINGARRAY(PetCommandStrings, ppchFollowMe) },
	{	"GotoSpot",			TOK_STRINGARRAY(PetCommandStrings, ppchGotoSpot) },
	{	"Dismiss",			TOK_STRINGARRAY(PetCommandStrings, ppchDismiss) },
	{	"}",				TOK_END,			0 },
	{	"", 0, 0 }
};

StaticDefineInt ParseVillainDefFlags[] =
{
	DEFINE_INT
	{ "NoGroupBadgeStat",			VILLAINDEF_NOGROUPBADGESTAT },
	{ "NoRankBadgeStat",			VILLAINDEF_NORANKBADGESTAT },
	{ "NoNameBadgeStat",			VILLAINDEF_NONAMEBADGESTAT },
	{ "NoGenericBadgeStat",			VILLAINDEF_NOGENERICBADGESTAT },
	DEFINE_END
};

TokenizerParseInfo ParseVillainDef[] =
{
	{	"Name",						TOK_STRUCTPARAM | TOK_STRING(VillainDef, name, 0)},
	{	"Class",					TOK_STRING(VillainDef, characterClassName, 0)},
	{	"Gender",					TOK_INT(VillainDef, gender,	0),	ParseGender },
	{	"DisplayDescription",		TOK_STRING(VillainDef, description, 0)},
	{	"GroupDescription",			TOK_STRING(VillainDef, groupdescription, 0) },
	{	"DisplayClassName",			TOK_STRING(VillainDef, displayClassName, 0) },
	{	"AIConfig",					TOK_STRING(VillainDef, aiConfig, 0)},
	{	"VillainGroup",				TOK_INT(VillainDef, group,	0), ParseVillainGroupEnum},
	{	"Power",					TOK_STRUCT(VillainDef, powers, ParsePowerNameRef)},
	{	"Level",					TOK_STRUCT(VillainDef, levels, ParseVillainLevelDef)},
	{	"Rank",						TOK_INT(VillainDef, rank,		0), ParseVillainRankEnum},
	{	"Ally",						TOK_STRING(VillainDef, ally, 0) },
	{	"Gang",						TOK_STRING(VillainDef, gang, 0) },
	{	"Exclusion",				TOK_INT(VillainDef, exclusion ,	0), ParseVillainExclusion},
	{	"IgnoreCombatMods",			TOK_BOOLFLAG(VillainDef, ignoreCombatMods, 0) },
	{	"CopyCreatorMods",			TOK_BOOLFLAG(VillainDef, copyCreatorMods, 0) },
	{	"IgnoreReduction",			TOK_BOOLFLAG(VillainDef, ignoreReduction, 0) },
	{	"CanZone",					TOK_BOOLFLAG(VillainDef, canZone, 0) },
	{	"SpawnLimit",				TOK_INT(VillainDef, spawnlimit, -1) },
	{	"SpawnLimitMission",		TOK_INT(VillainDef, spawnlimitMission, -2) },
	{	"AdditionalRewards",		TOK_REDUNDANTNAME | TOK_STRINGARRAY(VillainDef, additionalRewards), },
	{	"SuccessRewards",			TOK_STRINGARRAY(VillainDef, additionalRewards), },
	{	"FavoriteWeapon",			TOK_STRING(VillainDef, favoriteWeapon, 0), },
	{	"DeathFailureRewards",		TOK_STRINGARRAY(VillainDef, skillHPRewards), },
	{	"IntegrityFailureRewards",	TOK_REDUNDANTNAME | TOK_STRINGARRAY(VillainDef, skillStatusRewards), },
	{	"StatusFailureRewards",		TOK_STRINGARRAY(VillainDef, skillStatusRewards), },
	{	"RewardScale",				TOK_F32(VillainDef, rewardScale, 1)},
	{	"PowerTags",				TOK_STRINGARRAY(VillainDef, powerTags), },
	{	"SpecialPetPower",			TOK_STRING(VillainDef, specialPetPower, 0), },
	{   "FileName",					TOK_CURRENTFILE(VillainDef, fileName), },
	{	"FileAge",					TOK_TIMESTAMP(VillainDef, fileAge), },
	{	"PetCommandStrings",		TOK_STRUCT(VillainDef, petCommandStrings, ParsePetCommandStrings) },
	{	"PetVisibility",			TOK_INT(VillainDef, petVisibility, -1)  },
	{	"PetCommandability",		TOK_INT(VillainDef, petCommadability, 0), },
	{	"BadgeStat",				TOK_STRING(VillainDef, customBadgeStat, 0), },
	{	"Flags",					TOK_FLAGS(VillainDef,flags,0), ParseVillainDefFlags },
#if SERVER
	{ "ScriptDef",						TOK_STRUCT(VillainDef,scripts, ParseScriptDef) },
#else
	{ "ScriptDef",						TOK_NULLSTRUCT(ParseFakeScriptDef) },
#endif
	{	"{",						TOK_START,			0 },
	{	"}",						TOK_END,			0 },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseVillainDefBegin[] =
{
	{	"VillainDef",	TOK_STRUCT(VillainDefList, villainDefs, ParseVillainDef) },
	{	"", 0, 0 }
};

StaticDefineInt ParseGroupAlly[] =
{
	DEFINE_INT
	{"None",			VG_ALLY_NONE},
	{"Hero",			VG_ALLY_HERO},
	{"Villain",			VG_ALLY_VILLAIN},
	{"Monster",			VG_ALLY_MONSTER},
	DEFINE_END
};

TokenizerParseInfo ParseVillainGroup[] =
{
	{	"Name",					TOK_STRUCTPARAM | TOK_STRING(VillainGroup, name, 0)},
	{	"DisplayName",			TOK_STRING(VillainGroup, displayName, 0)},
	{	"DisplaySingluar",		TOK_STRING(VillainGroup, displaySingluarName, 0)},
	{	"DisplayLeaderName",	TOK_STRING(VillainGroup, displayLeaderName, 0)},
	{	"Description",			TOK_STRING(VillainGroup, description, 0)},
	{	"ShowInKiosk",			TOK_INT(VillainGroup, showInKiosk,	0),	ModBoolEnum },
	{	"Ally",					TOK_INT(VillainGroup, groupAlly,	VG_ALLY_NONE),	ParseGroupAlly },
	{	"{",					TOK_START,		0 },
	{	"}",					TOK_END,			0 },
	{	"", 0, 0 }
};


TokenizerParseInfo ParseVillainGroupBegin[] =
{
	{	"VillainGroup",			TOK_STRUCT(VillainGroupList, villainGroups, ParseVillainGroup)},
	{	"", 0, 0 }
};

// *********************************************************************************
//  Mission spawn sets
// *********************************************************************************

typedef struct MissionSpawnLevels
{
	int					minlevel;
	int					maxlevel;
	const char**		spawndefs;
} MissionSpawnLevels;

TokenizerParseInfo ParseMissionSpawnLevels[] = {
	{ "", TOK_STRUCTPARAM | TOK_INT(MissionSpawnLevels, minlevel,0) },
	{ "", TOK_STRUCTPARAM | TOK_INT(MissionSpawnLevels, maxlevel,0) },
	{ "SpawnDef",		TOK_STRINGARRAY(MissionSpawnLevels, spawndefs) },
	{ "{",				TOK_START,		0 },
	{ "}",				TOK_END,		0 },
	{ "", 0, 0 }
};

typedef struct MissionSpawnList
{
	const char*				filename;		// just for error reporting
	VillainGroupEnum	villaingroup;
	const MissionSpawnLevels** levels;
} MissionSpawnList;

TokenizerParseInfo ParseMissionSpawnList[] = {
	{ "",				TOK_CURRENTFILE(MissionSpawnList, filename) },
	{ "", TOK_STRUCTPARAM | TOK_INT(MissionSpawnList, villaingroup, 0), ParseVillainGroupEnum },
	{ "Levels",			TOK_STRUCT(MissionSpawnList, levels, ParseMissionSpawnLevels) },
	{ "{",				TOK_START,		0 },
	{ "}",				TOK_END,		0 },
	{ "", 0, 0 }
};

typedef struct MissionGenericSpawns
{
	const MissionSpawnList**	lists;
} MissionGenericSpawns;

TokenizerParseInfo ParseMissionGenericSpawns[] = {
	{ "MissionSpawns",	TOK_STRUCT(MissionGenericSpawns, lists, ParseMissionSpawnList) },
	{ "", 0, 0 }
};
""".}