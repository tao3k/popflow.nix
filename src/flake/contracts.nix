/*
  Named yants contracts for the flake domain. This file is the clearest current
  map from public POP objects to runtime-guarded method contracts.

  Type: { yants = AttrSet -> AttrSet; } -> AttrSet
*/
{ yants }:
let
  # Named contracts that mirror the public `flake.pops.*` surface.
  types = with (yants "popflow.flake"); rec {
    pop = openStruct "flake.pop" shapes.pop;
    exporterPop = openStruct "flake.exporterPop" shapes.exporterPop;
    inputsPop = openStruct "flake.inputsPop" shapes.inputsPop;
    inputsPatch = struct "flake.inputsPatch" shapes.inputsPatch;
    defaultPop = openStruct "flake.defaultPop" shapes.defaultPop;

    # Compatibility aliases for the older builder-oriented vocabulary.
    exporter = exporterPop;
    inputsExtenderPop = inputsPop;
    inputsExtender = inputsPatch;
    pipeline = defaultPop;
  };

  # Shape tables that back the named contracts and defun signatures.
  shapes = with yants; rec {
    # Shared POP metadata shape inherited by the domain-specific objects.
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

    # Exporters can read resolved inputs and, optionally, one concrete system.
    exporterPop = pop // {
      inputs = attrs any;
      exports = attrs any;
      withInputs = function;
      withSystem = function;
    };

    # Input objects answer the initial graph plus its de/systemized views.
    inputsPop = pop // {
      initInputs = attrs any;
      initFlake = attrs any;
      sysInputs = attrs any;
      inputs = attrs any;
      withInitInputs = function;
    };

    # One narrow attrset patch accepted by `addInputsExtender`.
    inputsPatch = {
      inputs = attrs any;
    };

    # The main workflow composes input growth plus exporter rendering.
    defaultPop =
      exporterPop
      // inputsPop
      // {
        exporters = list types.exporterPop;
        system = string;
        exports = attrs any;
        initInputs = attrs any;
        inputs = attrs any;
        sysInputs = attrs any;
        addInputsExtenders = function;
        addInputsExtender = function;
        addExporters = function;
        addExporter = function;
        outputsForSystem = function;
        outputsForSystems = function;
      };

    # Compatibility aliases for the older builder-oriented vocabulary.
    exporter = exporterPop;
    inputsExtenderPop = inputsPop;
    inputsExtender = inputsPatch;
    pipeline = defaultPop;
  };
in
{
  inherit shapes types;
}
