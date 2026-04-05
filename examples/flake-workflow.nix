/*
  Flake workflow example. It shows how the flake POP objects can call a pinned
  fixture flake, extend its input graph, export a per-system result, and still
  reuse the same resolved inputs for overlay-oriented experiments.

  Type: { inputs = AttrSet; lib = AttrSet; } -> AttrSet
*/
{ inputs, lib }:
let
  inherit (inputs.POP) extendPop;
  pops = lib.flake.pops;

  workflow =
    ((pops.default.withInitInputs ./__nixpkgsFlake).addInputsExtender (
      extendPop pops.inputs (
        self: _: {
          inputs.nixlib = inputs.nixlib;
          inputs.custom = self.inputs.nixlib;
        }
      )
    )).addExporter
      (
        extendPop pops.exporter (
          self: _: {
            exports.packages.sample = self.inputs.nixpkgs.hello;
            exports.metadata.hasCustomInput = self.inputs ? custom;
          }
        )
      );

  overlay = import ./__nixpkgsFlake/overlays.nix inputs;
  overlayedLegacyPackages = lib.mapAttrs (
    _: legacyPackages: legacyPackages.appendOverlays [ overlay ]
  ) workflow.sysInputs.nixpkgs.legacyPackages;
in
{
  inherit
    workflow
    overlayedLegacyPackages
    ;

  outputsForLinux = workflow.outputsForSystem "x86_64-linux";
  samplePackageName = (workflow.outputsForSystem "x86_64-linux").packages.x86_64-linux.sample.pname;
}
