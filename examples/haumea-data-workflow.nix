/*
  Haumea data workflow example. It focuses on the plain data path: configure a
  load object, add one exporter, and inspect the resulting data layouts and
  rendered outputs.

  Type: { inputs = AttrSet; lib = AttrSet; } -> AttrSet
*/
{ inputs, lib }:
with inputs.haumea.lib;
let
  inherit (inputs.POP) extendPop kxPop;
  pops = lib.haumea.pops;

  workflow =
    (
      (pops.default.withInitLoad {
        src = ../tests/haumeaData/__data;
        inputs = {
          a = "1";
          inherit inputs lib;
        };
      }).addLoadExtender
      # This mirrors the grafonnix template lesson: a constant load patch does
      # not need a behavioral extender.
      (
        kxPop pops.load {
          load.loader = [ (matchers.nix loaders.scoped) ];
        }
      )
    ).addExporter
      (
        extendPop pops.exporter (
          self: _: {
            exports.loadedData = self.layouts.default;
            exports.renderedOutput = self.outputs {
              metadata.example = "haumea-data-workflow";
            };
          }
        )
      );

  interfaceWorkflow = pops.default.withInitLoad {
    src = ../tests/haumeaData/__interface;
    transformer = [ lib.haumea.removeTopDefault ];
  };
in
{
  inherit workflow;

  layouts = workflow.layouts;
  exports = workflow.exports;
  interfaceLayouts = interfaceWorkflow.layouts.default;
  topDefaultRemoved = !(interfaceWorkflow.layouts.default ? default);
}
