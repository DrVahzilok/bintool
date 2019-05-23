{.emit: """
#include "encounter.h"
// *********************************************************************************
//  Spawndefs
// *********************************************************************************

StaticDefineInt ParseActorConColor[] =
{
	DEFINE_INT
	{ "Red",			CONCOLOR_RED },
	{ "Yellow",			CONCOLOR_YELLOW },
	DEFINE_END
};

StaticDefineInt ParseActorType[] =
{
	DEFINE_INT
	{ "eVillain",		ACTOR_VILLAIN },
	{ "eNPC",			ACTOR_NPC },
	DEFINE_END
};

StaticDefineInt ParseActorFlags[] =
{
	DEFINE_INT
	{ "AlwaysCon",			ACTOR_ALWAYSCON },
	{ "SeeThroughWalls",	ACTOR_SEETHROUGHWALLS },
	{ "Invisible",			ACTOR_INVISIBLE },
	DEFINE_END
};

TokenizerParseInfo ParseActor[] = {
	{ "{",				TOK_START,		0},
	{ "Type",			TOK_INT(Actor,type,	ACTOR_VILLAIN),	ParseActorType }, // DEPRECATED
	{ "Number",			TOK_INT(Actor,number,		1) },
	{ "HeroesRequired",	TOK_REDUNDANTNAME | TOK_INT(Actor,minheroesrequired, 0) },
	{ "MinimumHeroesRequired",	TOK_INT(Actor,minheroesrequired, 0) },
	{ "MaximumHeroesRequired",	TOK_INT(Actor,maxheroesrequired, 0) },
	{ "ExactHeroesRequired",	TOK_INT(Actor,exactheroesrequired, 0) },
	{ "ActorName",		TOK_NO_TRANSLATE | TOK_STRING(Actor,actorname, 0) },
	{ "Name",			TOK_STRING(Actor,displayname, 0) },
	{ "DisplayInfo",	TOK_STRING(Actor,displayinfo, 0) },
	{ "DisplayGroup",	TOK_STRING(Actor,displayGroup, 0) },
	{ "Location",		TOK_INTARRAY(Actor,locations) },
	{ "ShoutRange",		TOK_NO_TRANSLATE | TOK_STRING(Actor,shoutrange, 0) },
	{ "ShoutChance",	TOK_NO_TRANSLATE | TOK_STRING(Actor,shoutchance, 0) },
	{ "WalkRange",		TOK_NO_TRANSLATE | TOK_STRING(Actor,wanderrange, 0) },
	{ "NotRequired",	TOK_NO_TRANSLATE | TOK_STRING(Actor,notrequired, 0) },
	{ "NoGroundSnap",	TOK_INT(Actor,nogroundsnap, 0) },
	{ "Ally",			TOK_NO_TRANSLATE | TOK_STRING(Actor,ally, 0) },
	{ "Gang",			TOK_NO_TRANSLATE | TOK_STRING(Actor,gang, 0) },
	{ "ClassOverride",	TOK_NO_TRANSLATE | TOK_STRING(Actor,villainclass, 0) },
	{ "NoUnroll",		TOK_INT(Actor,nounroll, 0) },
	{ "SucceedOnDeath",	TOK_INT(Actor,succeedondeath, 0) },
	{ "FailOnDeath",	TOK_INT(Actor,failondeath, 0) }, // DEPRECATED
	{ "CustomCritterIdx",TOK_INT(Actor,customCritterIdx, 0) },
	{ "npcDefOverride", TOK_INT(Actor,npcDefOverride, 0) },
	{ "Flags",			TOK_FLAGS(Actor,flags, 0),							ParseActorFlags },
	{ "Reward",			TOK_STRUCT(Actor,reward, ParseStoryReward) },
	{ "ConColor",		TOK_INT(Actor, conColor, CONCOLOR_RED), ParseActorConColor },
	{ "RewardScaleOverridePct", TOK_INT(Actor, rewardScaleOverridePct, -1) },
	{ "VisionPhases", TOK_STRINGARRAY(Actor, bitfieldVisionPhaseRawStrings) },
	{ "DONTUSETHISJUSTINITIALIZE", TOK_INT(Actor, bitfieldVisionPhases, 1) },	// is there a better way to initialize?
	{ "ExclusiveVisionPhase", TOK_STRING(Actor, exclusiveVisionPhaseRawString, 0) },
	{ "DONTUSETHISEITHERINITIALIZE", TOK_INT(Actor, exclusiveVisionPhase, 0) },	// is there a better way to initialize?

	{ "Model",			TOK_NO_TRANSLATE | TOK_STRING(Actor,model, 0) },
	{ "VillainLevelMod",TOK_INT(Actor,villainlevelmod, 0) },
	{ "Villain",		TOK_NO_TRANSLATE | TOK_STRING(Actor,villain, 0) },
	{ "VillainGroup",	TOK_NO_TRANSLATE | TOK_STRING(Actor,villaingroup, 0) },
	{ "VillainType",	TOK_NO_TRANSLATE | TOK_STRING(Actor,villainrank, 0) },

	{ "AI_Group",		TOK_INT(Actor,ai_group, -1) },
	{ "AI_InActive",	TOK_NO_TRANSLATE | TOK_STRING(Actor,ai_states[ACT_WORKING], 0) },
	{ "AI_Active",		TOK_NO_TRANSLATE | TOK_STRING(Actor,ai_states[ACT_ACTIVE], 0) },
	{ "AI_Alerted",		TOK_NO_TRANSLATE | TOK_STRING(Actor,ai_states[ACT_ALERTED], 0) },
	{ "AI_Completion",	TOK_NO_TRANSLATE | TOK_STRING(Actor,ai_states[ACT_COMPLETED], 0) },
	{ "Dialog_InActive",	TOK_STRING(Actor,dialog_states[ACT_INACTIVE], 0) },
	{ "Dialog_Active",		TOK_STRING(Actor,dialog_states[ACT_ACTIVE], 0) },
	{ "Dialog_Alerted",		TOK_STRING(Actor,dialog_states[ACT_ALERTED], 0) },
	{ "Dialog_Completion",	TOK_STRING(Actor,dialog_states[ACT_COMPLETED], 0) },
	{ "Dialog_ThankHero",	TOK_STRING(Actor,dialog_states[ACT_THANK], 0) },
	{ "ActorReward",	TOK_REDUNDANTNAME | TOK_STRUCT(Actor,reward,ParseStoryReward) },
	{ "}",				TOK_END,			0},
	{ "", 0, 0 }
};

StaticDefineInt ParseSpawnDefFlags[] =
{
	DEFINE_INT
	{ "AllowAddingActors",	SPAWNDEF_ALLOWADDS },
	{ "IgnoreRadius",		SPAWNDEF_IGNORE_RADIUS },
	{ "AutoStart",			SPAWNDEF_AUTOSTART },
	{ "MissionRespawn",		SPAWNDEF_MISSIONRESPAWN },
	{ "CloneGroup",			SPAWNDEF_CLONEGROUP },
	{ "NeighborhoodDefined",	SPAWNDEF_NEIGHBORHOODDEFINED },
	DEFINE_END
};

// The Ally Group the encounter was designed for
StaticDefineInt ParseEncounterAlliance[] =
{
	DEFINE_INT
	{"Default",				ENC_UNINIT},
	{"Hero",				ENC_FOR_HERO},
	{"Villain",				ENC_FOR_VILLAIN},
	DEFINE_END
};

StaticDefineInt ParseMissionTeamOverride[] =
{
	DEFINE_INT
	{"None",			MO_NONE},
	{"Player",			MO_PLAYER},
	{"Mission",			MO_MISSION},
	DEFINE_END
};

TokenizerParseInfo ParseSpawnDef[] = {
	{ "{",							TOK_START,		0},
	{ "",							TOK_CURRENTFILE(SpawnDef,fileName) },
	{ "LogicalName",				TOK_NO_TRANSLATE | TOK_STRING(SpawnDef,logicalName, 0) },
	{ "EncounterSpawn",				TOK_NO_TRANSLATE | TOK_STRING(SpawnDef,spawntype, 0) },
	{ "Dialog",						TOK_FILENAME(SpawnDef,dialogfile, 0) },
	{ "Deprecated",					TOK_BOOLFLAG(SpawnDef,deprecated, 0) },
	{ "SpawnRadius",				TOK_INT(SpawnDef,spawnradius, -1) },
	{ "VillainMinLevel",			TOK_INT(SpawnDef,villainminlevel, 0) },
	{ "VillainMaxLevel",			TOK_INT(SpawnDef,villainmaxlevel, 0) },
	{ "MinTeamSize",				TOK_INT(SpawnDef,minteamsize, 1) },
	{ "MaxTeamSize",				TOK_INT(SpawnDef,maxteamsize, MAX_TEAM_MEMBERS) },
	{ "RespawnTimer",				TOK_INT(SpawnDef,respawnTimer, -1) },
	{ "Flags",						TOK_FLAGS(SpawnDef,flags,0), ParseSpawnDefFlags }, 

	{ "Actor",						TOK_STRUCT(SpawnDef,actors,	ParseActor) },
	{ "Script",						TOK_STRUCT(SpawnDef,scripts, ParseScriptDef) },
	{ "DialogDef",					TOK_STRUCT(SpawnDef, dialogDefs, ParseDialogDef) },

	{ "EncounterComplete",			TOK_STRUCT(SpawnDef,encounterComplete,ParseStoryReward) },

	// mission map only
	{ "MissionPlacement",			TOK_INT(SpawnDef,missionplace,	MISSION_ANY),		ParseMissionPlaceEnum },
	{ "MissionCount",				TOK_INT(SpawnDef,missioncount,	1) },
	{ "MissionUncounted",			TOK_BOOLFLAG(SpawnDef,missionuncounted, 0) },
	{ "CreateOnObjectiveComplete",	TOK_NO_TRANSLATE | TOK_STRINGARRAY(SpawnDef,createOnObjectiveComplete) },
	{ "ActivateOnObjectiveComplete",TOK_NO_TRANSLATE | TOK_STRINGARRAY(SpawnDef,activateOnObjectiveComplete) },
	{ "Objective",					TOK_STRUCT(SpawnDef,objective,ParseMissionObjective) },
	{ "PlayerCreatedDetailType",	TOK_INT(SpawnDef, playerCreatedDetailType, 0) },
	//Cut Scene 
	{ "CutScene",					TOK_STRUCT(SpawnDef,cutSceneDefs, ParseCutScene) },

	{ "EncounterAlliance",			TOK_INT(SpawnDef,encounterAllyGroup,	ENC_UNINIT), ParseEncounterAlliance },
	{ "MissionTeamOverride",		TOK_INT(SpawnDef, override,	0), ParseMissionTeamOverride},

	{ "MissionEncounter",			TOK_INT(SpawnDef,oldfield, 0) },		// DEPRECATED - was used to determine how spawndef was verified
	{ "CVGIndex",					TOK_INT(SpawnDef,CVGIdx,0)	},
	{ "CVGIndex2",					TOK_INT(SpawnDef,CVGIdx2, 0) },
	{ "}",							TOK_END,			0},
	SCRIPTVARS_STD_PARSE(SpawnDef)
	{ "", 0, 0 }
};

TokenizerParseInfo ParseSpawnDefList[] = {
	{ "SpawnDef",		TOK_STRUCT(SpawnDefList, spawndefs,	ParseSpawnDef) },
	{ "", 0, 0 }
};

// dialog files
TokenizerParseInfo ParseDialogFile[] = {
	{ "{",				TOK_START,		0},
	{ "",				TOK_CURRENTFILE(DialogFile,name) },
	{ "}",				TOK_END,			0},
	SCRIPTVARS_STD_PARSE(DialogFile)
	{ "", 0, 0 }
};

TokenizerParseInfo ParseDialogFileList[] = {
	{ "Dialog",			TOK_STRUCT(DialogFileList,dialogfiles,ParseDialogFile) },
	{ "", 0, 0 }
};
""".}