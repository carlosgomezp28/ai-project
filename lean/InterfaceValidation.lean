import Gomez26LiquidityBuffers.ProofInterface

/-! Lean-native registration/type inspection. This emits declaration facts only;
it is not a semantic acceptance receipt. No source judgments are generated. -/
set_option pp.fullNames true
open Lean Elab Command Meta in
run_cmd do
  let out ← liftTermElabM do
    let env ← getEnv
    let specs := [``Gomez26LiquidityBuffers.proposition1Spec,
      ``Gomez26LiquidityBuffers.proposition2Spec,
      ``Gomez26LiquidityBuffers.proposition2LocalSupportSpec,
      ``Gomez26LiquidityBuffers.proposition2GlobalContinuationSpec]
    let pairs := [( ``Gomez26LiquidityBuffers.proposition1Spec, ``Gomez26LiquidityBuffers.proposition1),
      (``Gomez26LiquidityBuffers.proposition2LocalSupportSpec, ``Gomez26LiquidityBuffers.proposition2LocalSupport)]
    let mut rows : Array Json := #[]
    for n in specs do
      let some ci := env.find? n | throwError "Missing Spec: {n}"
      unless ← isProp (mkConst n) do throwError "Spec is not proposition-valued: {n}"
      let .defnInfo d := ci | throwError "Spec is not transparent def: {n}"
      let body ← ppExpr d.value
      rows := rows.push <| Json.mkObj [("name",toJson n.toString),
        ("kind",toJson "transparent_proposition_definition"),("body",toJson body.pretty)]
      logInfo m!"REGISTERED_SPEC {n}"
    for (s,p) in pairs do
      let some ci := env.find? p | throwError "Missing endpoint: {p}"
      let .thmInfo _ := ci | throwError "Endpoint is not a theorem: {p}"
      unless ← isDefEq ci.type (mkConst s) do throwError "Endpoint type differs from Spec: {p}"
      logInfo m!"EXACT_SPEC_PROOF {s} -> {p}"
    for n in [`Gomez26LiquidityBuffers.proposition2, `Gomez26LiquidityBuffers.proposition2GlobalContinuation] do
      if env.contains n then throwError "Unexpected full/open-result endpoint: {n}"
    let out := Json.mkObj [("schema",toJson (1 : Nat)),("producer",toJson "Lean elaborated environment"),
      ("semantic_acceptance",toJson false),("specs",Json.arr rows),
      ("exact_spec_proofs",Json.arr <| pairs.toArray.map fun (s,p) =>
        Json.mkObj [("spec",toJson s.toString),("proof",toJson p.toString)])]
    pure out
  liftIO <| IO.FS.writeFile "papers/Gomez26LiquidityBuffers/docs/INTERFACE_MANIFEST.json" (out.pretty ++ "\n")
  logInfo "INTERFACE_REGISTRATION_PASS specs=4 exact_proofs=2 full_P2_proof=absent"
