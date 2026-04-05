{
  root,
  POP,
  lib,
  yants,
  ...
}:
let
  inherit (builtins) foldl';
  # The flake workflow is the clearest current example of POP objects backed by
  # named yants contracts plus runtime `defun` guards.
  types = root.flake.contracts.types // yants;
  inherit (POP) pop extendPop;
  inherit (yants) defun;
  inherit (lib)
    mapAttrs
    mergeToDepth
    ;

  appendPopList =
    field: values: target:
    extendPop target (_: super: { ${field} = super.${field} ++ values; });
in
/*
  Main flake workflow object. Start here for flake input extension, exporter
  composition, and per-system materialization through `outputsForSystem(s)`.

  Matching yants contract:
  - `root.flake.contracts.types.defaultPop`

  Guard coverage:
  - `addInputsExtender`, `addExporter`, `outputsForSystem`, and
    `outputsForSystems` are all runtime-guarded with `defun`
*/
pop {
  parents = [
    root.flake.pops.exporter
    root.flake.pops.inputs
  ];
  defaults = {
    inputsExtenders = [ ];
    exporters = [ ];
  };
  extension =
    self: _:
    let
      extendedInputs = root.flake.internal.default.extendInputs self.initInputs self.inputsExtenders;
      deSystemizedInputs = mapAttrs (root.flake.internal.default.deSystemizeInput self.system) extendedInputs;
      exporterPartitions = root.flake.internal.default.partitionExporters self.exporters;
    in
    {
      sysInputs = extendedInputs;
      inputs = deSystemizedInputs;

      perSystemExporters = exporterPartitions.perSystem;
      generalExporters = exporterPartitions.general;

      exports = {
        perSystem = root.flake.internal.default.foldExporters self.inputs self.perSystemExporters;
        general = root.flake.internal.default.foldExporters self.inputs self.generalExporters;
      };

      /*
        * @name flake.default.addInputsExtenders
        *
        * @param inputsExtenders A list of input-graph extenders to append in order.
        *
        * @return A `flake.pops.default` workflow with additional input extenders.
      */
      # Extend the input graph before exporters run.
      # The result keeps matching the named `defaultPop` workflow contract.
      addInputsExtenders = inputsExtenders: appendPopList "inputsExtenders" inputsExtenders self;

      /*
        * @name flake.default.addInputsExtender
        *
        * @param inputsExtender One input-graph extender or extender pop.
        *
        * @return A `flake.pops.default` workflow with one more input extender.
      */
      addInputsExtender = defun (with types; [
        (either inputsExtender inputsExtenderPop)
        pipeline
      ]) (inputsExtender: self.addInputsExtenders [ inputsExtender ]);

      /*
        * @name flake.default.addExporters
        *
        * @param exporters Exporter POP objects that target general or per-system outputs.
        *
        * @return A `flake.pops.default` workflow with additional exporters.
      */
      # Exporters can target either per-system or general output spaces.
      addExporters = defun (with types; [
        (list exporter)
        pipeline
      ]) (exporters: appendPopList "exporters" exporters self);

      /*
        * @name flake.default.addExporter
        *
        * @param exporter One exporter POP object.
        *
        * @return A `flake.pops.default` workflow with one more exporter.
      */
      addExporter = defun (with types; [
        exporter
        pipeline
      ]) (exporter: self.addExporters [ exporter ]);

      /*
        * @name flake.default.outputsForSystem
        *
        * @param system Concrete system string such as `x86_64-linux`.
        *
        * @return The usual flake output shape materialized for one system.
      */
      # Render one concrete system into the usual flake output shape.
      outputsForSystem =
        defun
          (with types; [
            string
            (attrs any)
          ])
          (
            system:
            let
              inherit (self.withSystem system) exports;
              systemScopedExports = mapAttrs (_: export: { ${system} = export; }) exports.perSystem;
            in
            mergeToDepth 3 systemScopedExports exports.general
          );

      /*
        * @name flake.default.outputsForSystems
        *
        * @param systems A list of system strings.
        *
        * @return The called flake outputs merged with all rendered systems.
      */
      # Render multiple systems, then merge them back into the called flake.
      outputsForSystems =
        defun
          (with types; [
            (list string)
            (attrs any)
          ])
          (
            systems:
            lib.recursiveUpdate self.initFlake.outputs (
              foldl' (attrs: system: mergeToDepth 3 attrs (self.outputsForSystem system)) { } systems
            )
          );
    };
}
