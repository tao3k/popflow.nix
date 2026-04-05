/*
  Internal algorithms for the configs POP workflow.

  Public mapping:
  - `configs.pops.default.recipes` delegates to `mergeRecipesExtenders`
  - `configs.pops.default.exports` delegates to `foldRecipeExporters`

  This file is intentionally not a second public namespace. It only holds the
  algorithmic steps that the public POP objects call.

  Type: { lib = AttrSet; } -> AttrSet
*/
{
  lib,
  ...
}:
let
  inherit (builtins) foldl';
  inherit (lib) mergeToDepth;
in
rec {
  # Materialize the final recipe tree by folding recipe patches left to right.
  mergeRecipesExtenders =
    initRecipes: recipesExtenders:
    foldl' (attrs: extender: attrs // extender) initRecipes recipesExtenders;

  # Rebind recipes/args onto each exporter POP object, then merge all exports.
  foldRecipeExporters =
    recipes: args: exporters:
    let
      # Preserve the current exporter POP view when args are absent.
      applyExporterArgs =
        exporter:
        if args == { } then exporter.withRecipes recipes else (exporter.withRecipes recipes).withArgs args;
    in
    foldl' (attrs: exporter: mergeToDepth 2 attrs (applyExporterArgs exporter).exports) { } exporters;
}
