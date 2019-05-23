# bintool

## A very hacky tool to unpack CoX packed bins and such.

## Setup:

Just needs nim and vs2008 in my case.
You definitely need to edit in `bintool.nim` the `passC` and `passL` to fit your build includes/libs, vc version.

## How to add a new `.bin`:

Run the command without any options, just the bin file you wanna extract, to dump file list

`bitool.exe mybin.bin`

This will tell you how to approach the next step:

### If it's a single file:

Example:
```
of "dialogdefs":
  var data: DialogDefList
  readOrWriteBin parseDialogDefList, data
```

if your bin is `mybin.bin`

replace `of "dialogdefs"` with `of "mybin"`

figure out what token structs you need from .c files and past them somewhere/ create a new file in tokens (see tokens and parseinfo)

add them in `parseinfo.nim`, generally in this case you just need for example:

```
// Global DialogDefs
typedef struct DialogDefList
{
	const DialogDef**	dialogs;
	cStashTable			haDialogCRCs;
} DialogDefList;

TokenizerParseInfo ParseDialogDefList[] = {
	{ "Dialog",		TOK_STRUCT(DialogDefList,dialogs,ParseDialogDef) },
	{ "", 0, 0 }
};
```

given this C code you need to create a `DialogDefList` stub pure type

`DialogDefList {.importc: "DialogDefList", pure.} = object`

and the static parser var:

`parseDialogDefList {.importc: "ParseDialogDefList", nodecl.}: ptr ParseTable`

good to go, now build and run with a `-o:filename` option

### If it's multiple files:

Same steps as single files but you need 2 more things...

example:

```
of "particles":
  var data: ParticleInfoList
  # readOrWriteBin particleParseInfo, data
  # outputPath = outputPath / "Scripts.loc"
  readAndWriteMultiple particleParseInfo, systemParseInfo, data, data.list, "System"
```

as you can see we also need the inner struct, which represents a single record in many of the extracted files...

in this case `systemParseInfo` and `data.list` type

if you check `parseinfo.nim`:

```
ParticleInfoList {.importc: "ParticleInfoList", pure.} = object
    list: ptr UncheckedArray[ptr SystemParseInfo]
```

we add a member to this type, nim internally doesn't care that the struct is not complete btw, this is just sugar.


## Known issues

Nim compiler might freeze if some C related error happens,
in such case check `cache` folder for `bintool.c`, copy paste the actual full compiler command line and run that manually, should reveal the actual c compiler error.

## Source modifications I did (might have missed some)

### `missionspec.c` modifications
```
diff --git a/MapServer/storyarc/missionspec.c b/MapServer/storyarc/missionspec.c
index 4570d70..e1d5d89 100644
--- a/MapServer/storyarc/missionspec.c
+++ b/MapServer/storyarc/missionspec.c
@@ -58,8 +58,8 @@ TokenizerParseInfo ParseMapMissionSpec[] =
 	{	"}",		TOK_END },
 
 	// vars from ParseSetMissionSpec have to be here to get written..
-	{	"",			TOK_INT(MissionSpec, mapSet,0)	},
-	{	"",			TOK_INT(MissionSpec, mapSetTime,0)	},
+	{	"MapSet",			TOK_INT(MissionSpec, mapSet,0), ParseMapSetEnum	},
+	{	"MapSetTime",			TOK_INT(MissionSpec, mapSetTime,0)	},
 	{	"", 0, 0 }
 };
 ```

 ### Generally I run with this, but might not be needed depending on your branch:
 ```
 diff --git a/libs/UtilitiesLib/utils/file.c b/libs/UtilitiesLib/utils/file.c
index da47d08..bce0da5 100644
--- a/libs/UtilitiesLib/utils/file.c
+++ b/libs/UtilitiesLib/utils/file.c
@@ -3009,7 +3009,7 @@ int fileIsUsingDevData(void) { // Returns 1 if we're in development mode, 0 if i
 // and after command line parameters are parsed which will change the
 // value of g_force_production_mode.
 // CoC we only got bins.. this makes our life easier, must be set to 0 when generating bins!
-int g_force_production_mode = 1;
+int g_force_production_mode = 0;
 int g_force_qa_mode = 0;
 int isDevelopmentMode(void)
 {
```

### Textparser definitely needs this fix also:
```
diff --git a/libs/UtilitiesLib/utils/textparser.c b/libs/UtilitiesLib/utils/textparser.c
index 6f40b21..b83fb49 100644
--- a/libs/UtilitiesLib/utils/textparser.c
+++ b/libs/UtilitiesLib/utils/textparser.c
@@ -5364,6 +5364,7 @@ void condrgb_writetext(FILE* out, ParseTable tpi[], int column, void* structptr,
 	WriteUInt(out, c->g, 0, 0, tpi[column].subtable);
 	WriteString(out, ", ", 0, 0);
 	WriteUInt(out, c->b, 0, 0, tpi[column].subtable);
+	WriteString(out, "", 0, 1);
 }
 
 void vec3_applydynop(ParseTable tpi[], int column, void* dstStruct, void* srcStruct, int index, DynOpType optype, const F32* values, U8 uiValuesSpecd, U32* seed)
```

### Might need to mute translation errors too:
```
diff --git a/libs/UtilitiesLib/language/MessageStore.c b/libs/UtilitiesLib/language/MessageStore.c
index 6ec78a8..74fc9f5 100644
--- a/libs/UtilitiesLib/language/MessageStore.c
+++ b/libs/UtilitiesLib/language/MessageStore.c
@@ -55,7 +55,7 @@ typedef struct ExtendedTextMessage {
 int						msPrintfError;	// True when the messageID is unknown.
 static MessageStore*	cmdMessages;
 static U8				UTF8BOM[] = {0xEF, 0xBB, 0xBF};
-static int				hideTranslationErrors;
+static int				hideTranslationErrors = 1; // CoC default to hide
 
 typedef struct MessageStore {
 	int								localeID;					// locale ID corresponding to those in AppLocale.h
```