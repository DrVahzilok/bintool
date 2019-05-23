{.emit: """
#include "auction.h"

StaticDefineInt AuctionInvItemStatusEnum [] =
{
	DEFINE_INT
	{"None",AuctionInvItemStatus_None},
	{"Stored",AuctionInvItemStatus_Stored}, 
	{"ForSale",AuctionInvItemStatus_ForSale},
	{"Sold",AuctionInvItemStatus_Sold},
	{"Bidding",AuctionInvItemStatus_Bidding},
	{"Bought",AuctionInvItemStatus_Bought},
	DEFINE_END
};


// AuctionInvItem ////////////////////////////////////////////////////////////

TokenizerParseInfo parse_AuctionInvItem[] = 
{
	{ "AucInvItem",		TOK_START,									0},
	{ "ID",				TOK_INT(AuctionInvItem,id,0),				0},
	{ "Item",			TOK_POOL_STRING|TOK_STRING(AuctionInvItem,pchIdentifier,0),	0},
	{ "Status",			TOK_INT(AuctionInvItem,auction_status,0),	AuctionInvItemStatusEnum},
	{ "StoredCount",	TOK_INT(AuctionInvItem,amtStored,0),		0},
	{ "StoredInf",		TOK_INT(AuctionInvItem,infStored,0),		0},
	{ "OtherCount",		TOK_INT(AuctionInvItem,amtOther,0),			0},
	{ "Price",			TOK_INT(AuctionInvItem,infPrice,0),			0},
	{ "MapSideIdx",		TOK_INT(AuctionInvItem,iMapSide,0),			0},
	{ "DeleteMe",		TOK_BOOL(AuctionInvItem,bDeleteMe,false),	0},
	{ "MergedBid",		TOK_BOOL(AuctionInvItem,bMergedBid,false),	0},
	{ "CancelledCount",	TOK_INT(AuctionInvItem,amtCancelled,0),		0},
	{ "End",			TOK_END,			0},
	{ "", 0, 0 }
};

TokenizerParseInfo parse_AuctionInventory[] = 
{
	{ "InventorySize",	TOK_INT(AuctionInventory,invSize,0),						0},
	{ "Items",			TOK_STRUCT(AuctionInventory,items,parse_AuctionInvItem),	0},
	{ "End",			TOK_END,													0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseAuctionConfig[] =
{
	{ "AuctionConfig",	TOK_IGNORE, 0 },
	{ "{",				TOK_START,  0 },
	{ "SellFeePercent",	TOK_F32(AuctionConfig, fSellFeePercent, 0.0f)     },
	{ "BuyFeePercent",	TOK_F32(AuctionConfig, fBuyFeePercent, 0.0f)     },
	{ "MinFee",			TOK_INT(AuctionConfig, iMinFee, 0.0f)     },
	{ "}",				TOK_END,    0 },
	{ "", 0, 0 }
};
""".}