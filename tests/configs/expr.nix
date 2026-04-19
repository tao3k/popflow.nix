/*
  Exercise the configs POP workflow as an object semantic test. This verifies
  recipe merging, args folding, and exporter-visible final state.

  Type: AttrSet -> AttrSet
*/
_:
let
  popflowInputs = import ../..;
  inherit (popflowInputs) POP;
  inherit (popflowInputs) popflowLib;
  pops = popflowLib.configs.pops;

  workflow =
    let
      seed = pops.default.withInitRecipes {
        nixos.modules = [ "core" ];
      };
    in
    (
      (
        (seed.addRecipesExtenders [
          {
            nixos.roles.server = true;
          }
          {
            home-manager.modules = [
              "shell"
              "git"
            ];
          }
        ]).addArgsExtenders
        [
          {
            systems.default = "x86_64-linux";
          }
          {
            profiles.primary = "guangtao";
          }
        ]
      ).addExporter
      (
        POP.extendPop pops.exporter (
          self: _: {
            exports.summary = {
              recipeKinds = builtins.attrNames self.recipes;
              system = self.args.systems.default;
              profile = self.args.profiles.primary;
              hasHomeManager = self.recipes ? home-manager;
              nixosIsServer = self.recipes.nixos.roles.server;
              nixosHasModules = self.recipes.nixos ? modules;
            };
          }
        )
      )
    );
in
{
  recipes = workflow.recipes;
  args = workflow.args;
  exports = workflow.exports;
}
