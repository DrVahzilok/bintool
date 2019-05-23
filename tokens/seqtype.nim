{.emit: """
#include "seqtype.h"
#include "bones_h_ast.c"

// All parser-used defaults must be integers
#define SEQ_DEFAULT_VISSPHERERADIUS 5
#define SEQ_DEFAULT_MAX_ALPHA 255
#define SEQ_DEFAULT_TICKS_TO_LINGER_AFTER_DEATH  (20*30)
#define SEQ_DEFAULT_TICKS_TO_FADE_AWAY_AFTER_DEATH  (90)
#define SEQ_DEFAULT_NEAR_FADE_DISTANCE 350

#define SEQ_DEFAULT_RETICLEWIDTHBIAS 1



#define SEQ_DEFAULT_RETICLEHEIGHTBIAS 0.5
#define SEQ_DEFAULT_RETICLEBASEBIAS 0.0
#define SEQ_DEFAULT_FADE_OUT 100
#define SEQ_DEFAULT_ENTTYPE_CAPSULESIZE_X 3.0
#define SEQ_DEFAULT_ENTTYPE_CAPSULESIZE_Y 6.0
#define SEQ_DEFAULT_ENTTYPE_CAPSULESIZE_Z 3.0
#define SEQ_CRAZY_HIGH_LOD_DISTANCE 100000
#define SEQ_DEFAULT_MINIMUM_AMBIENT 0.15

#define SEQ_LOW_SHADOW_DEPTH	3.0		//for NPCS and other non jumpers
#define SEQ_MEDIUM_SHADOW_DEPTH 15.0	//for jumpers
#define SEQ_HIGH_SHADOW_DEPTH	30.0	//for fliers


typedef struct SeqTypeList {
	SeqType **seqTypes;
} SeqTypeList;

SeqTypeList seqTypeList;

StaticDefineInt	ParseShadowType[] =
{
	DEFINE_INT
	{ "Splat",		SEQ_SPLAT_SHADOW},
	{ "None",		SEQ_NO_SHADOW},
	DEFINE_END
};

StaticDefineInt	ParseShadowQuality[] =
{
	DEFINE_INT
	{ "Low",		SEQ_LOW_QUALITY_SHADOWS},
	{ "Medium",		SEQ_MEDIUM_QUALITY_SHADOWS},
	{ "High",		SEQ_HIGH_QUALITY_SHADOWS},
	DEFINE_END
};

StaticDefineInt	ParseSeqFlags[] =
{
	DEFINE_INT
	{ "NoShallowSplash",	SEQ_NO_SHALLOW_SPLASH},
	{ "NoDeepSplash",		SEQ_NO_DEEP_SPLASH | SEQ_NO_SHALLOW_SPLASH},
	{ "UseNormalTargeting",	SEQ_USE_NORMAL_TARGETING},
	{ "UseDynamicLibraryPiece",	SEQ_USE_DYNAMIC_LIBRARY_PIECE},
	{ "UseCapsuleForRangeFinding",	SEQ_USE_CAPSULE_FOR_RANGE_FINDING},
	DEFINE_END
};

StaticDefineInt ParseRejectContFX[] =
{
	DEFINE_INT
	{ "None",		SEQ_REJECTCONTFX_NONE },
	{ "All",		SEQ_REJECTCONTFX_ALL },
	{ "External",	SEQ_REJECTCONTFX_EXTERNAL },
	DEFINE_END
};


StaticDefineInt	ParseHealthFxFlags[] =
{
	DEFINE_INT
	{ "NoCollision",	HEALTHFX_NO_COLLISION },
	DEFINE_END
};

StaticDefineInt	ParseSeqPlacement[] =
{
	DEFINE_INT
	{ "DeadOn",			SEQ_PLACE_DEAD_ON},
	{ "SetBack",		SEQ_PLACE_SETBACK},
	DEFINE_END
};

StaticDefineInt	ParseSeqCollisionType[] =
{
	DEFINE_INT
	{ "Repulsion",		SEQ_ENTCOLL_REPULSION},
	{ "BounceUp",		SEQ_ENTCOLL_BOUNCEUP},
	{ "BounceFacing",	SEQ_ENTCOLL_BOUNCEFACING},
	{ "SteadyUp",		SEQ_ENTCOLL_STEADYUP},
	{ "SteadyFacing",	SEQ_ENTCOLL_STEADYFACING},
	{ "LaunchUp",		SEQ_ENTCOLL_LAUNCHUP},
	{ "LaunchFacing",	SEQ_ENTCOLL_LAUNCHFACING},
	{ "Door",			SEQ_ENTCOLL_DOOR},
	{ "LibraryPiece",	SEQ_ENTCOLL_LIBRARYPIECE},
	{ "Capsule",		SEQ_ENTCOLL_CAPSULE},
	{ "None",			SEQ_ENTCOLL_NONE},
	{ "BoneCapsules",	SEQ_ENTCOLL_BONECAPSULES},
	DEFINE_END
};

StaticDefineInt	ParseSeqSelectionType[] =
{
	DEFINE_INT
	{ "Capsule",		SEQ_SELECTION_CAPSULE},
	{ "LibraryPiece",	SEQ_SELECTION_LIBRARYPIECE},
	{ "Bones",			SEQ_SELECTION_BONES},
	{ "Door",			SEQ_SELECTION_DOOR},
	{ "BoneCapsules",	SEQ_SELECTION_BONECAPSULES},
	DEFINE_END
};

TokenizerParseInfo ParseHealthFx[] =
{
	{ "Range",				TOK_VEC2(HealthFx,range)		},
	{ "LibraryPiece",		TOK_STRINGARRAY(HealthFx,libraryPiece)	},
	{ "OneShotFx",			TOK_STRINGARRAY(HealthFx,oneShotFx)	},
	{ "ContinuingFx",		TOK_STRINGARRAY(HealthFx,continuingFx)	},
	{ "Flags",				TOK_FLAGS(HealthFx,flags,0),	ParseHealthFxFlags	},
	{ "End",				TOK_END,			0								},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseSequencerVar[] =
{
	{ "",				TOK_STRUCTPARAM | TOK_STRING( SequencerVar, variableName, 0 )		},
	{ "",				TOK_STRUCTPARAM | TOK_STRING( SequencerVar, replacementName, 0 )	},
	{	"\n",			TOK_END,							0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseBoneCapsule[] =
{
	{ "",	TOK_STRUCTPARAM | TOK_INT(BoneCapsule, bone, 0), BoneIdEnum	},
	{ "",	TOK_STRUCTPARAM | TOK_F32(BoneCapsule, radius, 0)			},
	{ "\n",	TOK_END														},
	{ "", 0 }
};

extern TokenizerParseInfo Vec3Default1[];	// from tricks.c, for geomscale

TokenizerParseInfo ParseSeqType[] =
{
	{ "Type",					TOK_IGNORE,		0}, // hack, for reloading
	{ "Name",					TOK_FIXEDSTR(SeqType,name)				},
	{ "FileName",				TOK_CURRENTFILE(SeqType,filename)			},
	{ "FileAge",				TOK_TIMESTAMP(SeqType,fileAge)	},
	{ "Sequencer",				TOK_FIXEDSTR(SeqType,seqname)			},
	{ "SequencerType",			TOK_FIXEDSTR(SeqType,seqTypeName)		},
	{ "Var",					TOK_STRUCT(SeqType, sequencerVars, ParseSequencerVar)	},
	{ "AnimScale",				TOK_F32(SeqType, animScale, 1)	},

	{ "Graphics",				TOK_STRING(SeqType,graphics,0)	},

	{ "LOD1_Dist",				TOK_F32(SeqType,loddist[1], 0)	},
	{ "LOD2_Dist",				TOK_F32(SeqType,loddist[2], 0)	},
	{ "LOD3_Dist",				TOK_F32(SeqType,loddist[3], 0)	},

	{ "VisSphereRadius",		TOK_F32(SeqType,vissphereradius,SEQ_DEFAULT_VISSPHERERADIUS)	},
	{ "MaxAlpha",				TOK_U8(SeqType,maxAlpha,SEQ_DEFAULT_MAX_ALPHA)		},
	{ "ReverseFadeOutDist",		TOK_F32(SeqType,reverseFadeOutDist, 0)		},

	{ "FadeOutStart",			TOK_F32(SeqType,fade[0],SEQ_DEFAULT_NEAR_FADE_DISTANCE)	},
	{ "FadeOutFinish",			TOK_F32(SeqType,fade[1],0)					},
	{ "TicksToLingerAfterDeath",TOK_INT(SeqType,ticksToLingerAfterDeath,SEQ_DEFAULT_TICKS_TO_LINGER_AFTER_DEATH)		},	
	{ "TicksToFadeAwayAfterDeath",TOK_INT(SeqType,ticksToFadeAwayAfterDeath,SEQ_DEFAULT_TICKS_TO_FADE_AWAY_AFTER_DEATH)	},	

	{ "ShadowType",				TOK_INT(SeqType,shadowType,SEQ_SPLAT_SHADOW),			ParseShadowType		},
	{ "ShadowTexture",			TOK_STRING(SeqType,shadowTexture, 0) },
	{ "ShadowQuality",			TOK_INT(SeqType,shadowQuality,SEQ_MEDIUM_QUALITY_SHADOWS),	ParseShadowQuality	},
	{ "ShadowSize",				TOK_VEC3(SeqType,shadowSize)		},
	{ "ShadowOffset",			TOK_VEC3(SeqType,shadowOffset)		},

	{ "Flags",					TOK_FLAGS(SeqType,flags,0),							ParseSeqFlags		},

	{ "LightAsDoorOutside",		TOK_INT(SeqType,lightAsDoorOutside, 0)},	
	{ "RejectContinuingFX",		TOK_INT(SeqType,rejectContinuingFX, 0),				ParseRejectContFX	},	

//	{ "GeomScale",				TOK_VEC3(SeqType,geomscale,1)	},  // MAK - Default of 1 for each component isn't supported any more
	{ "GeomScale",				TOK_EMBEDDEDSTRUCT(SeqType,geomscale,Vec3Default1) },
	{ "GeomScaleMax",			TOK_VEC3(SeqType,geomscalemax)		},
	{ "CapsuleSize",			TOK_VEC3(SeqType,capsuleSize)		},
	{ "CapsuleOffset",			TOK_VEC3(SeqType,capsuleOffset)		},
	{ "BoneCapsule",			TOK_STRUCT(SeqType,boneCapsules,ParseBoneCapsule)	},

	{ "HasRandomName",			TOK_INT(SeqType,hasRandomName, 0)		},
	{ "RandomNameFile",			TOK_STRING(SeqType,randomNameFile, 0)	},

	{ "BigMonster",				TOK_INT(SeqType,bigMonster, 0)		},

	{ "Fx",						TOK_STRINGARRAY(SeqType,fx)				},
	{ "OnClickFx",				TOK_STRING(SeqType,onClickFx, 0)			},
	
	{ "HealthFx",				TOK_STRUCT(SeqType, healthFx, ParseHealthFx)	},

	//{ "MinimumAmbient",			TOK_F32,			offsetof(SeqType,minimumambient),	SEQ_DEFAULT_MINIMUM_AMBIENT }, //floats dont work here
	{ "MinimumAmbient",			TOK_F32(SeqType,minimumambient,	0) },

	{ "BoneScaleFat",			TOK_STRING(SeqType,bonescalefat, 0)		},
	{ "BoneScaleSkinny",		TOK_STRING(SeqType,bonescaleskinny, 0)	},
	{ "RandomBoneScale",		TOK_INT(SeqType,randombonescale, 0)	},

	{ "NotSelectable",			TOK_INT(SeqType,notselectable,0)		},
	{ "CollisionType",			TOK_INT(SeqType,collisionType, SEQ_ENTCOLL_CAPSULE),	ParseSeqCollisionType	},
	{ "Bounciness",				TOK_F32(SeqType,bounciness, 0)		},
	{ "Placement",				TOK_INT(SeqType,placement, SEQ_PLACE_SETBACK),	ParseSeqPlacement},
	{ "Selection",				TOK_INT(SeqType,selection, SEQ_SELECTION_BONES),ParseSeqSelectionType		},

	{ "ConstantState",			TOK_STRINGARRAY(SeqType,constantStateStr)	},

	{ "ReticleHeightBias",		TOK_F32(SeqType,reticleHeightBias, 0)	}, // default is not an integer, set elsewhere
	{ "ReticleWidthBias",		TOK_F32(SeqType,reticleWidthBias, SEQ_DEFAULT_RETICLEWIDTHBIAS)	},
	{ "ReticleBaseBias",		TOK_F32(SeqType,reticleBaseBias, 0)	}, // default is not an integer, set elsewhere

	{ "ShoulderScaleSkinny",	TOK_VEC3(SeqType,shoulderScaleSkinny)},
	{ "ShoulderScaleFat",		TOK_VEC3(SeqType,shoulderScaleFat)	},
	{ "HipScale",				TOK_VEC3(SeqType,hipScale)			},
	{ "NeckScale",				TOK_VEC3(SeqType,neckScale)			},
	{ "LegScaleVec",			TOK_VEC3(SeqType,legScale)			},


	{ "HeadScaleRange",			TOK_F32(SeqType,headScaleRange, 0)	},
	{ "ShoulderScaleRange",		TOK_F32(SeqType,shoulderScaleRange, 0)},
	{ "ChestScaleRange",		TOK_F32(SeqType,chestScaleRange, 0),	},
	{ "WaistScaleRange",		TOK_F32(SeqType,waistScaleRange, 0)	},
	{ "HipScaleRange",			TOK_F32(SeqType,hipScaleRange, 0)		},
	{ "LegScaleMin",			TOK_F32(SeqType,legScaleMin, 0)		},
	{ "LegScaleMax",			TOK_F32(SeqType,legScaleMax, 0)		},
	{ "HeadScaleMin",			TOK_VEC3(SeqType,headScaleMin)		},
	{ "HeadScaleMax",			TOK_VEC3(SeqType,headScaleMax)		},

	{ "LegScaleRatio",			TOK_F32(SeqType,legScaleRatio, 0)		},

	{ "SpawnOffsetY",			TOK_F32(SeqType,spawnOffsetY, 0)		},

	{ "NoStrafe",				TOK_INT(SeqType,noStrafe, 0)			},
	{ "TurnSpeed",				TOK_F32(SeqType,turnSpeed,0)			},

	{ "CameraHeight",			TOK_F32(SeqType,cameraHeight, SEQ_DEFAULT_CAMERA_HEIGHT)	},

	{ "Pushable",				TOK_INT(SeqType,pushable, 0)			},
	{ "FullBodyPortrait",		TOK_INT(SeqType,fullBodyPortrait, 0)	},

	{ "StaticLighting",			TOK_INT(SeqType,useStaticLighting, 0)	},

	{ "End",					TOK_END												},
	{ "", 0, 0 }

};

TokenizerParseInfo ParseSeqTypeList[] = {
	{ "Type",		TOK_STRUCT(SeqTypeList,seqTypes,ParseSeqType) },
	{ "", 0, 0 }
};
""".}