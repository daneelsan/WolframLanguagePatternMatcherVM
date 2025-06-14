Unprotect["DanielS`PatternMatcherVM`*"];
ClearAll["DanielS`PatternMatcherVM`*"];
ClearAll["DanielS`PatternMatcherVM`*`*"];


BeginPackage["DanielS`PatternMatcherVM`"];


PatternBytecode::usage =
    "PatternBytecode[...] represents bytecode for a virtual machine of a given pattern expression.";

PatternToBytecode::usage =
    "PatternToBytecode[patt] converts a pattern expression into bytecode to be run in a virtual machine.";

PatternMatcherVirtualMachine::usage =
    "PatternMatcherVirtualMachine[...] represents a virtual machine that executes pattern bytecode.";

PatternToFunction::usage =
    "PatternToFunction[patt] converts a pattern patt into a Function[...].";


Begin["`Private`"];


(*
	TODO: Remove this hack. CreateMExpr should be independent of the compiler.
*)
FunctionCompile[Function[1]];


Needs["DanielS`PatternMatcherVM`FrontEnd`"]
Needs["DanielS`PatternMatcherVM`BackEnd`"]


End[];


EndPackage[];


SetAttributes[#, {Protected, ReadProtected}] & /@ Evaluate @ Names["DanielS`PatternMatcherVM`*"];
