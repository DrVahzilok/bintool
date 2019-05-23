{.emit: """
#include "entai.h"
#include "entaiprivate.h"
typedef enum AIConfigPowerAssignmentFromType {
	FROMTYPE_NAME,
	FROMTYPE_FLAG,
	FROMTYPE_NOFLAG,

	FROMTYPE_COUNT,
} AIConfigPowerAssignmentFromType;

static TokenizerParseInfo parseConfigPowerAssignmentByName[] = {
	{ "",									TOK_STRUCTPARAM | TOK_STRING(AIConfigPowerAssignment,nameTo,0) },
	{ "",									TOK_STRUCTPARAM | TOK_STRING(AIConfigPowerAssignment,nameFrom,0) },
	//--------------------------------------------------------------------------
	{ "",									TOK_INT(AIConfigPowerAssignment,fromType, FROMTYPE_NAME) },
	//--------------------------------------------------------------------------
	{ "\n",									TOK_END,			0 },
	//--------------------------------------------------------------------------
	{ "", 0, 0 }
};

static TokenizerParseInfo parseConfigPowerAssignmentByFlag[] = {
	{ "",									TOK_STRUCTPARAM | TOK_STRING(AIConfigPowerAssignment,nameTo,0) },
	{ "",									TOK_STRUCTPARAM | TOK_STRING(AIConfigPowerAssignment,nameFrom,0) },
	//------------------------------------------------------------------------
	{ "",									TOK_INT(AIConfigPowerAssignment,fromType, FROMTYPE_FLAG) },
	//------------------------------------------------------------------------
	{ "\n",									TOK_END,			0 },
	//--------------------------------------------------------------------------
	{ "", 0, 0 }
};

static TokenizerParseInfo parseConfigPowerAssignmentNoFlags[] = {
	{ "",									TOK_STRUCTPARAM | TOK_STRING(AIConfigPowerAssignment,nameTo,0) },
	//--------------------------------------------------------------------------
	{ "",									TOK_INT(AIConfigPowerAssignment,fromType, FROMTYPE_NOFLAG) },
	//--------------------------------------------------------------------------
	{ "\n",									TOK_END,			0 },
	//--------------------------------------------------------------------------
	{ "", 0, 0 }
};

static TokenizerParseInfo parseConfigPowerConfig[] = {
	{ "{",									TOK_IGNORE,		0 },
	{ "PowerName:",							TOK_STRING(AIConfigPowerConfig,			powerName,0) },
	{ "AllowedTarget:",						TOK_STRINGARRAY(AIConfigPowerConfig,	allowedTargets)	},
	{ "GroundAttack:",						TOK_INT(AIConfigPowerConfig,			groundAttack,0)	},
	{ "AllowMultipleBuffs:",				TOK_INT(AIConfigPowerConfig,			allowMultipleBuffs,0) },
	{ "DoNotToggleOff:",					TOK_INT(AIConfigPowerConfig,			doNotToggleOff,0) },
	{ "CritterOverridePrefMult:",			TOK_F32(AIConfigPowerConfig,		critterOverridePreferenceMultiplier, -1.0f)	},
	{ "}",									TOK_END,			0 },
	{ "", 0, 0 }
};

static TokenizerParseInfo parseConfigTargetPref[] = {
	{ "{",									TOK_IGNORE,		0 },
	{ "Archetype:",							TOK_STRING(AIConfigTargetPref,archetype,0) },
	{ "Factor:",							TOK_F32(AIConfigTargetPref,factor,0)	},
	{ "}",									TOK_END,			0 },
	{ "", 0, 0 }
};
static TokenizerParseInfo parseConfigAOEUsage[] = {
	{ "{",									TOK_IGNORE,		0 },
	{ "SingleTargetPreference:",			TOK_F32(AIConfigAOEUsage,fConfigSingleTargetPreference,-1.0) },
	{ "AOENumTargetMultiplier:",			TOK_F32(AIConfigAOEUsage,fAOENumTargetMultiplier,-1.0)	},
	{ "}",									TOK_END,			0 },
	{ "", 0, 0 }
};

#define CREATE_FIELD(name) AICONFIGFIELD_##name

typedef enum AIConfigField {
	CREATE_FIELD(BRAIN_NAME),
	//-------------------
	CREATE_FIELD(BRAIN_HYDRA_USE_TEAM),
	CREATE_FIELD(BRAIN_SWITCH_TARGETS_BASE_TIME),
	CREATE_FIELD(BRAIN_SWITCH_TARGETS_MIN_DISTANCE),
	CREATE_FIELD(BRAIN_SWITCH_TARGETS_TELEPORT),
	CREATE_FIELD(BRAIN_RIKTI_UXB_FULL_HEALTH),
	//-------------------
	CREATE_FIELD(TEAM_ASSIGN_TARGET_PRIORITY),
	//-------------------
	CREATE_FIELD(FEELING_SCALE_MEATTACKED),
	CREATE_FIELD(FEELING_SCALE_FRIENDATTACKED),
	CREATE_FIELD(FEELING_BASE_FEAR),
	CREATE_FIELD(FEELING_BASE_CONFIDENCE),
	CREATE_FIELD(FEELING_BASE_LOYALTY),
	CREATE_FIELD(FEELING_BASE_BOTHERED),
	//-------------------
	CREATE_FIELD(MISC_ALWAYS_FLY),
	CREATE_FIELD(MISC_ALWAYS_HIT),
	CREATE_FIELD(MISC_BOOST_SPEED),
	CREATE_FIELD(MISC_CONSIDER_ENEMY_LEVEL),
	CREATE_FIELD(MISC_DO_ATTACK_AI),
	CREATE_FIELD(MISC_DO_NOT_FACE_TARGET),
	CREATE_FIELD(MISC_DO_NOT_ASSIGN_TO_MELEE),
	CREATE_FIELD(MISC_DO_NOT_ASSIGN_TO_RANGED),
	CREATE_FIELD(MISC_DO_NOT_GO_TO_SLEEP),
	CREATE_FIELD(MISC_DO_NOT_MOVE),
	CREATE_FIELD(MISC_DO_NOT_SHARE_INFO_WITH_MEMBERS),
	CREATE_FIELD(MISC_EVENT_MEMORY_DURATION),
	CREATE_FIELD(MISC_FOV_DEGREES),
	CREATE_FIELD(MISC_FIND_TARGET_IN_PROXIMITY),
	CREATE_FIELD(MISC_GRIEF_HP_RATIO),
	CREATE_FIELD(MISC_GRIEF_TIME_BEGIN),
	CREATE_FIELD(MISC_GRIEF_TIME_END),
	CREATE_FIELD(MISC_IGNORE_FRIENDS_ATTACKED),
	CREATE_FIELD(MISC_IGNORE_TARGET_STEALTH_RADIUS),
	CREATE_FIELD(MISC_INVINCIBLE),
	CREATE_FIELD(MISC_IS_CAMERA),
	CREATE_FIELD(MISC_IS_RESURRECTABLE),
	CREATE_FIELD(MISC_KEEP_SPAWN_PYR),
	CREATE_FIELD(MISC_LIMITED_SPEED),
	CREATE_FIELD(MISC_NO_PHYSICS),
	CREATE_FIELD(MISC_ONTEAMVILLAIN),
	CREATE_FIELD(MISC_ONTEAMMONSTER),
	CREATE_FIELD(MISC_ONTEAMHERO),
	CREATE_FIELD(MISC_OVERRIDE_PERCEPTION_RADIUS),
	CREATE_FIELD(MISC_PATH_LIMITED),
	CREATE_FIELD(MISC_PERCEIVE_ATTACKS_WITHOUT_DAMAGE),
	CREATE_FIELD(MISC_PREFER_GROUND_COMBAT),
	CREATE_FIELD(MISC_PREFER_MELEE),
	CREATE_FIELD(MISC_PREFER_MELEE_SCALE),
	CREATE_FIELD(MISC_PREFER_RANGED),
	CREATE_FIELD(MISC_PREFER_RANGED_SCALE),
	CREATE_FIELD(MISC_PREFER_UNTARGETED),
	CREATE_FIELD(MISC_PROTECT_SPAWN_RADIUS),
	CREATE_FIELD(MISC_PROTECT_SPAWN_OUTSIDE_RADIUS),
	CREATE_FIELD(MISC_PROTECT_SPAWN_TIME),
	CREATE_FIELD(MISC_RELENTLESS),
	CREATE_FIELD(MISC_RETURN_TO_SPAWN_DISTANCE),
	CREATE_FIELD(MISC_SHOUT_RADIUS),
	CREATE_FIELD(MISC_SHOUT_CHANCE),
	CREATE_FIELD(MISC_SPAWN_POS_IS_SELF),
	CREATE_FIELD(MISC_STANDOFF_DISTANCE),
	CREATE_FIELD(MISC_TARGETED_SIGHT_ADD_RANGE),
	CREATE_FIELD(MISC_TURN_WHILE_IDLE),
	CREATE_FIELD(MISC_UNTARGETABLE),
	CREATE_FIELD(MISC_WALK_TO_SPAWN_RADIUS),
	//-------------------
	CREATE_FIELD(POWERS_MAX_PETS),
	CREATE_FIELD(POWERS_RESURRECT_ARCHVILLAINS),
	CREATE_FIELD(POWERS_USE_RANGE_AS_MAXIMUM),
} AIConfigField;

#undef CREATE_FIELD

static TokenizerParseInfo aiConfigSettingWrite[] = {
	{ "",									TOK_INT(AIConfigSetting, field, 0) },
	{ "",									TOK_RAW(AIConfigSetting, value)  },
	{ "",									TOK_STRING(AIConfigSetting, string, 0) },
	{ "", 0, 0 }
};

#define SETTING_STRUCT(name,tokenType,fieldName)																			\
static TokenizerParseInfo aiConfigSetting##name[] = {																		\
	{ "",									TOK_STRUCTPARAM |																\
											TOK_##tokenType(AIConfigSetting, fieldName, 0) },						\
	{ "",									TOK_INT(AIConfigSetting, field, AICONFIGFIELD_##name) },	\
	{ "\n",									TOK_END,			0 },														\
	{ "", 0, 0 }																											\
}
																		\
#define SETTING_STRUCT_INT(name) SETTING_STRUCT(name,INT,value.s32)
#define SETTING_STRUCT_STRING(name) SETTING_STRUCT(name,STRING,string)
#define SETTING_STRUCT_F32(name) SETTING_STRUCT(name,F32,value.f32)

	SETTING_STRUCT_STRING(BRAIN_NAME);
	//-------------------
	SETTING_STRUCT_INT(BRAIN_HYDRA_USE_TEAM);
	SETTING_STRUCT_F32(BRAIN_SWITCH_TARGETS_BASE_TIME);
	SETTING_STRUCT_F32(BRAIN_SWITCH_TARGETS_MIN_DISTANCE);
	SETTING_STRUCT_INT(BRAIN_SWITCH_TARGETS_TELEPORT);
	SETTING_STRUCT_INT(BRAIN_RIKTI_UXB_FULL_HEALTH);
	//---------------
	SETTING_STRUCT_INT(TEAM_ASSIGN_TARGET_PRIORITY);
	//---------------
	SETTING_STRUCT_F32(FEELING_SCALE_MEATTACKED);
	SETTING_STRUCT_F32(FEELING_SCALE_FRIENDATTACKED);
	SETTING_STRUCT_F32(FEELING_BASE_FEAR);
	SETTING_STRUCT_F32(FEELING_BASE_CONFIDENCE);
	SETTING_STRUCT_F32(FEELING_BASE_LOYALTY);
	SETTING_STRUCT_F32(FEELING_BASE_BOTHERED);
	//---------------
	SETTING_STRUCT_INT(MISC_ALWAYS_FLY);
	SETTING_STRUCT_INT(MISC_ALWAYS_HIT);
	SETTING_STRUCT_F32(MISC_BOOST_SPEED);
	SETTING_STRUCT_INT(MISC_CONSIDER_ENEMY_LEVEL);
	SETTING_STRUCT_INT(MISC_DO_ATTACK_AI);
	SETTING_STRUCT_INT(MISC_DO_NOT_FACE_TARGET);
	SETTING_STRUCT_INT(MISC_DO_NOT_ASSIGN_TO_MELEE);
	SETTING_STRUCT_INT(MISC_DO_NOT_ASSIGN_TO_RANGED);
	SETTING_STRUCT_INT(MISC_DO_NOT_GO_TO_SLEEP);
	SETTING_STRUCT_INT(MISC_DO_NOT_MOVE);
	SETTING_STRUCT_INT(MISC_DO_NOT_SHARE_INFO_WITH_MEMBERS);
	SETTING_STRUCT_F32(MISC_EVENT_MEMORY_DURATION);
	SETTING_STRUCT_F32(MISC_FOV_DEGREES);
	SETTING_STRUCT_INT(MISC_FIND_TARGET_IN_PROXIMITY);
	SETTING_STRUCT_F32(MISC_GRIEF_HP_RATIO);
	SETTING_STRUCT_F32(MISC_GRIEF_TIME_BEGIN);
	SETTING_STRUCT_F32(MISC_GRIEF_TIME_END);
	SETTING_STRUCT_INT(MISC_IGNORE_FRIENDS_ATTACKED);
	SETTING_STRUCT_INT(MISC_IGNORE_TARGET_STEALTH_RADIUS);
	SETTING_STRUCT_INT(MISC_INVINCIBLE);
	SETTING_STRUCT_INT(MISC_IS_CAMERA);
	SETTING_STRUCT_INT(MISC_IS_RESURRECTABLE);
	SETTING_STRUCT_INT(MISC_KEEP_SPAWN_PYR);
	SETTING_STRUCT_F32(MISC_LIMITED_SPEED);
	SETTING_STRUCT_INT(MISC_NO_PHYSICS);
	SETTING_STRUCT_INT(MISC_ONTEAMVILLAIN);
	SETTING_STRUCT_INT(MISC_ONTEAMMONSTER);
	SETTING_STRUCT_INT(MISC_ONTEAMHERO);
	SETTING_STRUCT_INT(MISC_OVERRIDE_PERCEPTION_RADIUS);
	SETTING_STRUCT_INT(MISC_PATH_LIMITED);
	SETTING_STRUCT_INT(MISC_PERCEIVE_ATTACKS_WITHOUT_DAMAGE);
	SETTING_STRUCT_INT(MISC_PREFER_GROUND_COMBAT);
	SETTING_STRUCT_INT(MISC_PREFER_MELEE);
	SETTING_STRUCT_F32(MISC_PREFER_MELEE_SCALE);
	SETTING_STRUCT_INT(MISC_PREFER_RANGED);
	SETTING_STRUCT_F32(MISC_PREFER_RANGED_SCALE);
	SETTING_STRUCT_INT(MISC_PREFER_UNTARGETED);
	SETTING_STRUCT_F32(MISC_PROTECT_SPAWN_RADIUS);
	SETTING_STRUCT_F32(MISC_PROTECT_SPAWN_OUTSIDE_RADIUS);
	SETTING_STRUCT_F32(MISC_PROTECT_SPAWN_TIME);
	SETTING_STRUCT_INT(MISC_RELENTLESS);
	SETTING_STRUCT_F32(MISC_RETURN_TO_SPAWN_DISTANCE);
	SETTING_STRUCT_F32(MISC_SHOUT_RADIUS);
	SETTING_STRUCT_INT(MISC_SHOUT_CHANCE);
	SETTING_STRUCT_INT(MISC_SPAWN_POS_IS_SELF);
	SETTING_STRUCT_F32(MISC_STANDOFF_DISTANCE);
	SETTING_STRUCT_F32(MISC_TARGETED_SIGHT_ADD_RANGE);
	SETTING_STRUCT_INT(MISC_TURN_WHILE_IDLE);
	SETTING_STRUCT_INT(MISC_UNTARGETABLE);
	SETTING_STRUCT_F32(MISC_WALK_TO_SPAWN_RADIUS);
	//-------------------
	SETTING_STRUCT_INT(POWERS_MAX_PETS);
	SETTING_STRUCT_INT(POWERS_RESURRECT_ARCHVILLAINS);
	SETTING_STRUCT_INT(POWERS_USE_RANGE_AS_MAXIMUM);

#undef SETTING_STRUCT_STRING
#undef SETTING_STRUCT_F32
#undef SETTING_STRUCT_INT
#undef SETTING_STRUCT

#define SETTING_LINE(parseName, name)																								\
	{ parseName, TOK_REDUNDANTNAME | TOK_STRUCT(AIConfig, settings, aiConfigSetting##name) }

static TokenizerParseInfo parseConfig[] = {
	{ "",									TOK_STRUCTPARAM |
											TOK_STRING(AIConfig,name,0) },
	//--------------------------------------------------------------------------
	{ "{",									TOK_IGNORE,			0 },
	//------------------------------------------------------------------------
	{ "BaseConfig:",						TOK_STRINGARRAY(AIConfig,baseConfigNames) },
	//------------------------------------------------------------------------
	{ "",									TOK_STRUCT(AIConfig, settings, aiConfigSettingWrite) },
	//--------------------------------------------------------------------------
	SETTING_LINE("Brain.Name:",							BRAIN_NAME),
	//--------------------------------------------------------------------------
	SETTING_LINE("Brain.Hydra.UseTeam:",				BRAIN_HYDRA_USE_TEAM),
	SETTING_LINE("Brain.SwitchTargets.BaseTime:",		BRAIN_SWITCH_TARGETS_BASE_TIME),
	SETTING_LINE("Brain.SwitchTargets.MinDistance:",	BRAIN_SWITCH_TARGETS_MIN_DISTANCE),
	SETTING_LINE("Brain.SwitchTargets.Teleport:",		BRAIN_SWITCH_TARGETS_TELEPORT),
	SETTING_LINE("Brain.RiktiUXB.FullHealth:",			BRAIN_RIKTI_UXB_FULL_HEALTH),
	//--------------------------------------------------------------------------
	SETTING_LINE("Team.AssignTargetPriority:",			TEAM_ASSIGN_TARGET_PRIORITY),
	//--------------------------------------------------------------------------
	SETTING_LINE("Feeling.Scale.MeAttacked:",			FEELING_SCALE_MEATTACKED),
	SETTING_LINE("Feeling.Scale.FriendAttacked:",		FEELING_SCALE_FRIENDATTACKED),
	SETTING_LINE("Feeling.Base.Fear:",					FEELING_BASE_FEAR),
	SETTING_LINE("Feeling.Base.Confidence:",			FEELING_BASE_CONFIDENCE),
	SETTING_LINE("Feeling.Base.Loyalty:",				FEELING_BASE_LOYALTY),
	SETTING_LINE("Feeling.Base.Bothered:",				FEELING_BASE_BOTHERED),
	//--------------------------------------------------------------------------
	SETTING_LINE("Misc.AlwaysFly:",						MISC_ALWAYS_FLY),
	SETTING_LINE("Misc.AlwaysHit:",						MISC_ALWAYS_HIT),
	SETTING_LINE("Misc.BoostSpeed",						MISC_BOOST_SPEED),
	SETTING_LINE("Misc.ConsiderEnemyLevel:",			MISC_CONSIDER_ENEMY_LEVEL),
	SETTING_LINE("Misc.DoAttackAI:",					MISC_DO_ATTACK_AI),
	SETTING_LINE("Misc.DoNotFaceTarget:",				MISC_DO_NOT_FACE_TARGET),
	SETTING_LINE("Misc.DoNotAssignToMelee:",			MISC_DO_NOT_ASSIGN_TO_MELEE),
	SETTING_LINE("Misc.DoNotAssignToRanged:",			MISC_DO_NOT_ASSIGN_TO_RANGED),
	SETTING_LINE("Misc.DoNotGoToSleep:",				MISC_DO_NOT_GO_TO_SLEEP),
	SETTING_LINE("Misc.DoNotMove:",						MISC_DO_NOT_MOVE),
	SETTING_LINE("Misc.DoNotShareInfoWithMembers:",		MISC_DO_NOT_SHARE_INFO_WITH_MEMBERS),
	SETTING_LINE("Misc.EventMemoryDuration:",			MISC_EVENT_MEMORY_DURATION),
	SETTING_LINE("Misc.FOVDegrees:",					MISC_FOV_DEGREES),
	SETTING_LINE("Misc.FindTargetInProximity:",			MISC_FIND_TARGET_IN_PROXIMITY),
	SETTING_LINE("Misc.GriefHPRatio:",					MISC_GRIEF_HP_RATIO),
	SETTING_LINE("Misc.GriefTimeBegin:",				MISC_GRIEF_TIME_BEGIN),
	SETTING_LINE("Misc.GriefTimeEnd:",					MISC_GRIEF_TIME_END),
	SETTING_LINE("Misc.IgnoreFriendsAttacked:",			MISC_IGNORE_FRIENDS_ATTACKED),
	SETTING_LINE("Misc.IgnoreTargetStealthRadius:",		MISC_IGNORE_TARGET_STEALTH_RADIUS),
	SETTING_LINE("Misc.Invincible:",					MISC_INVINCIBLE),
	SETTING_LINE("Misc.IsCamera:",						MISC_IS_CAMERA),
	SETTING_LINE("Misc.IsResurrectable:",				MISC_IS_RESURRECTABLE),
	SETTING_LINE("Misc.KeepSpawnPYR:",					MISC_KEEP_SPAWN_PYR),
	SETTING_LINE("Misc.LimitedSpeed",					MISC_LIMITED_SPEED),
	SETTING_LINE("Misc.NoPhysics:",						MISC_NO_PHYSICS),
	SETTING_LINE("Misc.OnTeamFoul:",					MISC_ONTEAMVILLAIN),
	SETTING_LINE("Misc.OnTeamEvil:",					MISC_ONTEAMMONSTER),
	SETTING_LINE("Misc.OnTeamGood:",					MISC_ONTEAMHERO),
	SETTING_LINE("Misc.OnTeamVillain:",					MISC_ONTEAMVILLAIN),
	SETTING_LINE("Misc.OnTeamMonster:",					MISC_ONTEAMMONSTER),
	SETTING_LINE("Misc.OnTeamHero:",					MISC_ONTEAMHERO),
	SETTING_LINE("Misc.OverridePerceptionRadius:",		MISC_OVERRIDE_PERCEPTION_RADIUS),
	SETTING_LINE("Misc.PathLimited:",					MISC_PATH_LIMITED),
	SETTING_LINE("Misc.PerceiveAttacksWithoutDamage:",	MISC_PERCEIVE_ATTACKS_WITHOUT_DAMAGE),
	SETTING_LINE("Misc.PreferGroundCombat:",			MISC_PREFER_GROUND_COMBAT),
	SETTING_LINE("Misc.PreferMelee:",					MISC_PREFER_MELEE),
	SETTING_LINE("Misc.PreferMeleeScale:",				MISC_PREFER_MELEE_SCALE),
	SETTING_LINE("Misc.PreferRanged:",					MISC_PREFER_RANGED),
	SETTING_LINE("Misc.PreferRangedScale:",				MISC_PREFER_RANGED_SCALE),
	SETTING_LINE("Misc.PreferUntargeted:",				MISC_PREFER_UNTARGETED),
	SETTING_LINE("Misc.ProtectSpawnRadius:",			MISC_PROTECT_SPAWN_RADIUS),
	SETTING_LINE("Misc.ProtectSpawnOutsideRadius:",		MISC_PROTECT_SPAWN_OUTSIDE_RADIUS),
	SETTING_LINE("Misc.ProtectSpawnTime:",				MISC_PROTECT_SPAWN_TIME),
	SETTING_LINE("Misc.Relentless:",					MISC_RELENTLESS),
	SETTING_LINE("Misc.ReturnToSpawnDistance:",			MISC_RETURN_TO_SPAWN_DISTANCE),
 	SETTING_LINE("Misc.ShoutRadius:",					MISC_SHOUT_RADIUS),
	SETTING_LINE("Misc.ShoutChance:",					MISC_SHOUT_CHANCE),
	SETTING_LINE("Misc.SpawnPosIsSelf:",				MISC_SPAWN_POS_IS_SELF),
	SETTING_LINE("Misc.StandoffDistance:",				MISC_STANDOFF_DISTANCE),
	SETTING_LINE("Misc.TargetedSightAddRange:",			MISC_TARGETED_SIGHT_ADD_RANGE),
	SETTING_LINE("Misc.TurnWhileIdle:",					MISC_TURN_WHILE_IDLE),
	SETTING_LINE("Misc.Untargetable:",					MISC_UNTARGETABLE),
	SETTING_LINE("Misc.WalkToSpawnRadius:",				MISC_WALK_TO_SPAWN_RADIUS),
	//--------------------------------------------------------------------------
	SETTING_LINE("Powers.MaxPets:",						POWERS_MAX_PETS),
	SETTING_LINE("Powers.ResurrectArchVillains:",		POWERS_RESURRECT_ARCHVILLAINS),
	SETTING_LINE("Powers.UseRangeAsMaximum:",			POWERS_USE_RANGE_AS_MAXIMUM),
	//--------------------------------------------------------------------------
	{ "AssignPowerByName:",					TOK_STRUCT(AIConfig, powerAssignment.list, parseConfigPowerAssignmentByName) },
	{ "AssignPowerByFlag:",					TOK_REDUNDANTNAME | TOK_STRUCT(AIConfig,powerAssignment.list, parseConfigPowerAssignmentByFlag) },
	{ "AssignPowerNoFlags:",				TOK_REDUNDANTNAME | TOK_STRUCT(AIConfig,powerAssignment.list, parseConfigPowerAssignmentNoFlags) },
	{ "PowerConfig",						TOK_STRUCT(AIConfig, powerConfigs, parseConfigPowerConfig)	},
	{ "TargetPreference",					TOK_STRUCT(AIConfig, targetPref, parseConfigTargetPref)	},
	{ "AOEUsage",							TOK_OPTIONALSTRUCT(AIConfig, AOEUsageConfig, parseConfigAOEUsage), },
	//------------------------------------------------------------------------
	{ "}",									TOK_END,			0 },
	//--------------------------------------------------------------------------
	{ "", 0, 0 }
};

static TokenizerParseInfo parsePowerGroup[] = {
	{ "",									TOK_STRUCTPARAM | TOK_STRING(AIConfigPowerGroup,name,0) },
	{ "",									TOK_STRUCTPARAM | TOK_INT(AIConfigPowerGroup,bit,0) },
	{ "\n",									TOK_END,			0 },
	//--------------------------------------------------------------------------
	{ "", 0, 0 }
};

static TokenizerParseInfo parseAllConfigs[] = {
	{ "Config:",		TOK_STRUCT(AIAllConfigs,configs,parseConfig)		},
	{ "PowerGroup:",	TOK_STRUCT(AIAllConfigs,powerGroups,parsePowerGroup)	},
	//--------------------------------------------------------------------------
	{ "", 0, 0 }
};
""".}