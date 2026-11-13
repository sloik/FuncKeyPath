# Formal model (TLA+)

`FuncKeyPathLaws.tla` is a finite TLA+ model of `Sources/FuncKeyPath`, whose only public API is
`prefix func ^ <Root, Value>(KeyPath<Root, Value>) -> (Root) -> Value` (`{ root in root[keyPath: kp] }`).

**Abstraction.** A `KeyPath` is modelled by its read semantics, a total function `Root -> Value`
over tiny enumerated carriers (`Roots = {0,1,2}`, `Mids = Vals = {0,1}`); TLC ranges over every
such function. `appending(path:)` is function composition. Real Swift types, `String`, `URL` are not modelled.

| Invariant | Swift API it abstracts |
|---|---|
| `TypeOK` | well-typed key paths |
| `CaretAppliesKeyPath` | `(^kp)(root) == root[keyPath: kp]` |
| `CaretIsExtensionallyKeyPath` | `^kp` and `kp` agree on every root |
| `CaretOfAppendIsComposition`, `CaretMapFusion` | `^(a.appending(path: b)) == ^b ∘ ^a` |

## Non-vacuity

`FuncKeyPathLaws.caret_constant.cfg` (caret ignores its argument root; caught by
`CaretAppliesKeyPath`) and `FuncKeyPathLaws.caret_zero_aliased.cfg` (root 0 read as root 1; caught by
`CaretIsExtensionallyKeyPath`). `run_tlc.sh` fails if a mutant passes.

## Running

```sh
TLA_JAR=/path/to/tla2tools-1.7.4.jar formal/run_tlc.sh   # needs Java 11+
```

CI: `.github/workflows/oracle-tla.yml` (self-hosted Oracle ARM64 runner, default branch / manual dispatch).

## Limits

The library is one operator, so the model is small by design. It describes intended semantics read
by hand from the Swift source and does not prove conformance; XCTest covers the code (which only checks
that the operator compiles). Writable key paths, optional chaining and `\.self` are not modelled.
