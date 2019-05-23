# This file creates the nim bridge between C basically
# Notice *include* and not *import*, this means the following token files are inlined
# Tokens are a mess but they use nim emit power for speed/hack/productivity
# They are basically copy pasted (and sometimes slightly modified) from .c files

include tokens/misc
include tokens/powers
include tokens/attribs
include tokens/badges
include tokens/tricks
include tokens/mapstats
include tokens/mapsspec
include tokens/missionspecs
include tokens/fxinfo
include tokens/seqtype
include tokens/villaindef
include tokens/cutscene
include tokens/encounter
include tokens/reward
include tokens/missiondef
include tokens/taskdef
include tokens/accountdata
include tokens/load_def
include tokens/auction
include tokens/accountcatalog
include tokens/power_system
include tokens/chat_emote
include tokens/classes
include tokens/costume
include tokens/contactdef
include tokens/pnpccommon
include tokens/entaiInstance
include tokens/particle

type
  ParseTable {.importc: "ParseTable", header: "textparser.h", pure.} = object

  GroupNames {.importc: "GroupNames", pure.} = object
    group_files: pointer
    group_libnames: pointer

  ArenaMap {.importc: "ArenaMap", header: "arenastruct.h", pure.} = object
    mapname: cstring
    displayName: cstring
    minplayers: cint
    maxplayers: cint

  ArenaMaps {.importc: "ArenaMaps", header: "arenastruct.h", pure.} = object
    maps: ptr UncheckedArray[ptr ArenaMap]

  PowerCategory {.importc: "PowerCategory", header: "powers.h", pure.} = object
    pchName: cstring
    pchDisplayName: cstring
    pchDisplayHelp: cstring
    pchDisplayShortHelp: cstring
    pchSourceFile: cstring
    ppPowerSets: ptr UncheckedArray[ptr BasePowerSet]
    ppPowerSetNames: ptr UncheckedArray[cstring]

  BasePowerSet {.importc: "BasePowerSet", header: "powers.h", pure.} = object
    pchSourceFile: cstring

  BasePower {.importc: "BasePower", header: "powers.h", pure.} = object

  PowerDictionary {.importc: "PowerDictionary", header: "powers.h", pure.} = object
    ppPowerCategories: ptr UncheckedArray[ptr PowerCategory]
    ppPowerSets: ptr UncheckedArray[ptr BasePowerSet]
    ppPowers: ptr UncheckedArray[ptr BasePower]

  AttribCategoryList {.importc: "AttribCategoryList", header: "powers.h", pure.} = object

  BadgeDefs {.importc: "BadgeDefs", header: "badges.h", pure.} = object

  TrickList {.importc: "TrickList", pure.} = object
    tricks: ptr UncheckedArray[ptr TrickInfo]
    texopts: ptr UncheckedArray[ptr TexOpt]

  TrickInfo {.importc: "TrickInfo", pure.} = object

  TexOpt {.importc: "TexOpt", pure.} = object

  DimReturnList {.importc: "DimReturnList", pure.} = object

  StateBitList {.importc: "StateBitList", pure.} = object

  MapSpecList {.importc: "MapSpecList", pure.} = object

  MissionSpecFile {.importc: "MissionSpecFile", pure.} = object

  MonorailList {.importc: "MonorailList", pure.} = object

  AttribFileDict {.importc: "AttribFileDict", header: "character_inventory.h", pure.} = object

  FxInfoList {.importc: "FxInfoList", pure.} = object

  SeqTypeList {.importc: "SeqTypeList", pure.} = object

  VillainGroupList {.importc: "VillainGroupList", pure.} = object

  VillainDefList {.importc: "VillainDefList", pure.} = object

  SouvenirClueList {.importc: "SouvenirClueList", pure.} = object

  MissionMapStatList {.importc: "MissionMapStatList", pure.} = object

  MinimapHeaderList {.importc: "MinimapHeaderList", pure.} = object

  MissionMapList {.importc: "MissionMapList", pure.} = object

  MissionGenericSpawns {.importc: "MissionGenericSpawns", pure.} = object

  StoryTaskSet {.importc: "StoryTaskSet", header: "storyarcprivate.h", pure.} = object

  StoryTaskSetList {.importc: "StoryTaskSetList", pure.} = object
    sets: ptr UncheckedArray[ptr StoryTaskSet]

  LoyaltyRewardTree {.importc: "LoyaltyRewardTree", pure.} = object

  AttribNames {.importc: "AttribNames", pure.} = object

  VisionPhaseNames {.importc: "VisionPhaseNames", pure.} = object

  CharacterOrigins {.importc: "CharacterOrigins", pure.} = object

  PopHelpDictionary {.importc: "PopHelpDictionary", pure.} = object

  CombatModsTable {.importc: "CombatModsTable", pure.} = object

  DamageDecayConfig {.importc: "DamageDecayConfig", pure.} = object

  InventorySizes {.importc: "InventorySizes", pure.} = object

  InventoryLoyaltyBonusSizes {.importc: "InventoryLoyaltyBonusSizes", pure.} = object

  ZoneEventKarmaTable {.importc: "ZoneEventKarmaTable", pure.} = object

  DayJobDetailDict {.importc: "DayJobDetailDict", pure.} = object

  DesignerContactTipTypes {.importc: "DesignerContactTipTypes", pure.} = object

  IncarnateMods {.importc: "IncarnateMods", pure.} = object

  EndGameRaidKickMods {.importc: "EndGameRaidKickMods", pure.} = object

  MARTYMods {.importc: "MARTYMods", pure.} = object

  NewFeatureList {.importc: "NewFeatureList", pure.} = object

  PCcCritterRewardMods {.importc: "PCC_CritterRewardMods", pure.} = object

  PowerSetConversionTable {.importc: "PowerSetConversionTable", pure.} = object

  AuctionConfig {.importc: "AuctionConfig", pure.} = object

  AccountCatalogList {.importc: "AccountCatalogList", pure.} = object

  ExemplarHandicaps {.importc: "ExemplarHandicaps", pure.} = object

  ExperienceTables {.importc: "ExperienceTables", pure.} = object

  Schedules {.importc: "Schedules", pure.} = object

  ReplacementHashes {.importc: "ReplacementHashes", pure.} = object

  BoostSetDictionary {.importc: "BoostSetDictionary", pure.} = object

  EmoteAnims {.importc: "EmoteAnims", pure.} = object

  PetBattleCreatureInfoList {.importc: "PetBattleCreatureInfoList", pure.} = object

  CharacterClasses {.importc: "CharacterClasses", pure.} = object

  SalvageDictionary {.importc: "SalvageDictionary", pure.} = object

  NPCDefList {.importc: "NPCDefList", pure.} = object

  StoryArcList {.importc: "StoryArcList", pure.} = object
    storyarcs: ptr UncheckedArray[ptr StoryArc]

  StoryArc {.importc: "StoryArc", pure.} = object

  ContactList {.importc: "ContactList", pure.} = object
    contactdefs: ptr UncheckedArray[ptr ContactDef]

  ContactDef {.importc: "ContactDef", pure.} = object

  PNPCDefList {.importc: "PNPCDefList", pure.} = object
    pnpcdefs: ptr UncheckedArray[ptr PNPCDef]

  PNPCDef {.importc: "PNPCDef", pure.} = object

  DialogDefList {.importc: "DialogDefList", pure.} = object

  StoryArcTimeLimitList {.importc: "StoryArcTimeLimitList", pure.} = object

  AIAllConfigs {.importc: "AIAllConfigs", pure.} = object
    configs: ptr UncheckedArray[pointer]
    powerGroups: ptr UncheckedArray[pointer]

  DialogFileList {.importc: "DialogFileList", pure.} = object

  SpawnDefList {.importc: "SpawnDefList", pure.} = object

  ScriptDefList {.importc: "ScriptDefList", pure.} = object

  ParticleInfoList {.importc: "ParticleInfoList", pure.} = object
    list: ptr UncheckedArray[ptr SystemParseInfo]

  SystemParseInfo {.importc: "SystemParseInfo", pure.} = object
  
