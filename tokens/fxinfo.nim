{.emit: """
#include "fxinfo.h"
#include "fxbhvr.h"

typedef struct FxBhvrList {
	FxBhvr **behaviors;
} FxBhvrList;

static StashTable fx_bhvrhash = 0;

StaticDefineInt splatFlags[] = {
	DEFINE_INT
	{ "ADDITIVE", SPLAT_ADDITIVE },
	{ "ADDBASE",  SPLAT_ADDBASE  },
	{ "ROUNDTEXTURE",  SPLAT_ROUNDTEXTURE  },
	{ "SUBTRACTIVE", SPLAT_SUBTRACTIVE },
	DEFINE_END
};

StaticDefineInt splatFalloffType[] = {
	DEFINE_INT
	{ "NONE",	SPLAT_FALLOFF_NONE },
	{ "UP",		SPLAT_FALLOFF_UP   },
	{ "DOWN",	SPLAT_FALLOFF_DOWN },
	{ "BOTH",	SPLAT_FALLOFF_UP },
	{ "SHADOW",	SPLAT_FALLOFF_SHADOW },
	DEFINE_END
};

#if NOVODEX
StaticDefineInt physForceTypeTable[] = {
	DEFINE_INT
	{ "None",		eNxForceType_None },
	{ "Out",		eNxForceType_Out },
	{ "In",			eNxForceType_In },
	{ "CWSwirl",	eNxForceType_CWSwirl },
	{ "CCWSwirl",	eNxForceType_CCWSwirl },
	{ "Up",			eNxForceType_Up },
	{ "Forward",	eNxForceType_Forward },
	{ "Side",		eNxForceType_Side },
	{ "Drag",		eNxForceType_Drag },
	DEFINE_END
};

StaticDefineInt physJointDOFTable[] = {
	DEFINE_INT
	{ "RotateX", 			eNxJointDOF_RotateX },
	{ "RotateY", 			eNxJointDOF_RotateY },
	{ "RotateZ", 			eNxJointDOF_RotateZ },
	{ "TranslateX", 		eNxJointDOF_TranslateX },
	{ "TranslateY", 		eNxJointDOF_TranslateY },
	{ "TranslateZ", 		eNxJointDOF_TranslateZ },
	DEFINE_END
};

StaticDefineInt physDebrisTable[] =
{
	DEFINE_INT
	{ "None", 				eNxPhysDebrisType_None },
	{ "Small", 				eNxPhysDebrisType_Small },
	{ "Large", 				eNxPhysDebrisType_Large },
	{ "LargeIfHardware",	eNxPhysDebrisType_LargeIfHardware },
	DEFINE_END
};
#endif

//########################################################################################
//## Get a .bhvr file

//Only used by splats
TokenizerParseInfo parseStAnim[] = {
	{ "",				TOK_STRUCTPARAM | TOK_F32(StAnim,speed_scale, 0)}, 
	{ "",				TOK_STRUCTPARAM | TOK_F32(StAnim,st_scale, 0)}, 
	{ "",				TOK_STRUCTPARAM | TOK_STRING(StAnim,name, 0)}, 
	{ "",				TOK_STRUCTPARAM | TOK_FLAGS(StAnim,flags,0),stanim_flags}, 
	{ "\n",				TOK_END,			0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseFxBhvr[] = {
	{ "Behavior",				TOK_IGNORE }, // hack, so we can use the old list system for a bit
	{ "ParamBitfield",			TOK_USEDFIELD(FxBhvr,paramBitfield,paramBitSize)},
	{ "Name",					TOK_CURRENTFILE(FxBhvr,name)					},
	{ "FileAge",				TOK_TIMESTAMP(FxBhvr,fileAge)					},
	{ "StartJitter",			TOK_VEC3(FxBhvr,startjitter)					},
	{ "InitialVelocity",		TOK_VEC3(FxBhvr,initialvelocity)				},
	{ "InitialVelocityJitter",	TOK_VEC3(FxBhvr,initialvelocityjitter)			},
	{ "InitialVelocityAngle",	TOK_F32(FxBhvr,initialvelocityangle, 0)			},
	{ "Gravity",				TOK_F32(FxBhvr,gravity, 0)						},
	{ "Physics",				TOK_U8(FxBhvr,physicsEnabled, 0)				},
	{ "PhysRadius",				TOK_F32(FxBhvr,physRadius, 0)					}, // 0.7f) },
	{ "PhysGravity",			TOK_F32(FxBhvr,physGravity, 1.0f)				},
	{ "PhysRestitution",		TOK_F32(FxBhvr,physRestitution, 0)				}, // 0.5f) },
	{ "PhysSFriction",			TOK_F32(FxBhvr,physStaticFriction, 0)			}, // 0.5f) },
	{ "PhysDFriction",			TOK_F32(FxBhvr,physDynamicFriction, 0)			}, // 0.3f) },
	{ "PhysKillBelowSpeed",		TOK_F32(FxBhvr,physKillBelowSpeed, 0.0f)		},
	{ "PhysDensity",			TOK_F32(FxBhvr,physDensity, 1.0f)				},
	{ "PhysForceRadius",		TOK_F32(FxBhvr,physForceRadius, 0.0f)			},
	{ "PhysForcePower",			TOK_F32(FxBhvr,physForcePower, 0.0f)			},
	{ "PhysForcePowerJitter",	TOK_F32(FxBhvr,physForcePowerJitter, 0.0f)		},
	{ "PhysForceCentripetal",	TOK_F32(FxBhvr,physForceCentripetal, 2.0f)		},
	{ "PhysForceSpeedScaleMax",	TOK_F32(FxBhvr,physForceSpeedScaleMax, 0.0f)	},
	{ "PhysScale",				TOK_VEC3(FxBhvr,physScale)						},
#if NOVODEX
	{ "PhysJointDOFs",			TOK_FLAGS(FxBhvr,physJointDOFs,0), physJointDOFTable	},
	{ "PhysJointAnchor",		TOK_VEC3(FxBhvr,physJointAnchor)		},
	{ "PhysJointAngLimit",		TOK_F32(FxBhvr,physJointAngLimit, 0) },
	{ "PhysJointLinLimit",		TOK_F32(FxBhvr,physJointLinLimit, 0) },
	{ "PhysJointBreakTorque",	TOK_F32(FxBhvr,physJointBreakTorque, 0.0f)	},
	{ "PhysJointBreakForce",	TOK_F32(FxBhvr,physJointBreakForce, 0.0f)	},
	{ "PhysJointLinSpring",		TOK_F32(FxBhvr,physJointLinSpring, 0) },
	{ "PhysJointLinSpringDamp",	TOK_F32(FxBhvr,physJointLinSpringDamp, 0) },
	{ "PhysJointAngSpring",		TOK_F32(FxBhvr,physJointAngSpring, 0.0f)	},
	{ "PhysJointAngSpringDamp",	TOK_F32(FxBhvr,physJointAngSpringDamp, 0.0f)	},
	{ "PhysJointDrag",			TOK_F32(FxBhvr,physJointDrag, 0)				},
	{ "PhysJointCollidesWorld", TOK_BOOLFLAG(FxBhvr,physJointCollidesWorld, false)			},
	{ "PhysForceType",			TOK_INT(FxBhvr,physForceType, eNxForceType_None), physForceTypeTable},
	{ "PhysDebris",				TOK_INT(FxBhvr,physDebris, eNxPhysDebrisType_None), physDebrisTable	},
#else
	{ "PhysJointDOFs",			TOK_IGNORE	},
	{ "PhysJointAnchor",		TOK_IGNORE	},
	{ "PhysJointAngLimit",		TOK_IGNORE	},
	{ "PhysJointLinLimit",		TOK_IGNORE	},
	{ "PhysJointBreakTorque",	TOK_IGNORE	},
	{ "PhysJointBreakForce",	TOK_IGNORE	},
	{ "PhysJointLinSpring",		TOK_IGNORE	},
	{ "PhysJointLinSpringDamp",	TOK_IGNORE	},
	{ "PhysJointAngSpring",		TOK_IGNORE	},
	{ "PhysJointAngSpringDamp",	TOK_IGNORE	},
	{ "PhysJointDrag",			TOK_IGNORE	},
	{ "PhysJointCollidesWorld",	TOK_IGNORE	},
	{ "PhysForceType",			TOK_IGNORE	},
	{ "PhysDebris",				TOK_IGNORE	},
#endif
	{ "Spin",					TOK_VEC3(FxBhvr,initspin)				},
	{ "SpinJitter",				TOK_VEC3(FxBhvr,spinjitter)				},
	{ "FadeInLength",			TOK_F32(FxBhvr,fadeinlength, 0)			},
	{ "FadeOutLength",			TOK_F32(FxBhvr,fadeoutlength, 0)		},
	{ "Shake",					TOK_F32(FxBhvr,shake, 0)				},
	{ "ShakeFallOff",			TOK_F32(FxBhvr,shakeFallOff, 0)			},
	{ "ShakeRadius",			TOK_F32(FxBhvr,shakeRadius, 0)			},
	{ "Blur",					TOK_F32(FxBhvr,blur, 0)					},
	{ "BlurFallOff",			TOK_F32(FxBhvr,blurFallOff, 0)			},
	{ "BlurRadius",				TOK_F32(FxBhvr,blurRadius, 0)			},
	{ "Scale",					TOK_VEC3(FxBhvr,scale)					},
	{ "ScaleRate",				TOK_VEC3(FxBhvr,scalerate)				},
	{ "ScaleTime",				TOK_VEC3(FxBhvr,scaleTime)				},
	{ "EndScale",				TOK_VEC3(FxBhvr,endscale)				},
	{ "Stretch",				TOK_U8(FxBhvr,stretch, 0)				},
	{ "Drag",					TOK_F32(FxBhvr,drag, 0)					},
	{ "PyrRotate",				TOK_VEC3(FxBhvr,pyrRotate)				},
	{ "PyrRotateJitter",		TOK_VEC3(FxBhvr,pyrRotateJitter)		},
	{ "PositionOffset",			TOK_VEC3(FxBhvr,positionOffset)			},
	{ "UseShieldOffset",		TOK_BOOLFLAG(FxBhvr, useShieldOffset, 0)	},
	{ "TrackRate",				TOK_F32(FxBhvr,trackrate, 0)			},
	{ "TrackMethod",			TOK_U8(FxBhvr,trackmethod, 0)			},
	{ "Collides",				TOK_U8(FxBhvr,collides, 0)				},
	{ "LifeSpan",				TOK_INT(FxBhvr,lifespan, 0)				},
	{ "AnimScale",				TOK_F32(FxBhvr,animscale, 0)			},
	{ "Alpha",					TOK_U8(FxBhvr,alpha, 0)					},
	{ "PulsePeakTime",			TOK_F32(FxBhvr,pulsePeakTime, 0)		},
	{ "PulseBrightness",		TOK_F32(FxBhvr,pulseBrightness, 0)		},
	{ "PulseClamp",				TOK_F32(FxBhvr,pulseClamp, 0)			},
	{ "SplatFlags",				TOK_FLAGS(FxBhvr,splatFlags,		0), splatFlags			},
	{ "SplatFalloffType",		TOK_FLAGS(FxBhvr,splatFalloffType,	0), splatFalloffType		},
	{ "SplatNormalFade",		TOK_F32(FxBhvr,splatNormalFade, 0)		},
	{ "SplatFadeCenter",		TOK_F32(FxBhvr,splatFadeCenter, 0)		},
	{ "SplatSetBack",			TOK_F32(FxBhvr,splatSetBack, 0)			},
	{ "StAnim",					TOK_STRUCT(FxBhvr,stAnim,parseStAnim) },
	{ "HueShift",				TOK_F32(FxBhvr,hueShift, 0)				},
	{ "HueShiftJitter",			TOK_F32(FxBhvr,hueShiftJitter, 0)			},
	{ "StartColor",				TOK_RGB(FxBhvr,colornavpoint[0].rgb)	},
	{ "BeColor1",				TOK_RGB(FxBhvr,colornavpoint[1].rgb)	},
	{ "BeColor2",				TOK_RGB(FxBhvr,colornavpoint[2].rgb)	},
	{ "BeColor3",				TOK_RGB(FxBhvr,colornavpoint[3].rgb)	},
	{ "BeColor4",				TOK_RGB(FxBhvr,colornavpoint[4].rgb)	},
	{ "ByTime1",				TOK_INT(FxBhvr,colornavpoint[1].time, 0)	},
	{ "ByTime2",				TOK_INT(FxBhvr,colornavpoint[2].time, 0)	},
	{ "ByTime3",				TOK_INT(FxBhvr,colornavpoint[3].time, 0)	},
	{ "ByTime4",				TOK_INT(FxBhvr,colornavpoint[4].time, 0)	},
	{ "PrimaryTint",			TOK_F32(FxBhvr, colornavpoint[0].primaryTint, 0.0f) },
	{ "PrimaryTint1",			TOK_F32(FxBhvr, colornavpoint[1].primaryTint, 0.0f) },
	{ "PrimaryTint2",			TOK_F32(FxBhvr, colornavpoint[2].primaryTint, 0.0f) },
	{ "PrimaryTint3",			TOK_F32(FxBhvr, colornavpoint[3].primaryTint, 0.0f) },
	{ "PrimaryTint4",			TOK_F32(FxBhvr, colornavpoint[4].primaryTint, 0.0f) },
	{ "SecondaryTint",			TOK_F32(FxBhvr, colornavpoint[0].secondaryTint, 0.0f) },
	{ "SecondaryTint1",			TOK_F32(FxBhvr, colornavpoint[1].secondaryTint, 0.0f) },
	{ "SecondaryTint2",			TOK_F32(FxBhvr, colornavpoint[2].secondaryTint, 0.0f) },
	{ "SecondaryTint3",			TOK_F32(FxBhvr, colornavpoint[3].secondaryTint, 0.0f) },
	{ "SecondaryTint4",			TOK_F32(FxBhvr, colornavpoint[4].secondaryTint, 0.0f) },
	{ "InheritGroupTint",		TOK_BOOLFLAG(FxBhvr,bInheritGroupTint, 0)	},
	{ "Rgb0",					TOK_RGB(FxBhvr,colornavpoint[0].rgb)	},
	{ "Rgb1",					TOK_RGB(FxBhvr,colornavpoint[1].rgb)	},
	{ "Rgb2",					TOK_RGB(FxBhvr,colornavpoint[2].rgb)	},
	{ "Rgb3",					TOK_RGB(FxBhvr,colornavpoint[3].rgb)	},
	{ "Rgb4",					TOK_RGB(FxBhvr,colornavpoint[4].rgb)	},
	{ "Rgb0Time",				TOK_INT(FxBhvr,colornavpoint[1].time, 0)	},
	{ "Rgb1Time",				TOK_INT(FxBhvr,colornavpoint[2].time, 0)	},
	{ "Rgb2Time",				TOK_INT(FxBhvr,colornavpoint[3].time, 0)	},
	{ "Rgb3Time",				TOK_INT(FxBhvr,colornavpoint[4].time, 0)	},
	{ "Rgb4Time",				TOK_INT(FxBhvr,colornavpoint[0].time, 0)	}, //junk
	{ "TintGeom",				TOK_BOOL(FxBhvr,bTintGeom, 0) },
	{ "End",					TOK_END,		0										},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseFxBhvrList[] = {
	{ "Behavior",				TOK_STRUCT(FxBhvrList,behaviors, ParseFxBhvr) },
	{ "", 0, 0 }
};

StaticDefineInt	ParseFxEventFlags[] =
{
	DEFINE_INT
	{ "AdoptParentEntity",	FXGEO_ADOPT_PARENT_ENTITY	},
	{ "NoReticle",			FXGEO_NO_RETICLE			},
	{ "PowerLoopingSound",	FXGEO_POWER_LOOPING_SOUND	},
	{ "OneAtATime",			FXGEO_ONE_AT_A_TIME			},
	DEFINE_END
};

StaticDefineInt FxTypeTable[] = {
	DEFINE_INT
	{ "Create",				FxTypeCreate },
	{ "Destroy",			FxTypeDestroy },
	{ "Local",				FxTypeLocal },
	{ "Start",				FxTypeStart },
	{ "Posit",				FxTypePosit },
	{ "StartPositOnly",		FxTypeStartPositOnly },
	{ "PositOnly",			FxTypePositOnly },
	{ "SetState",			FxTypeSetState },
	{ "IncludeFx",			FxTypeIncludeFx },
	{ "SetLight",			FxTypeSetLight },
	DEFINE_END
};

StaticDefineInt FxCeventCollisionRotation[] = {
	DEFINE_INT
	{ "UseCollisionNormal",	FX_CEVENT_USE_COLLISION_NORM },
	{ "UseWorldUp",			FX_CEVENT_USE_WORLD_UP   },
	DEFINE_END
};

StaticDefineInt FxTransformFlag[] = {
	DEFINE_INT
	{ "None",	FX_NONE },
	{ "Rotation",	FX_ROTATION },
	{ "SuperRotation",	(FX_ROTATION | FX_ROTATE_ALL) },
	{ "Position",	FX_POSITION },
	{ "Scale",		FX_SCALE },
	{ "All",	FX_ALL },
	DEFINE_END
};


StaticDefineInt	ParseFxInfoFlags[] =
{
	DEFINE_INT
	{ "SoundOnly",			FX_SOUND_ONLY				},
	{ "InheritAlpha",		FX_INHERIT_ALPHA			},
	{ "IsArmor",			FX_IS_ARMOR					},	/* no longer used */
	{ "InheritAnimScale",	FX_INHERIT_ANIM_SCALE		},
	{ "DontInheritBits",	FX_DONT_INHERIT_BITS		},
	{ "DontSuppress",		FX_DONT_SUPPRESS			},
	{ "DontInheritTexFromCostume", FX_DONT_INHERIT_TEX_FROM_COSTUME },
	{ "UseSkinTint",		FX_USE_SKIN_TINT },
	{ "IsShield",			FX_IS_SHIELD },
	{ "IsWeapon",			FX_IS_WEAPON },
    { "NotCompatibleWithAnimalHead", FX_NOT_COMPATIBLE_WITH_ANIMAL_HEAD },
	{ "InheritGeoScale",	FX_INHERIT_GEO_SCALE },
	{ "UseTargetSeq",		FX_USE_TARGET_SEQ },
	DEFINE_END
};

TokenizerParseInfo parseSplatEvent[] =
{
	{	"",				TOK_STRUCTPARAM | TOK_STRING(SplatEvent, texture1, 0) },
	{	"",				TOK_STRUCTPARAM | TOK_STRING(SplatEvent, texture2, 0) },
	{	"\n",			TOK_END,								0},
	{	"", 0, 0 }
};

TokenizerParseInfo parseSoundEvent[] =
{
	{	"",				TOK_STRUCTPARAM | TOK_STRING(SoundEvent, soundName, 0) },
	{	"",				TOK_STRUCTPARAM | TOK_F32(SoundEvent, radius,	100)  },
	{	"",				TOK_STRUCTPARAM | TOK_F32(SoundEvent, fade,		20) },
	{	"",				TOK_STRUCTPARAM | TOK_F32(SoundEvent, volume,	1) },
	{	"\n",			TOK_END,		 				0},
	{	"", 0, 0 }						 
};										 

TokenizerParseInfo ParseFxEvent[] =
{
	{ "EName",		TOK_STRING(FxEvent,name, 0)		},
	{ "Type", 		TOK_INT(FxEvent,type,FxTypeCreate), FxTypeTable	},
	{ "Inherit",	TOK_FLAGS(FxEvent,inherit,0), FxTransformFlag	},
	{ "Update",		TOK_FLAGS(FxEvent,update,0), FxTransformFlag	},
	{ "At",			TOK_POOL_STRING | TOK_STRING(FxEvent,at,"Origin")	},
	{ "Bhvr",		TOK_STRING(FxEvent,bhvr, 0)		},	//BHVR can't be part of pool memory, because the filename might get expanded.
	{ "BhvrOverride",TOK_STRUCT(FxEvent,bhvrOverride, ParseFxBhvr)		},
	{ "JEvent",		TOK_STRING(FxEvent,jevent, 0)	},
	{ "CEvent",		TOK_STRING(FxEvent,cevent, 0)		},
	{ "CDestroy",	TOK_U8(FxEvent,cdestroy, 0)		},
	{ "JDestroy",	TOK_U8(FxEvent,jdestroy, 0)		},
	{ "CRotation",	TOK_FLAGS(FxEvent,crotation, 0), FxCeventCollisionRotation },
	{ "ParentVelocityFraction",	TOK_F32(FxEvent,parentVelFraction, 0) },
	{ "CThresh",	TOK_F32(FxEvent,cthresh, 0)		},
	{ "HardwareOnly",TOK_BOOLFLAG(FxEvent,bHardwareOnly, 0)		},
	{ "SoftwareOnly",TOK_BOOLFLAG(FxEvent,bSoftwareOnly, 0)		},
	{ "PhysicsOnly",TOK_BOOLFLAG(FxEvent,bPhysicsOnly, 0)		},
	{ "CameraSpace",TOK_BOOLFLAG(FxEvent,bCameraSpace, 0)		},
	{ "RayLength",	TOK_F32(FxEvent,fRayLength, 0.0f)		},
	{ "AtRayFx",	TOK_STRING(FxEvent,atRayFx, 0)	},
	{ "Geom",		TOK_UNPARSED(FxEvent,geom)		},
	{ "Cape",		TOK_UNPARSED(FxEvent,capeFiles)	},
	{ "AltPiv",		TOK_INT(FxEvent,altpiv, 0)	},
	{ "AnimPiv",	TOK_STRING(FxEvent,animpiv, 0)	},
	{ "Part1",		TOK_REDUNDANTNAME | TOK_UNPARSED(FxEvent,part)	},
	{ "Part2",		TOK_REDUNDANTNAME | TOK_UNPARSED(FxEvent,part)	},
	{ "Part3",		TOK_REDUNDANTNAME | TOK_UNPARSED(FxEvent,part)	},
	{ "Part4",		TOK_REDUNDANTNAME | TOK_UNPARSED(FxEvent,part)	},
	{ "Part5",		TOK_REDUNDANTNAME | TOK_UNPARSED(FxEvent,part)	},
	{ "Part",		TOK_UNPARSED(FxEvent,part)	},
	{ "Anim",		TOK_STRING(FxEvent,anim, 0)		},
	{ "SetState",	TOK_POOL_STRING | TOK_STRING(FxEvent,newstate, 0)	},
	{ "ChildFx",	TOK_STRING(FxEvent,childfx, 0)	},
	{ "Magnet",		TOK_STRING(FxEvent,magnet, 0)	},
	{ "LookAt",		TOK_STRING(FxEvent,lookat, 0)	},
	{ "PMagnet",	TOK_STRING(FxEvent,pmagnet, 0)	},
	{ "POther",		TOK_STRING(FxEvent,pother, 0)	},
	{ "Splat",		TOK_STRUCT(FxEvent,splat,	parseSplatEvent) }, //Convert sound, part and others over to this
	{ "Sound",		TOK_STRUCT(FxEvent,sound,	parseSoundEvent) },
	{ "SoundNoRepeat", TOK_INT(FxEvent, soundNoRepeat, 0)	},
	{ "LifeSpan",	TOK_F32(FxEvent,lifespan, 0)	},
	{ "LifeSpanJitter",	TOK_F32(FxEvent,lifespanjitter, 0)	},
	{ "Power",		TOK_RG(FxEvent,power)		},
	{ "While",		TOK_UNPARSED(FxEvent,whilebits)},
	{ "Until",		TOK_UNPARSED(FxEvent,untilbits)},
	{ "WorldGroup",	TOK_STRING(FxEvent,worldGroup, 0)},
	{ "Flags",		TOK_FLAGS(FxEvent,fxevent_flags,	0),	ParseFxEventFlags	},

	{ "End",		TOK_END,		0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseFxCondition[] =
{
	{ "On",			TOK_POOL_STRING | TOK_STRING(FxCondition,on, 0)	},
	{ "Time",		TOK_F32(FxCondition,time, 0)					},
	{ "DayStart",	TOK_F32(FxCondition,dayStart, 0)				},
	{ "DayEnd",		TOK_F32(FxCondition,dayEnd, 0)					},
	{ "Dist",		TOK_F32(FxCondition,dist, 0)					},
	{ "Chance",		TOK_F32(FxCondition,chance, 0)					},
	{ "DoMany",		TOK_U8(FxCondition,domany, 0)					},
	{ "Repeat",		TOK_U8(FxCondition,repeat, 0)					},
	{ "RepeatJitter",TOK_U8(FxCondition,repeatJitter, 0)			},
	{ "TriggerBits",TOK_UNPARSED(FxCondition,triggerbits)			},
	{ "Event",		TOK_STRUCT(FxCondition,events,ParseFxEvent)		},
	{ "Random",		TOK_U8(FxCondition,randomEvent, 0)				},
	{ "ForceThreshold", TOK_F32(FxCondition,forceThreshold,0.0f)	},
	{ "End",		TOK_END,		0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseFxInput[] =
{
	{"InpName",		TOK_STRING(FxInput,name, 0)		},
	{"End",			TOK_END,		0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseFxInfo[] =
{
	{ "FxInfo",		TOK_IGNORE,	0 }, // hack so we can use the existing list structure for a bit
	{ "Name",		TOK_CURRENTFILE(FxInfo,name)												},
	{ "FileAge",	TOK_TIMESTAMP(FxInfo,fileAge)								},
	{ "LifeSpan",	TOK_INT(FxInfo,lifespan, 0)												},
	{ "Lighting",	TOK_INT(FxInfo,lighting, 0)												},
	{ "Input",		TOK_STRUCT(FxInfo,inputs,ParseFxInput)		},
	{ "Condition",	TOK_STRUCT(FxInfo,conditions,ParseFxCondition)	},
	{ "Flags",		TOK_FLAGS(FxInfo,fxinfo_flags,0),			ParseFxInfoFlags	},
	{ "PerformanceRadius",TOK_F32(FxInfo,performanceRadius, 0)										},
	{ "OnForceRadius", TOK_F32(FxInfo,onForceRadius, 0.0f)				},
	{ "AnimScale",	TOK_F32(FxInfo,animScale,		1),										},
	{ "ClampMinScale",	TOK_VEC3(FxInfo, clampMinScale), },
	{ "ClampMaxScale",	TOK_VEC3(FxInfo, clampMaxScale), },
	{ "End",		TOK_END,		0 },
	{ "", 0, 0 }
};

typedef struct FxInfoList {
	FxInfo **fxinfos;
} FxInfoList;

TokenizerParseInfo ParseFxInfoList[] =
{
	{ "FxInfo",		TOK_STRUCT(FxInfoList,fxinfos,	ParseFxInfo) },
	{ "", 0, 0 },
} ;
""".}