/*
  Haumea module experiment example. It shows the distinctive popflow path where a
  Haumea load becomes a `nixosModules`-style surface and is then patched
  through POP-driven override logic before `evalModules`.

  Type: { inputs = AttrSet; lib = AttrSet; } -> AttrSet
*/
{ inputs, lib }:
let
  inherit (inputs)
    POP
    dmerge
    ;
  inherit (inputs.POP) extendPop;
  pops = lib.haumea.pops;

  workflow =
    (pops.default.withInitLoad {
      src = ../tests/evalModules/__fixture;
      type = "nixosModules";
      inputs = {
        inherit lib POP;
      };
    }).addExporter
      (
        extendPop pops.exporter (
          self: _: {
            exports.modules = self.outputs [
              {
                value =
                  { selfModule' }:
                  selfModule' (
                    m:
                    dmerge m {
                      config.services.openssh.enable = false;
                      config.services.openssh.customList = with dmerge; append [ "1" ];
                      imports = with dmerge; append [ ];
                    }
                  );
                path = [
                  "services"
                  "openssh"
                ];
              }
            ];
          }
        )
      );

  evaluated = lib.evalModules {
    modules = [ workflow.exports.modules.services.openssh ];
  };
in
{
  inherit
    workflow
    evaluated
    ;

  patchedServiceConfig = evaluated.config.services.openssh;
}
