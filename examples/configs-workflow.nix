/*
  Configs workflow example. It shows the step-by-step POP workflow for the
  configs domain and exports only serializable learning snapshots.

  Type: { inputs = AttrSet; } -> AttrSet
*/
{ inputs, ... }:
let
  inherit (inputs.POP) extendPop;
  inherit (inputs) popflowLib;
  pops = popflowLib.configs.pops;

  seed = pops.default.withInitRecipes {
    nixos.modules = [ ];
    home-manager.modules = [ ];
  };

  recipeStage = seed.addRecipesExtender {
    nixos.modules = [
      "hardware"
      "networking"
    ];
    home-manager.modules = [
      "shell"
      "git"
    ];
  };

  argsStage = recipeStage.addArgsExtender {
    systems.default = "x86_64-linux";
  };

  workflow = argsStage.addExporter (
    extendPop pops.exporter (
      self: _: {
        exports.summary = {
          system = self.args.systems.default;
          recipeKinds = builtins.attrNames self.recipes;
        };
        exports.recipes = self.recipes;
      }
    )
  );
in
{
  stages = {
    seed = {
      initRecipes = seed.initRecipes;
      recipes = seed.recipes;
    };

    recipes = {
      extenderCount = builtins.length recipeStage.recipesExtenders;
      recipes = recipeStage.recipes;
    };

    args = {
      extenderCount = builtins.length argsStage.argsExtenders;
      args = argsStage.args;
    };

    workflow = {
      exporterCount = builtins.length workflow.exporters;
    };
  };

  exports = {
    summary = {
      system = argsStage.args.systems.default;
      recipeKinds = builtins.attrNames workflow.recipes;
    };
    recipes = workflow.recipes;
  };
}
