/*
  Exercise the plain Haumea data-loading path. This test checks that the
  Haumea POP load object, load extenders, scoped loaders, exporter-added
  outputs, and `dmerge`-based output overrides all evaluate successfully.

  Type: AttrSet -> AttrSet
*/
_:
let
  popflowInputs = import ../..;
in
with popflowInputs.haumea.lib;
let
  inherit (popflowInputs) POP dmerge;
  inherit (POP) extendPop kxPop;
  popflowLib = import ../../src/__loader.nix popflowInputs;
  inherit (popflowLib.haumea) pops;

  # Start from the default Haumea POP object and opt into lifted default.nix data files.
  baseDataLoad = pops.default.withInitLoad {
    transformer = [ transformers.liftDefault ];
    inputs = {
      lib = popflowInputs.nixlib;
    };
  };

  # Thread extra inputs into the load so exporters can use dmerge-aware helpers.
  dataLoadWithDmerge = baseDataLoad.addLoadExtender {
    load = {
      inputs = {
        dmerge = popflowInputs.dmerge;
      };
    };
  };

  # Load the fixture tree and expose one custom export built through `outputs`.
  dataFixtureLoad =
    ((dataLoadWithDmerge.addLoadExtender { load.src = ./__data; }).addLoadExtender (
      # This extender is a pure constant patch, so `kxPop` is the lighter POP fit.
      kxPop pops.load { load.loader = [ (matchers.nix loaders.scoped) ]; }
    )).addExporters
      [
        (extendPop pops.exporter (
          self: _: {
            exports.customData =
              with dmerge;
              self.outputs {
                treefmt.formatter.nix.excludes = append [ "data.nix" ];
                treefmt.formatter.prettier.includes = append [ "*.jsl" ];
              };
          }
        ))
      ];

  inherit (builtins) deepSeq mapAttrs tryEval;
in
/*
  Evaluate both the raw outputs and the custom exporter outputs so Namaka can
  snapshot their final shapes.
*/
mapAttrs (_: x: tryEval (deepSeq x x)) {
  outputs = {
    default = dataFixtureLoad.outputs { };
    dmergeWithOutputs = dataFixtureLoad.outputs {
      treefmt.formatter.nix.command = "nixfmt";
      treefmt.formatter.prettier.includes = with dmerge; append [ "*.dmergeOutputs" ];
    };
    funWithOutputs = dataFixtureLoad.outputs (
      x:
      x
      // {
        dataExt = {
          foo = "bar";
        };
      }
    );
  };
  exports = dataFixtureLoad.exports;
}
