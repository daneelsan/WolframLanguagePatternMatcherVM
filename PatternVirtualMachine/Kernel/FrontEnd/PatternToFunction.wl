BeginPackage["DanielS`PatternMatcherVM`FrontEnd`PatternToFunction`"];


Begin["`Private`"];


Needs["DanielS`PatternMatcherVM`"] (* for PatternToFunction *)

Needs["CompileAST`Create`Construct`"] (* for CreateMExpr *)


(*=============================================================================
	PatternToFunction
=============================================================================*)
(*
	TODO: Consider renaming to PatternToMatchQFunction.
	If we returned an object with more data, it could be called CompilePatternToFunction.
*)

Options[PatternToFunction] = {
	"ApplyOptimizations" -> True
}

PatternToFunction[patt_, opts:OptionsPattern[]] :=
	Module[{state},
		state = <|
			"VariableCounter" -> CreateDataStructure["Counter", 1],
			"Input" :> patt,
			"CurrentVariable" -> CreateDataStructure["Value", vm`expr$],
			"TestsList" -> CreateDataStructure["DynamicArray"],
			"TestsStack" -> CreateDataStructure["Stack"],
			"Evaluations" -> CreateDataStructure["DynamicArray"],
			"BoundVariables" -> CreateDataStructure["OrderedHashSet"],
			"BoundVariablesMap" -> CreateDataStructure["HashTable"],
			"AssignedVariablesStack" -> CreateDataStructure["Stack"],
			"ApplyOptimizations" -> TrueQ[OptionValue["ApplyOptimizations"]]
		|>;
		visitPattern[state, CreateMExpr[patt]];
		With[{
				moduleVars = getAssignmentVariables[state],
				moduleBody = getFullCondition[state]
			},
			If[state["ApplyOptimizations"] && moduleVars["length"] === 0,
				CreateMExpr @ Function[vm`expr$, moduleBody]
				,
				CreateMExpr @ Function[vm`expr$, Module[moduleVars, moduleBody]]
			]
		]["toExpression"]
	]


(*======================================
	visitPattern
======================================*)

visitPattern[state_, mexpr_] :=
	Which[
		isLiteral[mexpr],
			processLiteral[state, mexpr]
		,
		mexpr["normalQ"],
			Which[
				isPattern[mexpr],
					processPattern[state, mexpr]
				,
				isBlank[mexpr],
					processBlank[state, mexpr]
				,
				isPatternTest[mexpr],
					processPatternTest[state, mexpr]
				,
				isExcept[mexpr],
					processExcept[state, mexpr]
				,
				isAlternatives[mexpr],
					processAlternatives[state, mexpr]
				,
				True,
					processNormal[state, mexpr]
			]
		,
		True,
			(* TODO: Improve error handling *)
			Throw[$Failed]
	]


(*======================================
	isXXXX
======================================*)

isBlank[patt_] :=
	patt["hasHead", Blank] && patt["length"] <= 1


isPattern[patt_] :=
	patt["hasHead", Pattern] && patt["length"] == 2 && patt["part", 1]["symbolQ"]


isPatternTest[patt_] :=
	patt["hasHead", PatternTest] && patt["length"] == 2


isCondition[patt_] :=
	patt["hasHead", Condition] && patt["length"] == 2


isExcept[patt_] :=
	patt["hasHead", Except] && Between[patt["length"], {1, 2}]


isAlternatives[patt_] :=
	patt["hasHead", Alternatives] && patt["length"] >= 1


isLiteral[patt_] :=
	Internal`PatternFreeQ[patt["toHeldExpression"]]


(*======================================
	processPattern
======================================*)
(*
	`Pattern[sym, patt]`
	Pattern needs to be aware of repeated names, in which case a SameQ test needs to be added.
	If the first instance then bind the name to the state["CurrentVariable"].
*)
processPattern[state_, mexpr_] :=
	Module[{sym, patt},
		sym = mexpr["part", 1];
		patt = mexpr["part", 2];
		processPatternWork[state, sym, state["CurrentVariable"]["Get"]];
		visitPattern[state, patt];
	]


processPatternWork[state_, boundSym_, currentExpr_] :=
	Module[{lexicalName, symData},
		lexicalName = boundSym["lexicalName"];
		state["BoundVariables"]["Insert", lexicalName];
		symData = state["BoundVariablesMap"]["Lookup", lexicalName, Null &];
		If[symData === Null,
			state["BoundVariablesMap"]["Insert", lexicalName -> <|"Symbol" -> boundSym, "Expression" -> currentExpr|>];
			(*state["variables"]["appendTo", lexicalName];*)
			,
			addSameQTest[state, symData["Expression"], currentExpr]
		]
	]

(*======================================
	processBlank
======================================*)
(*
	`Blank[]` OR `Blank[f]`
*)
processBlank[state_, mexpr_] :=
	If[mexpr["length"] === 0,
		addTest[state, CreateMExpr[True]]
		,
		With[{var = state["CurrentVariable"]["Get"], head = mexpr["part", 1]},
			addTest[state, CreateMExpr[Head[var] === head]]
		]
	]


(*======================================
	processPatternTest
======================================*)
(*
	`PatternTest[patt, test]`
	TODO: What about something like `__?(TrueQ[And @@ {##}] &)`
*)
processPatternTest[state_, mexpr_] :=
	With[{
		patt = mexpr["part", 1],
		test = mexpr["part", 2],
		var = state["CurrentVariable"]["Get"]
	},
		visitPattern[state, patt];
		addTest[state, CreateMExpr[TrueQ[test[var]]]]
	]


(*======================================
	processExcept
======================================*)
(*
	`Except[notPatt]` or `Except[notPatt, patt]`
*)
processExcept[state_, mexpr_] :=
	Module[{notPatt, patt},
		notPatt = mexpr["part", 1];
		pushTests[state];
		visitPattern[state, notPatt];
		popTests[state, Not, {getFullCondition[state]}];
		If[mexpr["length"] === 2,
			patt = mexpr["part", 2];
			visitPattern[state, patt]
		]
	]


(*======================================
	processAlternatives
======================================*)
(*
	`patt1 | patt2 | ...`
*)
processAlternatives[state_, mexpr_] :=
	Module[{altArgs},
		pushTests[state];
		altArgs =
			Map[
				(visitPattern[state, #]; getFullCondition[state]) &,
				mexpr["arguments"]
			];
		popTests[state, Or, altArgs];
	]


(*======================================
	processLiteral
======================================*)
processLiteral[state_, mexpr_] :=
	addSameQTest[state, state["CurrentVariable"]["Get"], mexpr]


(*======================================
	processNormal
======================================*)
(*
	head[arg1, arg2, ...]
*)
processNormal[state_, mexpr_] :=
	(
		addLengthTest[state, mexpr["length"]];
		addStateElement[state, 0, mexpr["head"]];
		MapIndexed[
			addStateElement[state, #2[[1]], #1] &,
			mexpr["arguments"]
		]
	)


(*======================================
	addStateElement
======================================*)
(*
	addStateElement digs into the inside of an element.
	It creates a new variable, which is set to the head or the part depending whether index is 0 or not.
*)
addStateElement[state_, index_, pattMExpr_] :=
	With[{newVar = newVariable[state], currentVar = state["CurrentVariable"]["Get"]},
		state["Evaluations"]["Append",
			If[index === 0,
				CreateMExpr[newVar = Head[currentVar]]
				,
				CreateMExpr[newVar = Part[currentVar, index]]
			]
		];
		state["CurrentVariable"]["Set", newVar];
		visitPattern[state, pattMExpr];
		state["CurrentVariable"]["Set", currentVar];
	];


(*======================================
	getFullCondition
======================================*)
getFullCondition[state_] :=
	Module[{condList},
		condList = Function[{tests},
			If[Length[tests] === 1, tests[[1]], Apply[CreateMExpr[CompoundExpression[##]] &][tests]]
		] /@ state["TestsList"]["Elements"];
		state["TestsList"]["DropAll"];
		If[state["ApplyOptimizations"] && Length[condList] === 1,
			condList[[1]]
			,
			Apply[CreateMExpr[And[##]] &][condList]
		]
	]


(*======================================
	addLengthTest
======================================*)
addLengthTest[state_, len_] :=
	With[{var = state["CurrentVariable"]["Get"]},
		addTest[state, CreateMExpr[Length[var] === len]]
	]


(*======================================
	addSameQTest
======================================*)
addSameQTest[state_, lhs_, rhs_] :=
	addTest[state, CreateMExpr[lhs === rhs]]


(*======================================
	addTest
======================================*)
addTest[state_, test_] :=
	Module[{evals},
		evals = Flatten[{state["Evaluations"]["Elements"], test}];
		state["TestsList"]["Append", evals];
		state["Evaluations"]["DropAll"];
	]


(*======================================
	pushTests
======================================*)
pushTests[state_] :=
	(
		state["TestsStack"]["Push", state["TestsList"]["Elements"]];
		state["TestsList"]["DropAll"]
	)


(*======================================
	popTests
======================================*)
popTests[state_, head_, args_List] :=
	Module[{currentTest, oldTests},
		oldTests = state["TestsStack"]["Pop"];
		Assert[state["TestsList"]["Length"] === 0];
		state["TestsList"]["JoinBack", oldTests];
		currentTest = Apply[CreateMExpr[head[##]] &, args];
		state["TestsList"]["Append", currentTest];
	]


(*======================================
	getAssignmentVariables
======================================*)
getAssignmentVariables[state_] :=
	With[{vars = state["AssignedVariablesStack"]["Elements"][[All, "Variable"]]},
		CreateMExpr[vars]
	]


(*======================================
	newVariable
======================================*)
newVariable[state_] :=
	With[{var = makeVariable[state]},
		addAssignment[state, var, Null];
		var
	]


(*======================================
	addAssignment
======================================*)
(*
	Add an assignment, this will show up in the Module of the outer function.
	A value of Null means there is no top-level assignment.
*)
addAssignment[state_, var_, val_] :=
	state["AssignedVariablesStack"]["Push", <|"Variable" -> var, "Value" -> val|>]


(*======================================
	makeVariable
======================================*)
makeVariable[state_] :=
	CreateMExprSymbolEval[Symbol["var" <> ToString[state["VariableCounter"]["Increment"]]]]


End[];


EndPackage[];
