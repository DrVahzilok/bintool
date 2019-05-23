{.emit: """
#include "AccountCatalog.h"
typedef struct AccountCatalogList
{
	const AccountProduct** catalog;
	cStashTable skuIdIndex;
	cStashTable recipeIndex;
} AccountCatalogList;

// These names must match the authbit names. The fulfillment code sets the
// authbit by name.
static StaticDefineInt parse_ProductAuthBitEnum[] =
{
	DEFINE_INT
	{	"RogueAccess",		PRODUCT_AUTHBIT_ROGUE_ACCESS },
	{	"RogueCompleteBox",	PRODUCT_AUTHBIT_ROGUE_COMPLETE },
	DEFINE_END
};

static StaticDefineInt parse_InventoryTypeEnum[] =
{
	DEFINE_INT
	{	"Certification",			kAccountInventoryType_Certification },
	{	"Voucher",					kAccountInventoryType_Voucher },
	{	"PlayerInventory",			kAccountInventoryType_PlayerInventory },
	DEFINE_END
};

StaticDefineInt parse_AccountProductFlags[] =
{
	DEFINE_INT
	{"Unpublished",	PRODFLAG_NOT_PUBLISHED	},
	{"FreeForVIP",	PRODFLAG_FREE_FOR_VIP	},
	DEFINE_END
};

static ParseTable parse_ProductCatalogItem[] =
{
	{ "Title",				TOK_STRING(AccountProduct, title, 0), 0 },
	{ "SKU",				TOK_FIXEDCHAR(AccountProduct, sku_id.c), 0 },
	{ "InventoryType",		TOK_INT(AccountProduct, invType, kAccountInventoryType_Count), parse_InventoryTypeEnum },
	{ "ProductFlags",		TOK_FLAGS(AccountProduct,productFlags,0), parse_AccountProductFlags		},
	{ "InventoryCount",		TOK_INT(AccountProduct, invCount, 0), 0 },
	{ "GrantLimit",			TOK_INT(AccountProduct, grantLimit, 0), 0 },
	{ "InventoryMax",		TOK_REDUNDANTNAME | TOK_INT(AccountProduct, grantLimit, 0), 0 }, // deprecated name
	{ "ExpirationSecs",		TOK_INT(AccountProduct, expirationSecs, 0), 0 },
	{ "Global",				TOK_BOOL(AccountProduct, isGlobal, 0), 0 },
	{ "AuthBit",			TOK_INT(AccountProduct, authBit, PRODUCT_AUTHBIT_INVALID), parse_ProductAuthBitEnum },
	{ "Recipe",				TOK_STRING(AccountProduct, recipe, 0), 0 },
	{ "ItemKey",			TOK_REDUNDANTNAME | TOK_STRING(AccountProduct, recipe, 0), 0 }, // deprecated name
	{ "StartDate",			TOK_INT(AccountProduct, productStartDt, 0), 0 },
	{ "EndDate",			TOK_INT(AccountProduct, productEndDt, 0), 0 },
	{ "End",				TOK_END, 0 },
	{ "",					0, 0 }
};

static ParseTable parse_ProductCatalog[] =
{
	{ "CatalogItem",	TOK_STRUCT(AccountCatalogList, catalog, parse_ProductCatalogItem), 0 },
	{ "",				0, 0 }
};
""".}