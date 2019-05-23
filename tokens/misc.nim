{.emit: """/*TYPESETION*/
#define MAX_TEAM_MEMBERS			8
#define MAX_TASKFORCE_MEMBERS		MAX_TEAM_MEMBERS
#define TF_NAME_LEN					64
#define MAX_TASKFORCE_PARAMETERS	32
#define MAX_RAID_MEMBERS			MAX_TEAM_MEMBERS
#define MAX_LEVELINGPACT_MEMBERS	2
#define LEVELINGPACT_MAXLEVEL		5
#define LEVELINGPACT_VERSION		1 //update this every time you need old pacts due to a change in the structure.
#define MAX_LEAGUE_TEAMS			6
#define MAX_LEAGUE_MEMBERS			(MAX_LEAGUE_TEAMS * MAX_TEAM_MEMBERS)

#include "badges.h"

#include "earray.h"
#define eaSizeNim(__x) eaSize(&__x)

#include "group.h"
#include "groupfilelib.h"
typedef struct GroupLibNameEntry
{
	char		*name;
	union {
		struct {
			short		dir_idx;
			U8			is_rootname;
		};
		int intvalue;
	};
	GroupBounds	bounds;
} GroupLibNameEntry;

typedef struct GroupNames {
	GroupFileEntry **group_files;
	GroupLibNameEntry **group_libnames;
} GroupNames;

// Format for writing/reading .bin file (not actually parsed text)
TokenizerParseInfo GroupFileEntrySaveInfo[] =
{
	{ "",	TOK_STRUCTPARAM|TOK_STRING(GroupFileEntry, name, 0) },
	{ "", 0, 0 }
};

TokenizerParseInfo GroupLibNameEntrySaveInfo[] =
{
	{ "",	TOK_STRUCTPARAM|TOK_STRING(GroupLibNameEntry, name, 0) },
	{ "",	TOK_STRUCTPARAM|TOK_INT(GroupLibNameEntry, intvalue, 0) },
	{ "", 0, 0 }
};

TokenizerParseInfo GroupNamesSaveInfo[] = {
	{ "F",	TOK_STRUCT(GroupNames,group_files, GroupFileEntrySaveInfo)},
	{ "N",	TOK_STRUCT(GroupNames,group_libnames, GroupLibNameEntrySaveInfo)},
	{ "", 0, 0 }
};

#include "arenastruct.h"
TokenizerParseInfo ParseArenaMap[] =
{
	{ "MapDisplayName",	TOK_STRUCTPARAM|TOK_STRING(ArenaMap, displayName, 0) },
	{ "MapName",		TOK_STRUCTPARAM|TOK_STRING(ArenaMap, mapname, 0) },
	{ "MinPlayers",		TOK_STRUCTPARAM|TOK_INT(ArenaMap, minplayers, 0) },
	{ "MaxPlayers",		TOK_STRUCTPARAM|TOK_INT(ArenaMap, maxplayers, 0) },
	{ "\n",				TOK_END, 0 },
	{ 0 }
};

TokenizerParseInfo ParseArenaMaps[] =
{
	{ "{",			TOK_START,       0 },
	{ "map",		TOK_STRUCT(ArenaMaps, maps, ParseArenaMap) },
	{ "}",			TOK_END,         0 },
	{ 0 }
};

#include "seqstate.h"


static StaticDefineInt statebit_flags[] = 
{
	DEFINE_INT
	{ "Predictable",	STATEBIT_PREDICTABLE	},
	{ "Flash",			STATEBIT_FLASH			},
	{ "Continuing",		STATEBIT_CONTINUING		},
//	{ "CodeSet",		STATEBIT_CODESET		},  //You can't set this flag from the data file
	DEFINE_END
};

typedef struct StateBitList{
	StateBit ** stateBits;
} StateBitList;

TokenizerParseInfo ParseStateBit[] =
{
	{	"",				TOK_STRUCTPARAM | TOK_STRING(StateBit, name, 0)},
	{   "",				TOK_STRUCTPARAM | TOK_FLAGS(StateBit, flags, 0), statebit_flags},
	{   "\n",			TOK_END,							0 },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseStateBitList[] =
{
	{	"StateBit",		TOK_STRUCT(StateBitList, stateBits, ParseStateBit) },
	{	"", 0, 0 }
};

extern U32 Crc32cLowerStringHash(U32 hash, const char * s);

TokenizerParseInfo ParseAttributeItem[] =
{
	{	"Id",			TOK_STRUCTPARAM | TOK_INT(AttribFileItem, id, 0)},
	{	"Name",			TOK_STRUCTPARAM | TOK_STRING(AttribFileItem, name, 0)},
	{	"\n",			TOK_END,							0},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseAttributeItems[] =
{
	{	"AttribFileItem", TOK_STRUCT(AttribFileDict, ppAttribItems, ParseAttributeItem)},
	{	"", 0, 0 }
};

#include "scriptengine.h"
TokenizerParseInfo ParseScriptDef[] = {
	{ "{",				TOK_START,		0},
	{ "",				TOK_CURRENTFILE(ScriptDef, filename) },
	{ "ScriptName",		TOK_STRING(ScriptDef, scriptname,0) },
	{ "}",				TOK_END,			0},
	SCRIPTVARS_STD_PARSE(ScriptDef)
	{ "", 0, 0 }
};

typedef struct ScriptDefList
{
	const ScriptDef** scripts;
} ScriptDefList;

TokenizerParseInfo ParseScriptDefList[] = {
	{ "ScriptDef",		TOK_STRUCT(ScriptDefList,scripts,ParseScriptDef) },
	{ "", 0, 0 }
};


#include "SouvenirClue.h"
typedef struct
{
	const SouvenirClue** clues;
} SouvenirClueList;

TokenizerParseInfo ParseSouvenirClue[] =
{
	{ "{",				TOK_START,			0},
	{ "}",				TOK_END,			0},

	{ "",				TOK_STRUCTPARAM | TOK_STRING(SouvenirClue, name, 0) },
	{ "",				TOK_CURRENTFILE(SouvenirClue, filename) },
	{ "Name",			TOK_STRING(SouvenirClue, displayName, 0) },
	{ "Icon",			TOK_STRING(SouvenirClue, icon, 0) },
	{ "DetailString",	TOK_STRING(SouvenirClue, description, 0) },

	{ "", 0, 0 }
};

TokenizerParseInfo ParseSouvenirClueList[] =
{
	{ "SouvenirClueDef",	TOK_STRUCT(SouvenirClueList, clues, ParseSouvenirClue) },
	{ "", 0, 0 }
};

StaticDefineInt AccountTypes_RarityEnum[] =
{
	DEFINE_INT
	{ "Common", 1},
	{ "Uncommon", 2},
	{ "Rare", 3},
	{ "VeryRare", 4},
	DEFINE_END
};

static char *structGetFilename(ParseTable *pti, void *structptr)
{
	int i;
	if (!structptr)
		return NULL;
	
	FORALL_PARSEINFO(pti, i)
	{
		if (TOK_GET_TYPE(pti[i].type) == TOK_CURRENTFILE_X)
			return TokenStoreGetString(pti, i, structptr, 0);
	}

	printf("Warning: structGetFilename called on structure missing filename field!\n");
	return NULL;
}

typedef struct AttribName
{
	char *pchName;
	char *pchDisplayName;
	char *pchIconName;
} AttribName;

TokenizerParseInfo ParseAttribName[] =
{
	{ "Name",         TOK_STRUCTPARAM|TOK_STRING(AttribName, pchName, 0) },
	{ "DisplayName",  TOK_STRUCTPARAM|TOK_STRING(AttribName, pchDisplayName, 0) },
	{ "IconName",     TOK_STRUCTPARAM|TOK_STRING(AttribName, pchIconName, 0) },
	{ "\n",           TOK_END,                      0 },
	{ 0 }
};

typedef struct AttribNames
{
	const AttribName **ppDamage;
	const AttribName **ppDefense;
	const AttribName **ppBoost;
	const AttribName **ppGroup;
	const AttribName **ppMode;
	const AttribName **ppElusivity;
	const AttribName **ppStackKey;
} AttribNames;

TokenizerParseInfo ParseAttribNames[] =
{
	{ "{",				TOK_START,       0 },
	{ "Damage",			TOK_STRUCT(AttribNames, ppDamage, ParseAttribName) },
	{ "Defense",		TOK_STRUCT(AttribNames, ppDefense, ParseAttribName) },
	{ "Boost",			TOK_STRUCT(AttribNames, ppBoost, ParseAttribName) },
	{ "Group",			TOK_STRUCT(AttribNames, ppGroup, ParseAttribName) },
	{ "Mode",			TOK_STRUCT(AttribNames, ppMode, ParseAttribName) },
	{ "Elusivity",		TOK_STRUCT(AttribNames, ppElusivity, ParseAttribName) },
	{ "StackKey",		TOK_STRUCT(AttribNames, ppStackKey, ParseAttribName) },
	{ "}",				TOK_END,         0 },
	{ 0 }
};

#include "pnpcCommon.h"
TokenizerParseInfo ParseVisionPhaseNamesTable[]=
{
	{ "VisionPhaseName",	TOK_STRINGARRAY(VisionPhaseNames, visionPhases)},
	{ "", 0, 0 }
};

/***************************************************************************/
/***************************************************************************/

typedef struct CharacterOrigin
{
	// Defines the character origin, which at this point is nothing more
	//   than a bit of color.

	const char *pchName;

	const char *pchDisplayName;
	const char *pchDisplayHelp;
	const char *pchDisplayShortHelp;
		// Various strings for user-interaction

	const char *pchIcon;
		// The icon for this origin

} CharacterOrigin;

TokenizerParseInfo ParseCharacterOrigin[] =
{
	{ "{",                        TOK_START,  0 },
	{ "Name",                     TOK_STRING(CharacterOrigin, pchName, 0)                   },
	{ "DisplayName",              TOK_STRING(CharacterOrigin, pchDisplayName, 0)            },
	{ "DisplayHelp",              TOK_STRING(CharacterOrigin, pchDisplayHelp, 0)            },
	{ "DisplayShortHelp",         TOK_STRING(CharacterOrigin, pchDisplayShortHelp, 0)       },
	{ "Icon",                     TOK_STRING(CharacterOrigin, pchIcon, 0)                   },
	{ "}",                        TOK_END,    0 },
	{ "", 0, 0 }
};

/***************************************************************************/
/***************************************************************************/

typedef struct CharacterOrigins
{
	const CharacterOrigin **ppOrigins;
} CharacterOrigins;

TokenizerParseInfo ParseCharacterOrigins[] =
{
	{ "Origin", TOK_STRUCT(CharacterOrigins, ppOrigins, ParseCharacterOrigin)},
	{ "", 0, 0 }
};

#include "pophelp.h"

typedef struct PopHelpDictionary
{
	int init;
	PopHelpItem **items;
} PopHelpDictionary;

// Parse structures
//---------------------------------------------------------------------

TokenizerParseInfo ParsePopHelp[] =
{
	{ "{",				TOK_START,		0							},
	{ "Tag",			TOK_STRING(PopHelpItem, tag, 0)				},
	{ "InYourFace",		TOK_BOOLFLAG(PopHelpItem, inYourFace, 0)	},
	{ "DisplayTitle",	TOK_STRING(PopHelpItem, name, 0)			},
	{ "DisplayText",	TOK_STRING(PopHelpItem, text, 0)			},
	{ "SoundName",		TOK_STRING(PopHelpItem, soundName, 0)		},
	{ "TimeTriggered",	TOK_INT64(PopHelpItem, timeTriggered, 0)	},
	{ "}",				TOK_END,		0							},
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePopHelpDictionary[] =
{
	{ "PopHelp", TOK_STRUCT(PopHelpDictionary, items, ParsePopHelp) },
	{ "", 0, 0 }
};

typedef struct CombatMod
{
	// Holds a set of percentage modifiers used to vary combat between
	// characters of different level.

	const float *pfToHit;
	const float *pfMagnitude;
	const float *pfDuration;
	const float *pfAccuracy;

} CombatMod;


TokenizerParseInfo ParseCombatMod[] =
{
	{ "{",           TOK_START,    0 },
	{ "ToHit",       TOK_F32ARRAY(CombatMod, pfToHit)     },
	{ "Magnitude",   TOK_F32ARRAY(CombatMod, pfMagnitude) },
	{ "Duration",    TOK_F32ARRAY(CombatMod, pfDuration)  },
	{ "Accuracy",    TOK_F32ARRAY(CombatMod, pfAccuracy)  },
	{ "}",           TOK_END,      0 },
	{ "", 0, 0 }
};


typedef struct CombatMods
{
	CombatMod Higher;
	CombatMod Lower;

	int iMaxSize;
	int iMinSize;

} CombatMods;

TokenizerParseInfo ParseCombatMods[] =
{
	{ "{",                   TOK_START,  0 },
	{ "MinSize",            TOK_INT(CombatMods, iMinSize,   0) },
	{ "MaxSize",            TOK_INT(CombatMods, iMaxSize, 100) },

	{ "HigherLevel",         TOK_EMBEDDEDSTRUCT(CombatMods, Higher, ParseCombatMod) },
	{ "LowerLevel",          TOK_EMBEDDEDSTRUCT(CombatMods, Lower, ParseCombatMod) },
	{ "}",                   TOK_END,    0 },
	{ "", 0, 0 }
};

typedef struct CombatModsTable
{
	float fPvPToHitMod;
	float fPvPElusivityMod;
	const float *pfToHitLevelMods;
	const CombatMods **ppMods;
} CombatModsTable;


TokenizerParseInfo ParseCombatModsTable[] =
{
	{ "PvPToHitMod",		TOK_F32(CombatModsTable, fPvPToHitMod,  0) },
	{ "PvPElusivityMod",	TOK_F32(CombatModsTable, fPvPElusivityMod,  0) },
	{ "ToHitLevelMod",		TOK_F32ARRAY(CombatModsTable, pfToHitLevelMods) },
	{ "CombatMods",			TOK_STRUCT(CombatModsTable, ppMods, ParseCombatMods) },
	{ "", 0, 0 }
};

typedef struct DamageDecayConfig
{
	int iDecayDelay;
	int iFullDiscardDelay;
	float fDiscardDamage;
	float fRegenFactor;
	int discardZeroDamagers;
} DamageDecayConfig;

TokenizerParseInfo ParseDamageDecayConfig[] =
{
	{ "{",                TOK_START,    0 },
	{ "DecayDelay",       TOK_INT(DamageDecayConfig, iDecayDelay, 0) },
	{ "FullDiscardDelay", TOK_INT(DamageDecayConfig, iFullDiscardDelay, 0) },
	{ "DiscardDamage",    TOK_F32(DamageDecayConfig, fDiscardDamage, 0)  },
	{ "RegenFactor",      TOK_F32(DamageDecayConfig, fRegenFactor, 0) },
	{ "DiscardZeroDamagers",       TOK_INT(DamageDecayConfig, discardZeroDamagers, 0) },
	{ "}",                TOK_END,      0 },
	{ "", 0, 0 }
};

#include "character_inventory.h"

TokenizerParseInfo ParseInventoryDefinition[] =
{
	{ "{",				TOK_START,  0 },
	{ "AmountAtLevel",	TOK_INTARRAY(InventorySizeDefinition, piAmountAtLevel)     },
	{ "AmountAtLevelFree",	TOK_INTARRAY(InventorySizeDefinition, piAmountAtLevelFree)     },
	{ "}",				TOK_END,    0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseInventoryDefinitions[] =
{
	{ "{",				TOK_START,  0 },
	{ "Salvage",		TOK_EMBEDDEDSTRUCT(InventorySizes, salvageSizes, ParseInventoryDefinition)},
	{ "Recipe",			TOK_EMBEDDEDSTRUCT(InventorySizes, recipeSizes, ParseInventoryDefinition)},
	{ "Auction",		TOK_EMBEDDEDSTRUCT(InventorySizes, auctionSizes, ParseInventoryDefinition)},
	{ "StoredSalvage",		TOK_EMBEDDEDSTRUCT(InventorySizes, storedSalvageSizes, ParseInventoryDefinition)},
	{ "}",				TOK_END,    0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseInventoryLoyaltyBonusDefinition[] =
{
	{ "{",					TOK_START,  0 },
	{ "Name",				TOK_STRING(InventoryLoyaltyBonusSizeDefinition, name, 0)     },
	{ "SalvageBonusSlots",	TOK_INT(InventoryLoyaltyBonusSizeDefinition, salvageBonus, 0)     },
	{ "RecipeBonusSlots",	TOK_INT(InventoryLoyaltyBonusSizeDefinition, recipeBonus, 0)     },
	{ "VaultBonusSlots",	TOK_INT(InventoryLoyaltyBonusSizeDefinition, vaultBonus, 0)     },
	{ "AuctionBonusSlots",	TOK_INT(InventoryLoyaltyBonusSizeDefinition, auctionBonus, 0)     },
	{ "}",					TOK_END,    0 },
	{ 0 }
};

TokenizerParseInfo ParseInventoryLoyaltyBonusDefinitions[] =
{
	{ "LoyaltyBonus",		TOK_STRUCT(InventoryLoyaltyBonusSizes, bonusList, ParseInventoryLoyaltyBonusDefinition)},
	{ "", 0, 0 }
};

#include "DayJob.h"
StaticDefineInt DayJobPowerTypeParseEnum[] =
{
	DEFINE_INT
	{ "TimeInGame",			kDayJobPowerType_TimeInGame	},
	{ "TimeUsed",			kDayJobPowerType_TimeUsed	},
	{ "Activation",			kDayJobPowerType_Activation	},
	DEFINE_END
};


static TokenizerParseInfo parse_dayjobpowers[] =
{
	{ "{",							TOK_START, 0},
	{ "Power",						TOK_STRING( DayJobPower, pchPower, 0 ),				},
	{ "Salvage",					TOK_STRING( DayJobPower, pchSalvage, 0 ),			},
	{ "Requires",					TOK_STRINGARRAY( DayJobPower, ppchRequires)			},
	{ "Factor",						TOK_F32(DayJobPower, fFactor,0),					},
	{ "Max",						TOK_INT(DayJobPower, iMax, 0),						},
	{ "RemainderToken",				TOK_STRING( DayJobPower, pchRemainderToken, 0 ),	},
	{ "Type",			            TOK_INT(DayJobPower, eType, kDayJobPowerType_TimeInGame), DayJobPowerTypeParseEnum },
	{ "}",							TOK_END,   0},
	{ "", 0, 0 }
};

static TokenizerParseInfo parse_dayjobdetail[] =
{
	{ "{",							TOK_START, 0},
	{ "SourceFile",					TOK_CURRENTFILE						( DayJobDetail, pchSourceFile)		},
	{ "Name",						TOK_STRUCTPARAM | TOK_STRING		( DayJobDetail, pchName, 0 ),           },
	{ "DisplayName",				TOK_STRING( DayJobDetail, pchDisplayName, 0 ), },
	{ "VolumeName",					TOK_STRINGARRAY( DayJobDetail, ppchVolumeNames ), },
	{ "ZoneName",					TOK_STRING( DayJobDetail, pchZoneName, 0 ), },
	{ "Stat",						TOK_STRING( DayJobDetail, pchStat, 0 ), },
	{ "Power",						TOK_STRUCT( DayJobDetail, ppPowers, parse_dayjobpowers ) },
	{ "}",              TOK_END,   0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseDayJobDetailDict[] =
{
	{ "DayJob",				TOK_STRUCT(DayJobDetailDict, ppJobs, parse_dayjobdetail)	},
	{ "MinTime",			TOK_INT(DayJobDetailDict, minTime, 0)						},
	{ "PatrolXPMultiplier",	TOK_F32(DayJobDetailDict, fPatrolXPMultiplier, 2.0f),		},
	{ "PatrolScalar",		TOK_F32(DayJobDetailDict, fPatrolScalar, 0)					}, // 0.0001f) },
	{ "", 0, 0 }
};

#include "NewFeatures.h"
TokenizerParseInfo ParseNewFeature[]=
{
	{ "",   TOK_STRUCTPARAM|TOK_INT(NewFeature, id, 0 ) }, //ID
	{ "",   TOK_STRUCTPARAM|TOK_STRING(NewFeature, pchDescription, 0 ) },	//Description
	{ "",   TOK_STRUCTPARAM|TOK_STRING(NewFeature, pchCommand, 0 ) },		//Command
	{ "\n",   TOK_STRUCTPARAM|TOK_END,  0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseNewFeatureList[]=
{
	{ "NewFeature",   TOK_STRUCT(NewFeatureList, list, ParseNewFeature),  0 },
	{ "", 0, 0 }
};

#include "boost.h"

TokenizerParseInfo ParseBoostChanceTable[] =
{
	{ "{",                TOK_START,    0 },
	{ "CombineChances",   TOK_EARRAY | TOK_F32_X, 0 },
	{ "}",                TOK_END,      0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseBoostEffectivenessTable[] =
{
	{ "{",                TOK_START,    0 },
	{ "Effectiveness",    TOK_EARRAY | TOK_F32_X, 0 },
	{ "}",                TOK_END,      0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseBoostExemplarTable[] =
{
	{ "{",                TOK_START,    0 },
	{ "Limits",           TOK_F32ARRAY(ExemplarHandicaps, pfLimits)    },
	{ "Weights",          TOK_F32ARRAY(ExemplarHandicaps, pfHandicaps) },
	{ "PreClamp",         TOK_F32ARRAY(ExemplarHandicaps, pfPreClamp)  },
	{ "PostClamp",        TOK_F32ARRAY(ExemplarHandicaps, pfPostClamp) },
	{ "}",                TOK_END,      0 },
	{ "", 0, 0 }
};

#define MAX_PETS 20 //Corresponds to the number of "PetBattlePetX" in RewardTokens.reward, if you change, remember to rebuild templates 
#define PETREWARDSTRING "PetBattlePet"
#define DEFAULT_MAX_PET_ARMY_POINTS 1000

typedef struct PetBattleCreatureInfo
{
	char * name;				//Name is unique, and used to create tokenID for reward token
	char * VillainDefName;
	int spawnLevel;
	int tokenID;				//Generated 
	char * badgeRequired;
	int cost;
	char * baseBehavior;
} PetBattleCreatureInfo;

typedef struct PetBattleCreatureInfoList
{
	PetBattleCreatureInfo ** infos;
	int maxPoints;
} PetBattleCreatureInfoList;

TokenizerParseInfo ParsePetBattleCreatureInfo[] =
{
	{ "CreatureInfo",			TOK_START,						0													}, // hack, for reloading
	{ "Name",					TOK_STRUCTPARAM | TOK_STRING( PetBattleCreatureInfo, name, 0			)	},
	{ "VillainDef",				TOK_STRING( PetBattleCreatureInfo, VillainDefName, 0	)	},
	{ "SpawnLevel",				TOK_INT( PetBattleCreatureInfo, spawnLevel, 0		)	},
	{ "BadgeRequired",			TOK_STRING( PetBattleCreatureInfo, badgeRequired, 0	)	},
	{ "BaseBehavior",			TOK_STRING( PetBattleCreatureInfo, baseBehavior, 0	)	},
	{ "Cost",					TOK_INT( PetBattleCreatureInfo, cost, 0			)	},
	{	"{",					TOK_START,						0 },
	{	"}",					TOK_END,							0 },
	{ "", 0, 0 }

};


TokenizerParseInfo ParsePetBattleCreatureInfoList[] = 
{
	{ "MaxPoints",		TOK_INT( PetBattleCreatureInfoList, maxPoints, DEFAULT_MAX_PET_ARMY_POINTS )		},
	{ "CreatureInfo",	TOK_STRUCT( PetBattleCreatureInfoList, infos, ParsePetBattleCreatureInfo ) },
	{ "", 0, 0 }
};

#include "dialogdef.h"

// Global DialogDefs
typedef struct DialogDefList
{
	const DialogDef**	dialogs;
	cStashTable			haDialogCRCs;
} DialogDefList;

TokenizerParseInfo ParseDialogDefList[] = {
	{ "Dialog",		TOK_STRUCT(DialogDefList,dialogs,ParseDialogDef) },
	{ "", 0, 0 }
};

#include "TaskforceParams.h"

typedef struct SLLevelMapping
{
	TFParamSL stature;
	int minLevel;
	int maxLevel;
} SLLevelMapping;

static SLLevelMapping SLMappings[] =
{
	TFPARAM_SL1,	1,	5,
	TFPARAM_SL2,	6,	10,
	TFPARAM_SL25,	11,	14,
	TFPARAM_SL3,	15,	19,
	TFPARAM_SL4,	20,	24,
	TFPARAM_SL5,	25,	29,
	TFPARAM_SL6,	30,	34,
	TFPARAM_SL7,	35,	39,
	TFPARAM_SL8,	40,	45,
	TFPARAM_SL9,	46,	50
};

typedef struct StoryArcTimeLimit
{
	StoryArc* arcDef;
	char* fileName;
	U32 bronze;
	U32 silver;
	U32 gold;
} StoryArcTimeLimit;

typedef struct StoryArcTimeLimitList
{
	StoryArcTimeLimit** limits;
} StoryArcTimeLimitList;

static ParseTable ParseStoryArcTimeLimits[] =
{
	{ "{", TOK_START, 0 },
	{ "Filename", TOK_STRING(StoryArcTimeLimit, fileName, 0) },
	{ "Gold", TOK_INT(StoryArcTimeLimit, gold, 0) },
	{ "Silver", TOK_INT(StoryArcTimeLimit, silver, 0) },
	{ "Bronze", TOK_INT(StoryArcTimeLimit, bronze, 0) },
	{ "}", TOK_END, 0 },
	{ 0 }
};

static ParseTable ParseStoryArcTimeLimit[] =
{
	{ "StoryArc", TOK_STRUCT(StoryArcTimeLimitList, limits, ParseStoryArcTimeLimits), 0 },
	{ 0 }
};


""".}