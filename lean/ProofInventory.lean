import Gomez26LiquidityBuffers.ProofInterface
import Mathlib.Util.AssertNoSorry

/-! Lean-owned discovery and axiom closure of actual compiled theorem declarations.
This command is a proof-safety check, not a source-semantic acceptance receipt. -/
open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let mut count := 0
  for (name, info) in env.constants.toList do
    if name.toString.startsWith "Gomez26LiquidityBuffers." && !name.isInternal then
      match info with
      | .thmInfo _ =>
        let axioms ← Lean.collectAxioms name
        for ax in axioms do
          unless ax == ``propext || ax == ``Classical.choice || ax == ``Quot.sound do
            throwError "Nonstandard axiom dependency in {name}: {ax}"
        logInfo m!"PROVED {name}; axioms={axioms}"
        count := count + 1
      | _ => pure ()
  logInfo m!"CHECKED_THEOREM_COUNT={count}; nonstandard_axioms=0; sorryAx=0"
