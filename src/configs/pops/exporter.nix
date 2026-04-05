{
  POP,
  ...
}:
let
  inherit (POP) pop extendPop;

  appendPopList =
    field: values: target:
    extendPop target (_: super: { ${field} = super.${field} ++ values; });
in
/*
  Export object for the configs domain. It binds recipes and args together and
  emits the final exported config fragments.

  Matching yants contract:
  - `root.configs.contracts.types.exporterPop`

  Guard coverage:
  - this file currently relies on named POP contracts, not `defun`
  - `withRecipes` and `withArgs` intentionally stay on `extendPop` because the
    exporter path expects a full recursive POP view instead of a shallow patch
*/
pop {
  defaults = {
    recipes = { };
    args = { };
    exports = { };
  };
  extension = self: _: {
    /*
       * @name configs.exporter.withRecipes
       *
       * @param recipes Resolved recipe tree that this exporter should read.
       *
      * @return A `configs.pops.exporter` object rebound to the given recipes.
    */
    # In configs, exporter rebinding still needs `extendPop` so recursive self
    # and later exports keep the expected workflow view named by `exporterPop`.
    withRecipes = recipes: extendPop self (_: _: { inherit recipes; });

    /*
      * @name configs.exporter.withArgs
      *
      * @param args Exporter-facing argument attrset.
      *
      * @return A `configs.pops.exporter` object rebound to the given args.
    */
    withArgs = args: extendPop self (_: _: { inherit args; });

    /*
      * @name configs.exporter.addExporters
      *
      * @param exporters Exporter POP objects to append to the current pipeline.
      *
      * @return A `configs.pops.exporter` object with additional exporters.
    */
    # Exporters compose just like other POP lists in popflow.
    addExporters = exporters: appendPopList "exporters" exporters self;

    /*
      * @name configs.exporter.addExporter
      *
      * @param exporter One exporter POP object to append.
      *
      * @return A `configs.pops.exporter` object with one more exporter.
    */
    addExporter = exporter: self.addExporters [ exporter ];
  };
}
