/*
  Exercise the flake POP workflow as an object semantic test. This verifies
  called-flake resolution, input extension, and per-system output rendering.

  Type: AttrSet -> AttrSet
*/
_:
let
  popflowInputs = import ../..;
  inherit (popflowInputs) POP;
  popflowLib = import ../../src/__loader.nix popflowInputs;
  pops = popflowLib.flake.pops;

  workflow =
    ((pops.default.withInitInputs (popflowInputs.call-flake ./__lock)).addInputsExtenders [
      (POP.extendPop pops.inputs (
        self: _: {
          inputs = {
            inherit ((popflowInputs.call-flake ../../examples/__nixpkgsFlake).inputs) nixpkgs;
            nixlib.func = self.initInputs.nixlib.genAttrs;
            custom.flag = true;
          };
        }
      ))
    ]).addExporter
      (
        POP.extendPop pops.exporter (
          self: _: {
            exports.packages.sample = self.inputs.nixpkgs.hello;
            exports.metadata = {
              hasCustom = self.inputs ? custom;
              hasFunc = self.inputs.nixlib ? func;
            };
          }
        )
      );

  linuxOutputs = workflow.outputsForSystem "x86_64-linux";
  allOutputs = workflow.outputsForSystems [
    "x86_64-linux"
    "x86_64-darwin"
  ];
in
{
  initFlake = {
    inputNames = builtins.attrNames workflow.initInputs;
    outputNames = builtins.attrNames workflow.initFlake.outputs;
  };

  inputs = {
    deSystemized = builtins.attrNames workflow.inputs;
    systemized = builtins.attrNames workflow.sysInputs;
    metadata = {
      hasCustom = workflow.inputs ? custom;
      hasNixpkgs = workflow.inputs ? nixpkgs;
      hasNixlibFunc = workflow.inputs.nixlib ? func;
    };
  };

  outputs = {
    linux = {
      packageSystems = builtins.attrNames linuxOutputs.packages;
      packageName = linuxOutputs.packages.x86_64-linux.sample.pname;
      metadata = linuxOutputs.metadata.x86_64-linux;
    };
    mergedSystems = builtins.attrNames allOutputs.packages;
  };
}
