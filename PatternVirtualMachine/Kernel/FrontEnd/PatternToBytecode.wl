BeginPackage["DanielS`PatternMatcherVM`FrontEnd`PatternToBytecode`"]


Begin["`Private`"]


Needs["DanielS`PatternMatcherVM`ErrorHandling`"] (* for PatternToBytecode *)
Needs["DanielS`PatternMatcherVM`BackEnd`Bytecode`"] (* for CreatePatternBytecode *)
Needs["DanielS`PatternMatcherVM`"] (* for PatternToBytecode *)


(*=============================================================================
    PatternToBytecode
=============================================================================*)

PatternToBytecode[patt_] :=
    Module[{},
        If[Internal`PatternFreeQ[patt],
            ThrowFailure["NotAPattern", "The expression `Input` is not a valid pattern.", <|"Input" -> patt|>]
        ];
        (* TODO: Placeholder *)
        CreatePatternBytecode[patt, ByteArray[ConstantArray[0, 255]], <||>]
    ]


End[]


EndPackage[]
