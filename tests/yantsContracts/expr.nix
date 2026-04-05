/*
  Exercise the yants contract layer as an executable semantic test. This
  verifies named POP contract validators and the method-level runtime guards
  that already exist in `flake` and `haumea`.

  Type: AttrSet -> AttrSet
*/
_:
let
  popflowInputs = import ../..;
  popflowLib = import ../../src/__loader.nix popflowInputs;

  configsTypes = popflowLib.configs.contracts.types;
  flakeTypes = popflowLib.flake.contracts.types;
  haumeaTypes = popflowLib.haumea.types;

  validInputsPatch = {
    inputs.demo.flag = true;
  };

  validLoadExtender = {
    load = {
      src = "fixtures";
      transformer = [ ];
      inputsTransformer = [ ];
      inputs = { };
      loader = [ ];
      type = "default";
      nixosModuleImporter = x: x;
    };
  };

  trySuccess = value: (builtins.tryEval value).success;
in
{
  contracts = {
    configs = {
      defaultPopAcceptsDefaultObject = trySuccess (
        configsTypes.defaultPop popflowLib.configs.pops.default
      );
      exporterPopAcceptsExporterObject = trySuccess (
        configsTypes.exporterPop popflowLib.configs.pops.exporter
      );
    };

    flake = {
      defaultPopAcceptsDefaultObject = trySuccess (flakeTypes.defaultPop popflowLib.flake.pops.default);
      validatedInputsPatch = flakeTypes.inputsPatch validInputsPatch;
      invalidInputsPatchRejected = !(trySuccess (flakeTypes.inputsPatch { wrong = true; }));
    };

    haumea = {
      defaultPopAcceptsDefaultObject = trySuccess (haumeaTypes.defaultPop popflowLib.haumea.pops.default);
      loadExtenderAcceptsStructuredPatch = trySuccess (haumeaTypes.loadExtender validLoadExtender);
      invalidLoadExtenderRejected =
        !(trySuccess (haumeaTypes.loadExtender (validLoadExtender // { load.type = "oops"; })));
    };
  };

  methods = {
    configs = {
      note = "Configs contract names are in place, but richer runtime method typing is still deferred because naive defun retrofits disturbed polymorphic POP chaining.";
    };

    flake = {
      addInputsExtenderAcceptsPatch = trySuccess (
        popflowLib.flake.pops.default.addInputsExtender validInputsPatch
      );
      addInputsExtenderRejectsWrongShape =
        !(trySuccess (popflowLib.flake.pops.default.addInputsExtender { wrong = true; }));
    };

    haumea = {
      addLoadExtenderAcceptsStructuredPatch = trySuccess (
        popflowLib.haumea.pops.default.addLoadExtender validLoadExtender
      );
      addLoadExtenderRejectsInvalidType =
        !(trySuccess (
          popflowLib.haumea.pops.default.addLoadExtender (validLoadExtender // { load.type = "oops"; })
        ));
    };
  };
}