var
  groupNamesSaveInfo {.importc: "GroupNamesSaveInfo", nodecl.}: ptr ParseTable
  parseArenaMaps {.importc: "ParseArenaMaps", nodecl.}: ptr ParseTable
  parsePowerDictionary {.importc: "ParsePowerDictionary", nodecl.}: ptr ParseTable
  parseAttribCategoryList {.importc: "ParseAttribCategoryList", nodecl.}: ptr ParseTable
  parseBadgeDefs {.importc: "ParseBadgeDefs", nodecl.}: ptr ParseTable
  parseTrickList {.importc: "parse_trick_list", nodecl.}: ptr ParseTable
  parseTrick {.importc: "parse_trick", nodecl.}: ptr ParseTable
  parseTexOpt {.importc: "parse_tex_opt", nodecl.}: ptr ParseTable
  parsePowerCatDictionary {.importc: "ParsePowerCatDictionary", nodecl.}: ptr ParseTable
  parsePowerSetDictionary {.importc: "ParsePowerSetDictionary", nodecl.}: ptr ParseTable
  parseDimReturnList {.importc: "ParseDimReturnList", nodecl.}: ptr ParseTable
  parseBasePowerSet {.importc: "ParseBasePowerSet", nodecl.}: ptr ParseTable
  parseBasePower {.importc: "ParseBasePower", nodecl.}: ptr ParseTable
  parsePowerCategory {.importc: "ParsePowerCategory", nodecl.}: ptr ParseTable
  parseStateBitList {.importc: "ParseStateBitList", nodecl.}: ptr ParseTable
  parseMapSpecList {.importc: "ParseMapSpecList", nodecl.}: ptr ParseTable
  parseMissionSpecFile {.importc: "ParseMissionSpecFile", nodecl.}: ptr ParseTable
  parseMonorailList {.importc: "ParseMonorailList", nodecl.}: ptr ParseTable
  parseAttributeItems {.importc: "ParseAttributeItems", nodecl.}: ptr ParseTable
  parseFxInfoList {.importc: "ParseFxInfoList", nodecl.}: ptr ParseTable
  parseSeqTypeList {.importc: "ParseSeqTypeList", nodecl.}: ptr ParseTable
  parseVillainGroupBegin {.importc: "ParseVillainGroupBegin", nodecl.}: ptr ParseTable
  parseVillainDefBegin {.importc: "ParseVillainDefBegin", nodecl.}: ptr ParseTable
  parseSouvenirClueList {.importc: "ParseSouvenirClueList", nodecl.}: ptr ParseTable
  parseMissionMapStatList {.importc: "parse_MissionMapStatList", nodecl.}: ptr ParseTable
  parseArchitectMapHeaderList {.importc: "parse_ArchitectMapHeaderList", nodecl.}: ptr ParseTable
  parseMissionMapList {.importc: "ParseMissionMapList", nodecl.}: ptr ParseTable
  parseMissionGenericSpawns {.importc: "ParseMissionGenericSpawns", nodecl.}: ptr ParseTable
  parseStoryTaskSet {.importc: "ParseStoryTaskSet", nodecl.}: ptr ParseTable
  parseStoryTaskSetList {.importc: "ParseStoryTaskSetList", nodecl.}: ptr ParseTable
  parseAccountLoyaltyRewardTree {.importc: "parse_AccountLoyaltyRewardTree", nodecl.}: ptr ParseTable
  parseAttribNames {.importc: "ParseAttribNames", nodecl.}: ptr ParseTable
  parseVisionPhaseNamesTable {.importc: "ParseVisionPhaseNamesTable", nodecl.}: ptr ParseTable
  parseCharacterOrigins {.importc: "ParseCharacterOrigins", nodecl.}: ptr ParseTable
  parsePopHelpDictionary {.importc: "ParsePopHelpDictionary", nodecl.}: ptr ParseTable
  parseCombatModsTable {.importc: "ParseCombatModsTable", nodecl.}: ptr ParseTable
  parseDamageDecayConfig {.importc: "ParseDamageDecayConfig", nodecl.}: ptr ParseTable
  parseInventoryDefinitions {.importc: "ParseInventoryDefinitions", nodecl.}: ptr ParseTable
  parseInventoryLoyaltyBonusDefinitions {.importc: "ParseInventoryLoyaltyBonusDefinitions", nodecl.}: ptr ParseTable
  parseZoneEventKarmaTable {.importc: "ParseZoneEventKarmaTable", nodecl.}: ptr ParseTable
  parseDayJobDetailDict {.importc: "ParseDayJobDetailDict", nodecl.}: ptr ParseTable
  parseDesignerContactTipTypes {.importc: "ParseDesignerContactTipTypes", nodecl.}: ptr ParseTable
  parseIncarnateMods {.importc: "ParseIncarnateMods", nodecl.}: ptr ParseTable
  parseEndGameRaidKickMods {.importc: "ParseEndGameRaidKickMods", nodecl.}: ptr ParseTable
  parseMARTYMods {.importc: "ParseMARTYMods", nodecl.}: ptr ParseTable
  parseNewFeatureList {.importc: "ParseNewFeatureList", nodecl.}: ptr ParseTable
  parsePCcCritterRewardMods {.importc: "ParsePCC_CritterRewardMods", nodecl.}: ptr ParseTable
  parsePowerSetConversionTable {.importc: "ParsePowerSetConversionTable", nodecl.}: ptr ParseTable
  parseAuctionConfig {.importc: "ParseAuctionConfig", nodecl.}: ptr ParseTable
  parseProductCatalog {.importc: "parse_ProductCatalog", nodecl.}: ptr ParseTable
  parseBoostChanceTable {.importc: "ParseBoostChanceTable", nodecl.}: ptr ParseTable
  parseBoostEffectivenessTable {.importc: "ParseBoostEffectivenessTable", nodecl.}: ptr ParseTable
  parseBoostExemplarTable {.importc: "ParseBoostExemplarTable", nodecl.}: ptr ParseTable
  parseExperienceTables {.importc: "ParseExperienceTables", nodecl.}: ptr ParseTable
  parseSchedules {.importc: "ParseSchedules", nodecl.}: ptr ParseTable
  parsePowerReplacements {.importc: "ParsePowerReplacements", nodecl.}: ptr ParseTable
  parseBoostSetDictionary {.importc: "ParseBoostSetDictionary", nodecl.}: ptr ParseTable
  globalPowerDictionary {.importc: "g_PowerDictionary", nodecl.}: PowerDictionary
  parseEmoteAnims {.importc: "ParseEmoteAnims", nodecl.}: ptr ParseTable
  parsePetBattleCreatureInfoList {.importc: "ParsePetBattleCreatureInfoList", nodecl.}: ptr ParseTable
  parseCharacterClasses {.importc: "ParseCharacterClasses", nodecl.}: ptr ParseTable
  parseSalvageDictionary {.importc: "ParseSalvageDictionary", nodecl.}: ptr ParseTable
  parseNPCDefBegin {.importc: "ParseNPCDefBegin", nodecl.}: ptr ParseTable
  parseStoryArcList {.importc: "ParseStoryArcList", nodecl.}: ptr ParseTable
  parseStoryArc {.importc: "ParseStoryArc", nodecl.}: ptr ParseTable
  parseContactDefList {.importc: "ParseContactDefList", nodecl.}: ptr ParseTable
  parseContactDef {.importc: "ParseContactDef", nodecl.}: ptr ParseTable
  parsePNPCDefList {.importc: "ParsePNPCDefList", nodecl.}: ptr ParseTable
  parsePNPCDef {.importc: "ParsePNPCDef", nodecl.}: ptr ParseTable
  parseDialogDefList {.importc: "ParseDialogDefList", nodecl.}: ptr ParseTable
  parseStoryArcTimeLimit {.importc: "ParseStoryArcTimeLimit", nodecl.}: ptr ParseTable
  parseAllConfigs {.importc: "parseAllConfigs", nodecl.}: ptr ParseTable
  parseAllConfigs2 {.importc: "parseAllConfigs2", nodecl.}: ptr ParseTable
  parseConfig {.importc: "parseConfig", nodecl.}: ptr ParseTable
  parsePowerGroup {.importc: "parsePowerGroup", nodecl.}: ptr ParseTable
  parseDialogFileList {.importc: "ParseDialogFileList", nodecl.}: ptr ParseTable
  parseSpawnDefList {.importc: "ParseSpawnDefList", nodecl.}: ptr ParseTable
  parseScriptDefList {.importc: "ParseScriptDefList", nodecl.}: ptr ParseTable
  particleParseInfo {.importc: "ParticleParseInfo", nodecl.}: ptr ParseTable
  systemParseInfo {.importc: "SystemParseInfo", nodecl.}: ptr ParseTable
  
  