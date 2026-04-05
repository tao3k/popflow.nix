/*
  Exercise the NixOS-module flavored Haumea loader. This verifies that module
  imports, load extenders, and exported outputs all work when the load type is
  `nixosModules`.

  Type: AttrSet -> AttrSet
*/
_:
let
  popflowInputs = import ../..;
  inherit (popflowInputs) POP dmerge;
  inherit (POP) kxPop;
  popflowLib = import ../../src/__loader.nix popflowInputs;
  inherit (popflowLib.haumea) pops;

  # Start from the repository root with the lib expected by the module importer.
  baseModuleLoad =
    with popflowInputs.haumea.lib;
    pops.default.withInitLoad {
      src = ../..;
      inputs = {
        lib = popflowLib;
      };
      type = "nixosModules";
    };

  # Add dmerge so fixture modules can build module-level overrides.
  moduleLoadWithDmerge =
    with popflowInputs.haumea.lib;
    baseModuleLoad.addLoadExtender {
      load.inputs = {
        inherit (popflowInputs) dmerge;
      };
    };

  # Narrow the load to the fixture tree and provide POP for nested module extenders.
  nixosModules =
    with popflowInputs.haumea.lib;
    (
      (moduleLoadWithDmerge.addLoadExtender {
        load = {
          src = ../evalModules/__fixture;
          type = "nixosModules";
        };
      }).addLoadExtender
      (
        # The extra POP input is a constant load patch, not a behavioral one.
        kxPop pops.load {
          load.inputs = {
            POP = popflowInputs.POP;
          };
        }
      )
    );
  inherit (builtins) deepSeq mapAttrs tryEval;
in
# Evaluate both the convenience `outputs` view and the raw exporter surface.
mapAttrs (_: x: tryEval (deepSeq x x)) {

  outputs = nixosModules.outputs { };

  exports = nixosModules.exports;
}
