{.emit: """
#include "contactdef.h"

// *********************************************************************************
//  Contact store parsing
// *********************************************************************************

TokenizerParseInfo ParseContactStoreItem[] =
{
	{ "{",		TOK_START,		0}, 
	{ "}",		TOK_END,			0}, 
	{ "Power",	TOK_EMBEDDEDSTRUCT(ContactStoreItem, power, ParsePowerNameRef) },
	{ "Price",	TOK_INT(ContactStoreItem, price,0) },
	{ "Unique", TOK_BOOLFLAG(ContactStoreItem, unique,0) },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseContactStoreItems[] =
{
	{ "{",		TOK_START,		0}, 
	{ "}",		TOK_END,			0}, 
	{ "Item",	TOK_STRUCT(ContactStoreItems, items, ParseContactStoreItem) },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseContactStore[] =
{
	{ "{",		TOK_START,		0}, 
	{ "}",		TOK_END,			0}, 
	{ "Acquaintance",	TOK_EMBEDDEDSTRUCT(ContactStore, acquaintanceItems, ParseContactStoreItems) },
	{ "Friend",			TOK_EMBEDDEDSTRUCT(ContactStore, friendItems, ParseContactStoreItems) },
	{ "Confidant",		TOK_EMBEDDEDSTRUCT(ContactStore, confidantItems, ParseContactStoreItems) },
	{ "", 0, 0 }
};

	#if SERVER
		StaticDefineInt ParseStatus[] = {
			DEFINE_INT
			{ "undefined",				STATUS_UNDEFINED			},
			{ "low",					STATUS_LOW					},
			{ "medium",					STATUS_MEDIUM				},
			{ "high",					STATUS_HIGH					},
			DEFINE_END
		};
	#endif
// *********************************************************************************
//  Contact definition parsing
// *********************************************************************************

TokenizerParseInfo ParseStoryArcRef[] = {
	{ "", TOK_STRUCTPARAM | TOK_FILENAME(StoryArcRef,filename,0) },
	{ "\n",				TOK_END,		0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseStoryTaskInclude[] = {
	{ "", TOK_STRUCTPARAM | TOK_FILENAME(StoryTaskInclude,filename,0) },
	{ "\n",				TOK_END,		0 },
	{ "", 0, 0 }
};

StaticDefineInt ParseContactFlag[] = {
	DEFINE_INT
	{ "Deprecated",				CONTACT_DEPRECATED			},
	{ "TaskForceContact",		CONTACT_TASKFORCE			},
	{ "CanTrain",				CONTACT_TRAINER				},
	{ "TutorialContact",		CONTACT_TUTORIAL			},
	{ "TeleportOnComplete",		CONTACT_TELEPORTONCOMPLETE	},
	{ "AutoIssueContact",		CONTACT_ISSUEONINTERACT		},
	{ "IssueOnInteract",		CONTACT_ISSUEONINTERACT		},
	{ "AutoHideContact",		CONTACT_AUTOHIDE			},
	{ "NoFriendIntroduction",	CONTACT_NOFRIENDINTRO		},
	{ "NoCompleteIntroduction",	CONTACT_NOCOMPLETEINTRO		},
	{ "DontIntroduceMe",		CONTACT_DONTINTRODUCEME		},
	{ "NoIntroductions",		CONTACT_NOINTRODUCTIONS		},
	{ "NoHeadshot",				CONTACT_NOHEADSHOT			},
	{ "NoAboutPage",			CONTACT_NOABOUTPAGE			},
	{ "CanTailor",				CONTACT_TAILOR				},
	{ "CanRespec",				CONTACT_RESPEC				},
	{ "NotorietyContact",		CONTACT_NOTORIETY			},
	{ "Broker",					CONTACT_BROKER				},
	{ "Newspaper",				CONTACT_NEWSPAPER			},
	{ "CanTeach",				CONTACT_TEACHER				},
	{ "ScriptControlled",		CONTACT_SCRIPT				},
	{ "PvPContact",				CONTACT_PVP					},
	{ "NoCellphone",			CONTACT_NOCELLPHONE			},
	{ "Registrar",				CONTACT_REGISTRAR			},
	{ "SupergroupMissionContact",CONTACT_SUPERGROUP			},
	{ "MetaContact",			CONTACT_METACONTACT			},
	{ "IssueOnZoneEnter",		CONTACT_ISSUEONZONEENTER	},
	{ "HideOnComplete",			CONTACT_HIDEONCOMPLETE		},
	{ "Flashback",				CONTACT_FLASHBACK			},
	{ "PlayerMissionGiver",		CONTACT_PLAYERMISSIONGIVER	},
	{ "StartWithCellPhone",		CONTACT_STARTWITHCELLPHONE	},
	{ "IsTip",					CONTACT_TIP					},
	{ "Dismissable",			CONTACT_DISMISSABLE			},
	{ "AutoDismiss",			CONTACT_AUTODISMISS			},
	DEFINE_END
};

StaticDefineInt ParseContactAlliance[] = {
	DEFINE_INT
	{ "Both",					ALLIANCE_NEUTRAL },
	{ "Neutral",				ALLIANCE_NEUTRAL },
	{ "Hero",					ALLIANCE_HERO },
	{ "Villain",				ALLIANCE_VILLAIN },
	DEFINE_END
};

StaticDefineInt ParseContactUniverse[] = {
	DEFINE_INT
	{ "Both",					UNIVERSE_BOTH },
	{ "Neutral",				UNIVERSE_BOTH },
	{ "Primal",					UNIVERSE_PRIMAL },
	{ "Praetorian",				UNIVERSE_PRAETORIAN },
	DEFINE_END
};

StaticDefineInt ParseContactTipType[] = {
	DEFINE_INT
	{ "None",					TIPTYPE_NONE },
	{ "AlignmentTip",			TIPTYPE_ALIGNMENT },
	{ "MoralityTip",			TIPTYPE_MORALITY },
	{ "Special",				TIPTYPE_SPECIAL },
	DEFINE_END
};

TokenizerParseInfo ParseContactDef[] = {
	{ "{",							TOK_START,		0},
	{ "",							TOK_CURRENTFILE(ContactDef,filename) },

	// strings
	{ "Name",						TOK_STRING(ContactDef,displayname,0) },
	{ "Gender",						TOK_INT(ContactDef,gender,0),		ParseGender },
	{ "Status",						TOK_INT(ContactDef,status,0),		ParseStatus },
	{ "Alliance",					TOK_INT(ContactDef,alliance,ALLIANCE_UNSPECIFIED),	ParseContactAlliance },
	{ "Universe",					TOK_INT(ContactDef,universe,UNIVERSE_UNSPECIFIED),	ParseContactUniverse },
	{ "TipType",					TOK_STRING(ContactDef,tipTypeStr,0) },
	{ "DescriptionString",			TOK_STRING(ContactDef,description,0) },
	{ "ProfessionString",			TOK_STRING(ContactDef,profession,0) },
	{ "HelloString",				TOK_STRING(ContactDef,hello,0) },
	{ "SOLHelloString",				TOK_STRING(ContactDef,SOLhello,0) },
	{ "IDontKnowYouString",			TOK_STRING(ContactDef,dontknow,0) },
	{ "SOLIDontKnowYouString",		TOK_STRING(ContactDef,SOLdontknow,0) },
	{ "FirstVisitString",			TOK_STRING(ContactDef,firstVisit,0) },
	{ "SOLFirstVisitString",		TOK_STRING(ContactDef,SOLfirstVisit,0) },
	{ "NoTasksRemainingString",		TOK_STRING(ContactDef,noTasksRemaining,0) },
	{ "SOLNoTasksRemainingString",	TOK_STRING(ContactDef,SOLnoTasksRemaining,0) },
	{ "PlayerBusyString",			TOK_STRING(ContactDef,playerBusy,0) },
	{ "SOLPlayerBusyString",		TOK_STRING(ContactDef,SOLplayerBusy,0) },
	{ "ComeBackLaterString",		TOK_STRING(ContactDef,comeBackLater,0) },
	{ "SOLComeBackLaterString",		TOK_STRING(ContactDef,SOLcomeBackLater,0) },
	{ "ZeroContactPointsString",	TOK_STRING(ContactDef,zeroRelPoints,0) },		// for tutorial contact
	{ "SOLZeroContactPointsString",	TOK_STRING(ContactDef,SOLzeroRelPoints,0) },	// for tutorial contact
	{ "NeverIssuedTaskString",		TOK_STRING(ContactDef,neverIssuedTask,0) },		// for tutorial contact
	{ "SOLNeverIssuedTaskString",	TOK_STRING(ContactDef,SOLneverIssuedTask,0) },		// for tutorial contact
	{ "WrongAllianceString",		TOK_STRING(ContactDef,wrongAlliance,0) },
	{ "SOLWrongAllianceString",		TOK_STRING(ContactDef,SOLwrongAlliance,0) },
	{ "WrongUniverseString",		TOK_STRING(ContactDef,wrongUniverse,0) },
	{ "SOLWrongUniverseString",		TOK_STRING(ContactDef,SOLwrongUniverse,0) },
	{ "CallTextOverride",			TOK_STRING(ContactDef,callTextOverride,0) },
	{ "AskAboutTextOverride",		TOK_STRING(ContactDef,askAboutTextOverride,0) },
	{ "LeaveTextOverride",			TOK_STRING(ContactDef,leaveTextOverride,0) },
	{ "ImageOverride",				TOK_STRING(ContactDef,imageOverride,0) },
	{ "DismissOptionOverride",		TOK_STRING(ContactDef,dismissOptionOverride,0) },
	{ "DismissConfirmTextOverride",	TOK_STRING(ContactDef,dismissConfirmTextOverride,0) },
	{ "DismissConfirmYesOverride",	TOK_STRING(ContactDef,dismissConfirmYesOverride,0) },
	{ "DismissConfirmNoOverride",	TOK_STRING(ContactDef,dismissConfirmNoOverride,0) },
	{ "DismissSuccessOverride",		TOK_STRING(ContactDef,dismissSuccessOverride,0) },
	{ "DismissUnableOverride",		TOK_STRING(ContactDef,dismissUnableOverride,0) },
	{ "TaskDeclineOverride",		TOK_STRING(ContactDef,taskDeclineOverride,0) },
	{ "NoCellOverride",				TOK_STRING(ContactDef,noCellOverride,0) },

	{ "MinutesTillExpire",			TOK_F32(ContactDef,minutesExpire,0) },
	{ "RelationshipChangeString_ToFriend",		TOK_STRING(ContactDef,relToFriend,0) },
	{ "RelationshipChangeString_ToConfidant",	TOK_STRING(ContactDef,relToConfidant,0) },
	{ "IntroString",				TOK_STRING(ContactDef,introduction,0) },
	{ "IntroAcceptString",			TOK_STRING(ContactDef,introductionAccept,0) },
	{ "IntroSendoffString",			TOK_STRING(ContactDef,introductionSendoff,0) },
	{ "SOLIntroSendoffString",		TOK_STRING(ContactDef,SOLintroductionSendoff,0) },
	{ "IntroduceOneContact",		TOK_STRING(ContactDef,introduceOneContact,0) },
	{ "IntroduceTwoContacts",		TOK_STRING(ContactDef,introduceTwoContacts,0) },
	{ "FailSafeLevelString",		TOK_STRING(ContactDef,failsafeString,0) },
	{ "SOLFailSafeLevelString",		TOK_STRING(ContactDef,SOLfailsafeString,0) },
	{ "LocationString",				TOK_STRING(ContactDef,locationName,0) },

	// Subcontacts for MetaContacts
	{ "SubContacts",				TOK_STRINGARRAY(ContactDef,subContacts) },
	{ "SubContactsDisplay",			TOK_STRINGARRAY(ContactDef,subContactsDisplay) },

	//contact requires statement
	{ "InteractionRequires",		TOK_STRINGARRAY(ContactDef,interactionRequires) },
	{ "ContactRequires",			TOK_REDUNDANTNAME | TOK_STRINGARRAY(ContactDef,interactionRequires) },
	{ "InteractionRequiresText",	TOK_STRING(ContactDef,interactionRequiresFailString,0) },
	{ "ContactRequiresText",		TOK_REDUNDANTNAME | TOK_STRING(ContactDef,interactionRequiresFailString,0) },

	// Badge Requirements
	{ "RequiredBadge",				TOK_STRING(ContactDef,requiredBadge,0) },
	{ "BadgeNeededString",			TOK_STRING(ContactDef,badgeNeededString,0) },
	{ "SOLBadgeNeededString",		TOK_STRING(ContactDef,SOLbadgeNeededString,0) },
	{ "BadgeFirstTick",				TOK_STRING(ContactDef,badgeFirstTick,0) },
	{ "BadgeSecondTick",			TOK_STRING(ContactDef,badgeSecondTick,0) },
	{ "BadgeThirdTick",				TOK_STRING(ContactDef,badgeThirdTick,0) },
	{ "BadgeFourthTick",			TOK_STRING(ContactDef,badgeFourthTick,0) },

	// Map Token Requirement
	{ "MapTokenRequired",			TOK_STRING(ContactDef,mapTokenRequired,0) },

	// task force strings
	{ "RequiredToken",				TOK_STRING(ContactDef,requiredToken,0) },
	{ "DontHaveToken",				TOK_STRING(ContactDef,dontHaveToken,0) },
	{ "SOLDontHaveToken",			TOK_STRING(ContactDef,SOLdontHaveToken,0) },
	{ "PlayerLevelTooLow",			TOK_STRING(ContactDef,levelTooLow,0) },
	{ "PlayerLevelTooHigh",			TOK_STRING(ContactDef,levelTooHigh,0) },
	{ "NeedLargeTeam",				TOK_STRING(ContactDef,needLargeTeam,0) },
	{ "NeedTeamLeader",				TOK_STRING(ContactDef,needTeamLeader,0) },
	{ "NeedTeamOnMap",				TOK_STRING(ContactDef,needTeamOnMap,0) },
	{ "BadTeamLevel",				TOK_STRING(ContactDef,badTeamLevel,0) },
	{ "TaskForceInvite",			TOK_STRING(ContactDef,taskForceInvite,0) },
	{ "TaskForceRewardRequires",	TOK_STRINGARRAY(ContactDef,taskForceRewardRequires) },
	{ "TaskForceRewardRequiresText",TOK_STRING(ContactDef,taskForceRewardRequiresText,0) },
	{ "TaskForceName",				TOK_STRING(ContactDef,taskForceName,0) },
	{ "TaskForceLevelAdjust",		TOK_INT(ContactDef,taskForceLevelAdjust,0) },

	// deprecated
	{ "StoreTitleString",			TOK_STRING(ContactDef,old_text,0) },
	{ "Icon",						TOK_STRING(ContactDef,old_text,0) },
	{ "StoreYouBoughtXXXString",	TOK_STRING(ContactDef,old_text,0) },

	// logical fields
	{ "TaskDef",					TOK_STRUCT(ContactDef,mytasks,ParseStoryTask) },
	{ "TaskInclude",				TOK_STRUCT(ContactDef,taskIncludes,ParseStoryTaskInclude) },
	{ "",							TOK_AUTOINTEARRAY(ContactDef,tasks) },
	// this will allow me to force the shared memory to allocate however much space I need
	{ "StoryArc",					TOK_STRUCT(ContactDef,storyarcrefs,ParseStoryArcRef) },
	{ "Dialog",						TOK_STRUCT(ContactDef,dialogDefs,ParseDialogDef) },

	{ "Stature",					TOK_INT(ContactDef,stature,0) },
	{ "StatureSet",					TOK_STRING(ContactDef,statureSet,0) },
	{ "NextStatureSet",				TOK_STRING(ContactDef,nextStatureSet,0) },
	{ "NextStatureSet2",			TOK_STRING(ContactDef,nextStatureSet2,0) },
	{ "ContactsAtOnce",				TOK_INT(ContactDef,contactsAtOnce,0) },
	{ "FriendCP",					TOK_INT(ContactDef,friendCP,0) },
	{ "ConfidantCP",				TOK_INT(ContactDef,confidantCP,0) },
	{ "CompleteCP",					TOK_INT(ContactDef,completeCP,0) },
	{ "HeistCP",					TOK_INT(ContactDef,heistCP,0) },
	{ "CompletePlayerLevel",		TOK_INT(ContactDef,completePlayerLevel,0) },
	{ "FailsafePlayerLevel",		TOK_INT(ContactDef,failsafePlayerLevel,0) },
	{ "MinPlayerLevel",				TOK_INT(ContactDef,minPlayerLevel,1) },
	{ "MaxPlayerLevel",				TOK_INT(ContactDef,maxPlayerLevel,MAX_PLAYER_SECURITY_LEVEL) },
	{ "Store",						TOK_EMBEDDEDSTRUCT(ContactDef, store, ParseContactStore) },

	{ "StoreCount", 				TOK_INT(ContactDef,stores.iCnt,0) },
	{ "Stores", 					TOK_STRINGARRAY(ContactDef,stores.ppchStores) },

	{ "AccessibleContact",			TOK_INT(ContactDef,accessibleContactValue,0) },

	{ "KnownVillainGroups",			TOK_INTARRAY(ContactDef,knownVillainGroups), ParseVillainGroupEnum},

	{ "DismissReward",				TOK_STRUCT(ContactDef,dismissReward,ParseStoryReward) },

	// flags
	{ "Deprecated",					TOK_BOOLFLAG(ContactDef,deprecated,0) },
	{ "SupergroupContact",			TOK_BOOLFLAG(ContactDef,deprecated,0) }, // DEPRECATED
	{ "CanTrain",					TOK_BOOLFLAG(ContactDef,canTrain,0) },
	{ "TutorialContact",			TOK_BOOLFLAG(ContactDef,tutorialContact,0) },
	{ "TeleportOnComplete",			TOK_BOOLFLAG(ContactDef,teleportOnComplete,0) },
	{ "AutoIssueContact",			TOK_BOOLFLAG(ContactDef,autoIssue,0) },
	{ "AutoHideContact",			TOK_BOOLFLAG(ContactDef,autoHide,0) },
	{ "TaskForceContact",			TOK_BOOLFLAG(ContactDef,taskforceContact,0) },
	{ "NoFriendIntroduction",		TOK_BOOLFLAG(ContactDef,noFriendIntro,0) },
	{ "MinTaskForceSize",			TOK_INT(ContactDef,minTaskForceSize,BEGIN_TASKFORCE_SIZE) },

	// new flags field
	{ "Flags",						TOK_FLAGARRAY(ContactDef,flags,CONTACT_DEF_FLAGS_SIZE),	ParseContactFlag },

	{ "}",							TOK_END,			0},
	SCRIPTVARS_STD_PARSE(ContactDef)
	{ "", 0, 0 }
};

TokenizerParseInfo ParseContactDefList[] = {
	{ "ContactDef",		TOK_STRUCT(ContactList,contactdefs,ParseContactDef) },
	{ "", 0, 0 }
};
""".}