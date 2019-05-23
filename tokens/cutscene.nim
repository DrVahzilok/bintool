{.emit: """
#include "cutScene.h"
typedef struct CutSceneFileList {
	CutSceneDef ** cutSceneDefs;
} CutSceneFileList;

TokenizerParseInfo ParseCutSceneEvent[] =
{	
	{ "Time",			TOK_STRUCTPARAM | TOK_F32   	( CutSceneEvent, time , 0)			},
	{ "Actor",			TOK_STRUCTPARAM | TOK_STRING	( CutSceneEvent, actor , 0)			},
	{ "Dialog",			TOK_STRUCTPARAM | TOK_STRING	( CutSceneEvent, dialog , 0)		},
	{ "Action",			TOK_STRING						( CutSceneEvent, action , 0)		},
	{ "Target",			TOK_STRING						( CutSceneEvent, target , 0)		},
	{ "Position",		TOK_STRING						( CutSceneEvent, position , 0)		},
	{ "MoveTo",			TOK_STRING						( CutSceneEvent, moveTo , 0)		},
	{ "DepthOfField",	TOK_F32							( CutSceneEvent, depthOfField , 0)	},
	{ "MoveToDepthOfField",	TOK_F32						( CutSceneEvent, moveToDepthOfField , 0)	},
	{ "Over",			TOK_INT							( CutSceneEvent, over , 0)			},
	{ "Music",			TOK_STRING						( CutSceneEvent, music , 0)			},
	{ "SoundFx",		TOK_STRING						( CutSceneEvent, soundfx , 0)		},
	{ "LeftText",		TOK_STRING						( CutSceneEvent, leftText , 0)		},
	{ "LeftWatermark",	TOK_STRING						( CutSceneEvent, leftWatermark , 0)	},
	{ "LeftObjective",	TOK_STRING						( CutSceneEvent, leftObjective , 0)	},
	{ "LeftReward",		TOK_STRING						( CutSceneEvent, leftReward , 0)	},
	{ "RightText",		TOK_STRING						( CutSceneEvent, rightText , 0)		},
	{ "RightWatermark",	TOK_STRING						( CutSceneEvent, rightWatermark , 0)	},
	{ "RightObjective",	TOK_STRING						( CutSceneEvent, rightObjective , 0)	},
	{ "RightReward",	TOK_STRING						( CutSceneEvent, rightReward , 0)	},
	{ ">",				TOK_END,			0												},
	{ "", 0, 0 }
};

#define	CUTSCENE_ONENCOUNTERCREATE	(1 << 0)	
#define	CUTSCENE_FREEZEMAPSERVER	(1 << 1)
#define CUTSCENE_FROMSTRING			(1 << 2)

//THe flags are really for the encounter to read, I suppose they should go into a super structure...kinds like how spawndefs and spawninclude+missionencounter shouldn't be one big struct
StaticDefineInt ParseCutSceneFlags[] =
{
	DEFINE_INT
	{ "OnEncounterCreate",	CUTSCENE_ONENCOUNTERCREATE },	//for the encounter only
	{ "FreezeMapServer",	CUTSCENE_FREEZEMAPSERVER },		//for the encounter only
	DEFINE_END
};

TokenizerParseInfo ParseCutScene[] =
{
	{ "{",			TOK_START,		0},
	{ "Flags",		TOK_FLAGS(CutSceneDef,flags,			0),					ParseCutSceneFlags }, 
	{ "<",			TOK_STRUCT(CutSceneDef, events,		ParseCutSceneEvent) },
	{ "}",			TOK_END,			0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseCutSceneList[] =
{
	{ "CutScene",	TOK_STRUCT( CutSceneFileList, cutSceneDefs, ParseCutScene) },
	{ "", 0, 0 },
};
""".}