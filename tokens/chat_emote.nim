{.emit: """
typedef struct EmoteAnim
{
	const char *pchDisplayName;
	const int *piModeBits;
	const char *pchRequiredToken;
	const char *pchRequiredBadge;
	const char **pchRequires;
	const char *pchPowerReward;
	const char **pchPowerRequires;
    const char *pchStoreProduct;
	int bDevOnly;
} EmoteAnim;

extern StaticDefine ParsePowerDefines[]; // defined in load_def.c

TokenizerParseInfo ParseEmoteAnim[] =
{
	{ "DisplayName",		TOK_STRUCTPARAM|TOK_STRING(EmoteAnim, pchDisplayName, 0) },
	{ "ModeBits",			TOK_STRUCTPARAM|TOK_INTARRAY(EmoteAnim, piModeBits), ParsePowerDefines },
	{ "{",					TOK_START,                        0},
	{ "RequiredToken",		TOK_STRING(EmoteAnim, pchRequiredToken,0), ParsePowerDefines },
	{ "RequiredBadge",		TOK_STRING(EmoteAnim, pchRequiredBadge,0), ParsePowerDefines },
	{ "Requires",			TOK_STRINGARRAY(EmoteAnim, pchRequires) },
	{ "PowerReward",		TOK_STRING(EmoteAnim, pchPowerReward, 0) },
	{ "PowerRequires",		TOK_STRINGARRAY(EmoteAnim, pchPowerRequires) },
	{ "StoreProduct",		TOK_STRING(EmoteAnim, pchStoreProduct, 0) },
	{ "DevOnly",			TOK_INT(EmoteAnim,bDevOnly,0) },
	{ "}",					TOK_END,      0 },
	{ 0 }
};
TokenizerParseInfo ParseDevEmoteAnim[] =
{
	{ "DisplayName",  TOK_STRUCTPARAM|TOK_STRING(EmoteAnim,pchDisplayName,0) },
	{ "ModeBits",     TOK_STRUCTPARAM|TOK_INTARRAY(EmoteAnim, piModeBits), ParsePowerDefines },
	{ "DevOnly",      TOK_INT(EmoteAnim, bDevOnly, 1) },
	{ "\n",           TOK_END,                        0 },
	{ 0 }
};

typedef struct EmoteAnims
{
	const EmoteAnim **ppAnims;
} EmoteAnims;

TokenizerParseInfo ParseEmoteAnims[] =
{
	{ "{",           TOK_START,       0 },
	{ "Emote",       TOK_STRUCT(EmoteAnims, ppAnims, ParseEmoteAnim) },
	{ "DevEmote",    TOK_REDUNDANTNAME | TOK_STRUCT(EmoteAnims, ppAnims, ParseDevEmoteAnim) }, // Dirty hack?
	{ "}",           TOK_END,         0 },
	{ 0 }
};
""".}