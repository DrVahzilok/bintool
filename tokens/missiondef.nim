{.emit: """
#include "mission.h"

// location types
StaticDefineInt ParseLocationTypeEnum[] =
{
	DEFINE_INT
	{ "Person",			LOCATION_PERSON },
	{ "ItemAgainstWall", LOCATION_ITEMWALL },
	{ "ItemWall",		LOCATION_ITEMWALL },
	{ "ItemOnFloor",	LOCATION_ITEMFLOOR },
	{ "ItemFloor",		LOCATION_ITEMFLOOR },
	{ "ItemOnRoof",		LOCATION_ITEMROOF },
	{ "ItemRoof",		LOCATION_ITEMROOF },

	// terms that were in scripts previously
	{ "Item",			LOCATION_LEGACY },
	{ "HiddenItem",		LOCATION_LEGACY },
	{ "WallItem",		LOCATION_LEGACY },
	{ "HiddenWallItem",	LOCATION_LEGACY },

	// terms that were used on maps
	{ "Hidden",			LOCATION_LEGACY },
	{ "ItemHidden",		LOCATION_LEGACY },
	{ "Obvious",		LOCATION_LEGACY },
	{ "ItemObvious",	LOCATION_LEGACY },
	DEFINE_END
};

// *********************************************************************************
//  Story arc defs
// *********************************************************************************

TokenizerParseInfo ParseStoryClue[] = {
	{ "", TOK_STRUCTPARAM | TOK_NO_TRANSLATE | TOK_STRING(StoryClue,name,0) },
	{ "",				TOK_CURRENTFILE(StoryClue,filename) },
	{ "{",				TOK_START,		0},

	// strings
	{ "Name",			TOK_STRING(StoryClue,displayname,0) },
	{ "DetailString",	TOK_STRING(StoryClue,detailtext,0) },
	{ "Icon",			TOK_FILENAME(StoryClue,iconfile,0) },

	// is this required?
	{ "IntroString",	TOK_STRING(StoryClue,introstring,0) },

	// Semi deprecated, used with the mission editor
	{ "ClueName",		TOK_REDUNDANTNAME | TOK_STRING(StoryClue,name,0) },
	{ "Display",		TOK_REDUNDANTNAME | TOK_STRING(StoryClue,displayname,0) },

	// deprecated
	{ "Detail",			TOK_REDUNDANTNAME | TOK_STRING(StoryClue,detailtext,0)	},
	{ "}",				TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseStoryEpisode[] = {
	{ "{",				TOK_START,		0},
	{ "TaskDef",		TOK_STRUCT(StoryEpisode,tasks,ParseStoryTask) },
	{ "ReturnSuccess",	TOK_STRUCT(StoryEpisode,success,ParseStoryReward) },

	// deprecated stuff
	{ "Success",		TOK_REDUNDANTNAME | TOK_STRUCT(StoryEpisode,success,ParseStoryReward) },
	{ "}",				TOK_END,		0},
	{ "", 0, 0 }
};

StaticDefineInt ParseStoryArcFlag[] = {
	DEFINE_INT
	{ "Deprecated",				STORYARC_DEPRECATED			},
	{ "MiniStoryarc",			STORYARC_MINI				},
	{ "Repeatable",				STORYARC_REPEATABLE			},
	{ "NoFlashback",			STORYARC_NOFLASHBACK		},
	{ "ScalableTf",				STORYARC_SCALABLE_TF		},
	{ "FlashbackOnly",			STORYARC_FLASHBACK_ONLY		},
	DEFINE_END
};

StaticDefineInt ParseStoryArcAlliance[] = {
	DEFINE_INT
	{ "Both",					SA_ALLIANCE_BOTH			},
	{ "Hero",					SA_ALLIANCE_HERO			},
	{ "Villain",				SA_ALLIANCE_VILLAIN			},
	DEFINE_END
};

TokenizerParseInfo ParseStoryArc[] = {
	{ "{",								TOK_START,		0 },
	{ "",								TOK_CURRENTFILE(StoryArc,filename) },
	{ "Deprecated",						TOK_BOOLFLAG(StoryArc,deprecated,0), },
	{ "Flags",							TOK_FLAGS(StoryArc,flags,0),						ParseStoryArcFlag },
	{ "Episode",						TOK_STRUCT(StoryArc,episodes,ParseStoryEpisode) },
	{ "ClueDef",						TOK_STRUCT(StoryArc,clues,ParseStoryClue) },
	{ "MinPlayerLevel",					TOK_INT(StoryArc,minPlayerLevel,0)  },
	{ "MaxPlayerLevel",					TOK_INT(StoryArc,maxPlayerLevel,0)  },

	// If you add something here you probably need to add it to tasks as well to support Flashbackable tasks
	// see StoryArcPostprocessAppendFlashback
	{ "CompleteRequires",				TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryArc, completeRequires) },
	{ "FlashbackRequires",				TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryArc, flashbackRequires) },
	{ "FlashbackRequiresFailedText",	TOK_STRING(StoryArc, flashbackRequiresFailed, 0) },
 	{ "FlashbackTeamRequires",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryArc, flashbackTeamRequires) },
 	{ "FlashbackTeamRequiresFailedText",TOK_STRING(StoryArc, flashbackTeamFailed, 0) },
	{ "Requires",						TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryArc, assignRequires) },
	{ "RequiresFailedText",				TOK_STRING(StoryArc, assignRequiresFailed, 0) },
	{ "TeamRequires",					TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryArc, teamRequires) },
	{ "TeamRequiresFailedText",			TOK_STRING(StoryArc, teamRequiresFailed, 0) },
	
	{ "Name",							TOK_STRING(StoryArc, name, 0) },
	{ "Alliance",						TOK_INT(StoryArc,alliance, SA_ALLIANCE_BOTH), ParseStoryArcAlliance },
	{ "FlashbackDescription",			TOK_STRING(StoryArc, flashbackDescription, 0) },
	{ "FlashbackCostMultiplier",		TOK_F32(StoryArc,flashbackCostMulitplier, 1.0) },
	{ "FlashbackLeft",					TOK_STRUCT(StoryArc, rewardFlashbackLeft, ParseStoryReward) },
	{ "architectAboutContact",			TOK_STRING(StoryArc, architectAboutContact, 0) },
	{ "}",								TOK_END,		0 },
	SCRIPTVARS_STD_PARSE(StoryArc)
	{ "", 0, 0 }
};

TokenizerParseInfo ParseStoryArcList[] = {
	{ "StoryArcDef",	TOK_STRUCT(StoryArcList,storyarcs,ParseStoryArc) },
	{ "", 0, 0 }
};


// *********************************************************************************
//  Load and parse mission defs
// *********************************************************************************

StaticDefineInt ParseDialogPageDefFlags[] =
{
	DEFINE_INT
	{ "CompleteDeliveryTask",		DIALOGPAGE_COMPLETEDELIVERYTASK },
	{ "CompleteAnyTask",			DIALOGPAGE_COMPLETEANYTASK },
	{ "AutoClose",					DIALOGPAGE_AUTOCLOSE },
	{ "NoHeadshot",					DIALOGPAGE_NOHEADSHOT },
	DEFINE_END
};

StaticDefineInt ParseDialogPageListDefFlags[] =
{
	DEFINE_INT
	{ "Random",						DIALOGPAGELIST_RANDOM },
	{ "InOrder",					DIALOGPAGELIST_INORDER },
	DEFINE_END
};

TokenizerParseInfo ParseDialogAnswerDef[] = {
	{ "{",					TOK_START,		0},
	{ "Text",				TOK_STRING(DialogAnswerDef, text,0) },
	{ "Page",				TOK_STRING(DialogAnswerDef, page,0) },
	{ "Requires",	 		TOK_STRINGARRAY(DialogAnswerDef, pRequires) },
	{ "}",					TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseDialogPageDef[] = {
	{ "{",					TOK_START,		0},
	{ "Name",				TOK_STRUCTPARAM | TOK_STRING(DialogPageDef, name, 0) },
	{ "MissionName",		TOK_STRING(DialogPageDef, missionName, 0) },
	{ "ContactFilename",	TOK_STRING(DialogPageDef, contactFilename, 0) },
	{ "TeleportDest",		TOK_STRING(DialogPageDef, teleportDest, 0) },
	{ "Text",				TOK_STRING(DialogPageDef, text, 0) },
	{ "SayOutLoudText",		TOK_STRING(DialogPageDef, sayOutLoudText, 0) },
	{ "Requires",	 		TOK_STRINGARRAY(DialogPageDef, pRequires) },
	{ "Objectives",	 		TOK_STRINGARRAY(DialogPageDef, pObjectives) },
	{ "Rewards", 			TOK_STRINGARRAY(DialogPageDef, pRewards) },
	{ "AddClues", 			TOK_STRINGARRAY(DialogPageDef, pAddClues) },
	{ "RemoveClues", 		TOK_STRINGARRAY(DialogPageDef, pRemoveClues) },
	{ "AddTokens",			TOK_STRINGARRAY(DialogPageDef, pAddTokens) },
	{ "RemoveTokens",		TOK_STRINGARRAY(DialogPageDef, pRemoveTokens) },
	{ "AddTokensToAll",		TOK_STRINGARRAY(DialogPageDef, pAddTokensToAll) },
	{ "RemoveTokensFromAll",TOK_STRINGARRAY(DialogPageDef, pRemoveTokensFromAll) },
	{ "AbandonContacts",	TOK_STRINGARRAY(DialogPageDef, pAbandonContacts) },
	{ "Answer",				TOK_STRUCT(DialogPageDef, pAnswers, ParseDialogAnswerDef) },
	{ "Flags",				TOK_FLAGS(DialogPageDef,flags,0), ParseDialogPageDefFlags },

	{ "}",					TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseDialogPageListDef[] = {
	{ "{",					TOK_START,		0},
	{ "Name",				TOK_STRUCTPARAM | TOK_STRING(DialogPageListDef, name, 0) },
	{ "List",				TOK_STRINGARRAY(DialogPageListDef, pPages) },
	{ "Fallback",			TOK_STRING(DialogPageListDef, fallbackPage,0) },
	{ "Requires",	 		TOK_STRINGARRAY(DialogPageListDef, pRequires) },
	{ "Flags",				TOK_FLAGS(DialogPageListDef,flags,0), ParseDialogPageListDefFlags },
	{ "}",					TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseDialogDef[] = {
	{ "{",					TOK_START,		0},
	{ "",					TOK_CURRENTFILE(DialogDef, filename) },
	{ "Name",				TOK_STRUCTPARAM | TOK_STRING(DialogDef, name, 0) },
	{ "Filename",			TOK_CURRENTFILE(DialogDef, filename) },
	{ "QualifyRequires",	TOK_STRINGARRAY(DialogDef, pQualifyRequires) },
	{ "Page",				TOK_STRUCT(DialogDef, pPages, ParseDialogPageDef) },
	{ "MissionPage",		TOK_STRUCT(DialogDef, pPages, ParseDialogPageDef) },
	{ "ContactPage",		TOK_STRUCT(DialogDef, pPages, ParseDialogPageDef) },
	{ "PageList",			TOK_STRUCT(DialogDef, pPageLists, ParseDialogPageListDef) },

	{ "}",					TOK_END,			0},
	{ "", 0, 0 }
};

// *********************************************************************************
//  Load and parse mission defs
// *********************************************************************************

// villain pacing
StaticDefineInt ParseVillainPacingEnum[] =
{
	DEFINE_INT
	{ "Flat",				PACING_FLAT },
	{ "SlowRampUp",			PACING_SLOWRAMPUP },
	{ "SlowRampDown",		PACING_SLOWRAMPDOWN },
	{ "Staggered",			PACING_STAGGERED },
	{ "FrontLoaded",		PACING_FRONTLOADED },
	{ "BackLoaded",			PACING_BACKLOADED },
	{ "HighNotoriety",		PACING_HIGHNOTORIETY },
	{ "Unmodifiable",		PACING_UNMODIFIABLE },
	DEFINE_END
};

StaticDefineInt ParseMissionInteractOutcomeEnum[] =
{
	DEFINE_INT
	{ "None",			MIO_NONE },
	{ "Remove",			MIO_REMOVE },
	DEFINE_END
};

StaticDefineInt ParseDayNightCycleEnum[] =
{
	DEFINE_INT
	{ "Normal",			DAYNIGHT_NORMAL },
	{ "AlwaysNight",	DAYNIGHT_ALWAYSNIGHT },
	{ "AlwaysDay",		DAYNIGHT_ALWAYSDAY },
	{ "FastCycle",		DAYNIGHT_FAST },
	DEFINE_END
};

StaticDefineInt ParseMissionFlags[] =
{
	DEFINE_INT
	{ "NoTeleportOnComplete",	MISSION_NOTELEPORTONCOMPLETE },
	{ "NoBaseHospital",			MISSION_NOBASEHOSPITAL },
	{ "CoedTeamsAllowed",		MISSION_COEDTEAMSALLOWED },
	{ "PraetorianTutorial",		MISSION_PRAETORIAN_TUTORIAL },
	{ "CoUniverseTeamsAllowed",	MISSION_COUNIVERSETEAMSALLOWED },
	DEFINE_END
};

StaticDefineInt ParseMissionObjectiveFlags[] =
{
	DEFINE_INT
	{ "ShowWaypoint",			MISSIONOBJECTIVE_SHOWWAYPOINT },
	{ "RewardOnCompleteSet",	MISSIONOBJECTIVE_REWARDONCOMPLETESET },
	DEFINE_END
};

// mission objectives
TokenizerParseInfo ParseMissionObjective[] = {
	{ "{",					TOK_START,		0 },
	{ "",TOK_STRUCTPARAM |	TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,name,0) },

	{ "GroupName",			TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,groupName,0) },
	
	{ "Filename",			TOK_CURRENTFILE(MissionObjective, filename) },

	{ "ObjectiveName",TOK_REDUNDANTNAME | TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,name,0) },
	{ "Model",				TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,model,0) },
	{ "EffectInActive",		TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,effectInactive,0) },
	{ "EffectRequires",		TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,effectRequires,0) },
	{ "EffectActive",		TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,effectActive,0) },
	{ "EffectCooldown",		TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,effectCooldown,0) },
	{ "EffectCompletion",	TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,effectCompletion,0) },
	{ "EffectFailure",		TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,effectFailure,0) },

	{ "Description",					TOK_STRING(MissionObjective, description, 0)						},
	{ "SingularDescription",			TOK_STRING(MissionObjective, singulardescription, 0)				},
	{ "DescRequires",					TOK_STRINGARRAY(MissionObjective, descRequires)						},
	{ "ActivateOnObjectiveComplete",	TOK_STRINGARRAY(MissionObjective, activateRequires)					},
	{ "CharRequires",					TOK_STRINGARRAY(MissionObjective, charRequires)						},
	{ "CharRequiresFailedText",			TOK_STRING(MissionObjective, charRequiresFailedText, 0)				},
	{ "ModelDisplayName",				TOK_STRING(MissionObjective, modelDisplayName, 0)					},
	{ "Number",							TOK_INT(MissionObjective, count, 1)									},
	{ "Reward",							TOK_STRUCT(MissionObjective, reward, ParseStoryReward)				},
	{ "Level",							TOK_INT(MissionObjective, level, 0) }, // optional, can override the mission level - used for force fields currently
	{ "Flags",							TOK_FLAGS(MissionObjective, flags, 0), ParseMissionObjectiveFlags	}, 

	{ "InteractDelay",			TOK_INT(MissionObjective,interactDelay,0) },
	{ "SimultaneousObjective",	TOK_BOOLFLAG(MissionObjective,simultaneousObjective,0) },
	{ "InteractBeginString",	TOK_STRING(MissionObjective,interactBeginString,0) },
	{ "InteractCompleteString", TOK_STRING(MissionObjective,interactCompleteString,0) },
	{ "InteractInterruptedString", TOK_STRING(MissionObjective,interactInterruptedString,0) },
	{ "InteractActionString",	TOK_STRING(MissionObjective,interactActionString,0) },
	{ "InteractResetString",	TOK_STRING(MissionObjective,interactResetString,0) },
	{ "InteractWaitingString",	TOK_STRING(MissionObjective,interactWaitingString,0) },
	{ "InteractOutcome",		TOK_INT(MissionObjective,interactOutcome, MIO_NONE), ParseMissionInteractOutcomeEnum },

	{ "ForceFieldVillain",	TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,forceFieldVillain,0) },
	{ "ForceFieldRespawn",	TOK_INT(MissionObjective,forceFieldRespawn,0) },
	{ "ForceFieldObjective",TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,forceFieldObjective,0) },

	{ "LocationName",		TOK_NO_TRANSLATE | TOK_STRING(MissionObjective,locationName,0) },
	{ "Location",			TOK_INT(MissionObjective,locationtype,LOCATION_ITEMFLOOR),	ParseLocationTypeEnum },
	{ "Room",TOK_REDUNDANTNAME | TOK_INT(MissionObjective,room,MISSION_OBJECTIVE),	ParseMissionPlaceEnum },
	{ "MissionPlacement",	TOK_INT(MissionObjective,room,MISSION_OBJECTIVE),	ParseMissionPlaceEnum },
	{ "SkillCheck",			TOK_BOOLFLAG(MissionObjective,skillCheck,0) },
	{ "ScriptControlled",	TOK_BOOLFLAG(MissionObjective,scriptControlled,0) },

	{ "ObjectiveReward",	TOK_REDUNDANTNAME | TOK_STRUCT(MissionObjective,reward,ParseStoryReward) },
	{ "}",					TOK_END,			0},
	{ "", 0, 0 }
};

// mission objective sets
TokenizerParseInfo ParseMissionObjectiveSet[] = {
	{ "",	TOK_STRUCTPARAM | TOK_NO_TRANSLATE | TOK_STRINGARRAY(MissionObjectiveSet,objectives) },
	{ "\n",	TOK_END,	0 },
	{ "", 0, 0 }
};

// mission key doors
TokenizerParseInfo ParseMissionKeyDoor[] = {
	{ "",	TOK_STRUCTPARAM | TOK_NO_TRANSLATE | TOK_STRING(MissionKeyDoor,name,0) },
	{ "",	TOK_STRUCTPARAM | TOK_NO_TRANSLATE | TOK_STRINGARRAY(MissionKeyDoor,objectives) },
	{ "\n",	TOK_END,	0 },
	{ "", 0, 0 }
};

extern StaticDefineInt ParseVillainType[];

TokenizerParseInfo ParseMissionDef[] = {
	{ "{",					TOK_START,		0},
	{ "",					TOK_CURRENTFILE(MissionDef,filename) },
	{ "EntryString",		TOK_STRING(MissionDef,entrytext,0) },
	{ "ExitStringFail",		TOK_STRING(MissionDef,exittextfail,0) },
	{ "ExitStringSuccess",	TOK_STRING(MissionDef,exittextsuccess,0) },
	{ "DefeatAllText",		TOK_STRING(MissionDef,pchDefeatAllText,0) },
	{ "MapFile",			TOK_FILENAME(MissionDef,mapfile,0) },
	{ "MapSet",				TOK_INT(MissionDef,mapset,MAPSET_NONE),	ParseMapSetEnum },
	{ "MapLength",			TOK_INT(MissionDef,maplength,0),	},
	{ "VillainGroup",		TOK_NO_TRANSLATE | TOK_STRING(MissionDef,villaingroup,"VG_NONE") },//		ParseVillainGroupEnum },
	{ "VillainGroupVar",	TOK_NO_TRANSLATE | TOK_STRING(MissionDef,villaingroupVar,"VG_NONE") }, // field for VG_VAR type, not yet operational
	{ "VillainGroupType",	TOK_INT(MissionDef,villainGroupType,0),	ParseVillainType },
	{ "Flags",				TOK_FLAGS(MissionDef,flags,0),			ParseMissionFlags },

	// door
	{ "CityZone",			TOK_NO_TRANSLATE | TOK_STRING(MissionDef,cityzone,0) },		// normal name of city zone, or "WhereIssued" or "WhereIssuedIfPossible"
	{ "DoorType",			TOK_NO_TRANSLATE | TOK_STRING(MissionDef,doortype,0) },
	{ "LocationName",		TOK_NO_TRANSLATE | TOK_STRING(MissionDef,locationname,0) },	// used for ZoneTransfer mission doors now
	{ "FoyerType",			TOK_NO_TRANSLATE | TOK_STRING(MissionDef,foyertype,0) },	// deprecated
	{ "DoorNPC",			TOK_NO_TRANSLATE | TOK_STRING(MissionDef,doorNPC,0) },	
	{ "DoorNPCDialog",		TOK_NO_TRANSLATE | TOK_STRING(MissionDef,doorNPCDialog,0) },
	{ "DoorNPCDialogStart",	TOK_NO_TRANSLATE | TOK_STRING(MissionDef,doorNPCDialogStart,0) },

	// Side Missions
	{ "NumSideMissions",	TOK_INT(MissionDef,numSideMissions,0),	},
	{ "SideMission",		TOK_NO_TRANSLATE | TOK_STRINGARRAY(MissionDef,sideMissions),	},

	{ "VillainPacing",		TOK_INT(MissionDef,villainpacing,PACING_FLAT),	ParseVillainPacingEnum },
	{ "TimeToComplete",		TOK_INT(MissionDef,missiontime,0) },
	{ "RandomNPCs",			TOK_INT(MissionDef,numrandomnpcs,0) },
	{ "MissionLevel",		TOK_INT(MissionDef, missionLevel, -1) },

	{ "SpawnDef",			TOK_STRUCT(MissionDef,spawndefs,ParseSpawnDef) },
	{ "Objective",			TOK_STRUCT(MissionDef,objectives,ParseMissionObjective) },
	{ "CanCompleteWith",	TOK_STRUCT(MissionDef,objectivesets,ParseMissionObjectiveSet) },
	{ "CanFailWith",		TOK_STRUCT(MissionDef,failsets,ParseMissionObjectiveSet) },

	// specialty stuff
	{ "Race",				TOK_NO_TRANSLATE | TOK_STRING(MissionDef,race,0) },
	{ "DayNightCycle",		TOK_INT(MissionDef,daynightcycle,DAYNIGHT_NORMAL),	ParseDayNightCycleEnum },
	{ "KeyDoor",			TOK_STRUCT(MissionDef,keydoors,ParseMissionKeyDoor) },
	{ "Script",				TOK_STRUCT(MissionDef,scripts,ParseScriptDef) },
	{ "KeyClueDef",			TOK_STRUCT(MissionDef,keyclues,ParseStoryClue) },
	{ "CustomVGIdx",		TOK_INT(MissionDef, CVGIdx, 0)	},

	{ "FogDist",			TOK_F32(MissionDef, fFogDist, 0 ) },
	{ "FogColor",			TOK_VEC3(MissionDef, fogColor) },

	{ "ShowItemsOnMinimap",	   TOK_INT(MissionDef, showItemThreshold, 1) },
	{ "ShowCrittersOnMinimap", TOK_INT(MissionDef, showCritterThreshold, 1) },

	{ "LoadScreenPages",	TOK_STRINGARRAY(MissionDef, loadScreenPages) },

	{ "}",					TOK_END,			0},
	SCRIPTVARS_STD_PARSE(MissionDef)
	{ "", 0, 0 }
};

typedef struct MissionDefList
{
	MissionDef** missiondefs;
} MissionDefList;

TokenizerParseInfo ParseMissionDefList[] = {
	{ "MissionDef",		TOK_STRUCT(MissionDefList,missiondefs,ParseMissionDef) },
	{ "", 0, 0 }
};

""".}