{.emit: """
#include "Reward.h"

StaticDefineInt rewardTokenFlags[] = {
	DEFINE_INT
	{ "Player", kRewardTokenType_Player },
	{ "Sgrp", kRewardTokenType_Sgrp },
	{ "ActivePlayer", kRewardTokenType_ActivePlayer },
	DEFINE_END
};

typedef struct RewardTable
{
	const char *name;         // name of this table
	const char *filename;		// where the data came from (debugging only)
	RewardTokenType	permanentRewardToken;
	bool randomItemOfPower;
	const RewardDef** ppDefs; // rewards defs for each level
	int	verified;		// shortcut for verification purposes
} RewardTable;

typedef struct RewardDictionary
{
	const RewardTable **ppTables;
	cStashTable hashRewardTable;
} RewardDictionary;

typedef struct ItemSetDictionary
{
	const RewardItemSet **ppItemSets;
	cStashTable hashItemSets;
} ItemSetDictionary;

typedef struct RewardChoiceDictionary
{
	const RewardChoiceSet **ppChoiceSets;
	cStashTable hashRewardChoice;
}RewardChoiceDictionary;

typedef struct MeritRewardStoryArc
{
	const char *name;
	int	merits;
	int	failedmerits;
	const char *rewardToken;
	const char *bonusOncePerEpochTable;
	const char *bonusReplayTable;
	const char *bonusToken;
	int bonusMerits;
} MeritRewardStoryArc;

typedef struct MeritRewardDictionary
{
	const MeritRewardStoryArc **ppStoryArc;
	cStashTable hashMeritReward;
} MeritRewardDictionary;


typedef struct GlobalRewardDefinition
{
	const char *name;
	const char *path;
	const char *itemSetSM;
	const char *itemSetBin;
	const char *rewardSM;
	const char *rewardBin;
	const char *rewardChoiceSM;
	const char *rewardChoiceBin;
	
	ItemSetDictionary		itemSetDictionary;
	RewardDictionary		rewardDictionary;
	RewardChoiceDictionary	rewardChoiceDictionary;
	MeritRewardDictionary	meritRewardDictionary;

} GlobalRewardDefinition;

#if SERVER
DefineContext *g_pParseIncarnateDefines = NULL;
STATIC_DEFINE_WRAPPER(ParseIncarnateDefines, g_pParseIncarnateDefines);
#endif

StaticDefineInt AddRemoveEnum[] =
{
	DEFINE_INT
	{ "Power", 0 },
	{ "Add", 0 },
	{ "RemovePower", 1 },
	{ "Remove", 1 },
	DEFINE_END
};

TokenizerParseInfo ParsePowerRewardItemChance[] =
{
	{	"Chance",			TOK_STRUCTPARAM | TOK_INT(RewardItem, chance, 0),               },
	{	"AddRemove",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.remove, 0), AddRemoveEnum},
	{	"PowerCategory",	TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerCategory, 0)   },
	{	"PowerSet",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerSet, 0)        },
	{	"Power",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.power,   0)           },
	{	"Level",			TOK_STRUCTPARAM | TOK_INT(RewardItem, power.level,      0) },
	{	"FixedLevel",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.fixedlevel, 0) },

	// -AB: this type should always be omitted, type is implicit, put new entries above this :2005 Feb 17 03:13 PM
	{	"Type",				TOK_INT(RewardItem, type, kRewardItemType_Power) },
	// these fields are here so the tokenizer persists them, but they are not used in a power
	// reward item. This is necessary because multiple reward item definitions use the same
	// type to convey reward information
	{	"Pad1",				TOK_INT(RewardItem, padField1, 0) },
	{	"Pad2",				TOK_INT(RewardItem, padField2, 0) },
	{	"ItemSetAddRemove",	TOK_INT(RewardItem, remove, 0), AddRemoveEnum},
	{	"\n",				TOK_END,								0 },
	{	"", 0, 0 }
};


TokenizerParseInfo ParsePowerRewardItemChanceFixedLevel[] =
{
	{	"Chance",			TOK_STRUCTPARAM | TOK_INT(RewardItem, chance, 0),               },
	{	"PowerCategory",	TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerCategory, 0)   },
	{	"PowerSet",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerSet, 0)        },
	{	"Power",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.power, 0)           },
	{	"Level",			TOK_STRUCTPARAM | TOK_INT(RewardItem, power.level,        0) },
	{	"FixedLevel",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.fixedlevel,   1) },
	{	"AddRemove",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.remove,       0), AddRemoveEnum},

	// -AB: this type should always be omitted :2005 Feb 17 03:13 PM
	{	"Type",				TOK_INT(RewardItem, type,             kRewardItemType_Power) },
	// these fields are here so the tokenizer persists them, but they are not used in a power
	// reward item. This is necessary because multiple reward item definitions use the same
	// type to convey reward information
	{	"Pad1",				TOK_INT(RewardItem, padField1, 0) },
	{	"Pad2",				TOK_INT(RewardItem, padField2, 0) },
	{	"ItemSetAddRemove",	TOK_INT(RewardItem, remove, 0), AddRemoveEnum},
	{	"\n",				TOK_END,							0},
	{	"", 0, 0 }
};

TokenizerParseInfo ParsePowerRewardItemAdd[] =
{
	{	"PowerCategory",	TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerCategory, 0)   },
	{	"PowerSet",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerSet, 0)        },
	{	"Power",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.power, 0)           },
	{	"Level",			TOK_STRUCTPARAM | TOK_INT(RewardItem, power.level,        0) },
	{	"Chance",			TOK_STRUCTPARAM | TOK_INT(RewardItem, chance,             1) },
	{	"FixedLevel",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.fixedlevel,   0) },
	{	"AddRemove",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.remove,       0), AddRemoveEnum},

	// -AB: this type should always be omitted :2005 Feb 17 03:13 PM
	{	"Type",				TOK_INT(RewardItem, type,             kRewardItemType_Power) },
	// these fields are here so the tokenizer persists them, but they are not used in a power
	// reward item. This is necessary because multiple reward item definitions use the same
	// type to convey reward information
	{	"Pad1",				TOK_INT(RewardItem, padField1, 0) },
	{	"Pad2",				TOK_INT(RewardItem, padField2, 0) },
	{	"ItemSetAddRemove",	TOK_INT(RewardItem, remove, 0), AddRemoveEnum},
	{	"\n",				TOK_END,							0},
	{	"", 0, 0 }
};

TokenizerParseInfo ParsePowerRewardItemRemove[] =
{
	{	"PowerCategory",	TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerCategory, 0)   },
	{	"PowerSet",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.powerSet, 0)        },
	{	"Power",			TOK_STRUCTPARAM | TOK_STRING(RewardItem, power.power, 0)           },
	{	"Level",			TOK_STRUCTPARAM | TOK_INT(RewardItem, power.level,        0) },
	{	"FixedLevel",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.fixedlevel,   0) },
	{	"Chance",			TOK_STRUCTPARAM | TOK_INT(RewardItem, chance,             1) },
	{	"AddRemove",		TOK_STRUCTPARAM | TOK_INT(RewardItem, power.remove,       1), AddRemoveEnum},
	{	"\n",				TOK_END,							0},
	{	"", 0, 0 }
};

//------------------------------------------------------------
//  Helper for the reward items that share common characteristics:
// - Salvage 10 Scrap
// - Concept 20 Dynamite
// - Proficiency 71 Gadget
// NOTE: the 'type' element is not a STRUCTPARAM, and is there for the
//       automatic value that it takes.
//----------------------------------------------------------
#define GENERIC_REWARDITEM_PARSEINFO(TYPE) \
	{	"Chance",	TOK_STRUCTPARAM | TOK_INT(RewardItem, chance,1) }, \
	{	"Name",		TOK_STRUCTPARAM | TOK_STRING(RewardItem, itemName, 0) }, \
	{	"Type",		TOK_INT(RewardItem, type, TYPE)						}, \
	{	"\n",		TOK_END,							0				}

TokenizerParseInfo ParseTokenRewardItemRemove[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_Token),
	{	"AddRemove",	TOK_STRUCTPARAM | TOK_INT(RewardItem, remove, 1), AddRemoveEnum},
	{	"", 0, 0 }
};

static TokenizerParseInfo ParseSalvageRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_Salvage),
	{	"Count", TOK_STRUCTPARAM | TOK_INT(RewardItem, count, 1) },
	{	"", 0, 0 }
};

static TokenizerParseInfo ParseConceptRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_Concept),
	{	"", 0, 0 }
};

static TokenizerParseInfo ParseProficiencyRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_Proficiency),
	{	"", 0, 0 }
};

StaticDefineInt rewardDetailRecipeFlags[] = {
	DEFINE_INT
	{ "unlimited", 1 },
	DEFINE_END
};

StaticDefineInt rewardRewardTableFlags[] = {
	DEFINE_INT
	{ "AtCritterLevel", kRewardTableFlags_AtCritterLevel },
	DEFINE_END
};

static TokenizerParseInfo ParseDetailRecipeRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_DetailRecipe),
	{	"Count", TOK_STRUCTPARAM | TOK_INT(RewardItem, count, 0) },
	{	"Unlimited", TOK_STRUCTPARAM | TOK_FLAGS(RewardItem, unlimited, 0), rewardDetailRecipeFlags },
	{	"", 0, 0 }
};

static TokenizerParseInfo ParseDetailRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_Detail),
	{	"", 0, 0 }
};


static TokenizerParseInfo ParseRewardTableRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_RewardTable),
	{	"RewardTableFlags", TOK_STRUCTPARAM | TOK_FLAGS(RewardItem, rewardTableFlags, 0), rewardRewardTableFlags },
	{	"", 0, 0 }
};

static TokenizerParseInfo ParseRewardTokenCountRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_RewardTokenCount),
	{	"Count", TOK_STRUCTPARAM | TOK_INT(RewardItem, count, 0) },
	{	"", 0, 0 }
};

static TokenizerParseInfo ParseIncarnatePointsRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_IncarnatePoints),
	{ "Count", TOK_STRUCTPARAM | TOK_INT(RewardItem, count, 0) },
	{ "", 0, 0 }
};

static TokenizerParseInfo ParseAccountProductRewardItem[] =
{
	GENERIC_REWARDITEM_PARSEINFO(kRewardItemType_AccountProduct),
	{ "Count", TOK_STRUCTPARAM | TOK_INT(RewardItem, count, 0) },
	{ "Rarity", TOK_STRUCTPARAM | TOK_INT(RewardItem, rarity, 0), AccountTypes_RarityEnum },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseChanceRequiresItem[] =
{
	{	"Requires",					TOK_STRINGARRAY( RewardItem, chanceRequires),             },
	{	"Chance",					TOK_NULLSTRUCT(ParsePowerRewardItemChance)},
	{	"Power",					TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParsePowerRewardItemAdd)},
	{	"RemovePower",				TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParsePowerRewardItemRemove)},
	{	"Salvage",					TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseSalvageRewardItem)},
	{	"Concept",					TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseConceptRewardItem)},
	{	"Proficiency",				TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseProficiencyRewardItem)},
	{	"DetailRecipe",				TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseDetailRecipeRewardItem)},
	{	"Recipe",					TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseDetailRecipeRewardItem)},
	{	"Detail",					TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseDetailRewardItem)},
	{	"RemoveToken",				TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseTokenRewardItemRemove)},
	{	"RewardTable",				TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseRewardTableRewardItem)},
	{	"TokenCount",				TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseRewardTokenCountRewardItem)},
	{	"IncarnatePoints",			TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseIncarnatePointsRewardItem)},
	{	"AccountProduct",			TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParseAccountProductRewardItem)},
	{	"FixedLevelEnh",			TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParsePowerRewardItemChanceFixedLevel)},
	{	"FixedLevelEnhancement",	TOK_REDUNDANTNAME | TOK_NULLSTRUCT(ParsePowerRewardItemChanceFixedLevel)},
	{	"{",						TOK_START,		0 },
	{	"}",						TOK_END,		0 },
	{	"", 0, 0 }
};


//------------------------------------------------------------
// parse a RewardItemSet
// see ParsePowerRewardItemChance, where it is called 'ItemSet'
// see ParseRewardItemSet, where it is called 'ItemSetDef'
// currently the 'Chance' member controls writing these members
//to memory and the bin file, i
// -AB: adding salvage :2005 Feb 17 02:55 PM
//----------------------------------------------------------
TokenizerParseInfo ParseRewardItemSet[] =
{
	{	"Name",						TOK_STRUCTPARAM | TOK_STRING(RewardItemSet, name, 0) },
	{	"Filename",					TOK_CURRENTFILE(RewardItemSet, filename) },
	{	"Verified",					TOK_INT(RewardItemSet, verified, 0) },
	{	"Chance",					TOK_STRUCT(RewardItemSet, rewardItems, ParsePowerRewardItemChance)},
	{	"Power",					TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParsePowerRewardItemAdd)},
	{	"RemovePower",				TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParsePowerRewardItemRemove)},
	{	"Salvage",					TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseSalvageRewardItem)},
	{	"Concept",					TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseConceptRewardItem)},
	{	"Proficiency",				TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseProficiencyRewardItem)},
	{	"DetailRecipe",				TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseDetailRecipeRewardItem)},
	{	"Recipe",					TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseDetailRecipeRewardItem)},
	{	"Detail",					TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseDetailRewardItem)},
	{	"RemoveToken",				TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseTokenRewardItemRemove)},
	{	"RewardTable",				TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseRewardTableRewardItem)},
	{	"TokenCount",				TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseRewardTokenCountRewardItem)},
	{	"IncarnatePoints",			TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseIncarnatePointsRewardItem)},
	{	"AccountProduct",			TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParseAccountProductRewardItem)},
	{	"FixedLevelEnh",			TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParsePowerRewardItemChanceFixedLevel)},
	{	"FixedLevelEnhancement",	TOK_REDUNDANTNAME | TOK_STRUCT(RewardItemSet, rewardItems, ParsePowerRewardItemChanceFixedLevel)},
	{	"ChanceRequires",			TOK_STRUCT(RewardItemSet, rewardItems, ParseChanceRequiresItem)},
	{	"{",						TOK_START,		0 },
	{	"}",						TOK_END,		0 },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseRewardDropGroup[] =
{
	{	"Chance",		TOK_STRUCTPARAM | TOK_INT(RewardDropGroup, chance, 0)},
	{	"ItemSetName",	TOK_STRINGARRAY(RewardDropGroup,itemSetNames) },
	{	"ItemSet",		TOK_STRUCT(RewardDropGroup, itemSets, ParseRewardItemSet)},
	{	"{",			TOK_START,		0 },
	{	"}",			TOK_END,			0 },
	{	"", 0, 0 }
};

StaticDefineInt rewardSetFlags[] = {
	DEFINE_INT
	{ "always",		RSF_ALWAYS },
	{ "everyone",	RSF_EVERYONE },
	{ "nolimit",	RSF_NOLIMIT },
	{ "forced",		RSF_FORCED },
	DEFINE_END
};


TokenizerParseInfo ParseRewardSet[] =
{
	{	"Filename",			TOK_CURRENTFILE(RewardSet, filename) },
	{	"Chance",			TOK_STRUCTPARAM | TOK_F32(RewardSet, chance, 0)},
	{	"Flags",			TOK_STRUCTPARAM | TOK_FLAGS(RewardSet, flags, 0), rewardSetFlags},
	{	"{",				TOK_START,		0 },
	{	"DefaultOrigin",	TOK_BOOLFLAG(RewardSet, catchUnlistedOrigins, 0)},
	{	"Origin",			TOK_STRINGARRAY(RewardSet, origins)},
	{	"DefaultArchetype",	TOK_BOOLFLAG(RewardSet, catchUnlistedArchetypes, 0)},
	{	"Archetype",		TOK_STRINGARRAY(RewardSet, archetypes)},
	{	"DefaultVillainGroup",	TOK_BOOLFLAG(RewardSet, catchUnlistedVGs, 0)},
	{	"VillainGroup",		TOK_INTARRAY(RewardSet, groups), ParseVillainGroupEnum},
	{	"Requires",			TOK_STRINGARRAY(RewardSet, rewardSetRequires)},
	{	"Experience",		TOK_INT(RewardSet, experience, 0)},
	{   "BonusExperience",	TOK_F32(RewardSet, bonus_experience, 0)},
	{	"Wisdom",			TOK_INT(RewardSet, wisdom, 0)},
	{	"Influence",		TOK_INT(RewardSet, influence, 0)},
//	{	"RewardTable",		TOK_STRINGARRAY(RewardSet, rewardTable)}, // ARM NOTE: This appears to be unused, so I'm pulling it.  Revert if I'm wrong.
	{	"Prestige",			TOK_INT(RewardSet, prestige, 0)},
	{	"IncarnateSubtype", TOK_STRUCTPARAM | TOK_FLAGS(RewardSet, incarnateSubtype, 0), ParseIncarnateDefines },
	{	"IncarnateCount",	TOK_INT(RewardSet, incarnateCount, 0)},
	{	"IgnoreRewardCaps",	TOK_BOOLFLAG(RewardSet, bIgnoreRewardCaps, 0)},
	{	"LeagueOnly",		TOK_BOOLFLAG(RewardSet, bLeagueOnly, 0)},
	{	"SuperDropGroup",	TOK_STRUCT(RewardSet, sgrpDropGroups, ParseRewardDropGroup)},
	{	"DropGroup",		TOK_STRUCT(RewardSet, dropGroups, ParseRewardDropGroup)},
	{	"}",				TOK_END,			0 },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseRewardDef[] =
{

	{	"Level",		TOK_STRUCTPARAM | TOK_INT(RewardDef, level, 0)},
	{	"{",			TOK_START,		0 },
	{	"Chance",		TOK_STRUCT(RewardDef, rewardSets, ParseRewardSet)},
	{	"}",			TOK_END,			0 },
	{	"", 0, 0 }
};

TokenizerParseInfo ParseRewardTable[] =
{
	{	"Name",					TOK_STRUCTPARAM | TOK_STRING(RewardTable, name, 0)},
	{	"{",					TOK_START,		0 },
	{	"PermanentRewardToken",	TOK_FLAGS(RewardTable, permanentRewardToken, 0), rewardTokenFlags },
	{	"RandomItemOfPower",	TOK_BOOLFLAG(RewardTable, randomItemOfPower, 0) },
	{   "dataFilename",			TOK_CURRENTFILE(RewardTable,filename) },
	{	"Verified",				TOK_INT(RewardTable, verified, 0)},
	{	"Level",				TOK_STRUCT(RewardTable, ppDefs, ParseRewardDef) },
	{	"}",					TOK_END,		0 },
	{ 0 }
};

TokenizerParseInfo ParseRewardChoiceRequirement[] =
{
	{	"{",			TOK_START,	0	},
	{	"Requires",		TOK_STRINGARRAY(RewardChoiceRequirement, ppchRequires)	},
	{	"Warning",		TOK_STRING(RewardChoiceRequirement, pchWarning, 0)	},
	{	"}",			TOK_END,	0	},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseRewardChoice[] =
{
	{	"{",				TOK_START,	0										},
	{	"Description",		TOK_STRING(RewardChoice, pchDescription, 0)	},
	{	"Watermark",		TOK_STRING(RewardChoice, pchWatermark, 0) },
	{	"RewardTable",		TOK_STRINGARRAY(RewardChoice, ppchRewardTable)	},
	{	"Requirement",		TOK_STRUCT(RewardChoice, ppRequirements, ParseRewardChoiceRequirement)	},
	{	"VisibleRequirement",		TOK_STRUCT(RewardChoice, ppVisibleRequirements, ParseRewardChoiceRequirement)	},
	{	"RewardTableFlags", TOK_STRUCTPARAM | TOK_FLAGS(RewardChoice, rewardTableFlags, 0), rewardRewardTableFlags },
	{	"}",				TOK_END,		0										},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseRewardChoiceSet[] =
{
	{	"Name",			TOK_STRUCTPARAM | TOK_STRING(RewardChoiceSet, pchName, 0)},
	{	"Filename",		TOK_CURRENTFILE(RewardChoiceSet, pchSourceFile)},
	{	"Desc",			TOK_STRING(RewardChoiceSet, pchDesc, 0)},
	{	"UnusedInitializer",	TOK_INT(RewardChoiceSet, isMoralChoice, 0)},
	{	"DisableChooseNothing",	TOK_BOOLFLAG(RewardChoiceSet, disableChooseNothing, 0)},
	{	"{",			TOK_START,		0 },
	{	"Choice",		TOK_STRUCT(RewardChoiceSet, ppChoices, ParseRewardChoice) },
	{	"}",			TOK_END,			0 },
	{ 0 }
};

TokenizerParseInfo ParseRewardMoralChoiceSet[] =
{
	{	"Name",			TOK_STRUCTPARAM | TOK_STRING(RewardChoiceSet, pchName, 0)},
	{	"Desc",			TOK_STRING(RewardChoiceSet, pchDesc, 0)},
	{	"UnusedInitializer",	TOK_INT(RewardChoiceSet, isMoralChoice, 1)},
	{	"DisableChooseNothing",	TOK_BOOLFLAG(RewardChoiceSet, disableChooseNothing, 0)},
	{	"{",			TOK_START,		0 },
	{	"Choice",		TOK_STRUCT(RewardChoiceSet, ppChoices, ParseRewardChoice) },
	{	"}",			TOK_END,			0 },
	{ 0 }
};

TokenizerParseInfo ParseRewardDictionary[] =
{
	{	"RewardTable", TOK_STRUCT(RewardDictionary, ppTables, ParseRewardTable) },
	{ 0 }
};

TokenizerParseInfo ParseItemSetDictionary[] =
{
	{	"ItemSetDef", TOK_STRUCT(ItemSetDictionary, ppItemSets, ParseRewardItemSet) },
	{ 0 }
};

TokenizerParseInfo ParseRewardChoiceDictionary[] =
{
	{	"RewardChoiceTable", TOK_STRUCT(RewardChoiceDictionary, ppChoiceSets, ParseRewardChoiceSet) },
	{	"RewardMoralChoiceTable", TOK_STRUCT(RewardChoiceDictionary, ppChoiceSets, ParseRewardMoralChoiceSet) },
	{ 0 }
};

////////////////////////////////////////////////////////////////////////////////////////
// storyarc.merits

TokenizerParseInfo ParseMeritRewardStoryArc[] =
{
	{	"Name",						TOK_STRUCTPARAM | TOK_STRING(MeritRewardStoryArc, name, 0)			}, 
	{	"Merits",					TOK_STRUCTPARAM | TOK_INT(MeritRewardStoryArc, merits, 0)			}, 
	{	"FailedMerits",				TOK_STRUCTPARAM | TOK_INT(MeritRewardStoryArc, failedmerits, 0)		}, 
	{	"Token",					TOK_STRUCTPARAM | TOK_STRING(MeritRewardStoryArc, rewardToken, 0)	}, 
	{	"BonusOncePerEpochTable",	TOK_STRUCTPARAM | TOK_STRING(MeritRewardStoryArc, bonusOncePerEpochTable, 0)	}, 
	{	"BonusReplayTable",			TOK_STRUCTPARAM | TOK_STRING(MeritRewardStoryArc, bonusReplayTable, 0)	}, 
	{	"BonusToken",				TOK_STRUCTPARAM | TOK_STRING(MeritRewardStoryArc, bonusToken, 0)	}, 
	{	"BonusMerits",				TOK_STRUCTPARAM | TOK_INT(MeritRewardStoryArc, bonusMerits, 0)	}, 
	{	"\n",						TOK_END,							0								},
	{ 0 }
};

TokenizerParseInfo ParseMeritRewardDictionary[] =
{
	{	"Storyarc", TOK_STRUCT(MeritRewardDictionary, ppStoryArc, ParseMeritRewardStoryArc) },
	{ 0 }
};
""".}