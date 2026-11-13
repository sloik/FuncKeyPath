------------------------- MODULE FuncKeyPathLaws -------------------------
(* Finite model of Sources/FuncKeyPath: the prefix operator                *)
(*   ^ : KeyPath<Root, Value> -> (Root) -> Value  =  { root in root[keyPath: kp] } *)
(* A KeyPath is abstracted as a total function Root -> Value (its read      *)
(* semantics). Appending key paths is function composition.                 *)
EXTENDS Naturals

CONSTANTS Roots, Mids, Vals,   \* small enumerated carriers
          Mutant

KPs1 == [Roots -> Mids]
KPs2 == [Mids -> Vals]
Subscript(r, kp) == kp[r]                 \* root[keyPath: kp]
Append(a, b) == [r \in Roots |-> b[a[r]]] \* a.appending(path: b)

\* FuncKeyPath.swift
Caret(kp) ==
  CASE Mutant = "caret_constant" ->
         [r \in DOMAIN kp |-> kp[CHOOSE x \in DOMAIN kp : TRUE]]
    [] Mutant = "caret_zero_aliased" ->
         [r \in DOMAIN kp |-> IF r = 0 THEN kp[1] ELSE kp[r]]
    [] OTHER -> [r \in DOMAIN kp |-> kp[r]]

VARIABLES a, b
Init == a \in KPs1 /\ b \in KPs2
Next == UNCHANGED <<a, b>>
Spec == Init /\ [][Next]_<<a, b>>

TypeOK == a \in KPs1 /\ b \in KPs2
CaretAppliesKeyPath == \A r \in Roots : Caret(a)[r] = Subscript(r, a)
CaretIsExtensionallyKeyPath == Caret(a) = a
CaretOfAppendIsComposition ==
  \A r \in Roots : Caret(Append(a, b))[r] = Caret(b)[Caret(a)[r]]
CaretMapFusion ==   \* [r].map(^a).map(^b) == [r].map(^(a.appending(b)))
  \A r \in Roots : Caret(b)[Caret(a)[r]] = Caret(Append(a, b))[r]
=============================================================================
