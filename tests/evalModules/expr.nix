/*
  Exercise the module-evaluation path by loading fixture modules through the
  Haumea POP load object and then feeding the result into
  `nixpkgs.lib.evalModules`.

  Type: AttrSet -> AttrSet
*/
_:
let
  popflowInputs = import ../..;
  inherit (popflowInputs) POP dmerge nixlib;
  inherit (POP) extendPop;
  popflowLib = import ../../src/__loader.nix popflowInputs;
  inherit (popflowLib.haumea) pops;
  inherit (nixlib) evalModules;

  # Build a Haumea POP object rooted at the repository so later extenders can narrow it.
  baseRepositoryLoad =
    with popflowInputs.haumea.lib;
    pops.default.withInitLoad {
      src = ../..;
      type = "default";
    };

  # Inject the dependencies that the module importer expects at evaluation time.
  repositoryLoadWithModuleInputs =
    with popflowInputs.haumea.lib;
    baseRepositoryLoad.addLoadExtender {
      load.inputs = {
        POP = popflowInputs.POP;
        lib = popflowInputs.nixlib;
        inherit (popflowInputs) dmerge;
      };
    };

  # Turn the fixture tree into module layouts and add one exporter-driven override.
  fixtureModuleLoad =
    (repositoryLoadWithModuleInputs.addLoadExtender {
      load = {
        src = ./__fixture;
        type = "nixosModules";
      };
    }).addExporters
      [
        (extendPop pops.exporter (
          self: _: {
            exports.test = self.outputs [
              ({
                value = (
                  { selfModule' }: selfModule' (m: dmerge m { config.programs.git.__profiles__.enable = false; })
                );
                path = [
                  "programs"
                  "git"
                ];
              })
              ({
                value = (
                  { selfModule' }: selfModule' (m: dmerge m { config.programs.git.__profiles__.name = "guangtao"; })
                );
                path = [
                  "programs"
                  "git"
                  "opt"
                ];
              })
            ];
          }
        ))
      ];

  # Evaluate both the raw module set and the customized exported module set.
  evaluatedConfigs = {
    default =
      (evalModules {
        modules = [
          fixtureModuleLoad.layouts.default.programs.git
          fixtureModuleLoad.layouts.default.programs.emacs
          fixtureModuleLoad.layouts.default.services.openssh
        ];
      }).config;
    custom =
      (evalModules {
        modules = [
          fixtureModuleLoad.exports.test.programs.git
          # fixtureModuleLoad.outputs.default.programs.git
        ];
      }).config;
  };
  inherit (builtins) deepSeq mapAttrs tryEval;
in
/*
  Returning the evaluated configs keeps the snapshot focused on final module
  semantics instead of intermediate pop state.
*/
evaluatedConfigs
