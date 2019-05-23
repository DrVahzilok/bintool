{.emit: """
#include "storyarc.h"
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
""".}