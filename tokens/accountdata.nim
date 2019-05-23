{.emit: """
#include "AccountData.h"
/////////////////////////////////////////////////////////
// Loyalty Rewards

static ParseTable parse_AccountLoyaltyRewardNode[] =  
{
	{ "Name",					TOK_STRING(LoyaltyRewardNode, name,0)									},
	{ "DisplayName",			TOK_STRING(LoyaltyRewardNode, displayName,0)							},
	{ "DisplayDescription",		TOK_STRING(LoyaltyRewardNode, displayDescription,0)						},
	{ "Product",				TOK_STRINGARRAY(LoyaltyRewardNode, storeProduct)						},
	{ "Repeatable",				TOK_BOOL(LoyaltyRewardNode, repeat, 1)									},
	{ "Purchasable",			TOK_BOOL(LoyaltyRewardNode, purchasable, 1)								},
	{ "VIPOnly",				TOK_BOOL(LoyaltyRewardNode, VIPOnly, 0)									},
	{ "End",					TOK_END																	},
	{ 0 },
};

static ParseTable parse_AccountLoyaltyRewardTier[] =  
{
	{ "Name",					TOK_STRING(LoyaltyRewardTier, name,0)									},
	{ "DisplayName",			TOK_STRING(LoyaltyRewardTier, displayName,0)							},
	{ "DisplayDescription",		TOK_STRING(LoyaltyRewardTier, displayDescription,0)						},
	{ "NextTier",				TOK_STRING(LoyaltyRewardTier, nextTier,0)								},
	{ "NodesRequiredForNext",	TOK_INT(LoyaltyRewardTier, nodesRequiredToUnlockNextTier, 0)			},
	{ "Node",					TOK_STRUCT(LoyaltyRewardTier, nodeList, parse_AccountLoyaltyRewardNode)	},
	{ "End",					TOK_END																	},
	{ 0 },
};

static ParseTable parse_AccountLoyaltyRewardLevel[] =  
{
	{ "Name",					TOK_STRING(LoyaltyRewardLevel, name,0)									},
	{ "DisplayName",			TOK_STRING(LoyaltyRewardLevel, displayName,0)							},
	{ "DisplayVIP",				TOK_STRING(LoyaltyRewardLevel, displayVIP,0)							},
	{ "DisplayFree",			TOK_STRING(LoyaltyRewardLevel, displayFree, 0)							},
	{ "Product",				TOK_STRINGARRAY(LoyaltyRewardLevel, storeProduct)						},
	{ "LoyaltyPointsRequired",	TOK_INT(LoyaltyRewardLevel, earnedPointsRequired, 0)					},
	{ "InfluenceCap",			TOK_INT64(LoyaltyRewardLevel, influenceCap, 0)							},
	{ "End",					TOK_END																	},
	{ 0 },
};

static ParseTable parse_AccountLoyaltyRewardNodeName[] = {
	{ "",	TOK_STRUCTPARAM | TOK_NO_TRANSLATE | TOK_STRING(LoyaltyRewardNodeName, name, 0)				},
	{ "",	TOK_STRUCTPARAM | TOK_INT(LoyaltyRewardNodeName, index, 0)									},
	{ "\n",	TOK_END,	0 },
	{ "", 0, 0 }
};

static ParseTable parse_AccountLoyaltyRewardTree[] =  
{
	{ "Tier",					TOK_STRUCT(LoyaltyRewardTree, tiers, parse_AccountLoyaltyRewardTier)		},
	{ "Level",					TOK_STRUCT(LoyaltyRewardTree, levels, parse_AccountLoyaltyRewardLevel)		},
	{ "NodeNames",				TOK_STRUCT(LoyaltyRewardTree, names, parse_AccountLoyaltyRewardNodeName)	},
	{ "DefaultInfluenceCap",	TOK_INT64(LoyaltyRewardTree, defaultInfluenceCap, 0)						},
	{ "VIPInfluenceCap",		TOK_INT64(LoyaltyRewardTree, VIPInfluenceCap, 0)							},
	{ "End",					TOK_END																		},
	{ 0 },
};
""".}