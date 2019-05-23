# Run in a prompt
# Build all deps for Opt Debug.. or change passL adding missing libs/syms
# "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat"
# nim c --cc:vcc --cpu:i386 --nimcache:./cache bintool.nim

import parseopt, os, rdstdin, strutils, marshal, streams, re

{.passC: "--vccversion:90 /Zi /Od /DSERVER /I../Game/graphics/FX /I../MapServer/ai /I../Common/gameData /I../Common/auction /I../Common/account /I../MapServer/AutoGen /I../Game/graphics /I../NovodeXWrapper /I../MapServer/language /I../MapServer/gameComm /I../Common/gridcoll /I../MapServer/gameSys /I../MapServer/script/zoneevents /I../MapServer /I../MapServer/script /I../Common/gameComm /I../MapServer/entity /I../Common/cmdparse /I../MapServer/svr /I../MapServer/group /I../libs/UtilitiesLib/language /I../MapServer/generator /I../Game/render /I../Common /I../Common/storyarc /I../MapServer/storyarc /I../MapServer/dbcomm /I../Game/render/thread /I../Common/gameData /I../Common/seq /I../Common/player /I../Common/entity /I../Common/group /I../libs/UtilitiesLib/components /I../libs/UtilitiesLib/network /I../libs/UtilitiesLib/utils /I../libs/UtilitiesLib".}
{.passL: """--vccversion:90 /LTCG Shell32.lib kernel32.lib User32.lib Advapi32.lib Gdi32.lib "../libs/UtilitiesLib/win32/Opt Debug/UtilitiesLib.lib" "../3rdparty/bin/libclient.lib" "../3rdparty/bin/librpc.lib" "../3rdparty/bin/libsupp.lib" "../3rdparty/bin/cryptlibrltcg.lib" "../3rdparty/bin/zlibsrcmrsseltcg.lib" "../3rdparty/bin/zlibsrcmrltcg.lib" """.}

const
  PARSE_SIG = "Parse6"
  SEEK_SET = 0
  # SEEK_CUR = 1
  # SEEK_END = 2

include parseinfo

type
  SimpleBufHandle {.importc: "SimpleBufHandle", header: "serialize.h", pure.} = object
  DefineContext {.importc: "DefineContext", header: "structDefines.h", pure.} = object
  FileList {.importc: "FileList", header: "textparser.h", pure.} = object
  TimeT {.importc: "__time32_t", header: "textparser.h", pure.} = object
  FileListCB = proc(path: cstring, date:TimeT) {.cdecl.}
  
proc serializeReadOpen(fileName, fileType: cstring; build, ignore_crc_difference: cint): SimpleBufHandle {.importc: "SerializeReadOpen", header: "serialize.h".}
proc simpleBufSeek(buf: SimpleBufHandle; offset: clong; origin: cint): cint {.importc: "SimpleBufSeek", header: "serialize.h".}
proc simpleBufTell(buf: SimpleBufHandle): cint {.importc: "SimpleBufTell", header: "serialize.h".}
proc parserCrcFromParseInfo(table: ptr ParseTable; context: ptr DefineContext): cint {.importc: "ParseTableCRC", header: "textparser.h".}
proc fileListRead(list: ptr FileList; file: SimpleBufHandle): cint {.importc: "FileListRead", header: "structInternals.h".}
proc fileListLength(list: ptr FileList): cint {.importc: "FileListLength", header: "structInternals.h".}
proc fileListForEach(list: ptr FileList; cb: FileListCB) {.importc: "FileListForEach", header: "structInternals.h".}
proc parserReadBinaryFile(buf: SimpleBufHandle; fileName: cstring; pti: ptr ParseTable; structptr: pointer; fileList: ptr FileList; defines: ptr DefineContext): cint {.importc: "ParserReadBinaryFile", header: "textparser.h".}
proc parserWriteText(stringBuffer: ptr cstring; pti: ptr ParseTable; structptr: pointer; iOptionFlagsToMatch, iOptionFlagsToExclude: uint32): cint {.importc: "ParserWriteText", header: "textparser.h".}
proc parserWriteBinaryFile(fileName: cstring; pti: ptr ParseTable; structptr: pointer; filelist: ptr FileList; defines: ptr DefineContext; iOptionFlagsToMatch, iOptionFlagsToExclude: uint32): cint {.importc: "ParserWriteBinaryFile", header: "textparser.h".}
proc parserReadText(dataStr: cstring; strLen: cint; pti: ptr ParseTable; memory: pointer): cint {.importc: "ParserReadText", header: "textparser.h".}
proc doCrcThing(hash: uint32; s: cstring): uint32 {.importc: "Crc32cLowerStringHash", header: "textparser.h".}
# proc parserWriteTextEscaped(stringBuffer: ptr cstring; pti: ptr ParseTable; structptr: pointer; iOptionFlagsToMatch, iOptionFlagsToExclude: uint32): cint {.importc: "ParserWriteTextEscaped", header: "textparser.h".}
proc eaSize[T](a: T): cint {.importc: "eaSizeNim", nodecl.}
proc structGetFilename(pti: ptr ParseTable; structptr: pointer): cstring {.importc: "structGetFilename", nodecl.}

