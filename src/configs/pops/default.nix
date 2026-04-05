{
  root,
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
  Main configs workflow object. Start here for the configs domain, then add
  recipe extenders, optional args extenders, and exporters.

  Matching yants contract:
  - `root.configs.contracts.types.defaultPop`

  Guard coverage:
  - this file teaches the main workflow shape directly
  - method-level runtime guards are intentionally more conservative here than
    in `flake` or `haumea`
*/
pop {
  parents = [
    root.configs.pops.recipes
    root.configs.pops.args
    root.configs.pops.exporter
  ];
  defaults = {
    recipesExtenders = [ ];
    exporters = [ ];
  };
  extension = self: _: {
    # Materialize the current recipe tree before exporters run.
    recipes = root.configs.internal.default.mergeRecipesExtenders self.initRecipes self.recipesExtenders;

    /*
      * @name configs.default.addRecipesExtenders
      *
      * @param recipesExtenders A list of recipe patches to append in order.
      *
      * @return A `configs.pops.default` workflow with additional recipe extenders.
    */
    # Grow the recipe pipeline one extender at a time or in batches.
    addRecipesExtenders = recipesExtenders: appendPopList "recipesExtenders" recipesExtenders self;

    /*
      * @name configs.default.addRecipesExtender
      *
      * @param recipesExtender One recipe patch to append.
      *
      * @return A `configs.pops.default` workflow with one more recipe extender.
    */
    addRecipesExtender = recipesExtender: self.addRecipesExtenders [ recipesExtender ];

    /*
       * @name configs.default.exports
       *
      * @return Final exported config fragments built from `self.recipes`,
      * `self.args`, and `self.exporters`.
    */
    # Exporters see the resolved recipes plus any computed args.
    # The final workflow result should still match `defaultPop`.
    exports = root.configs.internal.default.foldRecipeExporters self.recipes self.args self.exporters;
  };
}
