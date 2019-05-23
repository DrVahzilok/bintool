{.emit: """
StaticDefineInt CollectionTypeEnum[] =
{
	DEFINE_INT
	{ "kBadge",					kCollectionType_Badge				},
	{ "kMarket",				kCollectionType_Market				},
	{ "kSuperPack",				kCollectionType_SuperPack			},
	{ "kIncarnate",				kCollectionType_Incarnate			},
	{ "kSupergroup",			kCollectionType_Supergroup			},
	DEFINE_END
};

StaticDefineInt BadgeTypeEnum[] =
{
	DEFINE_INT
	{ "kNone",					kBadgeType_None           },
	{ "kInternal",				kBadgeType_Internal       },
	{ "kTourism",				kBadgeType_Tourism        },
	{ "kHistory",				kBadgeType_History        },
	{ "kAccomplishment",		kBadgeType_Accomplishment },
	{ "kAchievement",			kBadgeType_Achievement    },
	{ "kPerk",					kBadgeType_Perk           },
	{ "kGladiator",				kBadgeType_Gladiator      },
	{ "kVeteran",				kBadgeType_Veteran        },

	{ "kPVP",					kBadgeType_PVP			},
	{ "kInvention",				kBadgeType_Invention	},
	{ "kDefeat",				kBadgeType_Defeat		},
	{ "kEvent",					kBadgeType_Event		},
	{ "kFlashback",				kBadgeType_Flashback	},
	{ "kAuction",				kBadgeType_Auction		},
	{ "kDayJob",				kBadgeType_DayJob		},
	{ "kArchitect",				kBadgeType_Architect	},

	{ "kContent",				kMarketType_Content	},
	{ "kSignatureStoryArc1",	kMarketType_SignatureStoryArc1	},
	{ "kSignatureStoryArc2",	kMarketType_SignatureStoryArc2	},

	{ "kHeroesAndVillains",		kSuperPackType_HeroesAndVillains	},
	{ "kRoguesAndVigilantes",	kSuperPackType_RoguesAndVigilantes	},

	{ "kEmpyrean",				kIncarnateType_Empyrean	},
	{ "kAstral",				kIncarnateType_Astral	},

	DEFINE_END
};

TokenizerParseInfo ParseBadgeDef[] = {
	{ "{",					TOK_START,										0},
	{ "",					TOK_CURRENTFILE(BadgeDef, filename)				},
	{ "Name",				TOK_STRUCTPARAM | TOK_STRING(BadgeDef, pchName,0)				},
	{ "Index",				TOK_INT(BadgeDef, iIdx,0)						},
	{ "Collection",			TOK_INT(BadgeDef, eCollection, kCollectionType_Badge), CollectionTypeEnum	},
	{ "Category",			TOK_INT(BadgeDef, eCategory, kBadgeType_None), BadgeTypeEnum	},
	{ "SteamExport",		TOK_STRING(BadgeDef, steamExport,0)				},
	{ "DisplayHint",		TOK_STRING(BadgeDef, pchDisplayHint[0],0)		},
	{ "DisplayText",		TOK_STRING(BadgeDef, pchDisplayText[0],0)		},
	{ "DisplayTitle",		TOK_STRING(BadgeDef, pchDisplayTitle[0],0)		},
	{ "Icon",				TOK_STRING(BadgeDef, pchIcon[0],0)				},
	{ "DisplayHintVillain",	TOK_STRING(BadgeDef, pchDisplayHint[1],0)		},
	{ "DisplayTextVillain",	TOK_STRING(BadgeDef, pchDisplayText[1],0)		},
	{ "DisplayTitleVillain",	TOK_STRING(BadgeDef, pchDisplayTitle[1],0)	},
	{ "VillainIcon",		TOK_STRING(BadgeDef, pchIcon[1],0)				},
	{ "Reward",				TOK_STRINGARRAY(BadgeDef, ppchReward)			},
	{ "Visible",			TOK_STRINGARRAY(BadgeDef, ppchVisible)			},
	{ "Hinted",				TOK_STRINGARRAY(BadgeDef, ppchKnown)			},
	{ "Known",				TOK_REDUNDANTNAME|TOK_STRINGARRAY(BadgeDef, ppchKnown)			},
	{ "Requires",			TOK_STRINGARRAY(BadgeDef, ppchRequires)			},
	{ "Meter",				TOK_STRINGARRAY(BadgeDef, ppchMeter)			},
	{ "Revoke",				TOK_STRINGARRAY(BadgeDef, ppchRevoke)			},
	{ "DisplayButton",		TOK_STRING(BadgeDef, pchDisplayButton,0)		},
	{ "ButtonReward",		TOK_STRINGARRAY(BadgeDef, ppchButtonReward)		},
	{ "DoNotCount",			TOK_BOOL(BadgeDef, bDoNotCount, false)			},
	{ "DisplayPopup",		TOK_STRING(BadgeDef, pchDisplayPopup, 0)		},
	{ "AwardText",			TOK_STRING(BadgeDef, pchAwardText, 0)			},
	{ "AwardTextColor",		TOK_RGBA(BadgeDef, rgbaAwardText)				},
	{ "Contacts",			TOK_STRINGARRAY(BadgeDef, ppchContacts)			},
	{ "BadgeValues",		TOK_INT(BadgeDef, iProgressMaxValue, 0)			},
	{ "}",					TOK_END,										0},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseBadgeDefs[] = {
	{ "Badge",	TOK_STRUCT(BadgeDefs, ppBadges, ParseBadgeDef) },
	{ "", 0, 0 }
};
""".}