BeginPackage["DanielS`PatternMatcherVM`BackEnd`Bytecode`"]


CreatePatternBytecode::usage =
    "CreatePatternBytecode[assoc] creates the PatternBytecode[...] object.";


PatternBytecodeQ::usage =
    "PatternBytecodeQ[x] returns True if x is a valid PatternBytecode[...] object, and False otherwise."


Begin["`Private`"]


Needs["DanielS`PatternMatcherVM`"]


(*=============================================================================
    CreatePatternBytecode
=============================================================================*)

CreatePatternBytecode[pattern_?Internal`PatternPresentQ, byteArray_?ByteArrayQ, assoc_Association] :=
    System`Private`SetValid @
        PatternBytecode[<|
            "Pattern" -> pattern,
            "Bytecode" -> byteArray,
            assoc
        |>];

CreatePatternBytecode[__] :=
    $Failed;


(*=============================================================================
    PatternBytecodeQ
=============================================================================*)

PatternBytecodeQ[x_PatternBytecode] :=
    System`Private`ValidQ[Unevaluated[x]];

PatternBytecodeQ[_] :=
    False;


(*=============================================================================
    PatternBytecode
=============================================================================*)

PatternBytecode /: (obj_PatternBytecode)["Properties"] /; PatternBytecodeQ[obj] :=
    {
        "Bytecode",
        "Pattern"
    };

PatternBytecode /: (obj:PatternBytecode[assoc_])["Pattern"] /; PatternBytecodeQ[obj] :=
    assoc["Pattern"];

PatternBytecode /: (obj:PatternBytecode[assoc_])["Bytecode"] /; PatternBytecodeQ[obj] :=
    assoc["Bytecode"];

PatternBytecode /: (obj:PatternBytecode[assoc_])["Part", n_Integer] /; PatternBytecodeQ[obj] :=
    assoc["Bytecode"][[n]];


PatternBytecode /: Normal[obj_PatternBytecode] /; PatternBytecodeQ[obj] :=
    obj["Pattern"];


PatternBytecode /: MakeBoxes[obj_PatternBytecode, fmt_] /; PatternBytecodeQ[obj] :=
    Module[{pattern, byteArray},
        pattern = obj["Pattern"];
        byteArray = obj["Bytecode"];
        BoxForm`ArrangeSummaryBox[
            "PatternBytecode",
            obj,
            None,
            {
                BoxForm`SummaryItem[{"Pattern: ", ClickToCopy[pattern]}]
            },
            {
                BoxForm`SummaryItem[{"Pattern: ", ClickToCopy[pattern]}],
                BoxForm`SummaryItem[{"Bytecode: ", ClickToCopy[byteArray]}]
            }, 
            fmt,
            "CompleteReplacement" -> True
        ]
    ];


End[]


EndPackage[]
