/*
  Internal algorithms for the Haumea POP workflow.

  Public mapping:
  - `haumea.pops.exporter.withLoad` delegates to `normalizeLoadConfig`
  - `haumea.pops.default.load` delegates to `mergeLoadConfig`
  - `haumea.pops.default.exports` delegates to `foldGeneralExports`
  - `haumea.pops.default.layouts` delegates to `computeLayouts`

  This is the most experimental internal layer in the repo because it supports
  both plain-data loading and module-aware layout experiments.

  Type: { haumea = AttrSet; lib = AttrSet; root = AttrSet; } -> AttrSet
*/
{
  haumea,
  lib,
  root,
  ...
}:
let
  inherit (builtins) foldl';
  l = lib // builtins;

  moduleLikeLoadTypes = [
    "nixosModules"
    "nixosProfiles"
    "evalModules"
    "nixosProfilesOmnibus"
  ];
in
rec {
  # Normalize one load config into the shape the later exporter/layout phases expect.
  normalizeLoadConfig = load: currentLoad: {
    inherit (load)
      loader
      transformer
      type
      inputsTransformer
      nixosModuleImporter
      ;
    src = if l.isString load.src then l.unsafeDiscardStringContext load.src else load.src;
    inputs = lib.pipe load.inputs (
      load.inputsTransformer ++ [ (x: x // { loadSrc = currentLoad.src; }) ]
    );
  };

  # Accept either a plain load extender patch or a POP object with `withInitLoad`.
  applyLoadExtender =
    initLoad: extender: if extender ? withInitLoad then extender.withInitLoad initLoad else extender;

  # Merge all load extenders into one current load config.
  mergeLoadConfig =
    initLoad: loadExtenders:
    foldl' (
      acc: extender:
      let
        extenderConfig = (applyLoadExtender initLoad extender).load or { };
      in
      l.recursiveMerge' [
        acc
        extenderConfig
      ]
    ) initLoad loadExtenders;

  # Rebind outputs/layouts onto exporters, then merge the additional exports.
  foldGeneralExports =
    currentSelf: exporters:
    let
      exporterLayouts = currentSelf.layouts // {
        self = currentSelf;
      };
      currentOutputs = currentSelf.outputs;
    in
    foldl' (
      acc: exporter:
      let
        exporterOutputs =
          if exporter ? withOutputs then
            ((exporter.withOutputs currentOutputs).withLayouts exporterLayouts).exports
          else
            exporter.exports;
      in
      acc // exporterOutputs
    ) { } exporters;

  # Choose between plain Haumea data loading and the module-like layout path.
  computeLayouts =
    initLoad: load:
    if l.elem load.type moduleLikeLoadTypes then
      root.haumea.moduleLayouts {
        cfg = load;
        inherit initLoad;
      }
    else
      {
        default = haumea.lib.load (
          l.removeAttrs load [
            "type"
            "inputsTransformer"
            "nixosModuleImporter"
          ]
        );
      };
}
