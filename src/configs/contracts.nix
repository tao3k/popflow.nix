/*
  Named yants contracts for the configs domain. Read this file when you want to
  know which POP object shapes are public, even when method-level runtime
  guards are intentionally conservative.

  Type: { yants = AttrSet -> AttrSet; } -> AttrSet
*/
{ yants }:
let
  # Named open POP contracts that mirror the public `configs.pops.*` surface.
  types = with (yants "configs"); rec {
    pop = openStruct "configs.pop" shapes.pop;
    recipesPop = openStruct "configs.recipesPop" shapes.recipesPop;
    argsPop = openStruct "configs.argsPop" shapes.argsPop;
    exporterPop = openStruct "configs.exporterPop" shapes.exporterPop;
    defaultPop = openStruct "configs.defaultPop" shapes.defaultPop;

    # Compatibility aliases for the older builder-oriented vocabulary.
    recipesExtender = recipesPop;
    argsExtender = argsPop;
    exporter = exporterPop;
    pipeline = defaultPop;
  };

  # Raw shape tables used to build the named contracts above.
  shapes = with yants; rec {
    # Shared POP metadata shape inherited by the other configs POP objects.
    pop = {
      __meta__ = option (
        struct "__meta__" {
          __id__ = list any;
          name = string;
          parents = list types.pop;
          defaults = attrs any;
          extension = function;
          precedenceList = list (attrs any);
        }
      );
    };

    # The seed recipe object only needs one initializer method.
    recipesPop = pop // {
      recipes = attrs any;
      initRecipes = attrs any;
      withInitRecipes = function;
    };

    # Exporter args are folded from a list of attrset extenders.
    argsPop = pop // {
      args = attrs any;
      argsExtenders = list any;
      addArgsExtenders = function;
      addArgsExtender = function;
    };

    # Exporters read the resolved recipe and args views, then emit exports.
    exporterPop = pop // {
      recipes = attrs any;
      args = attrs any;
      exports = attrs any;
      withRecipes = function;
      withArgs = function;
      addExporters = function;
      addExporter = function;
    };

    # The main workflow composes the three smaller POP objects above.
    defaultPop =
      recipesPop
      // argsPop
      // exporterPop
      // {
        recipesExtenders = list any;
        exporters = list types.exporterPop;
        addRecipesExtenders = function;
        addRecipesExtender = function;
      };
  };
in
{
  inherit shapes types;
}
