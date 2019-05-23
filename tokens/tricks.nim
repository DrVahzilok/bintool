{.emit: """
#include "tricks.h"
#include "animtrackanimate.h"
#include "AutoLOD.h"

static StaticDefineInt autolod_flags[] = {
	DEFINE_INT
	{ "ErrorTriCount",		LOD_ERROR_TRICOUNT },
	{ "UseFallbackMaterial",LOD_USEFALLBACKMATERIAL },
	DEFINE_END
};

TokenizerParseInfo parse_auto_lod[] = {
	{ "AllowedError",	TOK_F32(AutoLOD,max_error, 0)			},
	{ "LodNearFade",	TOK_F32(AutoLOD,lod_nearfade, 0)		},
	{ "LodNear",		TOK_F32(AutoLOD,lod_near, 0)			},
	{ "LodFar",			TOK_F32(AutoLOD,lod_far, 0)			},
	{ "LodFarFade",		TOK_F32(AutoLOD,lod_farfade, 0)		},
	{ "LodFlags",		TOK_FLAGS(AutoLOD,flags,0),autolod_flags   },
	{ "ModelName",		TOK_STRING(AutoLOD,lod_modelname, 0)		},
	{ "End",			TOK_END,			0},
	{ "", 0, 0 }
};

typedef struct TexOptList
{
	TexOpt		**texopts;
	TrickInfo	**tricks;
	StashTable	texopt_name_hashes;
	StashTable	trick_name_hashes;
} TrickList;

static StaticDefineInt tex_flags[] = {
    DEFINE_INT
	{ "None",			0 },
	{ "ClampS",			TEXOPT_CLAMPS },
	{ "ClampT",			TEXOPT_CLAMPT },
	{ "RepeatS",		TEXOPT_REPEATS },
	{ "RepeatT",		TEXOPT_REPEATT },
	{ "MirrorS",		TEXOPT_MIRRORS },
	{ "MirrorT",		TEXOPT_MIRRORT },
	{ "Cubemap",		TEXOPT_CUBEMAP },
	{ "Truecolor",		TEXOPT_TRUECOLOR },
	{ "Replaceable",	TEXOPT_REPLACEABLE },
	{ "NoMip",			TEXOPT_NOMIP },
	{ "Jpeg",			TEXOPT_JPEG },
	{ "IsBumpMap",		TEXOPT_BUMPMAP },
	{ "NoDither",		TEXOPT_NODITHER },
	{ "NoColl",			TEXOPT_NOCOLL },
	{ "SurfaceSlick",	TEXOPT_SURFACESLICK },
	{ "SurfaceIcy",		TEXOPT_SURFACEICY },
	{ "SurfaceBouncy",	TEXOPT_SURFACEBOUNCY },
	{ "NoRandomAddGlow",	TEXOPT_NORANDOMADDGLOW },
	{ "AlwaysAddGlow",		TEXOPT_ALWAYSADDGLOW },
	{ "FullBright",		TEXOPT_FULLBRIGHT },
	{ "Border",			TEXOPT_BORDER },
	{ "OldTint",		TEXOPT_OLDTINT },
	{ "PointSample",	TEXOPT_POINTSAMPLE },
	{ "FallbackForceOpaque",	TEXOPT_FALLBACKFORCEOPAQUE },
    DEFINE_END
};

static StaticDefineInt stanim_flags[] = {
    DEFINE_INT
	{ "FRAMESNAP",		STANIM_FRAMESNAP },
	{ "PINGPONG",		STANIM_PINGPONG },
	{ "LOCAL_TIMER",	STANIM_LOCAL_TIMER },
	{ "GLOBAL_TIMER",	STANIM_GLOBAL_TIMER },
    DEFINE_END
};

static StaticDefineInt texblend_flags[] = {
    DEFINE_INT
	{ "Multiply",		BLENDMODE_MODULATE },
	{ "ColorBlendDual",	BLENDMODE_COLORBLEND_DUAL },
	{ "AddGlow",		BLENDMODE_ADDGLOW },
	{ "AlphaDetail",	BLENDMODE_ALPHADETAIL },
	{ "SunFlare",		BLENDMODE_SUNFLARE },
    DEFINE_END
};

static StaticDefineInt trick_flags[] = {
    DEFINE_INT
	// Legacy, not good practice, or unused
	{ "NoDraw",			TRICK_HIDE },
	{ "SimpleAlphaSort",TRICK_SIMPLEALPHASORT },
	{ "FancyWaterOffOnly",TRICK_FANCYWATEROFFONLY },
	{ "LightmapsOffOnly",TRICK_LIGHTMAPSOFFONLY },

	// Use these
	{ "FrontFace",		TRICK_FRONTYAW },
	{ "CameraFace",		TRICK_FRONTFACE },
	{ "NightLight",		TRICK_NIGHTLIGHT },
	{ "NoColl",			TRICK_NOCOLL },
	{ "EditorVisible",	TRICK_EDITORVISIBLE },
	{ "BaseEditVisible",TRICK_BASEEDITVISIBLE },
	{ "NoZTest",		TRICK_NOZTEST },
	{ "NoZWrite",		TRICK_NOZWRITE },
	{ "DoubleSided",	TRICK_DOUBLESIDED },
	{ "Additive",		TRICK_ADDITIVE },
	{ "Subtractive",	TRICK_SUBTRACTIVE },
	{ "NoFog",			TRICK_NOFOG },
	{ "LightFace",		TRICK_LIGHTFACE },
	{ "SelectOnly",		TRICK_PLAYERSELECT },
	{ "ReflectTex0",	TRICK_REFLECT },
	{ "ReflectTex1",	TRICK_REFLECT_TEX1 },
	{ "NoCameraCollide",TRICK_NOCAMERACOLLIDE },
	{ "NotSelectable",	TRICK_NOT_SELECTABLE },
	{ "AlphaCutout",	TRICK_ALPHACUTOUT },
    DEFINE_END
};

static StaticDefineInt model_flags[] = {
    DEFINE_INT
	// Legacy, not good practice, or unused
	{ "ForceAlphaSort",	OBJ_ALPHASORT },
	{ "ForceOpaque",	OBJ_FORCEOPAQUE },
	{ "TreeDraw",		OBJ_TREEDRAW },
	{ "SunFlare",		OBJ_SUNFLARE },
	
	// Use these
	{ "WorldFx",		OBJ_WORLDFX },
	{ "StaticFx",		OBJ_STATICFX },
	{ "FullBright",		OBJ_FULLBRIGHT },
	{ "NoLightAngle",	OBJ_NOLIGHTANGLE },
	{ "FancyWater",		OBJ_FANCYWATER },

	{ "DontCastShadowMap",	OBJ_DONTCASTSHADOWMAP },
	{ "DontReceiveShadowMap",	OBJ_DONTRECEIVESHADOWMAP },
    DEFINE_END
};

static StaticDefineInt group_flags[] = {
    DEFINE_INT
	{ "VisOutside",		GROUP_VIS_OUTSIDE },
	{ "VisBlocker",		GROUP_VIS_BLOCKER },
	{ "VisAngleBlocker",GROUP_VIS_ANGLEBLOCKER },
	{ "VisWindow",		GROUP_VIS_WINDOW },
	{ "VisDoorFrame",	GROUP_VIS_DOORFRAME },    //Used to get drawn/traversed in group tree even if beyond visible range?
	{ "RegionMarker",	GROUP_REGION_MARKER },	  //If set as nocoll still leaves it in the collision grid (for volume testing?)
	{ "VisOutsideOnly",	GROUP_VIS_OUTSIDE_ONLY },
	{ "SoundOccluder",	GROUP_SOUND_OCCLUDER },

	{ "VisTray",		GROUP_VIS_TRAY },
	{ "VolumeTrigger",	GROUP_VOLUME_TRIGGER },
	{ "WaterVolume",	GROUP_WATER_VOLUME },
	{ "LavaVolume",		GROUP_LAVA_VOLUME },
	{ "SewerWaterVolume",GROUP_SEWERWATER_VOLUME },
	{ "RedWaterVolume",	GROUP_REDWATER_VOLUME },
	{ "DoorVolume",		GROUP_DOOR_VOLUME },
	{ "MaterialVolume",	GROUP_MATERIAL_VOLUME },
	{ "ParentFade",		GROUP_PARENT_FADE },
	{ "KeyLight",		GROUP_KEY_LIGHT },
	{ "StackableFloor",	GROUP_STACKABLE_FLOOR },
	{ "StackableCeiling",GROUP_STACKABLE_CEILING },
	{ "StackableWall",	GROUP_STACKABLE_WALL },
    DEFINE_END
};

TokenizerParseInfo parse_rgb3[] = {
	{ "IgnoreHack1",				TOK_STRUCTPARAM | TOK_U8(TexOpt,scrollsScales.rgba3[0],0)},
	{ "IgnoreHack2",				TOK_STRUCTPARAM | TOK_U8(TexOpt,scrollsScales.rgba3[1],0)},
	{ "IgnoreHack3",				TOK_STRUCTPARAM | TOK_U8(TexOpt,scrollsScales.rgba3[2],0)},
	{ "IgnoreHack4",				TOK_U8(TexOpt,scrollsScales.hasRgb34,1)},
	{ "\n",				TOK_END,			0 },
	{ "", 0, 0 }
};

StaticDefineInt	parse_texopt_scroll_type[] =
{
	DEFINE_INT
	{ "Normal",	TEXOPTSCROLL_NORMAL},
	{ "PingPong",	TEXOPTSCROLL_PINGPONG},
	{ "Oval",	TEXOPTSCROLL_OVAL},
	DEFINE_END
};

TokenizerParseInfo Vec2Default1[] =
{
	{ "IgnoreHack1", TOK_STRUCTPARAM	|	TOK_F32_X,	0,				1 },
	{ "IgnoreHack2", TOK_STRUCTPARAM	|	TOK_F32_X,	sizeof(F32),	1 },
	{ "\n",						TOK_END },
	{ "", 0, 0 }
};

TokenizerParseInfo Vec3Default1[] =
{
	{ "IgnoreHack1", TOK_STRUCTPARAM	|	TOK_F32_X,	0,				1 },
	{ "IgnoreHack2", TOK_STRUCTPARAM	|	TOK_F32_X,	sizeof(F32),	1 },
	{ "IgnoreHack3", TOK_STRUCTPARAM	|	TOK_F32_X,	2*sizeof(F32),	1 },
	{ "\n",						TOK_END },
	{ "", 0, 0 }
};

TokenizerParseInfo RGBDefault255[] =
{
	{ "IgnoreHack1", TOK_STRUCTPARAM	|	TOK_U8_X,	0,				255 },
	{ "IgnoreHack2", TOK_STRUCTPARAM	|	TOK_U8_X,	sizeof(U8),		255 },
	{ "IgnoreHack3", TOK_STRUCTPARAM	|	TOK_U8_X,	2*sizeof(U8),	255 },
	{ "\n",						TOK_END },
	{ "", 0, 0 }
};

TokenizerParseInfo parse_tex_opt_fallback[] = {
	//{ "ScaleST0",		TOK_VEC2(TexOptFallback,scaleST[1], 1)},
	//{ "ScaleST1",		TOK_VEC2(TexOptFallback,scaleST[0], 1)},
	{ "ScaleST0",		TOK_EMBEDDEDSTRUCT(TexOptFallback,scaleST[1],Vec2Default1) },
	{ "ScaleST1",		TOK_EMBEDDEDSTRUCT(TexOptFallback,scaleST[0],Vec2Default1) },

	{ "Base",			TOK_STRING(TexOptFallback,base_name,0)},
	{ "Blend",			TOK_STRING(TexOptFallback,blend_name,0)},
	{ "BumpMap",		TOK_STRING(TexOptFallback,bumpmap,0)},
	{ "BlendType",		TOK_INT(TexOptFallback,blend_mode,0),texblend_flags},
	{ "UseFallback",	TOK_U8(TexOptFallback,useFallback,0)},

	{ "AmbientScale",		TOK_REDUNDANTNAME|TOK_F32(TexOptFallback,ambientScaleTrick[0], 0)},
	{ "DiffuseScale",		TOK_REDUNDANTNAME|TOK_F32(TexOptFallback,diffuseScaleTrick[0], 0)},
	{ "AmbientMin",			TOK_REDUNDANTNAME|TOK_F32(TexOptFallback,ambientMin[0], 0)},
	//{ "DiffuseScaleVec",	TOK_VEC3(TexOptFallback,diffuseScaleTrick, 1)},
	//{ "AmbientScaleVec",	TOK_VEC3(TexOptFallback,ambientScaleTrick, 1)},
	{ "DiffuseScaleVec",	TOK_EMBEDDEDSTRUCT(TexOptFallback,diffuseScaleTrick,Vec3Default1)},
	{ "AmbientScaleVec",	TOK_EMBEDDEDSTRUCT(TexOptFallback,ambientScaleTrick,Vec3Default1)},
	{ "AmbientMinVec",		TOK_VEC3(TexOptFallback,ambientMin)},

	{ "End",			TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo parse_name_value_set[] = {
	{ "IgnoreHack1",				TOK_STRUCTPARAM|TOK_STRING(CgFxParamVal,paramName,0)},
	{ "IgnoreHack2",				TOK_STRUCTPARAM|TOK_F32(CgFxParamVal,vals[0],0)   },
	{ "IgnoreHack3",				TOK_STRUCTPARAM|TOK_F32(CgFxParamVal,vals[1],0)   },
	{ "IgnoreHack4",				TOK_STRUCTPARAM|TOK_F32(CgFxParamVal,vals[2],0)   },
	{ "IgnoreHack5",				TOK_STRUCTPARAM|TOK_F32(CgFxParamVal,vals[3],0)   },
	{ "\n",				TOK_END },
	{ "", 0, 0 }
};

TokenizerParseInfo parse_tex_opt[] = {
	{ "IgnoreHack1",				TOK_STRUCTPARAM | TOK_STRING(TexOpt,name,0)},
	{ "F",				TOK_CURRENTFILE(TexOpt,file_name)},
	{ "TS",				TOK_TIMESTAMP(TexOpt,fileAge)},
	{ "InternalName",	TOK_STRING(TexOpt,name,0)},
	{ "Gloss",			TOK_F32(TexOpt,gloss,1.f)   },
	{ "Surface",		TOK_STRING(TexOpt,surface_name,0) },
	{ "Fade",			TOK_VEC2(TexOpt,texopt_fade) },
	{ "ScaleST0",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_OLD_TEX_GENERIC_BLEND],Vec2Default1)}, // JE: These two, apparently, have always been backwards.
	{ "ScaleST1",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_OLD_TEX_BASE],Vec2Default1)},
	{ "Blend",			TOK_STRING(TexOpt,blend_names[BLEND_OLD_TEX_GENERIC_BLEND],0)},
	{ "BumpMap",		TOK_STRING(TexOpt,blend_names[BLEND_BUMPMAP1],0)},
	{ "BlendType",		TOK_INT(TexOpt,blend_mode,0),texblend_flags},
	{ "Flags",			TOK_FLAGS(TexOpt,flags,0),tex_flags},
	{ "ObjFlags",		TOK_FLAGS(TexOpt,model_flags,0),model_flags},
	{ "DF_ObjName",     TOK_STRING(TexOpt,df_name,0) },

	// New Texture blending definitions
	{ "Base1",				TOK_STRING(TexOpt,blend_names[BLEND_BASE1],0)},
	{ "Base1Scale",			TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_BASE1],Vec2Default1)},
	{ "Base1Scroll",		TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_BASE1])},
	{ "Base1ScrollType",	TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_BASE1],TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "Base1Swappable",		TOK_U8(TexOpt,swappable[BLEND_BASE1],0) },

	{ "Multiply1",			TOK_STRING(TexOpt,blend_names[BLEND_MULTIPLY1],0)},
	{ "Multiply1Scale",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_MULTIPLY1],Vec2Default1)},
	{ "Multiply1Scroll",	TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_MULTIPLY1])},
	{ "Multiply1ScrollType",TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_MULTIPLY1], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "Multiply1Swappable",	TOK_U8(TexOpt,swappable[BLEND_MULTIPLY1],0) },

	{ "DualColor1",			TOK_STRING(TexOpt,blend_names[BLEND_DUALCOLOR1],0)},
	{ "DualColor1Scale",	TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_DUALCOLOR1],Vec2Default1)},
	{ "DualColor1Scroll",	TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_DUALCOLOR1])},
	{ "DualColor1ScrollType",TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_DUALCOLOR1], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "DualColor1Swappable",TOK_U8(TexOpt,swappable[BLEND_DUALCOLOR1],0) },

	{ "AddGlow1",			TOK_STRING(TexOpt,blend_names[BLEND_ADDGLOW1],0)},
	{ "AddGlow1Scale",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_ADDGLOW1],Vec2Default1)},
	{ "AddGlow1Scroll",		TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_ADDGLOW1])},
	{ "AddGlow1ScrollType",	TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_ADDGLOW1], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "AddGlow1Swappable",	TOK_U8(TexOpt,swappable[BLEND_ADDGLOW1],0) },

	{ "BumpMap1",			TOK_STRING(TexOpt,blend_names[BLEND_BUMPMAP1],0)},
	{ "BumpMap1Scale",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_BUMPMAP1],Vec2Default1)},
	{ "BumpMap1Scroll",		TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_BUMPMAP1])},
	{ "BumpMap1ScrollType",	TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_BUMPMAP1], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "BumpMap1Swappable",	TOK_U8(TexOpt,swappable[BLEND_BUMPMAP1],0) },

	{ "Mask",				TOK_STRING(TexOpt,blend_names[BLEND_MASK],0)},
	{ "MaskScale",			TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_MASK],Vec2Default1)},
	{ "MaskScroll",			TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_MASK])},
	{ "MaskScrollType",		TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_MASK], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "MaskSwappable",		TOK_U8(TexOpt,swappable[BLEND_MASK],0) },

	{ "Base2",				TOK_STRING(TexOpt,blend_names[BLEND_BASE2],0)},
	{ "Base2Scale",			TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_BASE2],Vec2Default1)},
	{ "Base2Scroll",		TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_BASE2])},
	{ "Base2ScrollType",	TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_BASE2], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "Base2Swappable",		TOK_U8(TexOpt,swappable[BLEND_BASE2],0) },

	{ "Multiply2",			TOK_STRING(TexOpt,blend_names[BLEND_MULTIPLY2],0)},
	{ "Multiply2Scale",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_MULTIPLY2],Vec2Default1)},
	{ "Multiply2Scroll",	TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_MULTIPLY2])},
	{ "Multiply2ScrollType",TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_MULTIPLY2], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "Multiply2Swappable",	TOK_U8(TexOpt,swappable[BLEND_MULTIPLY2],0) },

	{ "DualColor2",			TOK_STRING(TexOpt,blend_names[BLEND_DUALCOLOR2],0)},
	{ "DualColor2Scale",	TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_DUALCOLOR2],Vec2Default1)},
	{ "DualColor2Scroll",	TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_DUALCOLOR2])},
	{ "DualColor2ScrollType",TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_DUALCOLOR2], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "DualColor2Swappable",TOK_U8(TexOpt,swappable[BLEND_DUALCOLOR2],0) },

	{ "BumpMap2",			TOK_STRING(TexOpt,blend_names[BLEND_BUMPMAP2],0)},
	{ "BumpMap2Scale",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_BUMPMAP2],Vec2Default1)},
	{ "BumpMap2Scroll",		TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_BUMPMAP2])},
	{ "BumpMap2ScrollType",	TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_BUMPMAP2], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "BumpMap2Swappable",	TOK_U8(TexOpt,swappable[BLEND_BUMPMAP2],0) },

	{ "CubeMap",			TOK_STRING(TexOpt,blend_names[BLEND_CUBEMAP],0)},
	{ "CubeMapScale",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.texopt_scale[BLEND_CUBEMAP],Vec2Default1)},
	{ "CubeMapScroll",		TOK_VEC2(TexOpt,scrollsScales.texopt_scroll[BLEND_CUBEMAP])},
	{ "CubeMapScrollType",	TOK_INT(TexOpt,scrollsScales.texopt_scrollType[BLEND_CUBEMAP], TEXOPTSCROLL_NORMAL), parse_texopt_scroll_type},
	{ "CubeMapSwappable",	TOK_U8(TexOpt,swappable[BLEND_CUBEMAP],0) },

	{ "Color3",				TOK_NULLSTRUCT(parse_rgb3) }, // Using embedded struct to flag
	{ "Color4",				TOK_FIXED_ARRAY | TOK_U8_X, offsetof(TexOpt,scrollsScales.rgba4),	3},
	{ "SpecularColor",		TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.specularRgba1,RGBDefault255) },
	{ "SpecularColor1",		TOK_REDUNDANTNAME|TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.specularRgba1,RGBDefault255)},
	{ "SpecularColor2",		TOK_FIXED_ARRAY | TOK_U8_X, offsetof(TexOpt,scrollsScales.specularRgba2), 3 },
	{ "SpecularExponent",	TOK_F32(TexOpt,specularExponent1_parser,8)},
	{ "SpecularExponent1",	TOK_REDUNDANTNAME|TOK_F32(TexOpt,specularExponent1_parser,8)},
	{ "SpecularExponent2",	TOK_F32(TexOpt,specularExponent2_parser,0)},
	{ "Reflectivity",		TOK_F32(TexOpt,scrollsScales.reflectivity,0)}, // deprecated, to be removed
	{ "ReflectivityBase",	TOK_F32(TexOpt,scrollsScales.reflectivityBase,-1.0f)},
	{ "ReflectivityScale",	TOK_F32(TexOpt,scrollsScales.reflectivityScale,-1.0f)},
	{ "ReflectivityPower",	TOK_F32(TexOpt,scrollsScales.reflectivityPower,-1.0f)},

	{ "AlphaMask",			TOK_U8(TexOpt,scrollsScales.alphaMask,0)},
	{ "MaskWeight",			TOK_F32(TexOpt,scrollsScales.maskWeight, 1)},
	{ "Multiply1Reflect",	TOK_U8(TexOpt,scrollsScales.multiply1Reflect,0)},
	{ "Multiply2Reflect",	TOK_U8(TexOpt,scrollsScales.multiply2Reflect,0)},
	{ "BaseAddGlow",		TOK_U8(TexOpt,scrollsScales.baseAddGlow, 0)},
	{ "MinAddGlow",			TOK_U8(TexOpt,scrollsScales.minAddGlow, 0)},
	{ "MaxAddGlow",			TOK_U8(TexOpt,scrollsScales.maxAddGlow, 128)},

	{ "AddGlowMat2",		TOK_U8(TexOpt,scrollsScales.addGlowMat2, 0)},
	{ "AddGlowTint",		TOK_U8(TexOpt,scrollsScales.tintGlow, 0)},
	{ "ReflectionTint",		TOK_U8(TexOpt,scrollsScales.tintReflection, 0)},
	{ "ReflectionDesaturate",TOK_U8(TexOpt,scrollsScales.desaturateReflection, 0)},
	{ "AlphaWater",			TOK_U8(TexOpt,scrollsScales.alphaWater, 0)},

	{ "AmbientScale",		TOK_REDUNDANTNAME|TOK_F32(TexOpt,scrollsScales.ambientScaleTrick[0], 0)},
	{ "DiffuseScale",		TOK_REDUNDANTNAME|TOK_F32(TexOpt,scrollsScales.diffuseScaleTrick[0], 0)},
	{ "AmbientMin",			TOK_REDUNDANTNAME|TOK_F32(TexOpt,scrollsScales.ambientMin[0], 0)},
	{ "DiffuseScaleVec",	TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.diffuseScaleTrick,Vec3Default1)},
	{ "AmbientScaleVec",	TOK_EMBEDDEDSTRUCT(TexOpt,scrollsScales.ambientScaleTrick,Vec3Default1)},
	{ "AmbientMinVec",		TOK_VEC3(TexOpt,scrollsScales.ambientMin)},

	{ "Fallback",			TOK_EMBEDDEDSTRUCT(TexOpt,fallback,parse_tex_opt_fallback) },

	{ "End",				TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo parse_st_anim[] = {
	{ "IgnoreHack1",				TOK_STRUCTPARAM | TOK_F32(StAnim,speed_scale,0)},
	{ "IgnoreHack2",				TOK_STRUCTPARAM | TOK_F32(StAnim,st_scale,0)},
	{ "IgnoreHack3",				TOK_STRUCTPARAM | TOK_STRING(StAnim,name,0)},
	{ "IgnoreHack4",				TOK_STRUCTPARAM | TOK_FLAGS(StAnim,flags,0),stanim_flags},
	{ "\n",				TOK_END,			0 },
	{ "", 0, 0 }
};

TokenizerParseInfo parse_trick[] = {
	{ "IgnoreHack1",				TOK_STRUCTPARAM | TOK_STRING(TrickInfo,name,0)},
	{ "IgnoreHack2",				TOK_CURRENTFILE(TrickInfo,file_name)},
	{ "IgnoreHack3",				TOK_TIMESTAMP(TrickInfo,fileAge)},
	{ "LodFar",			TOK_F32(TrickInfo,lod_far,0)   },
	{ "LodFarFade",		TOK_F32(TrickInfo,lod_farfade,0)   },
	{ "LodNear",		TOK_F32(TrickInfo,lod_near,0)   },
	{ "LodNearFade",	TOK_F32(TrickInfo,lod_nearfade,0)   },

	{ "TrickFlags",		TOK_FLAGS(TrickInfo,tnode.flags1,0),trick_flags   },
	{ "ObjFlags",		TOK_FLAGS(TrickInfo,model_flags,0),model_flags   },
	{ "GroupFlags",		TOK_FLAGS(TrickInfo,group_flags,0),group_flags   },

	{ "Sway",			TOK_VEC2(TrickInfo,sway)   },
	{ "SwayRandomize",	TOK_VEC2(TrickInfo,sway_random)   },
	{ "Rotate",			TOK_REDUNDANTNAME | TOK_F32(TrickInfo,sway[0],0)   },
	{ "RotateRandomize",TOK_REDUNDANTNAME | TOK_F32(TrickInfo,sway_random[0],0)   },
	{ "SwayPitch",		TOK_VEC2(TrickInfo,sway_pitch)   },
	{ "SwayRoll",		TOK_VEC2(TrickInfo,sway_roll)   },
	{ "AlphaRef",		TOK_F32(TrickInfo,alpha_ref_parser,0)   },
	{ "SortBias",		TOK_F32(TrickInfo,alpha_sort_mod,0)   },
	{ "WaterReflectionSkew",		TOK_F32(TrickInfo,water_reflection_skew,30)   },
	{ "WaterReflectionStrength",	TOK_F32(TrickInfo,water_reflection_strength,60)   },
	{ "ScrollST0",		TOK_FIXED_ARRAY | TOK_F32_X, offsetof(TrickInfo,texScrollAmt[0]),	2   },
	{ "ScrollST1",		TOK_FIXED_ARRAY | TOK_F32_X, offsetof(TrickInfo,texScrollAmt[1]),	2   },
	{ "ShadowDist",		TOK_F32(TrickInfo,shadow_dist,0)   },
	{ "NightGlow",		TOK_VEC2(TrickInfo,nightglow_times)   },
	{ "TintColor0",		TOK_FIXED_ARRAY | TOK_U8_X, offsetof(TrickInfo,tnode.trick_rgba),	3   },
	{ "TintColor1",		TOK_FIXED_ARRAY | TOK_U8_X, offsetof(TrickInfo,tnode.trick_rgba2),  3  },
	{ "ObjTexBias",		TOK_F32(TrickInfo,tex_bias,0)	},
	{ "CameraFaceTightenUp",TOK_F32(TrickInfo,tighten_up,0)   },

	{ "StAnim",			TOK_STRUCT(TrickInfo,stAnim,parse_st_anim) },

	{ "AutoLOD",		TOK_STRUCT(TrickInfo,auto_lod,parse_auto_lod) },

	{ "End",			TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo parse_trick_list[] = {
	{ "Texture",		TOK_STRUCT(TrickList,texopts,parse_tex_opt) },
	{ "Trick",			TOK_STRUCT(TrickList,tricks,parse_trick) },
	{ "", 0, 0 }
};
""".}