proc testcrc() =
  var
    uintcrc = doCrcThing(0, "Hello World ggggggggggggggggggggg")
    intcrc = doCrcThing(0, "Hello World ggggggggggggggggggggg").int32
  echo uintcrc, "\t", "HEX: ", uintcrc.toHex
  echo intcrc, "\t", "HEX: ", intcrc.toHex

testcrc()

var
  filename: string
  outputPath: string
  inputPath: string

for kind, key, val in getopt():
  case kind
  of cmdArgument:
    filename = key
  of cmdLongOption, cmdShortOption:
    case key
    of "output", "o": outputPath = val
    of "input", "i": inputPath = val
  of cmdEnd: assert(false) # cannot happen
if filename == "":
  quit(1)

var
  crc = parserCrcFromParseInfo(groupNamesSaveInfo, nil)
  buf = serializeReadOpen(filename, PARSE_SIG, crc, 1)
  startPos = simpleBufTell(buf)
  fileList: FileList
  regex: Regex

doAssert fileListRead(addr fileList, buf) == 1

echo "Bin file has: ", fileListLength(addr fileList), " files..."
fileListForEach(addr fileList) do (path: cstring, date:TimeT) {.cdecl}:
  echo path

discard simpleBufSeek(buf, startPos, SEEK_SET)

template readAndWriteMultiple(tokenizerBin, tokenizerInner, memAll, memInner: typed; nameFix: string; skipData: bool = false): untyped =
  if outputPath != "":
    if not skipData:
      doAssert parserReadBinaryFile(buf, nil, tokenizerBin, addr memAll, nil, nil) == 1

    # multiples per file, need to clean and 
    for i in 0..<eaSize(memInner):
      let
        fileName = structGetFilename(tokenizerInner, memInner[i])
        fileInfo = ($fileName).splitFile()
        outPath = outputPath / fileInfo.dir
      
      try:
        removeFile(outPath / fileInfo.name & fileInfo.ext)
      except:
        discard

    for i in 0..<eaSize(memInner):
      let
        fileName = structGetFilename(tokenizerInner, memInner[i])
        fileInfo = ($fileName).splitFile()
        outPath = outputPath / fileInfo.dir
      
      createDir(outPath)

      var
        outputStr: cstring
        finalData: string
        finalFile = outPath / fileInfo.name & fileInfo.ext
      doAssert parserWriteText(addr outputStr, tokenizerInner, memInner[i], 0, 0) == 1

      finalData = $outputStr
      # Fix it
      finalData = nameFix & finalData

      if regex != nil:
        finalData = finalData.replace(regex, "")

      if not existsFile(finalFile):
        writeFile(finalFile, "// This file was extracted with bintool.exe by DrVahzilok\r\n\r\n")

      var fstream = newFileStream(finalFile, fmAppend)
      fstream.write(finalData)
      fstream.close()

