{.emit: """
#include "power_system.h"

TokenizerParseInfo ParseSchedule[] =
{
	{ "{",                         TOK_START,  0 },
	{ "FreeBoostSlotsOnPower",     TOK_INTARRAY(Schedule, piFreeBoostSlotsOnPower)     },
	{ "PoolPowerSet",              TOK_INTARRAY(Schedule, piPoolPowerSet)              },
	{ "EpicPowerSet",              TOK_INTARRAY(Schedule, piEpicPowerSet)              },
	{ "Power",                     TOK_INTARRAY(Schedule, piPower)                     },
	{ "AssignableBoost",           TOK_INTARRAY(Schedule, piAssignableBoost)           },
	{ "InspirationCol",            TOK_INTARRAY(Schedule, piInspirationCol)            },
	{ "InspirationRow",            TOK_INTARRAY(Schedule, piInspirationRow)            },
	{ "}",                         TOK_END,    0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseExperienceTable[] =
{
	{ "{",                     TOK_START,  0 },
	{ "ExperienceRequired",    TOK_INTARRAY(ExperienceTable, piRequired)      },
	{ "DefeatPenalty",         TOK_INTARRAY(ExperienceTable, piDefeatPenalty) },
	{ "}",                     TOK_END,    0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseSchedules[] =
{
	{ "{",                TOK_START,  0 },
	{ "Powers",           TOK_EMBEDDEDSTRUCT(Schedules, aSchedules, ParseSchedule)},
	{ "}",                TOK_END,    0 },
	{ "", 0, 0 }
};

TokenizerParseInfo ParseExperienceTables[] =
{
	{ "{",                TOK_START,  0 },
	{ "Powers",           TOK_EMBEDDEDSTRUCT(ExperienceTables, aTables, ParseExperienceTable)},
	{ "}",                TOK_END,    0 },
	{ "", 0, 0 }
};
""".}