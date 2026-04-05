/*
  Internal algorithms for the flake POP workflow.

  Public mapping:
  - `flake.pops.inputs.withInitInputs` uses `resolveInitFlake` and `resolveInitInputs`
  - `flake.pops.default.inputs/sysInputs` uses `extendInputs` and `deSystemizeInput`
  - `flake.pops.default.exports` uses `foldExporters` and `partitionExporters`

  These helpers explain how the public POP objects stay small while the
  algorithmic steps remain testable and readable.

  Type: { lib = AttrSet; call-flake = Path -> AttrSet; } -> AttrSet
*/
{
  lib,
  call-flake,
  ...
}:
let
  inherit (builtins) foldl';
  inherit (lib)
    mergeToDepth
    deSystemize
    reverseList
    ;
in
rec {
  # Normalize the first input into one called-flake-like value when possible.
  resolveInitFlake =
    initInputs: fallback:
    if (lib.isPath initInputs || lib.isString initInputs) then
      call-flake initInputs
    else if lib.hasAttr "outPath" initInputs then
      call-flake initInputs.outPath
    else
      fallback;

  # Extract the initial input graph from the resolved flake, or keep the input as-is.
  resolveInitInputs =
    initInputs: initFlake: if initFlake == { } then initInputs else initFlake.inputs;

  # Accept either a POP object with `withInitInputs` or a plain extender patch.
  applyInputsExtender =
    initInputs: extender:
    if extender ? withInitInputs then extender.withInitInputs initInputs else extender;

  # Grow the systemized input graph by merging each extender's `inputs`.
  extendInputs =
    initInputs: inputsExtenders:
    foldl' (
      currentInputs: extender:
      mergeToDepth 3 currentInputs (applyInputsExtender initInputs extender).inputs
    ) initInputs inputsExtenders;

  # Turn one systemized input back into the de-systemized view exporters expect.
  deSystemizeInput =
    system: name: input:
    if (name == "nixpkgs" && input ? legacyPackages && system != "") then
      (deSystemize system input).legacyPackages
    else
      deSystemize system input;

  # Rebind the resolved inputs onto each exporter and merge the resulting exports.
  foldExporters =
    inputs: exporters:
    foldl' (attrs: exporter: mergeToDepth 2 attrs (exporter.withInputs inputs).exports) { } exporters;

  # Keep per-system and general exporters separate so `outputsForSystem(s)` can
  # merge them back in the right order.
  partitionExporters =
    exporters:
    let
      reversedPartitions =
        foldl'
          (
            partitions: exporter:
            if exporter.system == "" then
              {
                perSystem = [ exporter ] ++ partitions.perSystem;
                inherit (partitions) general;
              }
            else
              {
                inherit (partitions) perSystem;
                general = [ exporter ] ++ partitions.general;
              }
          )
          {
            perSystem = [ ];
            general = [ ];
          }
          exporters;
    in
    {
      perSystem = reverseList reversedPartitions.perSystem;
      general = reverseList reversedPartitions.general;
    };
}
