BeginPackage["DanielS`PatternMatcherVM`BackEnd`VirtualMachine`"]


CreatePatternMatcherVirtualMachine::usage =
    "";

PatternMatcherExecute::usage =
    "";


Begin["`Private`"]


Needs["DanielS`PatternMatcherVM`BackEnd`Bytecode`"]
Needs["DanielS`PatternMatcherVM`"]


(*=============================================================================
    CreatePatternMatcherVirtualMachine
=============================================================================*)

CreatePatternMatcherVirtualMachine[bytecode_?PatternBytecodeQ] :=
    System`Private`SetValid @
        PatternMatcherVirtualMachine[<|
            "ProgramCounter" -> CreateDataStructure["Counter", 0],
            "PatternBytecode" -> bytecode,
            "Stack" -> CreateDataStructure["Stack", 256],
            "CurrentExpression" -> CreateDataStructure["Value", Undefined],
            "Halt" -> CreateDataStructure["Value", False]
        |>];

CreatePatternMatcherVirtualMachine[__] :=
    $Failed;


(*=============================================================================
    PatternMatcherVirtualMachineQ
=============================================================================*)

PatternMatcherVirtualMachineQ[x_PatternMatcherVirtualMachine] :=
    System`Private`ValidQ[Unevaluated[x]];

PatternMatcherVirtualMachineQ[_] :=
    False;


(*=============================================================================
    PatternMatcherVirtualMachine
=============================================================================*)

PatternMatcherVirtualMachine /: (obj_PatternMatcherVirtualMachine)["Properties"] /; PatternMatcherVirtualMachineQ[obj] :=
    {
        "ProgramCounter",
        "PatternBytecode",
        "Stack"
    };

PatternMatcherVirtualMachine /: (obj:PatternMatcherVirtualMachine[assoc_])["ProgramCounter"] /; PatternMatcherVirtualMachineQ[obj] :=
    assoc["ProgramCounter"];

PatternMatcherVirtualMachine /: (obj:PatternMatcherVirtualMachine[assoc_])["PatternBytecode"] /; PatternMatcherVirtualMachineQ[obj] :=
    assoc["PatternBytecode"];

PatternMatcherVirtualMachine /: (obj:PatternMatcherVirtualMachine[assoc_])["Registers"] /; PatternMatcherVirtualMachineQ[obj] :=
    assoc["Stack"];


PatternMatcherVirtualMachine /: Normal[obj:PatternMatcherVirtualMachine[assoc_]] /; PatternMatcherVirtualMachineQ[obj] :=
    assoc;


PatternMatcherVirtualMachine /: MakeBoxes[obj_PatternMatcherVirtualMachine, fmt_] /; PatternMatcherVirtualMachineQ[obj] :=
    Module[{pc, bytecode, stack},
        pc = obj["ProgramCounter"]["Get"];
        bytecode = obj["PatternBytecode"];
        stack = obj["Stack"]["Elements"];
        BoxForm`ArrangeSummaryBox[
            "PatternMatcherVirtualMachine",
            obj,
            None,
            {
                BoxForm`SummaryItem[{"Program counter: ", pc}]
            },
            {
                BoxForm`SummaryItem[{"Stack: ", stack}],
                BoxForm`SummaryItem[{"Pattern bytecode: ", bytecode}]
            }, 
            fmt
        ]
    ];


(*=============================================================================
    PatternMatcherExecute
=============================================================================*)

PatternMatcherExecute[vm_?PatternMatcherVirtualMachineQ, expr_] :=
    Module[{},
        vm["CurrentExpression"]["Set", expr];
        While[!vm["Halt"],
            PatternMatcherStep[vm]
        ]
    ];


(*=============================================================================
    PatternMatcherStep
=============================================================================*)

PatternMatcherStep[vm_?PatternMatcherVirtualMachineQ] :=
    Module[{expr, opcode},
        expr = vm["CurrentExpression"]["Get"];
        opcode = fetch[vm];
        execute[opcode][vm, expr]
    ];


fetch[vm_] :=
    Module[{data},
        data = vm["PatternBytecode"]["Part", vm["ProgramCounter"]["Get"]];
        vm["ProgramCounter"]["Increment"];
        data
    ];


execute["MATCH_HEAD"][vm_, expr_] :=
    Module[{tgtHead},
        tgtHead = vm["Stack"]["Pop"];
        Head[expr] === tgtHead
    ];


End[]


EndPackage[]