template readOrWriteBin(tokenizer, mem: typed): untyped =
  if outputPath != "":
    doAssert parserReadBinaryFile(buf, nil, tokenizer, addr mem, nil, nil) == 1
    var
      data: cstring
      finalData: string
    doAssert parserWriteText(addr data, tokenizer, addr mem, 0, 0) == 1
    
    finalData = $data
    if regex != nil:
      finalData = finalData.replace(regex, "")

    finalData = "// This file was extracted with bintool.exe by DrVahzilok\r\n\r\n" & finalData
      
    writeFile(outputPath, finalData)
  elif inputPath != "":
    let
      contents = readFile(inputPath)
      fileInfo = splitFile(filename)
      binOutPath = fileInfo.dir / "new_" & fileInfo.name & fileInfo.ext
    doAssert contents != ""
    doAssert parserReadText(contents, contents.len.cint, tokenizer, addr mem) == 1
    doAssert parserWriteBinaryFile(binOutPath, tokenizer, addr mem, addr fileList, nil, 0, 0) == 1

var
  binFileSplit = splitFile(filename)
  binName = binFileSplit.name.toLowerAscii

case binName
of "powers":
  var powers: PowerDictionary
  readAndWriteMultiple parsePowerDictionary, parseBasePower, powers, powers.ppPowers, "Power"

of "powercats":
  var powers: PowerDictionary
  readAndWriteMultiple parsePowerCatDictionary, parsePowerCategory, powers, powers.ppPowerCategories, "PowerCategory"

of "powersets":
  var powers: PowerDictionary
  readAndWriteMultiple parsePowerSetDictionary, parseBasePowerSet, powers, powers.ppPowerSets, "PowerSet"

of "dim_returns":
  var dimr: DimReturnList
  readOrWriteBin parseDimReturnList, dimr

of "attrib_descriptions":
  var attriblist: AttribCategoryList
  readOrWriteBin parseAttribCategoryList, attriblist

of "defnames":
  var groups: GroupNames
  readOrWriteBin groupNamesSaveInfo, groups

of "arenamaps":
  var maps: ArenaMaps
  readOrWriteBin parseArenaMaps, maps

of "badges":
  var badges: BadgeDefs
  readOrWriteBin parseBadgeDefs, badges

of "supergroup_badges":
  var badges: BadgeDefs
  readOrWriteBin parseBadgeDefs, badges

# of "tricks":
#   var tricks: TrickList
#   regex = re"\t*IgnoreHack\d\s\d+"
#   readOrWriteBin parseTrickList, tricks

of "tricks":
  var
    data: TrickList
  regex = re"\t*IgnoreHack\d\s\d+"
  # readAndWriteMultiple parseTrickList, parseTrick, data, data.tricks, "Trick"
  # readAndWriteMultiple parseTrickList, parseTexOpt, data, data.texopts, "Texture", true
  readAndWriteMultiple parseTrickList, parseTexOpt, data, data.texopts, "Texture"

of "seqstatebits":
  var bits: StateBitList
  readOrWriteBin parseStateBitList, bits

of "mapsspec":
  var maps: MapSpecList
  readOrWriteBin parseMapSpecList, maps

of "mapspecs":
  var maps: MissionMapList
  readOrWriteBin parseMissionMapList, maps

of "missionspecs":
  var maps: MissionSpecFile
  readOrWriteBin parseMissionSpecFile, maps

of "monorails":
  var monorails: MonorailList
  readOrWriteBin parseMonorailList, monorails

of "invsalvage":
  var attriblist: AttribFileDict
  readOrWriteBin parseAttributeItems, attriblist

of "invconcept":
  var attriblist: AttribFileDict
  readOrWriteBin parseAttributeItems, attriblist

of "invrecipe":
  var attriblist: AttribFileDict
  readOrWriteBin parseAttributeItems, attriblist

of "invbasedetail":
  var attriblist: AttribFileDict
  readOrWriteBin parseAttributeItems, attriblist

of "invstoredsalvage":
  var attriblist: AttribFileDict
  readOrWriteBin parseAttributeItems, attriblist

of "fxinfo":
  var fxinfo: FxInfoList
  readOrWriteBin parseFxInfoList, fxinfo

of "ent_types":
  var enttypes: SeqTypeList
  readOrWriteBin parseSeqTypeList, enttypes

of "villaindef":
  var data: VillainGroupList
  readOrWriteBin parseVillainDefBegin, data

of "souvenirclues":
  var data: SouvenirClueList
  readOrWriteBin parseSouvenirClueList, data

