{.emit: """
#include "pnpcCommon.h"
#if SERVER
	#include "pnpc.h"
#endif

#define DEFAULT_SHOUT_FREQUENCY		5
#define DEFAULT_SHOUT_VARIATION		10

TokenizerParseInfo ParsePNPCDef[] = {
	{ "{",				TOK_START,						0},
	{ "",				TOK_CURRENTFILE(PNPCDef,filename) },
	{ "Model",			TOK_STRING(PNPCDef,model,0) },
	{ "Name",			TOK_STRUCTPARAM | TOK_STRING(PNPCDef,name,0) },
	{ "DisplayName",	TOK_STRING(PNPCDef,displayname,0) },
	{ "SupergroupContact", TOK_STRING(PNPCDef,deprecated,0) }, // DEPRECATED
	{ "AI",				TOK_STRING(PNPCDef,ai,0) },
	{ "Contact",		TOK_STRING(PNPCDef,contact,0) },
	{ "RegistersSupergroup", TOK_INT(PNPCDef,canRegisterSupergroup,0) },
	{ "StoreCount", 	TOK_INT(PNPCDef,store.iCnt,0) },
	{ "Store", 			TOK_STRINGARRAY(PNPCDef,store.ppchStores) },
	{ "CanTailor", 		TOK_INT(PNPCDef,canTailor,0) },
	{ "CanRespec", 		TOK_INT(PNPCDef,canRespec,0) },
	{ "CanAuction",		TOK_INT(PNPCDef,canAuction,0) },
	{ "NoHeadshot",		TOK_INT(PNPCDef,noheadshot,0) },
	{ "Dialog",			TOK_STRINGARRAY(PNPCDef,dialog) }, // really means ClickDialog now
	{ "ShoutDialog",	TOK_STRINGARRAY(PNPCDef,shoutDialog) }, // random text that will be said all the time
	{ "ShoutFrequency", TOK_INT(PNPCDef,shoutFrequency,	DEFAULT_SHOUT_FREQUENCY)		},
	{ "ShoutVariation", TOK_INT(PNPCDef,shoutVariation,	DEFAULT_SHOUT_VARIATION)		},
	{ "AutoRewards",	TOK_STRINGARRAY(PNPCDef,autoRewards) },
	{ "TalksToStrangers",TOK_INT(PNPCDef,talksToStrangers,0) },
	{ "VisionPhases",	TOK_STRINGARRAY(PNPCDef,visionPhaseRawStrings) },
	{ "ExclusiveVisionPhase",	TOK_STRING(PNPCDef,exclusiveVisionPhaseRawString,0) },
	{ "WrongAllianceString",	TOK_STRING(PNPCDef,wrongAllianceString,0) },
#if SERVER
	{ "Script",			TOK_STRUCT(PNPCDef,scripts, ParseScriptDef) },
#else
	{ "Script",			TOK_NULLSTRUCT(ParseFakeScriptDef) },
#endif
	{ "}",				TOK_END,							0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePNPCDefList[] = {
	{ "NPCDef",			TOK_STRUCT(PNPCDefList,pnpcdefs,ParsePNPCDef) },
	{ "", 0, 0 }
};
""".}