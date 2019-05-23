{.emit: """
#include "powers.h"
#include "costume_data.h"
#include "attribmod.h"

DefineContext *g_pParsePowerDefines = NULL;
STATIC_DEFINE_WRAPPER(ParsePowerDefines, g_pParsePowerDefines);

StaticDefineInt ModTypeEnum[] =
{
	DEFINE_INT
	{ "kDuration",           kModType_Duration        },
	{ "kMagnitude",          kModType_Magnitude       },
	{ "kConstant",           kModType_Constant        },
	{ "kExpression",         kModType_Expression      },
	{ "kSkillMagnitude",     kModType_SkillMagnitude  },
	DEFINE_END
};

StaticDefineInt ModApplicationEnum[] =
{
	DEFINE_INT
	{ "kOnTick",				kModApplicationType_OnTick			},
	{ "kOnActivate",			kModApplicationType_OnActivate		},
	{ "kOnDeactivate",			kModApplicationType_OnDeactivate	},
	{ "kOnExpire",				kModApplicationType_OnExpire		},
	{ "kOnEnable",				kModApplicationType_OnEnable		},
	{ "kOnDisable",				kModApplicationType_OnDisable		},
	// The following are deprecated, please use the above instead.
	{ "kOnIncarnateEquip",		kModApplicationType_OnEnable		},
	{ "kOnIncarnateUnequip",	kModApplicationType_OnDisable		},
	DEFINE_END
};

StaticDefineInt ModTargetEnum[] =
{
	DEFINE_INT
	{ "kCaster",						kModTarget_Caster						},
	{ "kCastersOwnerAndAllPets",		kModTarget_CastersOwnerAndAllPets		},
	{ "kFocus",							kModTarget_Focus						},
	{ "kFocusOwnerAndAllPets",			kModTarget_FocusOwnerAndAllPets			},
	{ "kAffected",						kModTarget_Affected						},
	{ "kAffectedsOwnerAndAllPets",		kModTarget_AffectedsOwnerAndAllPets		},
	{ "kMarker",						kModTarget_Marker						},
	// the below are deprecated, please use the above from now on...
	{ "kSelf",							kModTarget_Caster						},
	{ "kSelfsOwnerAndAllPets",			kModTarget_CastersOwnerAndAllPets		},
	{ "kTarget",						kModTarget_Affected						},
	{ "kTargetsOwnerAndAllPets",		kModTarget_AffectedsOwnerAndAllPets		},
	DEFINE_END
};

StaticDefineInt AspectEnum[] =
{
	DEFINE_INT
	// Aspects
	{ "kCurrent",            offsetof(CharacterAttribSet, pattrMod)           },
	{ "kMaximum",            offsetof(CharacterAttribSet, pattrMax)           },
	{ "kStrength",           offsetof(CharacterAttribSet, pattrStrength)      },
	{ "kResistance",         offsetof(CharacterAttribSet, pattrResistance)    },
	{ "kAbsolute",           offsetof(CharacterAttribSet, pattrAbsolute)      },
	{ "kCurrentAbsolute",    offsetof(CharacterAttribSet, pattrAbsolute)      },
	{ "kCur",                offsetof(CharacterAttribSet, pattrMod)           },
	{ "kMax",                offsetof(CharacterAttribSet, pattrMax)           },
	{ "kStr",                offsetof(CharacterAttribSet, pattrStrength)      },
	{ "kRes",                offsetof(CharacterAttribSet, pattrResistance)    },
	{ "kAbs",                offsetof(CharacterAttribSet, pattrAbsolute)      },
	{ "kCurAbs",             offsetof(CharacterAttribSet, pattrAbsolute)      },
	DEFINE_END
};

StaticDefineInt ModBoolEnum[] =
{
	DEFINE_INT
	{ "false",               0  },
	{ "kFalse",              0  },
	{ "true",                1  },
	{ "kTrue",               1  },
	DEFINE_END
};

StaticDefineInt CasterStackTypeEnum[] =
{
	DEFINE_INT
	{ "kIndividual",		kCasterStackType_Individual	},
	{ "kCollective",		kCasterStackType_Collective },
	DEFINE_END
};

StaticDefineInt StackTypeEnum[] =
{
	DEFINE_INT
	{ "kStack",				kStackType_Stack   },
	{ "kIgnore",			kStackType_Ignore  },
	{ "kExtend",			kStackType_Extend  },
	{ "kReplace",			kStackType_Replace },
	{ "kOverlap",			kStackType_Overlap },
	{ "kStackThenIgnore",	kStackType_StackThenIgnore },
	{ "kRefresh",			kStackType_Refresh },
	{ "kRefreshToCount",	kStackType_RefreshToCount },
	{ "kMaximize",			kStackType_Maximize },
	{ "kSuppress",			kStackType_Suppress },
	DEFINE_END
};

StaticDefineInt DurationEnum[] =
{
	DEFINE_INT
	{ "kInstant",            -1  },
	{ "kUntilKilled",        ATTRIBMOD_DURATION_FOREVER },
	{ "kUntilShutOff",       ATTRIBMOD_DURATION_FOREVER },
	DEFINE_END
};

StaticDefineInt PowerEventEnum[] =
{
	DEFINE_INT
	{ "Activate",             kPowerEvent_Activate        },
	{ "ActivateAttackClick",  kPowerEvent_ActivateAttackClick },
	{ "EndActivate",          kPowerEvent_EndActivate     },

	{ "Hit",                  kPowerEvent_Hit             },
	{ "HitByOther",           kPowerEvent_HitByOther      },
	{ "HitByFriend",          kPowerEvent_HitByFriend     },
	{ "HitByFoe",             kPowerEvent_HitByFoe        },
	{ "Miss",                 kPowerEvent_Miss            },
	{ "MissByOther",          kPowerEvent_MissByOther     },
	{ "MissByFriend",         kPowerEvent_MissByFriend    },
	{ "MissByFoe",            kPowerEvent_MissByFoe       },
	{ "Attacked",             kPowerEvent_Attacked        },
	{ "AttackedNoException",  kPowerEvent_AttackedNoException  },

	{ "AttackedByOther",      kPowerEvent_AttackedByOther },
	{ "AttackedByOtherClick", kPowerEvent_AttackedByOtherClick },
	{ "Helped",               kPowerEvent_Helped          },
	{ "HelpedByOther",        kPowerEvent_HelpedByOther   },

	{ "Damaged",              kPowerEvent_Damaged         },
	{ "Healed",               kPowerEvent_Healed          },

	{ "Stunned",              kPowerEvent_Stunned         },
	{ "Stun",                 kPowerEvent_Stunned         },
	{ "Immobilized",          kPowerEvent_Immobilized     },
	{ "Immobilize",           kPowerEvent_Immobilized     },
	{ "Held",                 kPowerEvent_Held            },
	{ "Sleep",                kPowerEvent_Sleep           },
	{ "Terrorized",           kPowerEvent_Terrorized      },
	{ "Terrorize",            kPowerEvent_Terrorized      },
	{ "Confused",             kPowerEvent_Confused        },
	{ "Confuse",              kPowerEvent_Confused        },
	{ "Untouchable",          kPowerEvent_Untouchable     },
	{ "Intangible",           kPowerEvent_Intangible      },
	{ "OnlyAffectsSelf",      kPowerEvent_OnlyAffectsSelf },
	{ "AnyStatus",            kPowerEvent_AnyStatus       },

	{ "Knocked",              kPowerEvent_Knocked         },

	{ "Defeated",             kPowerEvent_Defeated        },

	{ "MissionObjectClick",   kPowerEvent_MissionObjectClick },

	{ "Moved",                kPowerEvent_Moved   },

	{ "Defiant",              kPowerEvent_Defiant },

	DEFINE_END
};

StaticDefineInt SupressAlwaysEnum[] =
{
	DEFINE_INT
	{ "WhenInactive",       0  },
	{ "Always",             1  },
	DEFINE_END
};

TokenizerParseInfo ParseSuppressPair[] =
{
	{ "Event",      TOK_STRUCTPARAM|TOK_INT(SuppressPair, idxEvent, 0), PowerEventEnum  },
	{ "Seconds",    TOK_STRUCTPARAM|TOK_INT(SuppressPair, ulSeconds, 0) },
	{ "Always",     TOK_STRUCTPARAM|TOK_BOOL(SuppressPair, bAlways, 0), SupressAlwaysEnum },
	{ "\n",         TOK_END,                         0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseAttribModTemplate[] =
{
	{ "{",                   TOK_START,  0 },
	{ "Name",                TOK_STRING(AttribModTemplate, pchName, 0)                 },
	{ "DisplayAttackerHit",  TOK_STRING(AttribModTemplate, pchDisplayAttackerHit, 0)   },
	{ "DisplayVictimHit",    TOK_STRING(AttribModTemplate, pchDisplayVictimHit, 0)     },
	{ "DisplayFloat",        TOK_STRING(AttribModTemplate, pchDisplayFloat, 0)         },
	{ "DisplayAttribDefenseFloat", TOK_STRING(AttribModTemplate, pchDisplayDefenseFloat, 0)  },
	{ "ShowFloaters",        TOK_BOOL(AttribModTemplate, bShowFloaters, 1), ModBoolEnum},

	{ "Attrib",              TOK_AUTOINT(AttribModTemplate, offAttrib, 0), ParsePowerDefines },
	{ "Aspect",              TOK_AUTOINT(AttribModTemplate, offAspect, 0), AspectEnum   },
	{ "BoostIgnoreDiminishing",	TOK_BOOL(AttribModTemplate, bIgnoresBoostDiminishing, 0), ModBoolEnum},

	{ "Target",              TOK_INT(AttribModTemplate, eTarget, kModTarget_Affected), ModTargetEnum },
	{ "Table" ,              TOK_STRING(AttribModTemplate, pchTable, 0) },
	{ "Scale",               TOK_F32(AttribModTemplate, fScale, 0) },

	{ "ApplicationType",		TOK_INT(AttribModTemplate, eApplicationType, kModApplicationType_OnTick), ModApplicationEnum },
	{ "Type",					TOK_INT(AttribModTemplate, eType, kModType_Magnitude), ModTypeEnum },
	{ "Delay",					TOK_F32(AttribModTemplate, fDelay, 0)             },
	{ "Period",					TOK_F32(AttribModTemplate, fPeriod, 0)            },
	{ "Chance",					TOK_F32(AttribModTemplate, fChance, 0)            },
	{ "CancelOnMiss",			TOK_BOOL(AttribModTemplate, bCancelOnMiss, 0), ModBoolEnum },
	{ "CancelEvents",			TOK_INTARRAY(AttribModTemplate, piCancelEvents), PowerEventEnum },
	{ "NearGround",				TOK_BOOL(AttribModTemplate, bNearGround, 0), ModBoolEnum },
	{ "AllowStrength",			TOK_BOOL(AttribModTemplate, bAllowStrength, 1), ModBoolEnum },
	{ "AllowResistance",		TOK_BOOL(AttribModTemplate, bAllowResistance, 1), ModBoolEnum },
	{ "UseMagnitudeResistance",	TOK_BOOL(AttribModTemplate, bUseMagnitudeResistance, -1), ModBoolEnum },
	{ "UseDurationResistance",	TOK_BOOL(AttribModTemplate, bUseDurationResistance, -1), ModBoolEnum },
	{ "AllowCombatMods",		TOK_BOOL(AttribModTemplate, bAllowCombatMods, 1), ModBoolEnum },
	{ "UseMagnitudeCombatMods",	TOK_BOOL(AttribModTemplate, bUseMagnitudeCombatMods, -1), ModBoolEnum },
	{ "UseDurationCombatMods",	TOK_BOOL(AttribModTemplate, bUseDurationCombatMods, -1), ModBoolEnum },
	{ "BoostTemplate",			TOK_BOOL(AttribModTemplate, bBoostTemplate, 0), ModBoolEnum },
	{ "Requires",				TOK_STRINGARRAY(AttribModTemplate, ppchApplicationRequires)       },
	{ "PrimaryStringList",		TOK_STRINGARRAY(AttribModTemplate, ppchPrimaryStringList)       },
	{ "SecondaryStringList",	TOK_STRINGARRAY(AttribModTemplate, ppchSecondaryStringList)       },
	{ "CasterStackType",		TOK_INT(AttribModTemplate, eCasterStack, kCasterStackType_Individual), CasterStackTypeEnum },
	{ "StackType",				TOK_INT(AttribModTemplate, eStack, kStackType_Replace), StackTypeEnum },
	{ "StackLimit",				TOK_INT(AttribModTemplate, iStackLimit, 2)		},
	{ "StackKey",				TOK_INT(AttribModTemplate, iStackKey, -1), ParsePowerDefines		},
	{ "Duration",				TOK_F32(AttribModTemplate, fDuration, -1), DurationEnum  },
	{ "DurationExpr",			TOK_STRINGARRAY(AttribModTemplate, ppchDuration)       },
	{ "Magnitude",				TOK_F32(AttribModTemplate, fMagnitude, 0), ParsePowerDefines },
	{ "MagnitudeExpr",			TOK_STRINGARRAY(AttribModTemplate, ppchMagnitude)      },
	{ "RadiusInner",			TOK_F32(AttribModTemplate, fRadiusInner, -1) },
	{ "RadiusOuter",			TOK_F32(AttribModTemplate, fRadiusOuter, -1) },

	{ "Suppress",            TOK_STRUCT(AttribModTemplate, ppSuppress, ParseSuppressPair) },
	{ "IgnoreSuppressErrors",TOK_STRING(AttribModTemplate, pchIgnoreSuppressErrors, 0)},

	{ "ContinuingBits",      TOK_INTARRAY(AttribModTemplate, piContinuingBits), ParsePowerDefines },
	{ "ContinuingFX",        TOK_FILENAME(AttribModTemplate, pchContinuingFX, 0)    },
	{ "ConditionalBits",     TOK_INTARRAY(AttribModTemplate, piConditionalBits), ParsePowerDefines },
	{ "ConditionalFX",       TOK_FILENAME(AttribModTemplate, pchConditionalFX, 0)   },

	{ "CostumeName",         TOK_FILENAME(AttribModTemplate, pchCostumeName, 0)     },

	{ "Power",               TOK_REDUNDANTNAME|TOK_STRING(AttribModTemplate, pchReward, 0)               },
	{ "Reward",              TOK_STRING(AttribModTemplate, pchReward, 0)               },
	{ "Params",				 TOK_STRING(AttribModTemplate, pchParams, 0)				},
	{ "EntityDef",           TOK_STRING(AttribModTemplate, pchEntityDef, 0)            },
	{ "PriorityListDefense", TOK_STRING(AttribModTemplate, pchPriorityListDefense, 0)  },
	{ "PriorityListOffense", TOK_STRING(AttribModTemplate, pchPriorityListOffense, 0)  },
	{ "PriorityListPassive", TOK_STRING(AttribModTemplate, pchPriorityListPassive, 0)  },
	{ "PriorityList",        TOK_REDUNDANTNAME|TOK_STRING(AttribModTemplate, pchPriorityListPassive, 0)  },
	{ "DisplayOnlyIfNotZero",TOK_BOOL(AttribModTemplate, bDisplayTextOnlyIfNotZero, 0), ModBoolEnum},
	{ "MatchExactPower",	 TOK_BOOL(AttribModTemplate, bMatchExactPower, 0), ModBoolEnum},
	{ "VanishEntOnTimeout",  TOK_BOOL(AttribModTemplate, bVanishEntOnTimeout, 0), ModBoolEnum},
	{ "DoNotTint",			 TOK_BOOL(AttribModTemplate, bDoNotTintCostume, 0), ModBoolEnum},
	{ "KeepThroughDeath",	 TOK_BOOL(AttribModTemplate, bKeepThroughDeath, 0), ModBoolEnum},
	{ "DelayEval",			 TOK_BOOL(AttribModTemplate, bDelayEval, 0), ModBoolEnum},
	{ "BoostModAllowed",	 TOK_INT(AttribModTemplate, boostModAllowed, 0), ParsePowerDefines },
	{ "EvalFlags",			 TOK_INT(AttribModTemplate, evalFlags, 0)		},						// created automatically at bin time from Requires statements
	{ "ProcsPerMinute",		 TOK_F32(AttribModTemplate, fProcsPerMinute, 0)         },

	{ "}",                   TOK_END,      0 },
	{ "", 0, 0 }
};

StaticDefineInt AIReportEnum[] =
{
	DEFINE_INT
	{ "kAlways",             kAIReport_Always    },
	{ "kNever",              kAIReport_Never     },
	{ "kHitOnly",            kAIReport_HitOnly   },
	{ "kMissOnly",           kAIReport_MissOnly  },
	DEFINE_END
};

StaticDefineInt EffectAreaEnum[] =
{
	DEFINE_INT
	{ "kCharacter",          kEffectArea_Character  },
	{ "kChar",               kEffectArea_Character  },
	{ "kCone",               kEffectArea_Cone       },
	{ "kSphere",             kEffectArea_Sphere     },
	{ "kLocation",           kEffectArea_Location   },
	{ "kVolume",             kEffectArea_Volume     },
	{ "kNamedVolume",        kEffectArea_NamedVolume},  //Not implemented
	{ "kMap",                kEffectArea_Map        },
	{ "kRoom",               kEffectArea_Room       },
	{ "kTouch",              kEffectArea_Touch      },
	{ "kBox",                kEffectArea_Box        },
	DEFINE_END
};

StaticDefineInt TargetVisibilityEnum[] =
{
	DEFINE_INT
	{ "kLineOfSight",        kTargetVisibility_LineOfSight  },
	{ "kNone",               kTargetVisibility_None         },
	DEFINE_END
};

StaticDefineInt TargetTypeEnum[] =
{
	DEFINE_INT
	{ "kCaster",							kTargetType_Caster								},
	{ "kPlayer",							kTargetType_Player								},
	{ "kPlayerHero",						kTargetType_PlayerHero							},
	{ "kPlayerVillain",						kTargetType_PlayerVillain						},
	{ "kDeadPlayer",						kTargetType_DeadPlayer							},
	{ "kDeadPlayerFriend",					kTargetType_DeadPlayerFriend					},
	{ "kDeadPlayerFoe",						kTargetType_DeadPlayerFoe						},
	{ "kTeammate",							kTargetType_Teammate							},
	{ "kDeadTeammate",						kTargetType_DeadTeammate						},
	{ "kDeadOrAliveTeammate",				kTargetType_DeadOrAliveTeammate					},
	{ "kFriend",							kTargetType_Friend								},
	{ "kEnemy",								kTargetType_Villain								},
	{ "kVillain",							kTargetType_Villain								},
	{ "kDeadVillain",						kTargetType_DeadVillain							},
	{ "kFoe",								kTargetType_Foe									},
	{ "kNPC",								kTargetType_NPC									},
	{ "kLocation",							kTargetType_Location							},
	{ "kTeleport",							kTargetType_Teleport							},
	{ "kDeadFoe",							kTargetType_DeadFoe								},
	{ "kDeadOrAliveFoe",					kTargetType_DeadOrAliveFoe						},
	{ "kDeadFriend",						kTargetType_DeadFriend							},
	{ "kDeadOrAliveFriend",					kTargetType_DeadOrAliveFriend					},
	{ "kMyPet",								kTargetType_MyPet								},
	{ "kDeadMyPet",							kTargetType_DeadMyPet							},
	{ "kDeadOrAliveMyPet",					kTargetType_DeadOrAliveMyPet					},
	{ "kMyOwner",							kTargetType_MyOwner								},
	{ "kMyCreator",							kTargetType_MyCreator							},
	{ "kMyCreation",						kTargetType_MyCreation							},
	{ "kDeadMyCreation",					kTargetType_DeadMyCreation						},
	{ "kDeadOrAliveMyCreation",				kTargetType_DeadOrAliveMyCreation				},
	{ "kLeaguemate",						kTargetType_Leaguemate							},
	{ "kDeadLeaguemate",					kTargetType_DeadLeaguemate						},
	{ "kDeadOrAliveLeaguemate",				kTargetType_DeadOrAliveLeaguemate				},
	{ "kAny",								kTargetType_Any									},
	{ "kPosition",							kTargetType_Position							},
	{ "kNone",								0												},
	DEFINE_END
};

StaticDefineInt PowerTypeEnum[] =
{
	DEFINE_INT
	{ "kClick",			kPowerType_Click		},
	{ "kAuto",			kPowerType_Auto			},
	{ "kToggle",		kPowerType_Toggle		},
	{ "kBoost",			kPowerType_Boost		},
	{ "kInspiration",	kPowerType_Inspiration	},
	{ "kGlobalBoost",	kPowerType_GlobalBoost	},
	DEFINE_END
};

StaticDefineInt BoolEnum[] =
{
	DEFINE_INT
	{ "false",               0  },
	{ "kFalse",              0  },
	{ "true",                1  },
	{ "kTrue",               1  },
	DEFINE_END
};

StaticDefineInt ToggleDroppableEnum[] =
{
	DEFINE_INT
	{ "kSometimes", kToggleDroppable_Sometimes },
	{ "kAlways",    kToggleDroppable_Always    },
	{ "kFirst",     kToggleDroppable_First     },
	{ "kLast",      kToggleDroppable_Last      },
	{ "kNever",     kToggleDroppable_Never     },

	{ "Sometimes",  kToggleDroppable_Sometimes },
	{ "Always",     kToggleDroppable_Always    },
	{ "First",      kToggleDroppable_First     },
	{ "Last",       kToggleDroppable_Last      },
	{ "Never",      kToggleDroppable_Never     },
	DEFINE_END
};

StaticDefineInt ShowPowerSettingEnum[] =
{
	DEFINE_INT
	// Based on BoolEnum
	{ "false",		kShowPowerSetting_Never		},
	{ "kFalse",		kShowPowerSetting_Never		},
	{ "true",		kShowPowerSetting_Default	},
	{ "kTrue",		kShowPowerSetting_Default	},
	// New strings
	{ "Never",		kShowPowerSetting_Never		},
	{ "kNever",		kShowPowerSetting_Never		},
	{ "Always",		kShowPowerSetting_Always	},
	{ "kAlways",	kShowPowerSetting_Always	},
	{ "Default",	kShowPowerSetting_Default	},
	{ "kDefault",	kShowPowerSetting_Default	},
	{ "IfUsable",	kShowPowerSetting_IfUsable	},
	{ "kIfUsable",	kShowPowerSetting_IfUsable	},
	{ "IfOwned",	kShowPowerSetting_IfOwned	},
	{ "kIfOwned",	kShowPowerSetting_IfOwned	},
	DEFINE_END
};

TokenizerParseInfo ParsePowerVar[] =
{
	{ "Index",              TOK_STRUCTPARAM | TOK_INT(PowerVar, iIndex, 0),  },
	{ "Name",               TOK_STRUCTPARAM | TOK_STRING(PowerVar, pchName, 0)  },
	{ "Min",                TOK_STRUCTPARAM | TOK_F32(PowerVar, fMin, 0)     },
	{ "Max",                TOK_STRUCTPARAM | TOK_F32(PowerVar, fMax, 0)     },
	{ "\n",                 TOK_END, 0 },
	{ "", 0, 0 }
};

// These are all for the visual effects. This supports the old, goofy
// lf_gamer names as well as the new, sensible ones.
#define ParsePowerFX(type, fx) \
	{ "AttackBits",       			TOK_INTARRAY(type, fx.piAttackBits),          ParsePowerDefines }, \
	{ "BlockBits",        			TOK_INTARRAY(type, fx.piBlockBits),           ParsePowerDefines }, \
	{ "WindUpBits",       			TOK_INTARRAY(type, fx.piWindUpBits),          ParsePowerDefines }, \
	{ "HitBits",          			TOK_INTARRAY(type, fx.piHitBits),             ParsePowerDefines }, \
	{ "DeathBits",        			TOK_INTARRAY(type, fx.piDeathBits),           ParsePowerDefines }, \
	{ "ActivationBits",   			TOK_INTARRAY(type, fx.piActivationBits),      ParsePowerDefines }, \
	{ "DeactivationBits", 			TOK_INTARRAY(type, fx.piDeactivationBits),    ParsePowerDefines }, \
	{ "InitialAttackBits",			TOK_INTARRAY(type, fx.piInitialAttackBits),   ParsePowerDefines }, \
	{ "ContinuingBits",   			TOK_INTARRAY(type, fx.piContinuingBits),      ParsePowerDefines }, \
	{ "ConditionalBits",  			TOK_INTARRAY(type, fx.piConditionalBits),     ParsePowerDefines }, \
	{ "ActivationFX",     			TOK_FILENAME(type, fx.pchActivationFX, 0)       }, \
	{ "DeactivationFX",   			TOK_FILENAME(type, fx.pchDeactivationFX, 0)     }, \
	{ "AttackFX",         			TOK_FILENAME(type, fx.pchAttackFX, 0)           }, \
	{ "HitFX",            			TOK_FILENAME(type, fx.pchHitFX, 0)              }, \
	{ "WindUpFX",         			TOK_FILENAME(type, fx.pchWindUpFX, 0)           }, \
	{ "BlockFX",          			TOK_FILENAME(type, fx.pchBlockFX, 0)            }, \
	{ "DeathFX",          			TOK_FILENAME(type, fx.pchDeathFX, 0)            }, \
	{ "InitialAttackFX",  			TOK_FILENAME(type, fx.pchInitialAttackFX, 0)    }, \
	{ "ContinuingFX",     			TOK_FILENAME(type, fx.pchContinuingFX[0], 0)       }, \
	{ "ContinuingFX1",     			TOK_FILENAME(type, fx.pchContinuingFX[0], 0)       }, \
	{ "ContinuingFX2",     			TOK_FILENAME(type, fx.pchContinuingFX[1], 0)       }, \
	{ "ContinuingFX3",     			TOK_FILENAME(type, fx.pchContinuingFX[2], 0)       }, \
	{ "ContinuingFX4",     			TOK_FILENAME(type, fx.pchContinuingFX[3], 0)       }, \
	{ "ConditionalFX",     			TOK_FILENAME(type, fx.pchConditionalFX[0], 0)       }, \
	{ "ConditionalFX1",     		TOK_FILENAME(type, fx.pchConditionalFX[0], 0)       }, \
	{ "ConditionalFX2",     		TOK_FILENAME(type, fx.pchConditionalFX[1], 0)       }, \
	{ "ConditionalFX3",     		TOK_FILENAME(type, fx.pchConditionalFX[2], 0)       }, \
	{ "ConditionalFX4",     		TOK_FILENAME(type, fx.pchConditionalFX[3], 0)       }, \
	{ "ModeBits",                   TOK_INTARRAY(type, fx.piModeBits), ParsePowerDefines }, \
	{ "FramesBeforeHit",            TOK_INT(type, fx.iFramesBeforeHit, -1)   }, \
	{ "SeqBits",                    TOK_REDUNDANTNAME|TOK_INTARRAY(type, fx.piModeBits), ParsePowerDefines }, \
	{ "cast_anim",                  TOK_REDUNDANTNAME|TOK_INTARRAY(type, fx.piAttackBits), ParsePowerDefines }, \
	{ "hit_anim",                   TOK_REDUNDANTNAME|TOK_INTARRAY(type, fx.piHitBits), ParsePowerDefines }, \
	{ "deathanimbits",              TOK_REDUNDANTNAME|TOK_INTARRAY(type, fx.piDeathBits), ParsePowerDefines }, \
	{ "AttachedAnim",               TOK_REDUNDANTNAME|TOK_INTARRAY(type, fx.piActivationBits), ParsePowerDefines }, \
	{ "AttachedFxName",             TOK_REDUNDANTNAME|TOK_FILENAME(type, fx.pchActivationFX, 0)    }, \
	{ "TravellingProjectileEffect", TOK_REDUNDANTNAME|TOK_FILENAME(type, fx.pchAttackFX, 0)        }, \
	{ "AttachedToVictimFxName",     TOK_REDUNDANTNAME|TOK_FILENAME(type, fx.pchHitFX, 0)           }, \
	{ "TimeBeforePunchHits",        TOK_REDUNDANTNAME|TOK_INT(type, fx.iFramesBeforeHit,  -1)   }, \
	{ "TimeBeforeMissileSpawns",    TOK_REDUNDANTNAME|TOK_INT(type, fx.iFramesBeforeHit,  -1)   }, \
	{ "DelayedHit",                 TOK_BOOL(type, fx.bDelayedHit, 0), BoolEnum }, \
	{ "TogglePower",                TOK_IGNORE,                        0 }, \
	\
	{ "AttackFrames",               TOK_INT(type, fx.iFramesAttack, -1)      }, \
	{ "NonInterruptFrames",         TOK_REDUNDANTNAME|TOK_INT(type, fx.iFramesAttack, -1)      }, \
	\
	{ "InitialFramesBeforeHit",     TOK_INT(type, fx.iInitialFramesBeforeHit, -1)    }, \
	{ "InitialAttackFXFrameDelay",	TOK_INT(type, fx.iInitialAttackFXFrameDelay, 0)     }, \
	{ "ProjectileSpeed",            TOK_F32(type, fx.fProjectileSpeed, 0)           }, \
	{ "InitialFramesBeforeBlock",   TOK_INT(type, fx.iInitialFramesBeforeBlock, 0)  }, \
	{ "IgnoreAttackTimeErrors",     TOK_STRING(type, fx.pchIgnoreAttackTimeErrors, 0)  }, \
	{ "FramesBeforeBlock",          TOK_INT(type, fx.iFramesBeforeBlock, 0)         }, \
	{ "FXImportant",                TOK_BOOL(type, fx.bImportant,	0), BoolEnum }, \
	{ "PrimaryTint",				TOK_CONDRGB(type, fx.defaultTint.primary) }, \
	{ "SecondaryTint",				TOK_CONDRGB(type, fx.defaultTint.secondary) },

static TokenizerParseInfo ParseColor[] =
{
	{ "",			TOK_STRUCTPARAM | TOK_FIXED_ARRAY | TOK_F32_X, 0, 3 },
	{ "\n",			TOK_END												},
	{ "", 0, 0 }
};

static TokenizerParseInfo ParseColorPalette[] =
{
	{ "Color", 		TOK_STRUCT(ColorPalette, color, ParseColor)			},
	{ "Name",		TOK_POOL_STRING|TOK_STRING(ColorPalette, name, 0)	},
	{ "End",		TOK_END												},
	{ "EndPalette",	TOK_END												},
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePowerCustomFX[] =
{
	{ "Token",			TOK_STRUCTPARAM|TOK_POOL_STRING|TOK_STRING(PowerCustomFX, pchToken, 0) },
	{ "AltTheme",		TOK_STRINGARRAY(PowerCustomFX, altThemes)					},
	{ "SourceFile",		TOK_CURRENTFILE(PowerCustomFX, fx.pchSourceFile)			},
	{ "Category",		TOK_POOL_STRING|TOK_STRING(PowerCustomFX, pchCategory, 0)	},
	{ "DisplayName",	TOK_STRING(PowerCustomFX, pchDisplayName, 0)				},
	ParsePowerFX(PowerCustomFX, fx) // included flat
	{ "Palette",		TOK_POOL_STRING|TOK_STRING(PowerCustomFX, paletteName, 0)	},
	{ "End",			TOK_END														},
	{ "", 0, 0 }
};

StaticDefineInt DeathCastableSettingEnum[] =
{
	DEFINE_INT
	// old values
	{ "false",				kDeathCastableSetting_AliveOnly		},
	{ "kFalse",				kDeathCastableSetting_AliveOnly		},
	{ "true",				kDeathCastableSetting_DeadOnly		},
	{ "kTrue",				kDeathCastableSetting_DeadOnly		},
	// new values
	{ "AliveOnly",			kDeathCastableSetting_AliveOnly		},
	{ "kAliveOnly",			kDeathCastableSetting_AliveOnly		},
	{ "DeadOnly",			kDeathCastableSetting_DeadOnly		},
	{ "kDeadOnly",			kDeathCastableSetting_DeadOnly		},
	{ "DeadOrAlive",		kDeathCastableSetting_DeadOrAlive	},
	{ "kDeadOrAlive",		kDeathCastableSetting_DeadOrAlive	},
	DEFINE_END
};

StaticDefineInt PowerSystemEnum[] =
{
	DEFINE_INT
	{ "kPowers", kPowerSystem_Powers },
	{ "kPower",  kPowerSystem_Powers },
	{ "Powers",  kPowerSystem_Powers },
	{ "Power",   kPowerSystem_Powers },
	DEFINE_END
};

TokenizerParseInfo ParseBasePower[] =
{
	{ "{",                  TOK_START,    0                                         },
	{ "FullName",           TOK_STRUCTPARAM | TOK_STRING(BasePower, pchFullName, 0)},
	{ "CRCFullName",		TOK_INT(BasePower, crcFullName, 0) },	// Do NOT add this to .powers files!  Needed here because that's how shared memory works?
	{ "SourceFile",         TOK_CURRENTFILE(BasePower, pchSourceFile) },
	{ "Name",               TOK_STRING(BasePower, pchName, 0)              },
	{ "SourceName",			TOK_STRING(BasePower, pchSourceName, 0)              },
	{ "System",             TOK_INT(BasePower, eSystem, kPowerSystem_Powers), PowerSystemEnum },
	{ "AutoIssue",          TOK_BOOL(BasePower, bAutoIssue, 0), BoolEnum },
	{ "AutoIssueSaveLevel", TOK_BOOL(BasePower, bAutoIssueSaveLevel, 0), BoolEnum },
	{ "Free",               TOK_BOOL(BasePower, bFree, 0), BoolEnum },
	{ "DisplayName",        TOK_STRING(BasePower, pchDisplayName, 0)       },
	{ "DisplayHelp",        TOK_STRING(BasePower, pchDisplayHelp, 0)       },
	{ "DisplayShortHelp",   TOK_STRING(BasePower, pchDisplayShortHelp, 0)  },
	{ "DisplayCasterHelp",     TOK_REDUNDANTNAME|TOK_STRING(BasePower, pchDisplayHelp, 0)       },
	{ "DisplayCasterShortHelp",TOK_REDUNDANTNAME|TOK_STRING(BasePower, pchDisplayShortHelp, 0)  },
	{ "DisplayTargetHelp",     TOK_STRING(BasePower, pchDisplayTargetHelp, 0)       },
	{ "DisplayTargetShortHelp",TOK_STRING(BasePower, pchDisplayTargetShortHelp, 0)  },
	{ "DisplayAttackerAttack", TOK_STRING(BasePower, pchDisplayAttackerAttack, 0)   },
	{ "DisplayAttackerAttackFloater", TOK_STRING(BasePower, pchDisplayAttackerAttackFloater, 0)   },
	{ "DisplayAttackerHit", TOK_STRING(BasePower, pchDisplayAttackerHit, 0)  },
	{ "DisplayVictimHit",   TOK_STRING(BasePower, pchDisplayVictimHit, 0)    },
	{ "DisplayConfirm",     TOK_STRING(BasePower, pchDisplayConfirm, 0)      },
	{ "FloatRewarded",      TOK_STRING(BasePower, pchDisplayFloatRewarded, 0)},
	{ "DisplayPowerDefenseFloat",TOK_STRING(BasePower, pchDisplayDefenseFloat, 0)},
	{ "IconName",           TOK_STRING(BasePower, pchIconName, 0)            },
	{ "FXName",             TOK_IGNORE,   0                                           },
	{ "Type",               TOK_INT(BasePower, eType, kPowerType_Click), PowerTypeEnum },
	{ "NumAllowed",         TOK_INT(BasePower, iNumAllowed, 1)},
	{ "AttackTypes",        TOK_INTARRAY(BasePower, pAttackTypes), ParsePowerDefines },
	{ "BuyRequires",        TOK_STRINGARRAY(BasePower, ppchBuyRequires),     },
	{ "ActivateRequires",   TOK_STRINGARRAY(BasePower, ppchActivateRequires),     },
	{ "SlotRequires",		TOK_STRINGARRAY(BasePower, ppchSlotRequires)       },
	{ "TargetRequires",		TOK_STRINGARRAY(BasePower, ppchTargetRequires)	},
	{ "RewardRequires",		TOK_STRINGARRAY(BasePower, ppchRewardRequires)	},
	{ "AuctionRequires",	TOK_STRINGARRAY(BasePower, ppchAuctionRequires)	},
	{ "RewardFallback",     TOK_STRING(BasePower, pchRewardFallback, 0)            },
	{ "Accuracy",           TOK_F32(BasePower, fAccuracy, 0)            },
	{ "NearGround",         TOK_BOOL(BasePower, bNearGround, 0), BoolEnum },
	{ "TargetNearGround",   TOK_BOOL(BasePower, bTargetNearGround, -1), BoolEnum },
	{ "CastableAfterDeath", TOK_INT(BasePower, eDeathCastableSetting, kDeathCastableSetting_AliveOnly), DeathCastableSettingEnum },
	{ "CastThroughHold",    TOK_BOOL(BasePower, bCastThroughHold, 0), BoolEnum },
	{ "CastThroughSleep",   TOK_BOOL(BasePower, bCastThroughSleep, 0), BoolEnum },
	{ "CastThroughStun",    TOK_BOOL(BasePower, bCastThroughStun, )0, BoolEnum },
	{ "CastThroughTerrorize",  TOK_BOOL(BasePower, bCastThroughTerrorize,0), BoolEnum },
	{ "ToggleIgnoreHold",   TOK_BOOL(BasePower, bToggleIgnoreHold, 0), BoolEnum },
	{ "ToggleIgnoreSleep",  TOK_BOOL(BasePower, bToggleIgnoreSleep, 0), BoolEnum },
	{ "ToggleIgnoreStun",   TOK_BOOL(BasePower, bToggleIgnoreStun, 0), BoolEnum },
	{ "IgnoreLevelBought",  TOK_BOOL(BasePower, bIgnoreLevelBought, 0), BoolEnum },
	{ "ShootThroughUntouchable", TOK_BOOL(BasePower, bShootThroughUntouchable, 0), BoolEnum },
	{ "InterruptLikeSleep", TOK_BOOL(BasePower, bInterruptLikeSleep, 0), BoolEnum },
	{ "AIReport",           TOK_INT(BasePower, eAIReport, kAIReport_Always),      AIReportEnum   },
	{ "EffectArea",         TOK_INT(BasePower, eEffectArea, kEffectArea_Character), EffectAreaEnum },
	{ "MaxTargetsHit",      TOK_INT(BasePower, iMaxTargetsHit, 0)      },
	{ "Radius",             TOK_F32(BasePower, fRadius, 0)              },
	{ "Arc",                TOK_F32(BasePower, fArc, 0)                 },
	{ "BoxOffset",          TOK_VEC3(BasePower, vecBoxOffset)         },
	{ "BoxSize",            TOK_VEC3(BasePower, vecBoxSize)           },
	{ "Range",              TOK_F32(BasePower, fRange, 0)               },
	{ "RangeSecondary",     TOK_F32(BasePower, fRangeSecondary, 0)      },
	{ "TimeToActivate",     TOK_F32(BasePower, fTimeToActivate, 0)      },
	{ "RechargeTime",       TOK_F32(BasePower, fRechargeTime, 0)        },
	{ "ActivatePeriod",     TOK_F32(BasePower, fActivatePeriod, 0)      },
	{ "EnduranceCost",      TOK_F32(BasePower, fEnduranceCost, 0)       },
	{ "InsightCost",        TOK_REDUNDANTNAME|TOK_F32(BasePower, fInsightCost, 0)         },
	{ "IdeaCost",           TOK_F32(BasePower, fInsightCost, 0)         },
	{ "TimeToConfirm",      TOK_INT(BasePower, iTimeToConfirm, 0),      },
	{ "SelfConfirm",		TOK_INT(BasePower, iSelfConfirm, 0),		},
	{ "ConfirmRequires",	TOK_STRINGARRAY(BasePower, ppchConfirmRequires)	},
	{ "DestroyOnLimit",     TOK_BOOL(BasePower, bDestroyOnLimit, 1), BoolEnum },
	{ "StackingUsage",      TOK_BOOL(BasePower, bStackingUsage, 0), BoolEnum },
	{ "NumCharges",         TOK_INT(BasePower, iNumCharges, 0),         },
	{ "MaxNumCharges",      TOK_INT(BasePower, iMaxNumCharges, 0),         },
	{ "UsageTime",          TOK_F32(BasePower, fUsageTime, 0),          },
	{ "MaxUsageTime",       TOK_F32(BasePower, fMaxUsageTime, 0),          },
	{ "Lifetime",           TOK_F32(BasePower, fLifetime, 0),           },
	{ "MaxLifetime",        TOK_F32(BasePower, fMaxLifetime, 0),           },
	{ "LifetimeInGame",     TOK_F32(BasePower, fLifetimeInGame, 0),     },
	{ "MaxLifetimeInGame",  TOK_F32(BasePower, fMaxLifetimeInGame, 0),     },
	{ "InterruptTime",      TOK_F32(BasePower, fInterruptTime, 0)       },
	{ "TargetVisibility",   TOK_INT(BasePower, eTargetVisibility, kTargetVisibility_LineOfSight), TargetVisibilityEnum },
	{ "Target",             TOK_INT(BasePower, eTargetType, kTargetType_None), TargetTypeEnum },
	{ "TargetSecondary",    TOK_INT(BasePower, eTargetTypeSecondary, kTargetType_None), TargetTypeEnum },
	{ "EntsAutoHit",        TOK_INTARRAY(BasePower, pAutoHit), TargetTypeEnum },
	{ "EntsAffected",       TOK_INTARRAY(BasePower, pAffected), TargetTypeEnum },
	{ "TargetsThroughVisionPhase",	TOK_BOOL(BasePower, bTargetsThroughVisionPhase, 0), BoolEnum },
	{ "BoostsAllowed",      TOK_INTARRAY(BasePower, pBoostsAllowed), ParsePowerDefines },
	{ "GroupMembership",    TOK_INTARRAY(BasePower, pGroupMembership), ParsePowerDefines },
	{ "ModesRequired",      TOK_INTARRAY(BasePower, pModesRequired), ParsePowerDefines },
	{ "ModesDisallowed",    TOK_INTARRAY(BasePower, pModesDisallowed), ParsePowerDefines },
	{ "AIGroups",           TOK_STRINGARRAY(BasePower, ppchAIGroups),     },
	{ "AttribMod",          TOK_STRUCT(BasePower, ppTemplates, ParseAttribModTemplate) },
	{ "IgnoreStrength",     TOK_BOOL(BasePower, bIgnoreStrength, 0), BoolEnum },
	{ "IgnoreStr",          TOK_REDUNDANTNAME|TOK_BOOL(BasePower, bIgnoreStrength, 0), BoolEnum },
	{ "ShowBuffIcon",       TOK_BOOL(BasePower, bShowBuffIcon, -1),		BoolEnum },
	{ "ShowInInventory",    TOK_INT(BasePower, eShowInInventory, kShowPowerSetting_Default),	ShowPowerSettingEnum },
	{ "ShowInManage",       TOK_BOOL(BasePower, bShowInManage, 1),		BoolEnum },
	{ "ShowInInfo",			TOK_BOOL(BasePower, bShowInInfo, 1),		BoolEnum },
	{ "Deletable",			TOK_BOOL(BasePower, bDeletable, 0),			BoolEnum },
	{ "Tradeable",			TOK_BOOL(BasePower, bTradeable,	0),			BoolEnum },
	{ "MaxBoosts",          TOK_INT(BasePower, iMaxBoosts, 6) },
	{ "DoNotSave",          TOK_BOOL(BasePower, bDoNotSave, 0),			BoolEnum },
	{ "DoesNotExpire",      TOK_REDUNDANTNAME|TOK_BOOL(BasePower, bBoostIgnoreEffectiveness, 0), BoolEnum },
	{ "BoostIgnoreEffectiveness", TOK_BOOL(BasePower, bBoostIgnoreEffectiveness, 0), BoolEnum },
	{ "BoostAlwaysCountForSet", TOK_BOOL(BasePower, bBoostAlwaysCountForSet, 0), BoolEnum },
	{ "BoostTradeable",		TOK_BOOL(BasePower, bBoostTradeable, 1), BoolEnum },
	{ "BoostCombinable",    TOK_BOOL(BasePower, bBoostCombinable, 1),	BoolEnum },
	{ "BoostAccountBound",	TOK_BOOL(BasePower, bBoostAccountBound, 0),	BoolEnum },
	{ "BoostBoostable",		TOK_BOOL(BasePower, bBoostBoostable, 0),	BoolEnum },
	{ "BoostUsePlayerLevel",TOK_BOOL(BasePower, bBoostUsePlayerLevel, 0),	BoolEnum },
	{ "BoostCatalystConversion",		TOK_STRING(BasePower, pchBoostCatalystConversion, 0),		},
	{ "StoreProduct",		TOK_STRING(BasePower, pchStoreProduct, 0),		},
	{ "BoostLicenseLevel",  TOK_INT(BasePower, iBoostInventionLicenseRequiredLevel, 999) },
	{ "MinSlotLevel",       TOK_INT(BasePower, iMinSlotLevel, -3) },
	{ "MaxSlotLevel",       TOK_INT(BasePower, iMaxSlotLevel, MAX_PLAYER_SECURITY_LEVEL-1) },
	{ "MaxBoostLevel",      TOK_INT(BasePower, iMaxBoostLevel, MAX_PLAYER_SECURITY_LEVEL) },		// 1 based for designer sanity
	{ "Var",                TOK_STRUCT(BasePower, ppVars, ParsePowerVar) },
	{ "ToggleDroppable",    TOK_INT(BasePower, eToggleDroppable, kToggleDroppable_Sometimes), ToggleDroppableEnum },
	{ "TogglesDroppable",   TOK_REDUNDANTNAME|TOK_INT(BasePower, eToggleDroppable, kToggleDroppable_Sometimes), ToggleDroppableEnum },
	{ "StrengthsDisallowed",TOK_INTARRAY(BasePower, pStrengthsDisallowed), ParsePowerDefines },
	{ "ProcMainTargetOnly", TOK_BOOL(BasePower, bUseNonBoostTemplatesOnMainTarget, 0),	BoolEnum },
	{ "AnimMainTargetOnly", TOK_BOOL(BasePower, bMainTargetOnly, 0), BoolEnum }, 
	{ "HighlightEval",		TOK_STRINGARRAY(BasePower, ppchHighlightEval),	},
	{ "HighlightIcon",		TOK_STRING(BasePower, pchHighlightIcon, 0),		},
	{ "HighlightRing",		TOK_RGBA(BasePower, rgbaHighlightRing),			},
	{ "TravelSuppression",  TOK_F32(BasePower, fTravelSuppression, 0),		},
	{ "PreferenceMultiplier", TOK_F32(BasePower, fPreferenceMultiplier, 1),	},
	{ "DontSetStance",		TOK_BOOL(BasePower, bDontSetStance, 0),	},
	{ "PointValue",			 TOK_F32(BasePower, fPointVal, 0),		},
	{ "PointMultiplier",	 TOK_F32(BasePower, fPointMultiplier, 0),		},
	{ "ChainIntoPower",		TOK_STRING(BasePower, pchChainIntoPowerName, NULL)},
	{ "InstanceLocked",		TOK_BOOL(BasePower, bInstanceLocked, 0), BoolEnum},
	{ "IsEnvironmentHit",	TOK_BOOL(BasePower, bIsEnvironmentHit, 0), BoolEnum},
	{ "ShuffleTargets",		TOK_BOOL(BasePower, bShuffleTargetList, 0), BoolEnum},
	{ "ForceLevelBought",	TOK_INT(BasePower, iForceLevelBought, -1)},
	{ "RefreshesOnActivePlayerChange",	TOK_BOOL(BasePower, bRefreshesOnActivePlayerChange, 0), BoolEnum},
	{ "PowerRedirector",	TOK_BOOL(BasePower, bPowerRedirector, 0), BoolEnum},
	{ "Cancelable",			TOK_BOOL(BasePower, bCancelable, 0), BoolEnum},
	{ "IgnoreToggleMaxDistance",	TOK_BOOL(BasePower, bIgnoreToggleMaxDistance, 0), BoolEnum},
	{ "ServerTrayPriority",	TOK_INT(BasePower, iServerTrayPriority, 0) },
	{ "AbusiveBuff",		TOK_BOOL(BasePower, bAbusiveBuff, true), BoolEnum },
	{ "PositionCenter",		TOK_INT(BasePower, ePositionCenter, kModTarget_Caster), ModTargetEnum },
	{ "PositionDistance",	TOK_F32(BasePower, fPositionDistance, 0.0f) },
	{ "PositionHeight",		TOK_F32(BasePower, fPositionHeight, 0.0f) },
	{ "PositionYaw",		TOK_F32(BasePower, fPositionYaw, 0.0f) },
	{ "FaceTarget",			TOK_BOOL(BasePower, bFaceTarget, true), BoolEnum},
	
	// What .pfx file was included for this power. The rest of the data comes from this pfx file, via an Include
	{ "VisualFX",			TOK_FILENAME(BasePower, fx.pchSourceFile, 0)		},
	ParsePowerFX(BasePower, fx) // included flat
	{ "CustomFX",			TOK_STRUCT(BasePower, customfx, ParsePowerCustomFX)	},
	{ "}", TOK_END, 0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseBasePowerSet[] =
{
	{ "{",					TOK_START,       0 },
	{ "SourceFile",			TOK_CURRENTFILE(BasePowerSet, pchSourceFile)       },
	{ "FullName",			TOK_STRUCTPARAM|TOK_STRING(BasePowerSet, pchFullName, 0)},
	{ "Name",				TOK_STRING(BasePowerSet, pchName, 0)             },
	{ "System",				TOK_INT(BasePowerSet, eSystem, kPowerSystem_Powers), PowerSystemEnum },
	{ "Shared",				TOK_BOOL(BasePowerSet, bIsShared, 0), BoolEnum },
	{ "DisplayName",		TOK_STRING(BasePowerSet, pchDisplayName, 0)      },
	{ "DisplayHelp",		TOK_STRING(BasePowerSet, pchDisplayHelp, 0)      },
	{ "DisplayShortHelp",	TOK_STRING(BasePowerSet, pchDisplayShortHelp, 0) },
	{ "IconName",			TOK_STRING(BasePowerSet, pchIconName, 0)         },
	{ "CostumeKeys",		TOK_STRINGARRAY(BasePowerSet, ppchCostumeKeys)   },
	{ "CostumeParts",		TOK_STRINGARRAY(BasePowerSet, ppchCostumeParts)   },
	{ "SetAccountRequires",	TOK_STRING(BasePowerSet, pchAccountRequires, 0)   },
	{ "SetAccountTooltip",	TOK_STRING(BasePowerSet, pchAccountTooltip, 0)      },
	{ "SetAccountProduct",	TOK_STRING(BasePowerSet, pchAccountProduct, 0)      },
	{ "SetBuyRequires",		TOK_STRINGARRAY(BasePowerSet, ppchSetBuyRequires) },
	{ "SetBuyRequiresFailedText",	TOK_STRING(BasePowerSet, pchSetBuyRequiresFailedText, 0)	},
	{ "ShowInInventory",	TOK_INT(BasePowerSet, eShowInInventory, kShowPowerSetting_Default), ShowPowerSettingEnum },
	{ "ShowInManage",		TOK_BOOL(BasePowerSet, bShowInManage, 1), BoolEnum },
	{ "ShowInInfo",			TOK_BOOL(BasePowerSet, bShowInInfo, 1), BoolEnum },
	{ "SpecializeAt",		TOK_INT(BasePowerSet, iSpecializeAt, 0) },
	{ "SpecializeRequires",	TOK_STRINGARRAY(BasePowerSet, ppSpecializeRequires) },
	{ "Powers",				TOK_STRINGARRAY(BasePowerSet, ppPowerNames ) },
	{ "",					TOK_AUTOINTEARRAY(BasePowerSet, ppPowers ) },
	{ "Available",			TOK_INTARRAY(BasePowerSet, piAvailable)         },
	{ "AIMaxLevel",			TOK_INTARRAY(BasePowerSet, piAIMaxLevel)         },
	{ "AIMinRankCon",		TOK_INTARRAY(BasePowerSet, piAIMinRankCon)         },
	{ "AIMaxRankCon",		TOK_INTARRAY(BasePowerSet, piAIMaxRankCon)         },
	{ "MinDifficulty",		TOK_INTARRAY(BasePowerSet, piMinDifficulty)		   },
	{ "MaxDifficulty",		TOK_INTARRAY(BasePowerSet, piMaxDifficulty)		   },
	{ "ForceLevelBought",	TOK_INT(BasePowerSet, iForceLevelBought, -1)},
	{ "}",					TOK_END,         0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePowerCategory[] =
{
	{ "{",                TOK_START,       0 },
	{ "SourceFile",       TOK_CURRENTFILE(PowerCategory, pchSourceFile)  },
	{ "Name",             TOK_STRUCTPARAM | TOK_STRING(PowerCategory, pchName, 0)        },
	{ "DisplayName",      TOK_STRING(PowerCategory, pchDisplayName, 0) },
	{ "DisplayHelp",      TOK_STRING(PowerCategory, pchDisplayHelp, 0)      },
	{ "DisplayShortHelp", TOK_STRING(PowerCategory, pchDisplayShortHelp, 0) },
	{ "PowerSets",        TOK_STRINGARRAY(PowerCategory, ppPowerSetNames ) },
	{ "",			      TOK_AUTOINTEARRAY(PowerCategory, ppPowerSets ) },
	{ "Available",        TOK_IGNORE,      0 },
	{ "}",                TOK_END,         0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePowerCatDictionary[] =
{
	{ "PowerCategory",   TOK_STRUCT(PowerDictionary, ppPowerCategories, ParsePowerCategory)},
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePowerSetDictionary[] =
{
	{ "PowerSet",        TOK_STRUCT(PowerDictionary, ppPowerSets, ParseBasePowerSet)},
	{ "", 0, 0 }
};

TokenizerParseInfo ParsePowerDictionary[] =
{
	{ "Power",           TOK_STRUCT(PowerDictionary, ppPowers, ParseBasePower)},
	{ "", 0, 0 }
};

TokenizerParseInfo ParseEntirePowerDictionary[] =
{
	{ "PowerCategory",   TOK_STRUCT(PowerDictionary, ppPowerCategories, ParsePowerCategory)},
	{ "PowerSet",        TOK_STRUCT(PowerDictionary, ppPowerSets, ParseBasePowerSet)},
	{ "Power",           TOK_STRUCT(PowerDictionary, ppPowers, ParseBasePower)},
	{ "", 0, 0 }
};

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

TokenizerParseInfo ParseDimReturn[] =
{
	{ "Start",    TOK_STRUCTPARAM|TOK_F32(DimReturn, fStart, 0)     },
	{ "Handicap", TOK_STRUCTPARAM|TOK_F32(DimReturn, fHandicap, 0)  },
	{ "Basis",    TOK_STRUCTPARAM|TOK_F32(DimReturn, fBasis, 0)     },
	{ "\n",       TOK_END,    0 },
	{ 0 }
};

TokenizerParseInfo ParseAttribDimReturnSet[] =
{
	{ "{",        TOK_START,      0 },
	{ "Default",  TOK_INT(AttribDimReturnSet, bDefault, 0)  },
	{ "Attrib",   TOK_AUTOINTEARRAY(AttribDimReturnSet, offAttribs), ParsePowerDefines  },
	{ "Return",   TOK_STRUCT(AttribDimReturnSet, pReturns, ParseDimReturn) },
	{ "}",        TOK_END,        0 },
	{ 0 }
};


TokenizerParseInfo ParseDimReturnSet[] =
{
	{ "{",               TOK_START,      0 },
	{ "Default",         TOK_INT(DimReturnSet, bDefault, 0)  },
	{ "Boost",           TOK_INTARRAY(DimReturnSet, piBoosts), ParsePowerDefines  },
	{ "AttribReturnSet", TOK_STRUCT(DimReturnSet, ppReturns, ParseAttribDimReturnSet) },
	{ "}",               TOK_END,        0 },
	{ 0 }
};

TokenizerParseInfo ParseDimReturnList[] =
{
	{ "ReturnSet",		TOK_STRUCT(DimReturnList, ppSets, ParseDimReturnSet) },
	{ "", 0, 0 }
};

static TokenizerParseInfo ParseDestroyUnusedAttribMods[] =
{
	{ "AttribMod",             TOK_STRUCT(BasePower, ppTemplates, ParseAttribModTemplate) },
	{ 0 }
};

static TokenizerParseInfo ParseDestroyPartialAttribMod[] =
{
	// Used by enhancement help UI
	// { "Name",                TOK_STRING(AttribModTemplate, pchName, 0)                 },
	{ "DisplayAttackerHit",  TOK_STRING(AttribModTemplate, pchDisplayAttackerHit, 0)   },
	{ "DisplayVictimHit",    TOK_STRING(AttribModTemplate, pchDisplayVictimHit, 0)     },
	{ "DisplayFloat",        TOK_STRING(AttribModTemplate, pchDisplayFloat, 0)         },
	{ "DisplayAttribDefenseFloat", TOK_STRING(AttribModTemplate, pchDisplayDefenseFloat, 0)         },

	{ "ShowFloaters",        TOK_BOOL(AttribModTemplate, bShowFloaters, 1), ModBoolEnum},

	// Used by diminishing returns UI
	// { "Attrib",              TOK_INT(AttribModTemplate, offAttrib),              0, ParsePowerDefines },
	// { "Aspect",              TOK_INT(AttribModTemplate, offAspect),              0, AspectEnum   },

	{ "Target",              TOK_INT(AttribModTemplate, eTarget, kModTarget_Affected), ModTargetEnum },

	// Used by diminishing returns UI
	// { "Table" ,              TOK_STRING, offsetof(AttribModTemplate, pchTable)                },
	// { "Scale",               TOK_F32,    offsetof(AttribModTemplate, fScale)                  },

	{ "Type",					TOK_INT(AttribModTemplate, eType, kModType_Magnitude), ModTypeEnum },
	{ "Delay",					TOK_F32(AttribModTemplate, fDelay, 0)             },
	{ "Period",					TOK_F32(AttribModTemplate, fPeriod, 0)            },
	{ "Chance",					TOK_F32(AttribModTemplate, fChance, 0)            },
	{ "CancelOnMiss",			TOK_BOOL(AttribModTemplate, bCancelOnMiss, 0), ModBoolEnum },
	{ "CancelEvents",			TOK_INTARRAY(AttribModTemplate, piCancelEvents), PowerEventEnum },
	{ "NearGround",				TOK_BOOL(AttribModTemplate, bNearGround, 0), ModBoolEnum },
	{ "AllowStrength",			TOK_BOOL(AttribModTemplate, bAllowStrength, 1), ModBoolEnum },
	{ "AllowResistance",		TOK_BOOL(AttribModTemplate, bAllowResistance, 1), ModBoolEnum },
	{ "UseMagnitudeResistance",	TOK_BOOL(AttribModTemplate, bUseMagnitudeResistance,  -1), ModBoolEnum },
	{ "UseDurationResistance",	TOK_BOOL(AttribModTemplate, bUseDurationResistance,   -1), ModBoolEnum },
	{ "AllowCombatMods",		TOK_BOOL(AttribModTemplate, bAllowCombatMods,  1), ModBoolEnum },
	{ "UseMagnitudeCombatMods",	TOK_BOOL(AttribModTemplate, bUseMagnitudeCombatMods,  -1), ModBoolEnum },
	{ "UseDurationCombatMods",	TOK_BOOL(AttribModTemplate, bUseDurationCombatMods,   -1), ModBoolEnum },
	{ "Requires",				TOK_STRINGARRAY(AttribModTemplate, ppchApplicationRequires)			},
	{ "PrimaryStringList",		TOK_STRINGARRAY(AttribModTemplate, ppchPrimaryStringList)       },
	{ "SecondaryStringList",	TOK_STRINGARRAY(AttribModTemplate, ppchSecondaryStringList)       },
	{ "CasterStackType",		TOK_INT(AttribModTemplate, eCasterStack, kCasterStackType_Individual), CasterStackTypeEnum },
	{ "StackType",				TOK_INT(AttribModTemplate, eStack, kStackType_Replace), StackTypeEnum },
	{ "StackLimit",				TOK_INT(AttribModTemplate, iStackLimit, 2)		},
	{ "StackKey",				TOK_INT(AttribModTemplate, iStackKey, -1), ParsePowerDefines		},
	{ "Duration",				TOK_F32(AttribModTemplate, fDuration, -1), DurationEnum  },
	{ "DurationExpr",			TOK_STRINGARRAY(AttribModTemplate, ppchDuration)       },
	{ "Magnitude",				TOK_F32(AttribModTemplate, fMagnitude, 0), ParsePowerDefines },
	{ "MagnitudeExpr",			TOK_STRINGARRAY(AttribModTemplate, ppchMagnitude)  },
	{ "RadiusInner",			TOK_F32(AttribModTemplate, fRadiusInner, -1) },
	{ "RadiusOuter",			TOK_F32(AttribModTemplate, fRadiusOuter, -1) },

	{ "Suppress",            TOK_STRUCT(AttribModTemplate, ppSuppress, ParseSuppressPair) },
	{ "IgnoreSuppressErrors",TOK_STRING(AttribModTemplate, pchIgnoreSuppressErrors, 0)},

	{ "ContinuingBits",      TOK_INTARRAY(AttribModTemplate, piContinuingBits), ParsePowerDefines },
	{ "ContinuingFX",        TOK_FILENAME(AttribModTemplate, pchContinuingFX, 0)    },
	{ "ConditionalBits",     TOK_INTARRAY(AttribModTemplate, piConditionalBits), ParsePowerDefines },
	{ "ConditionalFX",       TOK_FILENAME(AttribModTemplate, pchConditionalFX, 0)   },

	{ "CostumeName",         TOK_FILENAME(AttribModTemplate, pchCostumeName, 0)     },

	{ "Reward",              TOK_STRING(AttribModTemplate, pchReward, 0)               },
	{ "Params",				 TOK_STRING(AttribModTemplate, pchParams, 0)				},

	{ "EntityDef",           TOK_STRING(AttribModTemplate, pchEntityDef, 0)            },
	{ "PriorityListDefense", TOK_STRING(AttribModTemplate, pchPriorityListDefense, 0)  },
	{ "PriorityListOffense", TOK_STRING(AttribModTemplate, pchPriorityListOffense, 0)  },
	{ "PriorityListPassive", TOK_STRING(AttribModTemplate, pchPriorityListPassive, 0)  },
	{ "VanishEntOnTimeout",  TOK_BOOL(AttribModTemplate, bVanishEntOnTimeout, 0), ModBoolEnum},
	{ "MatchExactPower",	 TOK_BOOL(AttribModTemplate, bMatchExactPower, 0), ModBoolEnum},
	{ "KeepThroughDeath", TOK_BOOL(AttribModTemplate, bKeepThroughDeath, 0), ModBoolEnum},
	{ 0 }
};

SHARED_MEMORY PowerDictionary g_PowerDictionary = {0};

ParseLink g_basepower_InfoLink = {
	(void***)&g_PowerDictionary.ppPowerCategories ,
	{
		{ offsetof(PowerCategory,pchName), offsetof(PowerCategory,ppPowerSets) },
		{ offsetof(BasePowerSet,pchName), offsetof(BasePowerSet,ppPowers) },
		{ offsetof(BasePower,pchName),      0 },
	}
};

ParseLink g_power_PowerInfoLink = {
	(void***)&g_PowerDictionary.ppPowers,
	{
		{ offsetof(BasePower,pchFullName), 0 },
	}
};

ParseLink g_power_SetInfoLink = {
	(void***)&g_PowerDictionary.ppPowerSets,
	{
		{ offsetof(BasePowerSet,pchFullName), 0 },
	}
};

ParseLink g_power_CatInfoLink = {
	(void***)&g_PowerDictionary.ppPowerCategories,
	{
		{ offsetof(PowerCategory,pchName), 0 },
	}
};

typedef struct 
{
	char *oldName;
	char *newName;
} PowerNameMap;

// the hashes for replacing obsolete powers/powersets
typedef struct 
{
	PowerNameMap **names;
	PowerNameMap **sets;
	StashTable htPowerSetReplacement;
	StashTable htPowerReplacement;
} ReplacementHashes;

#include "boostset.h"

TokenizerParseInfo ParsePowerNameMap[] =
{
	{"Old",		TOK_STRING(PowerNameMap, oldName, 0)},
	{"New",		TOK_STRING(PowerNameMap, newName, 0)},
	{"End",		TOK_END},
	{ "", 0 }
};

TokenizerParseInfo ParsePowerReplacements[] =
{
	{"PowerSet",	TOK_STRUCT(ReplacementHashes, sets, ParsePowerNameMap)},
	{"Power",		TOK_STRUCT(ReplacementHashes, names, ParsePowerNameMap)},
	{ "", 0 }
};

TokenizerParseInfo ParseBoostList[] =
{
	{ "{",                TOK_START,     0 },
	{ "Boosts",           TOK_LINKARRAY(BoostList, ppBoosts, &g_basepower_InfoLink) },
	{ "}",                TOK_END,       0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseBoostSetBonus[] =
{
	{ "{",                TOK_START,     0 },
	{ "DisplayText",      TOK_STRING(BoostSetBonus, pchDisplayName, 0) },
	{ "MinBoosts",        TOK_INT(BoostSetBonus, iMinBoosts, 0)    },
	{ "MaxBoosts",        TOK_INT(BoostSetBonus, iMaxBoosts, 0)    },
	{ "Requires",         TOK_STRINGARRAY(BoostSetBonus, ppchRequires),     }, 
	{ "AutoPowers",       TOK_LINKARRAY(BoostSetBonus, ppAutoPowers, &g_basepower_InfoLink) },
	{ "BonusPower",       TOK_LINK(BoostSetBonus, pBonusPower, 0, &g_basepower_InfoLink) },
	{ "}",                TOK_END,       0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseBoostSet[] =
{
	{ "{",					TOK_START,       0 },
	{ "Name",				TOK_STRUCTPARAM | TOK_STRING(BoostSet, pchName, 0)},
	{ "DisplayName",		TOK_STRING(BoostSet, pchDisplayName, 0) },
	{ "GroupName",			TOK_STRING(BoostSet, pchGroupName, 0) },
	{ "ConversionGroups",	TOK_STRINGARRAY(BoostSet, ppchConversionGroups),     }, 
	{ "Powers",				TOK_LINKARRAY(BoostSet, ppPowers, &g_basepower_InfoLink) },
	{ "BoostLists",			TOK_STRUCT(BoostSet, ppBoostLists, ParseBoostList)},
	{ "Bonuses",			TOK_STRUCT(BoostSet, ppBonuses, ParseBoostSetBonus)},
	{ "MinLevel",			TOK_INT(BoostSet, iMinLevel, 0) },
	{ "MaxLevel",			TOK_INT(BoostSet, iMaxLevel, 0) },
	{ "StoreProduct",		TOK_STRING(BoostSet, pchStoreProduct, 0) },
	{ "}",					TOK_END,         0 },
	{ "", 0, 0 }	
};

TokenizerParseInfo ParseBoostSetDictionary[] =
{
	{ "BoostSet", TOK_STRUCT(BoostSetDictionary, ppBoostSets, ParseBoostSet)},
	{ "", 0, 0 }
};


TokenizerParseInfo ParseConversionSetCost[] =
{
	{ "{",					TOK_START,       0 },
	{ "Name",				TOK_STRUCTPARAM | TOK_STRING(ConversionSetCost, pchConversionSetName, 0)},
	{ "InSet",				TOK_INT(ConversionSetCost, tokensInSet, 0)    },
	{ "OutSet",				TOK_INT(ConversionSetCost, tokensOutSet, 0)    },
	{ "AllowAttuned",		TOK_INT(ConversionSetCost, allowAttuned, 0)   },			
	{ "}",					TOK_END,         0 },
	{ "", 0, 0 }	
};

TokenizerParseInfo ParseConversionSet[] =
{
	{ "ConversionSet", TOK_STRUCT(ConversionSets, ppConversionSetCosts, ParseConversionSetCost)},
	{ "", 0, 0 }
};
""".}