of "mapstats":
  var data: MissionMapStatList
  readOrWriteBin parseMissionMapStatList, data

of "minimap":
  var data: MinimapHeaderList
  readOrWriteBin parseArchitectMapHeaderList, data

of "missionspawns":
  var data: MissionGenericSpawns
  readOrWriteBin parseMissionGenericSpawns, data

of "missionhostagespawns":
  var data: MissionGenericSpawns
  readOrWriteBin parseMissionGenericSpawns, data

of "tasksets":
  var data: StoryTaskSetList
  outputPath = outputPath / "Scripts.loc"
  readAndWriteMultiple parseStoryTaskSetList, parseStoryTaskSet, data, data.sets, "TaskSet"

of "loyaltyreward":
  var data: LoyaltyRewardTree
  readOrWriteBin parseAccountLoyaltyRewardTree, data

of "attrib_names":
  var data: AttribNames
  readOrWriteBin parseAttribNames, data

of "visionphases":
  var data: VisionPhaseNames
  readOrWriteBin parseVisionPhaseNamesTable, data

of "visionphasesexclusive":
  var data: VisionPhaseNames
  readOrWriteBin parseVisionPhaseNamesTable, data

of "origins":
  var data: CharacterOrigins
  readOrWriteBin parseCharacterOrigins, data

of "villain_origins":
  var data: CharacterOrigins
  readOrWriteBin parseCharacterOrigins, data

of "pophelp":
  var data: PopHelpDictionary
  readOrWriteBin parsePopHelpDictionary, data

of "combat_mods":
  var data: CombatModsTable
  readOrWriteBin parseCombatModsTable, data

of "combat_mods_villain":
  var data: CombatModsTable
  readOrWriteBin parseCombatModsTable, data

of "damagedecay":
  var data: DamageDecayConfig
  readOrWriteBin parseDamageDecayConfig, data

of "inventory_sizes":
  var data: InventorySizes
  readOrWriteBin parseInventoryDefinitions, data

of "inventory_tier_bonus":
  var data: InventoryLoyaltyBonusSizes
  readOrWriteBin parseInventoryLoyaltyBonusDefinitions, data

of "zone_event_karma":
  var data: ZoneEventKarmaTable
  readOrWriteBin parseZoneEventKarmaTable, data

of "dayjobs":
  var data: DayJobDetailDict
  readOrWriteBin parseDayJobDetailDict, data

of "designer_contact_tip_types":
  var data: DesignerContactTipTypes
  readOrWriteBin parseDesignerContactTipTypes, data

of "incarnate":
  var data: IncarnateMods
  readOrWriteBin parseIncarnateMods, data

of "tut_votekick":
  var data: EndGameRaidKickMods
  readOrWriteBin parseEndGameRaidKickMods, data

of "marty_exp_mods":
  var data: MARTYMods
  readOrWriteBin parseMARTYMods, data

of "newfeatures":
  var data: NewFeatureList
  readOrWriteBin parseNewFeatureList, data

of "customcritterrewardmods":
  var data: PCcCritterRewardMods
  readOrWriteBin parsePCcCritterRewardMods, data
  
of "powersetconversion":
  var data: PowerSetConversionTable
  readOrWriteBin parsePowerSetConversionTable, data

of "auctionconfig":
  var data: AuctionConfig
  readOrWriteBin parseAuctionConfig, data

of "product_catalog":
  var data: AccountCatalogList
  readOrWriteBin parseProductCatalog, data

of "combine_chances":
  var data: ptr ptr float
  readOrWriteBin parseBoostChanceTable, data

of "combine_same_set_chances":
  var data: ptr ptr float
  readOrWriteBin parseBoostChanceTable, data

of "boost_effect_above":
  var data: ptr ptr float
  readOrWriteBin parseBoostEffectivenessTable, data

of "boost_effect_below":
  var data: ptr ptr float
  readOrWriteBin parseBoostEffectivenessTable, data

of "combine_booster_chances":
  var data: ptr ptr float
  readOrWriteBin parseBoostChanceTable, data

of "boost_effect_boosters":
  var data: ptr ptr float
  readOrWriteBin parseBoostEffectivenessTable, data

of "exemplar_handicaps":
  var data: ExemplarHandicaps
  readOrWriteBin parseBoostExemplarTable, data

