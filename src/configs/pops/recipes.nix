{
  POP,
  ...
}:
let
  inherit (POP) pop extendPop;
in
/*
  Seed object for the configs domain. It only answers one question: what is
  the initial recipe tree before extenders and exporters run.

  Matching yants contract:
  - `root.configs.contracts.types.recipesPop`

  Guard coverage:
  - this file currently teaches the named contract surface
  - the method stays unguarded because the configs workflow is still the most
    polymorphic POP chain in the repo
*/
pop {
  defaults = {
    recipes = { };
    initRecipes = { };
  };
  extension = self: _: {
    /*
       * @name configs.recipes.withInitRecipes
       *
       * @param initRecipes Initial recipe tree for a new configs workflow.
       *
      * @return A `configs.pops.recipes` object with a new `initRecipes` seed.
    */
    # Keep the recipe seed reset on `extendPop` so the default workflow keeps
    # the expected recursive object view that the `recipesPop` contract names.
    withInitRecipes = initRecipes: extendPop self (_: _: { inherit initRecipes; });
  };
}
