{.emit: """
#include "Reward.h"

StaticDefineInt ParseVillainType[] =
{
	DEFINE_INT
	{"Any",		VGT_ANY},
	{"Arcane",	VGT_ARCANE},
	{"Tech",	VGT_TECH},
	DEFINE_END
};

// *********************************************************************************
//  Parse definitions
// *********************************************************************************

StaticDefineInt ParseTaskType[] = 
{
	DEFINE_INT
	{ "taskMission",			TASK_MISSION },
	{ "taskRandomEncounter",	TASK_RANDOMENCOUNTER },
	{ "taskRandomNPC",			TASK_RANDOMNPC },
	{ "taskKillX",				TASK_KILLX },
	{ "taskDeliverItem",		TASK_DELIVERITEM },
	{ "taskVisitLocation",		TASK_VISITLOCATION },
	{ "taskCraftInvention",		TASK_CRAFTINVENTION },
	{ "taskCompound",			TASK_COMPOUND },
	{ "taskContactIntroduction",TASK_CONTACTINTRO },
	{ "taskTokenCount",			TASK_TOKENCOUNT },
	{ "taskZowie",				TASK_ZOWIE },
	{ "taskGoToVolume",			TASK_GOTOVOLUME },
	DEFINE_END
};

StaticDefineInt ParseNewspaperType[] = 
{
	DEFINE_INT
	{ "GetItem",				NEWSPAPER_GETITEM },
	{ "Hostage",				NEWSPAPER_HOSTAGE },
	{ "Defeat",					NEWSPAPER_DEFEAT },
	{ "Heist",					NEWSPAPER_HEIST },
	DEFINE_END
};

StaticDefineInt ParseDeliveryMethod[] =
{
	DEFINE_INT
	{ "Any",					DELIVERYMETHOD_ANY },
	{ "CellOnly",				DELIVERYMETHOD_CELLONLY },
	{ "InPersonOnly",			DELIVERYMETHOD_INPERSONONLY },
	DEFINE_END
};

StaticDefineInt ParsePvPType[] = 
{
	DEFINE_INT
	{ "Patrol",					PVP_PATROL },
	{ "HeroDamage",				PVP_HERODAMAGE },
	{ "HeroResist",				PVP_HERORESIST },
	{ "VillainDamage",			PVP_VILLAINDAMAGE },
	{ "VillainResist",			PVP_VILLAINRESIST },
	DEFINE_END
};

StaticDefineInt ParseTaskAlliance[] = 
{
	DEFINE_INT
	{ "Both",					SA_ALLIANCE_BOTH			},
	{ "Hero",					SA_ALLIANCE_HERO			},
	{ "Villain",				SA_ALLIANCE_VILLAIN			},
	DEFINE_END
};

StaticDefineInt ParseTaskFlag[] = 
{
	DEFINE_INT
	{ "taskRequired",			TASK_REQUIRED },
	{ "taskNotRequired",		0 },
	{ "taskRepeatable",			TASK_REPEATONFAILURE },
	{ "taskNotRepeatable",		0 },
	{ "taskRepeatOnFailure",	TASK_REPEATONFAILURE },
	{ "taskRepeatOnSuccess",	TASK_REPEATONSUCCESS },
	{ "taskUrgent",				TASK_URGENT },	// urgent tasks will be given out before any other tasks
	{ "taskNotUrgent",			0 },
	{ "taskUnique",				TASK_UNIQUE },	// unique tasks will not be given out twice, even across contact sets
	{ "taskNotUnique",			0 },
	{ "taskLong",				TASK_LONG },
	{ "taskShort",				TASK_SHORT },	// contact tasks should be marked as one of these 2 types
	{ "taskDontReturnToContact",TASK_DONTRETURNTOCONTACT },
	{ "taskHeist",				TASK_HEIST },
	{ "taskNoTeamComplete",		TASK_NOTEAMCOMPLETE },
	{ "taskSupergroup",			TASK_SUPERGROUP | TASK_DONTRETURNTOCONTACT }, // Supergroup missions dont return to contact
	{ "taskEnforceTimeLimit",	TASK_ENFORCETIMELIMIT },	// Task will still boot you from a mission even when completed
	{ "taskDelayedTimerStart",	TASK_DELAYEDTIMERSTART },	// Task timer does not start until entering the mission
	{ "taskNoAbort",			TASK_NOAUTOCOMPLETE },		// This task cannot be auto-completed (was called aborted)
	{ "taskNoAutoComplete",		TASK_NOAUTOCOMPLETE },		// This task cannot be auto-completed
	{ "taskFlashback",			TASK_FLASHBACK },			// This task is available through the flashback system
	{ "taskFlashbackOnly",		TASK_FLASHBACK_ONLY },		// This task is only available through the flashback system
	{ "taskPlayerCreated",		TASK_PLAYERCREATED },		// This task was created by a player
	{ "taskAbandonable",		TASK_ABANDONABLE },			// Deprecated
	{ "taskNotAbandonable",		TASK_NOT_ABANDONABLE },		// This task cannot be abandoned and picked up again later
	{ "taskAutoIssue",			TASK_AUTO_ISSUE },
	DEFINE_END
};

StaticDefineInt ParseTaskTokenFlag[] = 
{
	DEFINE_INT
	{ "resetAtStart",			TOKEN_FLAG_RESET_AT_START }, // reset token count at start of mission
	DEFINE_END
};

StaticDefineInt ParseRewardSoundChannel[] = 
{
	DEFINE_INT
	{ "Music",					SOUND_MUSIC		},
	{ "SFX",					SOUND_GAME		},
	{ "Voiceover",				SOUND_VOICEOVER	},
	DEFINE_END
};

TokenizerParseInfo ParseStoryReward[] = 
{
	{ "{",					TOK_START,		0},
	{ "Dialog",				TOK_STRING(StoryReward,rewardDialog,0) },
	{ "SOLDialog",			TOK_STRING(StoryReward,SOLdialog,0) },
	{ "Caption",			TOK_STRING(StoryReward,caption,0) },
	{ "AddClue",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,addclues) },
	{ "AddClues",			TOK_REDUNDANTNAME | TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,addclues) },
	{ "RemoveClue",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,removeclues) },
	{ "RemoveClues",		TOK_REDUNDANTNAME | TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,removeclues) },
	{ "AddToken",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,addTokens) },
	{ "AddTokens",			TOK_REDUNDANTNAME | TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,addTokens) },
	{ "AddTokenToAll",		TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,addTokensToAll) },
	{ "AddTokensToAll",		TOK_REDUNDANTNAME | TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,addTokensToAll) },
	{ "RemoveToken",		TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,removeTokens) },
	{ "RemoveTokens",		TOK_REDUNDANTNAME | TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,removeTokens) },
	{ "RemoveTokenFromAll",	TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,removeTokensFromAll) },
	{ "RemoveTokensFromAll",TOK_REDUNDANTNAME | TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,removeTokensFromAll) },
	{ "PopHelp",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,popHelp) },
	{ "AbandonContacts",	TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,abandonContacts) },
	{ "PlaySound",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,rewardSoundName) },
	{ "PlaySoundChannel",	TOK_INTARRAY(StoryReward,rewardSoundChannel), ParseRewardSoundChannel},
	{ "PlaySoundVolumeLevel",	TOK_F32ARRAY(StoryReward,rewardSoundVolumeLevel) },
	{ "FadeSoundChannel",	TOK_INT(StoryReward,rewardSoundFadeChannel,0), ParseRewardSoundChannel},
	{ "FadeSoundTime",		TOK_F32(StoryReward,rewardSoundFadeTime,-1.0f) },
	{ "PlayFXOnPlayer",		TOK_STRING(StoryReward,rewardPlayFXOnPlayer,0) },
	{ "ContactPoints",		TOK_INT(StoryReward,contactPoints,0) },
	{ "CostumeSlot",		TOK_INT(StoryReward,costumeSlot,0) },
	{ "PrimaryReward", 		TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,primaryReward) },
	{ "SecondaryReward",	TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,secondaryReward) },
	{ "Chance",				TOK_STRUCT(StoryReward,rewardSets,ParseRewardSet) },
	{ "NewContactReward",	TOK_INT(StoryReward,newContactReward,0) },
	{ "RandomFameString",	TOK_STRING(StoryReward,famestring,0) },
	{ "SouvenirClue",		TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryReward,souvenirClues) },
	{ "BadgeStat",			TOK_NO_TRANSLATE | TOK_STRING(StoryReward,badgeStat,0) },
	{ "BonusTime",			TOK_INT(StoryReward,bonusTime,0) },
	{ "FloatText",			TOK_STRING(StoryReward,floatText,0) },
	{ "ArchitectBadgeStat",			TOK_STRING(StoryReward,architectBadgeStat,0) },
	{ "ArchitectBadgeStatTest",		TOK_STRING(StoryReward,architectBadgeStatTest,0) },
	{ "}",					TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseStoryTask[] = 
{
	{ "", TOK_STRUCTPARAM | TOK_INT(StoryTask,type,	0),	ParseTaskType },
	{ "", TOK_STRUCTPARAM | TOK_FLAGS(StoryTask,flags,	0),	ParseTaskFlag },
	{ "",				TOK_CURRENTFILE(StoryTask,filename) },
	{ "{",				TOK_START,		0},
	{ "Name",			TOK_NO_TRANSLATE | TOK_STRING(StoryTask,logicalname,0) },
	{ "Deprecated",		TOK_BOOLFLAG(StoryTask,deprecated,0), },
//	{ "Mission",		TOK_FILENAME(StoryTask,missionfile,0) },
	{ "MissionDef",		TOK_STRUCT(StoryTask,missiondef,ParseMissionDef) },
	{ "MissionEditor",	TOK_FILENAME(StoryTask,missioneditorfile,0), },
	{ "Spawn",			TOK_FILENAME(StoryTask,spawnfile,0) },
	{ "SpawnDef",		TOK_STRUCT(StoryTask,spawndefs,ParseSpawnDef)	},
	{ "ClueDef",		TOK_STRUCT(StoryTask,clues,ParseStoryClue) },
	{ "VillainGroup",	TOK_INT(StoryTask,villainGroup,0),	ParseVillainGroupEnum },
	{ "VillainGroupType",TOK_INT(StoryTask,villainGroupType,0),	ParseVillainType },
	{ "TaskFlags",		TOK_REDUNDANTNAME | TOK_FLAGS(StoryTask,flags,0),	ParseTaskFlag },
	{ "Dialog",			TOK_STRUCT(StoryTask, dialogDefs, ParseDialogDef)	},
	{ "MaxPlayers",		TOK_INT(StoryTask,maxPlayers,0) },
	
	// strings
	{ "IntroString",				TOK_STRING(StoryTask,detail_intro_text,0) },
	{ "SOLIntroString",				TOK_STRING(StoryTask,SOLdetail_intro_text,0) },
	{ "HeadlineString",				TOK_STRING(StoryTask,headline_text,0) },
	{ "AcceptString",				TOK_STRING(StoryTask,yes_text,0) },
	{ "DeclineString",				TOK_STRING(StoryTask,no_text,0) },
	{ "SendoffString",				TOK_STRING(StoryTask,sendoff_text,0) },
	{ "SOLSendoffString",			TOK_STRING(StoryTask,SOLsendoff_text,0) },
	{ "DeclineSendoffString",		TOK_STRING(StoryTask,decline_sendoff_text,0) },
	{ "SOLDeclineSendoffString",	TOK_STRING(StoryTask,SOLdecline_sendoff_text,0) },
	{ "YoureStillBusyString",		TOK_STRING(StoryTask,busy_text,0) },
	{ "SOLYoureStillBusyString",	TOK_STRING(StoryTask,SOLbusy_text,0) },
	{ "ActiveTaskString",			TOK_STRING(StoryTask,inprogress_description,0) },
	{ "TaskCompleteDescription",	TOK_STRING(StoryTask,taskComplete_description,0) },
	{ "TaskFailedDescription",		TOK_STRING(StoryTask,taskFailed_description,0) },
	{ "TaskAbandonedString",		TOK_STRING(StoryTask,task_abandoned,0) },

	{ "TaskTitle",					TOK_STRING(StoryTask,taskTitle,0) },
	{ "TaskSubTitle",				TOK_STRING(StoryTask,taskSubTitle,0) },
	{ "TaskIssueTitle",				TOK_STRING(StoryTask,taskIssueTitle,0) },
	{ "FlashbackDescription",		TOK_STRING(StoryTask,flashbackDescription,0) },
	{ "Alliance",					TOK_INT(StoryTask,alliance, SA_ALLIANCE_BOTH), ParseTaskAlliance },
	
	{ "CompleteRequires",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask,completeRequires)},
	{ "FlashbackRequires",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask,flashbackRequires)},
	{ "FlashbackRequiresFailedText",TOK_STRING(StoryTask, flashbackRequiresFailed, 0) },
 	{ "FlashbackTeamRequires",		TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask, flashbackTeamRequires) },
 	{ "FlashbackTeamRequiresFailedText",	TOK_STRING(StoryTask, flashbackTeamFailed, 0) },
	{ "Requires",					TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask,assignRequires)},
	{ "RequiresFailedText",			TOK_STRING(StoryTask,assignRequiresFailed,0) },
	{ "TeamRequires",				TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask, teamRequires) },
	{ "TeamRequiresFailedText",		TOK_STRING(StoryTask, teamRequiresFailed, 0) },
	{ "AutoIssueRequires",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask, autoIssueRequires) },

	// other fields
	{ "MinPlayerLevel",	TOK_INT(StoryTask,minPlayerLevel,	1) },
	{ "MaxPlayerLevel", TOK_INT(StoryTask,maxPlayerLevel,	MAX_PLAYER_SECURITY_LEVEL) },
	{ "TimeoutMinutes",	TOK_INT(StoryTask,timeoutMins, 0) },
	{ "ForceTaskLevel", TOK_INT(StoryTask,forceTaskLevel, 0) },

	// Special Type for Newspapers and PvPTasks
	{ "PvPType",		TOK_INT(StoryTask,pvpType,		PVP_NOTYPE), ParsePvPType },
	{ "NewspaperType",	TOK_INT(StoryTask,newspaperType,	NEWSPAPER_NOTYPE), ParseNewspaperType },

	// Task location
	{ "LocationName",	TOK_NO_TRANSLATE | TOK_STRING(StoryTask, taskLocationName, 0) },
	{ "LocationMap",	TOK_NO_TRANSLATE | TOK_STRING(StoryTask, taskLocationMap, 0) },

	// Kill task
	{ "VillainType",		TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainType,0) },
	{ "VillainCount",		TOK_INT(StoryTask,villainCount,0) },
	{ "VillainMap",			TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainMap,0) },
	{ "VillainNeighborhood", TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainNeighborhood,0) },
	{ "VillainVolumeName",	TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainVolumeName,0) },
	{ "VillainDescription", TOK_STRING(StoryTask,villainDescription,0) },
	{ "VillainSingularDescription", TOK_STRING(StoryTask,villainSingularDescription,0) },
	{ "VillainType2",		TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainType2,0) },
	{ "VillainCount2",		TOK_INT(StoryTask,villainCount2,0) },
	{ "VillainMap2",		TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainMap2,0) },
	{ "VillainNeighborhood2", TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainNeighborhood2,0) },
	{ "VillainVolumeName2",	TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainVolumeName2,0) },
	{ "VillainDescription2", TOK_STRING(StoryTask,villainDescription2,0) },
	{ "VillainSingularDescription2", TOK_STRING(StoryTask,villainSingularDescription2,0) },

	// Visit location task
	{ "VisitLocationName",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask,visitLocationNames)},

	// Delivery Item task
	{ "DeliveryTargetName",		TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask,deliveryTargetNames) },
	{ "DeliveryDialog",			TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask,deliveryTargetDialogs) },
	{ "DeliveryDialogStartPage",TOK_NO_TRANSLATE | TOK_STRINGARRAY(StoryTask,deliveryTargetDialogStarts) },
	{ "DeliveryMethod",			TOK_INTARRAY(StoryTask,deliveryTargetMethods), ParseDeliveryMethod },

	// Craft invention task,
	{ "InventionName",			TOK_NO_TRANSLATE | TOK_STRING(StoryTask,craftInventionName,0) },

	// Token Count task,
	{ "TokenName",				TOK_NO_TRANSLATE | TOK_STRING(StoryTask,tokenName,0) },
	{ "TokenCount",				TOK_INT(StoryTask,tokenCount,0) },
	{ "TokenProgressString",	TOK_STRING(StoryTask,tokenProgressString,0) },
	{ "TokenFlags",				TOK_FLAGS(StoryTask,tokenFlags,0),	ParseTaskTokenFlag },

	// Zowie task
	{ "ZowieType",				TOK_NO_TRANSLATE | TOK_STRING(StoryTask,zowieType,0) },
	{ "ZowiePoolSize",			TOK_NO_TRANSLATE | TOK_STRING(StoryTask,zowiePoolSize,0) },
	{ "ZowieDisplayName",		TOK_STRING(StoryTask,zowieDisplayName,0) },
	{ "ZowieCount",				TOK_INT(StoryTask,zowieCount,0) },
	{ "ZowieDescription",		TOK_STRING(StoryTask,zowieDescription,0) },
	{ "ZowieSingularDescription", TOK_STRING(StoryTask,zowieSingularDescription,0) },
	{ "ZowieMap",				TOK_NO_TRANSLATE | TOK_STRING(StoryTask,villainMap,0) },

	{ "InteractDelay",			TOK_INT(StoryTask,interactDelay,0) },
	{ "InteractBeginString",	TOK_STRING(StoryTask,interactBeginString,0) },
	{ "InteractCompleteString", TOK_STRING(StoryTask,interactCompleteString,0) },
	{ "InteractInterruptedString", TOK_STRING(StoryTask,interactInterruptedString,0) },
	{ "InteractActionString",	TOK_STRING(StoryTask,interactActionString,0) },

	// Go To Volume task
	{ "VolumeMapName",			TOK_STRING(StoryTask,volumeMapName,0) },
	{ "VolumeName",				TOK_STRING(StoryTask,volumeName,0) },
	{ "VolumeDescription",		TOK_STRING(StoryTask,volumeDescription,0) },

	// Compound task
	{ "TaskDef",				TOK_STRUCT(StoryTask,children, ParseStoryTask) },

	// reward times
	{ "TaskBegin",				TOK_STRUCT(StoryTask,taskBegin,ParseStoryReward) },
	{ "TaskBeginFlashback",		TOK_STRUCT(StoryTask,taskBeginFlashback,ParseStoryReward) },
	{ "TaskBeginNoFlashback",	TOK_STRUCT(StoryTask,taskBeginNoFlashback,ParseStoryReward) },
	{ "TaskSuccess",			TOK_STRUCT(StoryTask,taskSuccess,ParseStoryReward) },
	{ "TaskSuccessFlashback",	TOK_STRUCT(StoryTask,taskSuccessFlashback,ParseStoryReward) },
	{ "TaskSuccessNoFlashback",	TOK_STRUCT(StoryTask,taskSuccessNoFlashback,ParseStoryReward) },
	{ "TaskFailure",			TOK_STRUCT(StoryTask,taskFailure,ParseStoryReward) },
	{ "TaskAbandon",			TOK_STRUCT(StoryTask,taskAbandon,ParseStoryReward) },
	{ "ReturnSuccess",			TOK_STRUCT(StoryTask,returnSuccess,ParseStoryReward) },
	{ "ReturnSuccessFlashback",	TOK_STRUCT(StoryTask,returnSuccessFlashback,ParseStoryReward) },
	{ "ReturnSuccessNoFlashback",	TOK_STRUCT(StoryTask,returnSuccessNoFlashback,ParseStoryReward) },
	{ "ReturnFailure",			TOK_STRUCT(StoryTask,returnFailure,ParseStoryReward) },
	{ "TaskComplete",			TOK_REDUNDANTNAME | TOK_STRUCT(StoryTask,taskSuccess,ParseStoryReward) },

	{ "}",						TOK_END,			0 },
	SCRIPTVARS_STD_PARSE(StoryTask)
	{ "", 0, 0 }
};

TokenizerParseInfo ParseStoryTaskSet[] = {
	{ "",				TOK_CURRENTFILE(StoryTaskSet,filename) },
	{ "{",				TOK_START,		0},
	{ "TaskDef",		TOK_STRUCT(StoryTaskSet,tasks,ParseStoryTask) },
	{ "}",				TOK_END,			0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseStoryTaskSetList[] = {
	{ "TaskSet",		TOK_STRUCT(StoryTaskSetList,sets,ParseStoryTaskSet) },
	{ "", 0, 0 }
};
""".}