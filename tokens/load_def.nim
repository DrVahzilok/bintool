{.emit: """
#include "load_def.h"
#include "EndGameRaid.h"
#include "PCC_Critter.h"

TokenizerParseInfo ParsePCC_CritterRewardMods[]=
{
	{ "{",                TOK_START,  0 },
	{ "DifficultyMod",    TOK_F32ARRAY(PCC_CritterRewardMods, fDifficulty)},
	{ "MissingRankPenalty",    TOK_F32ARRAY(PCC_CritterRewardMods, fMissingRankPenalty)},
	{ "CustomPowerNumberMod",    TOK_F32ARRAY(PCC_CritterRewardMods, fPowerNum)},
	{ "ArchitectAmbushScaling",		TOK_F32(PCC_CritterRewardMods, fAmbushScaling, 1.0f)},
	{ "}",                TOK_END,    0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePowerSetConversion[]=
{
	{ "",   TOK_STRUCTPARAM|TOK_STRING(PowerSetConversion, pchPlayerPowerSet, 0 ),  0 },
	{ "",   TOK_STRUCTPARAM|TOK_STRINGARRAY(PowerSetConversion, ppchPowerSets ),  0 },
	{ "\n",   TOK_STRUCTPARAM|TOK_END,  0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePowerSetConversionTable[]=
{
	{ "PowerSet",   TOK_STRUCT(PowerSetConversionTable, ppConversions,  ParsePowerSetConversion),  0 },
	{ "", 0, 0 }
};

StaticDefineInt ParseMARTYExperienceTypes[] =
{
	DEFINE_INT
	{"Architect",MARTY_ExperienceArchitect},
	{"Combined",MARTY_ExperienceCombined},
	DEFINE_END
};

typedef enum MARTY_Actions
{
	MARTY_Action_Log,
	MARTY_Action_Throttle,
}MARTY_Actions;

StaticDefineInt ParseMARTYActions[] =
{
	DEFINE_INT
	{"Log",MARTY_Action_Log},
	{"Throttle",MARTY_Action_Throttle},
	DEFINE_END
};

StaticDefineInt ParseIncarnateSlotNames[] = {
	DEFINE_INT
	{	"Alpha",	kIncarnateSlot_Alpha		},
	{	"Destiny",	kIncarnateSlot_Destiny		},
	{	"Genesis",	kIncarnateSlot_Genesis		},
	{	"Hybrid",	kIncarnateSlot_Hybrid		},
	{	"Interface",kIncarnateSlot_Interface	},
	{	"Judgement",kIncarnateSlot_Judgement	},
	{	"Lore",		kIncarnateSlot_Lore			},
	{	"Mind",		kIncarnateSlot_Mind			},
	{	"Vitae",	kIncarnateSlot_Vitae		},
	{	"Omega",	kIncarnateSlot_Omega		},
	DEFINE_END
};

TokenizerParseInfo ParseZoneEventKarmaVar[]=
{
	{ "{",   TOK_START,  0 },
	{ "Amount",   TOK_INT(ZoneEventKarmaVarTable, karmaVar[CKV_AMOUNT], 0 ),  0 },
	{ "Lifespan",   TOK_INT(ZoneEventKarmaVarTable, karmaVar[CKV_LIFESPAN], 0 ),  0 },
	{ "StackLimit",   TOK_INT(ZoneEventKarmaVarTable, karmaVar[CKV_STACK_LIMIT], 0 ),  0 },
	{ "}",   TOK_END,  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseZoneEventKarmaClassMod[]=
{
	{ "{",   TOK_START,  0 },
	{ "ClassName",   TOK_STRING(ZoneEventKarmaClassMod, pchClassName, 0 )},
	{ "ClassMod",   TOK_F32(ZoneEventKarmaClassMod, classMod, 1.0f )},
	{ "}",   TOK_END,  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseZoneEventKarmaTable[]=
{
	{ "PowerClick",   TOK_EMBEDDEDSTRUCT(ZoneEventKarmaTable, karmaReasonTable[CKR_POWER_CLICK], ParseZoneEventKarmaVar),  0 },
	{ "BuffPowerClick",   TOK_EMBEDDEDSTRUCT(ZoneEventKarmaTable, karmaReasonTable[CKR_BUFF_POWER_CLICK], ParseZoneEventKarmaVar),  0 },
	{ "TeamObjComplete",   TOK_EMBEDDEDSTRUCT(ZoneEventKarmaTable, karmaReasonTable[CKR_TEAM_OBJ_COMPLETE], ParseZoneEventKarmaVar),  0 },
	{ "AllPlayObjComplete",   TOK_EMBEDDEDSTRUCT(ZoneEventKarmaTable, karmaReasonTable[CKR_ALL_OBJ_COMPLETE], ParseZoneEventKarmaVar),  0 },
	{ "ClassModifier",	TOK_STRUCT(ZoneEventKarmaTable, ppClassMod, ParseZoneEventKarmaClassMod), 0 },
	{ "PowerLifeCap",   TOK_INT(ZoneEventKarmaTable, powerLifespanCap, 0),  0 },	
	{ "PowerLifeConst",   TOK_INT(ZoneEventKarmaTable, powerLifespanConst, 0),  0 },	
	{ "PowerStackMod",   TOK_INT(ZoneEventKarmaTable, powerStackModifier, 0),  0 },	
	{ "PowerBubbleDur",	 TOK_INT(ZoneEventKarmaTable, powerBubbleDur, 0),  0 },	
	{ "PowerBubbleRad",	 TOK_INT(ZoneEventKarmaTable, powerBubbleRad, 0),  0 },	
	{ "KarmaPardonDuration",		TOK_INT(ZoneEventKarmaTable, pardonDuration, 0), 0 },
	{ "KarmaPardonGrace",		TOK_INT(ZoneEventKarmaTable, pardonGrace, 0), 0 },
	{ "ActiveDuration",		TOK_INT(ZoneEventKarmaTable, activeDuration, 0), 0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseDesignerContactTip[]=
{
	{ "",   TOK_STRUCTPARAM|TOK_STRING(DesignerContactTip, rewardTokenName, 0 ) },
	{ "",   TOK_STRUCTPARAM|TOK_STRING(DesignerContactTip, tokenTypeStr, 0 ) },
	{ "",   TOK_STRUCTPARAM|TOK_INT(DesignerContactTip, tipLimit, 0 ) },
	{ "",	TOK_STRUCTPARAM|TOK_BOOL(DesignerContactTip, revokeOnAlignmentSwitch, 0), ModBoolEnum},
	{ "\n",   TOK_STRUCTPARAM|TOK_END,  0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseDesignerContactTipTypes[]=
{
	{ "DesignerTipType",   TOK_STRUCT(DesignerContactTipTypes, designerTips,  ParseDesignerContactTip),  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseIncarnateSlotInfo[] =
{
	{ "{",   TOK_START,  0 },
	{ "SlotUnlocked",   TOK_INT(IncarnateSlotInfo, slotUnlocked, -1),  ParseIncarnateSlotNames},
	{ "BadgeStat",		TOK_STRING(IncarnateSlotInfo,badgeStat, 0)},
	{ "ClientMessage",	TOK_STRING(IncarnateSlotInfo,clientMessage, 0)},
	{ "}",   TOK_END,  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseIncarnateExpInfo[]=
{
	{ "{",   TOK_START,  0 },
	{ "ExpType",		 TOK_STRING(IncarnateExpInfo, incarnateXPType, 0)},
	{ "IncarnateSlotInfo",   TOK_STRUCT(IncarnateExpInfo, incarnateSlotInfo, ParseIncarnateSlotInfo)},
	{ "}",   TOK_END,  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseIncarnateExpMods[]=
{
	{ "{",   TOK_START,  0 },
	{ "Modifiers",   TOK_F32ARRAY(IncarnateModifier, incarnateExpModifier)},
	{ "}",   TOK_END,  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseIncarnateMods[]=
{
	{ "IncarnateSlots",   TOK_STRUCT(IncarnateMods, incarnateExpList,  ParseIncarnateExpInfo),  0 },
	{ "OriginTechMods",   TOK_EMBEDDEDSTRUCT(IncarnateMods, incarnateModifierList[kProfOriginType_Tech], ParseIncarnateExpMods),  0 },
	{ "OriginScienceMods",   TOK_EMBEDDEDSTRUCT(IncarnateMods, incarnateModifierList[kProfOriginType_Science], ParseIncarnateExpMods),  0 },
	{ "OriginMutantMods",   TOK_EMBEDDEDSTRUCT(IncarnateMods, incarnateModifierList[kProfOriginType_Mutant], ParseIncarnateExpMods),  0 },
	{ "OriginMagicMods",   TOK_EMBEDDEDSTRUCT(IncarnateMods, incarnateModifierList[kProfOriginType_Magic], ParseIncarnateExpMods),  0 },
	{ "OriginNaturalMods",   TOK_EMBEDDEDSTRUCT(IncarnateMods, incarnateModifierList[kProfOriginType_Natural], ParseIncarnateExpMods),  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseEndGameRaidKickMods[]=
{
	{ "LastKickTime_Secs",			TOK_INT(EndGameRaidKickMods, lastKickTimeSeconds, 0),  0 },
	{ "LastPlayerKickTime_Mins",	TOK_INT(EndGameRaidKickMods, lastPlayerKickTimeMins, 0),  0 },
	{ "MinRaidTime_Mins",			TOK_INT(EndGameRaidKickMods, minRaidTimeMins, 0),  0 },
	{ "KickDuration_Secs",			TOK_INT(EndGameRaidKickMods, kickDurationSeconds, 0),  0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseMARTYLevelMods[]=
{
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelMods, level, 0), 0 },
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelMods, expGain1Min, 0), 0 },
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelMods, expGain5Min, 0), 0 },
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelMods, expGain15Min, 0), 0 },
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelMods, expGain30Min, 0), 0 },
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelMods, expGain60Min, 0), 0 },
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelMods, expGain120Min, 0), 0 },
	{ "\n",						TOK_END, 0														},
	{ "", 0, 0 }
};
TokenizerParseInfo ParseMARTYExpMods[]=
{
	{ "{",   TOK_START,  0 },
	{ "ExpType",		TOK_INT(MARTYExpMods, expType, 0),  ParseMARTYExperienceTypes },
	{ "Action",			TOK_INT(MARTYExpMods, action, 0),  ParseMARTYActions },
	{ "Level",			TOK_STRUCT(MARTYExpMods, perLevelThrottles, ParseMARTYLevelMods)},
	{ "LogMessage",			TOK_STRING(MARTYExpMods, logAppendMsg, 0), 0},
	{ "}",   TOK_END,  0 },
	{ "", 0, 0 }
};
TokenizerParseInfo ParseMARTYLevelupMods[]=
{
	{	".",		TOK_STRUCTPARAM | TOK_INT(MARTYLevelupShifts, level, 0), 0 },
	{	".",		TOK_STRUCTPARAM | TOK_F32(MARTYLevelupShifts, mod, 0), 0 },
	{ "\n",						TOK_END, 0														},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseMARTYMods[]=
{
	{	"MARTYMod",			TOK_STRUCT(MARTYMods, perActionType, ParseMARTYExpMods)	},
	{	"MARTYLevelupMod",	TOK_STRUCT(MARTYMods, levelupShifts, ParseMARTYLevelupMods)	},
	{ "", 0, 0 }
};
""".}