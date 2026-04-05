{
  POP,
  yants,
  root,
  lib,
  dmerge,
  ...
}:
let
  inherit (POP) pop extendPop;
  inherit (yants) defun;
  # Haumea reuses the named contracts because its load and module paths are the
  # structurally richest surfaces in the repository.
  types = yants // root.haumea.types;
  l = lib // builtins;

  appendPopList =
    field: values: target:
    extendPop target (_: super: { ${field} = super.${field} ++ values; });
in
/*
  Main haumea workflow object. Start here for plain data loading, exporter
  composition, and the module-aware override experiments unique to popflow.

  Matching yants contract:
  - `root.haumea.types.defaultPop`

  Guard coverage:
  - `addLoadExtender`, `addLoadExtenders`, and `outputs` are runtime-guarded
  - this is the strongest contract-heavy workflow after `flake`
*/
pop {
  parents = [
    root.haumea.pops.load
    root.haumea.pops.exporter
  ];
  defaults = {
    loadExtenders = [ ];
    exporters = [ ];
  };
  extension = self: _: {
    # The default exports always include the raw layouts plus rendered outputs.
    exports = {
      default = self.layouts.default;
      outputs = self.outputs;
    }
    // root.haumea.internal.default.foldGeneralExports self self.exporters;

    # Exporters compose just like in the other domains.
    addExporter = exporter: self.addExporters [ exporter ];

    /*
       * @name haumea.default.addExporters
       *
       * @param exporters Exporter POP objects to append to the current workflow.
       *
      * @return A `haumea.pops.default` workflow with additional exporters.
    */
    # Exporter growth stays simple; the richer runtime guards are on load/output methods.
    addExporters = exporters: appendPopList "exporters" exporters self;

    # Merge load extenders, then normalize the resulting load through exporter.withLoad.
    load =
      (root.haumea.pops.exporter.withLoad (
        root.haumea.internal.default.mergeLoadConfig self.initLoad self.loadExtenders
      )).load;

    /*
      * @name haumea.default.addLoadExtender
      *
      * @param loadExtender One load extender or load-extender pop.
      *
      * @return A `haumea.pops.default` workflow with one more load extender.
    */
    addLoadExtender = defun (with types; [
      (either haumeaLoadExtenderPop haumeaLoadExtender)
      haumeaDefaultPop
    ]) (loadExtender: self.addLoadExtenders [ loadExtender ]);

    /*
      * @name haumea.default.addLoadExtenders
      *
      * @param loadExtenders A list of load extenders appended in order.
      *
      * @return A `haumea.pops.default` workflow with additional load extenders.
    */
    addLoadExtenders = defun (with types; [
      (either (list haumeaLoadExtenderPop) (list haumeaLoadExtender))
      haumeaDefaultPop
    ]) (loadExtenders: appendPopList "loadExtenders" loadExtenders self);

    /*
      * @name haumea.default.outputs
      *
      * @param ext Either a function, a list of module extenders, or an attrset patch.
      *
      * @return Plain merged attrs for `default` loads or layout-driven output
      * extension for module-like loads.
    */
    # Plain data loads merge attrs, while module-like loads use the layout extender.
    outputs =
      defun
        (with yants; [
          (either function (either (list any) (attrs any)))
          (attrs any)
        ])
        (
          ext:
          if self.load.type == "default" then
            if l.isFunction ext then ext self.layouts.default else dmerge self.layouts.default ext
          else
            self.layouts.__extender ext
        );

    # Compute the layouts after the merged load is finalized.
    layouts = root.haumea.internal.default.computeLayouts self.initLoad self.load;
  };
}