of "experience":
  var data: ExperienceTables
  readOrWriteBin parseExperienceTables, data

of "schedules":
  var data: Schedules
  readOrWriteBin parseSchedules, data

of "replacepowernames":
  var data: ReplacementHashes
  readOrWriteBin parsePowerReplacements, data

# of "boostsets":
#   # TODO , does not work actually
  
#   # Requires all of powers stuff loaded!
#   var
#     finfo = filename.splitFile()
  
#     bufP =  serializeReadOpen(finfo.dir / "powers.bin", PARSE_SIG, crc, 1)
#     bufPC = serializeReadOpen(finfo.dir / "powercats.bin", PARSE_SIG, crc, 1)
#     bufPS = serializeReadOpen(finfo.dir / "powersets.bin", PARSE_SIG, crc, 1)
  
#   doAssert parserReadBinaryFile(bufP , nil, parsePowerDictionary   , addr globalPowerDictionary, nil, nil) == 1
#   doAssert parserReadBinaryFile(bufPC, nil, parsePowerCatDictionary, addr globalPowerDictionary, nil, nil) == 1
#   doAssert parserReadBinaryFile(bufPS, nil, parsePowerSetDictionary, addr globalPowerDictionary, nil, nil) == 1

#   var data: BoostSetDictionary
#   readOrWriteBin parseBoostSetDictionary, data

of "emotes":
  var data: EmoteAnims
  readOrWriteBin parseEmoteAnims, data

of "petbattlecreatureinfo":
  var data: PetBattleCreatureInfoList
  readOrWriteBin parsePetBattleCreatureInfoList, data

of "classes":
  var data: CharacterClasses
  readOrWriteBin parseCharacterClasses, data

of "villain_classes":
  var data: CharacterClasses
  readOrWriteBin parseCharacterClasses, data

of "villaincostume":
  var data: NPCDefList
  readOrWriteBin parseNPCDefBegin, data

of "villaingroups":
  var data: VillainGroupList
  readOrWriteBin parseVillainGroupBegin, data

of "storyarc":
  var data: StoryArcList
  # readOrWriteBin parseStoryArcList, data
  outputPath = outputPath / "Scripts.loc"
  readAndWriteMultiple parseStoryArcList, parseStoryArc, data, data.storyarcs, "StoryArcDef"

of "contacts":
  var data: ContactList
  # readOrWriteBin parseContactDefList, data
  outputPath = outputPath / "Scripts.loc"
  readAndWriteMultiple parseContactDefList, parseContactDef, data, data.contactdefs, "ContactDef"

of "npcs_server":
  var data: PNPCDefList
  # readOrWriteBin parsePNPCDefList, data
  outputPath = outputPath / "Scripts.loc"
  readAndWriteMultiple parsePNPCDefList, parsePNPCDef, data, data.pnpcdefs, "NPCDef"

of "dialogdefs":
  var data: DialogDefList
  readOrWriteBin parseDialogDefList, data

of "tftimelimits":
  var data: StoryArcTimeLimitList
  outputPath = outputPath / "defs" / "TFTimeLimits.def"
  readOrWriteBin parseStoryArcTimeLimit, data

of "ai_config":
  # TODO VERY BROKEN TXT GENERATION
  var data: AIAllConfigs
  outputPath = outputPath / "AIScript" / "config" / "all.cfg"
  readOrWriteBin parseAllConfigs, data

of "dialog":
  var data: DialogFileList
  # outputPath = outputPath / "defs" / "TFTimeLimits.def"
  readOrWriteBin parseDialogFileList, data


of "spawndefs":
  var data: SpawnDefList
  # outputPath = outputPath / "defs" / "TFTimeLimits.def"
  readOrWriteBin parseSpawnDefList, data

of "scriptdefs":
  var data: ScriptDefList
  # outputPath = outputPath / "defs" / "TFTimeLimits.def"
  readOrWriteBin parseScriptDefList, data

of "particles":
  var data: ParticleInfoList
  # readOrWriteBin particleParseInfo, data
  # outputPath = outputPath / "Scripts.loc"
  readAndWriteMultiple particleParseInfo, systemParseInfo, data, data.list, "System"

