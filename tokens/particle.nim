{.emit: """
#include "particle.h"

typedef struct ParticleInfoList {
	ParticleSystemInfo** list;
} ParticleInfoList;
// SystemInfo ############################################################

StaticDefineInt	ParticleFlags[] =
{
	DEFINE_INT
	{ "AlwaysDraw",				PART_ALWAYS_DRAW },
	{ "FadeImmediatelyOnDeath", PART_FADE_IMMEDIATELY_ON_DEATH },
	{ "Ribbon",					PART_RIBBON },
	{ "IgnoreFxTint",			PART_IGNORE_FX_TINT },
	DEFINE_END
};

StaticDefineInt	ParseParticleBlendMode[] =
{
	DEFINE_INT
	{ "Normal",				PARTICLE_NORMAL},
	{ "Additive",			PARTICLE_ADDITIVE},
	{ "Subtractive",		PARTICLE_SUBTRACTIVE},
	{ "PremultipliedAlpha",	PARTICLE_PREMULTIPLIED_ALPHA},
	{ "Multiply",			PARTICLE_MULTIPLY},
	{ "SubtractiveInverse",	PARTICLE_SUBTRACTIVE_INVERSE},
	DEFINE_END
};


TokenizerParseInfo SystemParseInfo[] = 
{
	{ "System",					TOK_IGNORE,	0	}, // hack, so we can use the old list system for a bit..
	{ "Name",					TOK_CURRENTFILE(ParticleSystemInfo,name)			},

	{ "FrontOrLocalFacing",		TOK_INT(ParticleSystemInfo,frontorlocalfacing,0)		},
	{ "WorldOrLocalPosition",	TOK_INT(ParticleSystemInfo,worldorlocalposition,0)	},

	{ "TimeToFull",				TOK_F32(ParticleSystemInfo,timetofull,			PART_DEFAULT_TIMETOFULL)	},
	{ "KickStart",				TOK_INT(ParticleSystemInfo,kickstart,0)				},

	{ "NewPerFrame",			TOK_F32ARRAY(ParticleSystemInfo,new_per_frame)		},
	{ "Burst",					TOK_INTARRAY(ParticleSystemInfo,burst)				},
	{ "BurbleAmplitude",		TOK_F32ARRAY(ParticleSystemInfo,burbleamplitude)	},
	{ "BurbleType",				TOK_INT(ParticleSystemInfo,burbletype,0)				},
	{ "BurbleFrequency",		TOK_F32(ParticleSystemInfo,burblefrequency,0)		},
	{ "BurbleThreshold",		TOK_F32(ParticleSystemInfo,burblethreshold,0)		},
	{ "MoveScale",				TOK_F32(ParticleSystemInfo,movescale,0)				},

	{ "EmissionType",			TOK_INT(ParticleSystemInfo,emission_type,0)			},
	{ "EmissionStartJitter",	TOK_F32ARRAY(ParticleSystemInfo,emission_start_jitter)	},
	{ "EmissionRadius",			TOK_F32(ParticleSystemInfo,emission_radius,0)		},
	{ "EmissionHeight",			TOK_F32(ParticleSystemInfo,emission_height,0)		},
	{ "EmissionLifeSpan",		TOK_F32(ParticleSystemInfo,emission_life_span,0)		},
	{ "EmissionLifeSpanJitter",	TOK_F32(ParticleSystemInfo,emission_life_span_jitter,0)		},

	{ "Spin",					TOK_INT(ParticleSystemInfo,spin,0)					},
	{ "SpinJitter",				TOK_INT(ParticleSystemInfo,spin_jitter,0)			},
	{ "OrientationJitter",		TOK_INT(ParticleSystemInfo,orientation_jitter,0)		},

	{ "Magnetism",				TOK_F32(ParticleSystemInfo,magnetism,0)				},
	{ "Gravity",				TOK_F32(ParticleSystemInfo,gravity,0)				},
	{ "KillOnZero",				TOK_INT(ParticleSystemInfo,kill_on_zero,0)			},
	{ "Terrain",				TOK_INT(ParticleSystemInfo,terrain,0)				},

	{ "InitialVelocity",		TOK_F32ARRAY(ParticleSystemInfo,initial_velocity)		},
	{ "InitialVelocityJitter",	TOK_F32ARRAY(ParticleSystemInfo,initial_velocity_jitter)},
	{ "VelocityJitter",			TOK_VEC3(ParticleSystemInfo,velocity_jitter)		},
	{ "TightenUp",				TOK_F32(ParticleSystemInfo,tighten_up,0)				},
	{ "SortBias",				TOK_F32(ParticleSystemInfo,sortBias,0)				},
	{ "Drag",					TOK_F32(ParticleSystemInfo,drag,0)					},
	{ "Stickiness",				TOK_F32(ParticleSystemInfo,stickiness,0)				},

	{ "ColorOffset",			TOK_VEC3(ParticleSystemInfo,colorOffset)			},
	{ "ColorOffsetJitter",		TOK_VEC3(ParticleSystemInfo,colorOffsetJitter)		},

	{ "Alpha",					TOK_INTARRAY(ParticleSystemInfo,alpha)				},
	{ "ColorChangeType",		TOK_INT(ParticleSystemInfo,colorchangetype,0)		},

	{ "StartColor",				TOK_RGB(ParticleSystemInfo,colornavpoint[0].rgb)	},
	{ "BeColor1",				TOK_RGB(ParticleSystemInfo,colornavpoint[1].rgb)	},
	{ "BeColor2",				TOK_RGB(ParticleSystemInfo,colornavpoint[2].rgb)	},
	{ "BeColor3",				TOK_RGB(ParticleSystemInfo,colornavpoint[3].rgb)	},
	{ "BeColor4",				TOK_RGB(ParticleSystemInfo,colornavpoint[4].rgb)	},

	{ "ByTime1",				TOK_INT(ParticleSystemInfo,colornavpoint[1].time,0)	},
	{ "ByTime2",				TOK_INT(ParticleSystemInfo,colornavpoint[2].time,0)	},
	{ "ByTime3",				TOK_INT(ParticleSystemInfo,colornavpoint[3].time,0)	},
	{ "ByTime4",				TOK_INT(ParticleSystemInfo,colornavpoint[4].time,0)	},

	{ "PrimaryTint",			TOK_F32(ParticleSystemInfo,colornavpoint[0].primaryTint,0)	},
	{ "PrimaryTint1",			TOK_F32(ParticleSystemInfo,colornavpoint[1].primaryTint,0)	},
	{ "PrimaryTint2",			TOK_F32(ParticleSystemInfo,colornavpoint[2].primaryTint,0)	},
	{ "PrimaryTint3",			TOK_F32(ParticleSystemInfo,colornavpoint[3].primaryTint,0)	},
	{ "PrimaryTint4",			TOK_F32(ParticleSystemInfo,colornavpoint[4].primaryTint,0)	},

	{ "SecondaryTint",			TOK_F32(ParticleSystemInfo,colornavpoint[0].secondaryTint,0)	},
	{ "SecondaryTint1",			TOK_F32(ParticleSystemInfo,colornavpoint[1].secondaryTint,0)	},
	{ "SecondaryTint2",			TOK_F32(ParticleSystemInfo,colornavpoint[2].secondaryTint,0)	},
	{ "SecondaryTint3",			TOK_F32(ParticleSystemInfo,colornavpoint[3].secondaryTint,0)	},
	{ "SecondaryTint4",			TOK_F32(ParticleSystemInfo,colornavpoint[4].secondaryTint,0)	},

	{ "Rgb0",					TOK_RGB(ParticleSystemInfo,colornavpoint[0].rgb)	},
	{ "Rgb1",					TOK_RGB(ParticleSystemInfo,colornavpoint[1].rgb)	},
	{ "Rgb2",					TOK_RGB(ParticleSystemInfo,colornavpoint[2].rgb)	},
	{ "Rgb3",					TOK_RGB(ParticleSystemInfo,colornavpoint[3].rgb)	},
	{ "Rgb4",					TOK_RGB(ParticleSystemInfo,colornavpoint[4].rgb)	},
	{ "Rgb0Time",				TOK_INT(ParticleSystemInfo,colornavpoint[1].time,0)	},
	{ "Rgb1Time",				TOK_INT(ParticleSystemInfo,colornavpoint[2].time,0)	},
	{ "Rgb2Time",				TOK_INT(ParticleSystemInfo,colornavpoint[3].time,0)	},
	{ "Rgb3Time",				TOK_INT(ParticleSystemInfo,colornavpoint[4].time,0)	},
	{ "Rgb4Time",				TOK_INT(ParticleSystemInfo,colornavpoint[0].time,0)	}, //junk

	{ "FadeInBy",				TOK_F32(ParticleSystemInfo,fade_in_by,0)				},
	{ "FadeOutStart",			TOK_F32(ParticleSystemInfo,fade_out_start,0)			},
	{ "FadeOutBy",    			TOK_F32(ParticleSystemInfo,fade_out_by,0)			},

	{ "DieLikeThis",			TOK_FIXEDSTR(ParticleSystemInfo,dielikethis)		},
	{ "DeathAgeToZero",			TOK_U8(ParticleSystemInfo,deathagetozero,0)			},

	{ "StartSize",				TOK_F32ARRAY(ParticleSystemInfo,startsize)			},
	{ "StartSizeJitter",		TOK_F32(ParticleSystemInfo,startsizejitter,0)		},
	{ "Blend_mode",				TOK_INT(ParticleSystemInfo,blend_mode, 0), ParseParticleBlendMode	},

	{ "TextureName",			TOK_FIXEDSTR(ParticleSystemInfo,parttex[0].texturename)	},
	{ "TextureName2",			TOK_FIXEDSTR(ParticleSystemInfo,parttex[1].texturename)	},
	{ "TexScroll1",  			TOK_VEC3(ParticleSystemInfo,parttex[0].texscroll)	},
	{ "TexScroll2",  			TOK_VEC3(ParticleSystemInfo,parttex[1].texscroll)	},

	{ "TexScrollJitter1",		TOK_VEC3(ParticleSystemInfo,parttex[0].texscrolljitter)},
	{ "TexScrollJitter2",		TOK_VEC3(ParticleSystemInfo,parttex[1].texscrolljitter)},
	{ "AnimFrames1",			TOK_F32(ParticleSystemInfo,parttex[0].animframes,0)	},
	{ "AnimFrames2",			TOK_F32(ParticleSystemInfo,parttex[1].animframes,0)	},

	{ "AnimPace1",				TOK_F32(ParticleSystemInfo,parttex[0].animpace,0)	},
	{ "AnimPace2",				TOK_F32(ParticleSystemInfo,parttex[1].animpace,0)	},
	{ "AnimType1",				TOK_INT(ParticleSystemInfo,parttex[0].animtype,0)	},
	{ "AnimType2",				TOK_INT(ParticleSystemInfo,parttex[1].animtype,0)	},

	{ "EndSize",				TOK_F32ARRAY(ParticleSystemInfo,endsize)			},
	{ "ExpandRate",				TOK_F32(ParticleSystemInfo,expandrate,0)				},
	{ "ExpandType",				TOK_INT(ParticleSystemInfo,expandtype,0)				},

	{ "StreakType",				TOK_INT(ParticleSystemInfo,streaktype,0)				},
	{ "StreakScale",			TOK_F32(ParticleSystemInfo,streakscale,0)			},
	{ "StreakOrient",			TOK_INT(ParticleSystemInfo,streakorient,0)			},
	{ "StreakDirection",		TOK_INT(ParticleSystemInfo,streakdirection,0)		},

	{ "VisRadius",				TOK_F32(ParticleSystemInfo,visradius,0)				},
	{ "VisDist",				TOK_F32(ParticleSystemInfo,visdist,0)				},

	{ "Flags",					TOK_FLAGS(ParticleSystemInfo, flags,	0),	ParticleFlags},

	{ "End",					TOK_END,	0													},
	{ "", 0, 0 }
};

TokenizerParseInfo ParticleParseInfo[] =
{
	{ "System",					TOK_STRUCT(ParticleInfoList,list,SystemParseInfo) },
	{ "", 0, 0 }
};
""".}