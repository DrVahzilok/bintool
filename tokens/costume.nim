{.emit: """
#include "costume.h"
// Costume list for NPCs and villains
typedef struct{
	Costume** costumes;
} CostumeList;
CostumeList costumeList;
Costume** costumes = NULL;


TokenizerParseInfo ParseCostumePart[] =
{
	{	"Name",			TOK_STRUCTPARAM|TOK_POOL_STRING|TOK_STRING(CostumePart, pchName, 0)		},
	{	"SourceFile",	TOK_CURRENTFILE(CostumePart,sourceFile)									},

	{	"Fx",			TOK_POOL_STRING|TOK_STRING(CostumePart, pchFxName, 0 )					},
	{	"FxName",		TOK_POOL_STRING|TOK_REDUNDANTNAME|TOK_STRING(CostumePart, pchFxName, 0)	},
	{	"Geometry",		TOK_POOL_STRING|TOK_STRING(CostumePart, pchGeom, 0)						},
	{	"Texture1",		TOK_POOL_STRING|TOK_STRING(CostumePart, pchTex1, 0)						},
	{	"Texture2",		TOK_POOL_STRING|TOK_STRING(CostumePart, pchTex2, 0)						},

	{	"DisplayName",	TOK_POOL_STRING|TOK_STRING(CostumePart, displayName,0)					},
	{	"RegionName",	TOK_POOL_STRING|TOK_STRING(CostumePart, regionName,0 )					},
	{	"BodySetName",	TOK_POOL_STRING|TOK_STRING(CostumePart, bodySetName,0)					},

	{	"CostumeNum",	TOK_INT(CostumePart,costumeNum, 0)										},
	{	"Color1",		TOK_RGB(CostumePart, color[0].rgb)										},
	{	"Color2",		TOK_RGB(CostumePart, color[1].rgb)										},
	{	"Color3",		TOK_RGB(CostumePart, color[2].rgb)										},
	{	"Color4",		TOK_RGB(CostumePart, color[3].rgb)										},

	{	"{",			TOK_START																},
	{	"}",			TOK_END																	},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseCostumePartDiff[] = 
{
	{	"PartIndex",	TOK_INT(CostumePartDiff, index, 0)										},
	{	"CostumePart",	TOK_OPTIONALSTRUCT(CostumePartDiff, part, ParseCostumePart)				},
	{	"{",			TOK_START																},
	{	"}",			TOK_END																	},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseCostume[] =
{
	{	"EntTypeFile",			TOK_POOL_STRING|TOK_STRING(Costume, appearance.entTypeFile, 0)			},
	{	"CostumeFilePrefix",	TOK_POOL_STRING|TOK_STRING(Costume, appearance.costumeFilePrefix, 0)	},

	{	"Scale",				TOK_F32(Costume, appearance.fScale, 0)									},
	{	"BoneScale",			TOK_F32(Costume, appearance.fBoneScale, 0)								},
	{	"HeadScale",			TOK_F32(Costume, appearance.fHeadScale, 0)								},
	{	"ShoulderScale",		TOK_F32(Costume, appearance.fShoulderScale, 0)							},
	{	"ChestScale",			TOK_F32(Costume, appearance.fChestScale, 0)								},
	{	"WaistScale",			TOK_F32(Costume, appearance.fWaistScale, 0)								},
	{	"HipScale",				TOK_F32(Costume, appearance.fHipScale, 0)								},
	{	"LegScale",				TOK_F32(Costume, appearance.fLegScale, 0)								},
	{	"ArmScale",				TOK_F32(Costume, appearance.fArmScale, 0)								},

	{	"HeadScales",			TOK_VEC3(Costume, appearance.fHeadScales)								},
	{	"BrowScales",			TOK_VEC3(Costume, appearance.fBrowScales)								},
	{	"CheekScales",			TOK_VEC3(Costume, appearance.fCheekScales)								},
	{	"ChinScales",			TOK_VEC3(Costume, appearance.fChinScales)								},
	{	"CraniumScales",		TOK_VEC3(Costume, appearance.fCraniumScales)							},
	{	"JawScales",			TOK_VEC3(Costume, appearance.fJawScales)								},
	{	"NoseScales",			TOK_VEC3(Costume, appearance.fNoseScales)								},

	{	"SkinColor",			TOK_RGB(Costume, appearance.colorSkin.rgb)								},
	{	"NumParts",				TOK_INT(Costume, appearance.iNumParts, 0)								},
	{	"BodyType",				TOK_INT(Costume, appearance.bodytype, 0)								},
	{	"CostumePart",			TOK_STRUCT(Costume, parts, ParseCostumePart)							},
	{	"{",					TOK_START																},
	{	"}",					TOK_END																	},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseCostumeDiff[] =
{
	{	"EntTypeFile",			TOK_POOL_STRING|TOK_STRING(CostumeDiff, appearance.entTypeFile, 0)			},
	{	"CostumeFilePrefix",	TOK_POOL_STRING|TOK_STRING(CostumeDiff, appearance.costumeFilePrefix, 0)	},

	{	"Scale",				TOK_F32(CostumeDiff, appearance.fScale, 0)									},
	{	"BoneScale",			TOK_F32(CostumeDiff, appearance.fBoneScale, 0)								},
	{	"HeadScale",			TOK_F32(CostumeDiff, appearance.fHeadScale, 0)								},
	{	"ShoulderScale",		TOK_F32(CostumeDiff, appearance.fShoulderScale, 0)							},
	{	"ChestScale",			TOK_F32(CostumeDiff, appearance.fChestScale, 0)								},
	{	"WaistScale",			TOK_F32(CostumeDiff, appearance.fWaistScale, 0)								},
	{	"HipScale",				TOK_F32(CostumeDiff, appearance.fHipScale, 0)								},
	{	"LegScale",				TOK_F32(CostumeDiff, appearance.fLegScale, 0)								},
	{	"ArmScale",				TOK_F32(CostumeDiff, appearance.fArmScale, 0)								},

	{	"HeadScales",			TOK_VEC3(CostumeDiff, appearance.fHeadScales)								},
	{	"BrowScales",			TOK_VEC3(CostumeDiff, appearance.fBrowScales)								},
	{	"CheekScales",			TOK_VEC3(CostumeDiff, appearance.fCheekScales)								},
	{	"ChinScales",			TOK_VEC3(CostumeDiff, appearance.fChinScales)								},
	{	"CraniumScales",		TOK_VEC3(CostumeDiff, appearance.fCraniumScales)							},
	{	"JawScales",			TOK_VEC3(CostumeDiff, appearance.fJawScales)								},
	{	"NoseScales",			TOK_VEC3(CostumeDiff, appearance.fNoseScales)								},

	{	"SkinColor",			TOK_RGB(CostumeDiff, appearance.colorSkin.rgb)								},
	{	"NumParts",				TOK_INT(CostumeDiff, appearance.iNumParts, 0)								},
	{	"BodyType",				TOK_INT(CostumeDiff, appearance.bodytype, 0)								},
	{	"BaseCostumeNum",		TOK_INT(CostumeDiff, costumeBaseNum, 0)										},
	{	"DiffCostumePart",		TOK_STRUCT(CostumeDiff, differentParts, ParseCostumePartDiff)					},
	{	"{",					TOK_START																},
	{	"}",					TOK_END																	},
	{	"", 0, 0 }
};

#include "npc.h"
//---------------------------------------------------------------------------------------------------------------
// NPC definition parsing
//---------------------------------------------------------------------------------------------------------------

TokenizerParseInfo ParseNPCDef[] =
{
	{	"Name",			TOK_STRUCTPARAM | TOK_STRING(NPCDef, name, 0)},
	{	"DisplayName",	TOK_STRING(NPCDef, displayName, 0)},

	{	"Class",		TOK_IGNORE	}, //TODO remove from data
	{	"Level",		TOK_IGNORE	},
	{	"Rank",			TOK_IGNORE	},
	{	"XP",			TOK_IGNORE	},

	{	"Costume",		TOK_STRUCT(NPCDef, costumes, ParseCostume) },
	{	"{",			TOK_START,		0 },
	{	"}",			TOK_END,			0 },
	{	"FileName",		TOK_CURRENTFILE(NPCDef, fileName)},
	{	"", 0, 0 }
};

TokenizerParseInfo ParseNPCDefBegin[] =
{
	{	"NPC",		TOK_STRUCT(NPCDefList, npcDefs, ParseNPCDef) },
	{	"", 0, 0 }
};
""".}