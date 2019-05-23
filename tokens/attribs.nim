{.emit: """
#include "attrib_description.h"
StaticDefineInt AttribTypeEnum[] =
{
	DEFINE_INT
	{ "Cur", kAttribType_Cur },
	{ "Str", kAttribType_Str },
	{ "Res", kAttribType_Res },
	{ "Max", kAttribType_Max },
	{ "Mod", kAttribType_Mod },
	{ "Special", kAttribType_Special },
	DEFINE_END
};

StaticDefineInt AttribStyleEnum[] =
{
	DEFINE_INT
	{ "None",				kAttribStyle_None },
	{ "Percent",			kAttribStyle_Percent },
	{ "Magnitude",			kAttribStyle_Magnitude },
	{ "Distance",			kAttribStyle_Distance },
	{ "PercentMinus100",	kAttribStyle_PercentMinus100 },
	{ "PerSecond",			kAttribStyle_PerSecond },
	{ "Speed",				kAttribStyle_Speed },
	{ "ResistanceDuration",	kAttribStyle_ResistanceDuration },
	{ "Multiply",			kAttribStyle_Multiply },
	{ "Integer",			kAttribStyle_Integer },
	{ "EnduranceReduction",	kAttribStyle_EnduranceReduction },
	{ "InversePercent",		kAttribStyle_InversePercent },
	DEFINE_END
};


TokenizerParseInfo ParseAttribDescription[] =
{
	{ "{",				TOK_START,    0 },
	{ "Name",			TOK_STRUCTPARAM | TOK_STRING(AttribDescription, pchName, 0),     },
	{ "DisplayName",	TOK_STRING(AttribDescription, pchDisplayName, 0), },
	{ "Tooltip",		TOK_STRING(AttribDescription, pchToolTip, 0), },
	{ "Type",			TOK_INT(AttribDescription, eType, kAttribType_Cur), AttribTypeEnum, },
	{ "Style",			TOK_INT(AttribDescription, eStyle, kAttribStyle_None), AttribStyleEnum, },
	{ "Key",			TOK_INT(AttribDescription, iKey, 0), },
	{ "Offset",			TOK_INT(AttribDescription, offAttrib, 0), },
	{ "ShowBase",		TOK_BOOL(AttribDescription, bShowBase, 0), },
	{ "}",				TOK_END,      0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseAttribCategory[] =
{
	{ "{",			TOK_START,    0 },
	{ "Name",		TOK_STRUCTPARAM | TOK_STRING(AttribCategory, pchDisplayName, 0), },
	{ "Attrib",		TOK_STRUCT(AttribCategory, ppAttrib, ParseAttribDescription),	},
	{ "}",			TOK_END,      0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseAttribCategoryList[] =
{
	{ "AttribCategory", TOK_STRUCT(AttribCategoryList, ppCategories, ParseAttribCategory), },
	{ "", 0, 0 }
};
""".}