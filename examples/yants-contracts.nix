/*
  Yants contract example. Read this after `pop-vocabulary.nix` to see how
  popflow turns POP objects into named runtime contracts and where method-level
  `defun` checks already exist.

  Type: { inputs = AttrSet; } -> AttrSet
*/
{ inputs, ... }:
let
  popflowLib = import ../src/__loader.nix inputs;
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

  methodContracts = {
    configs = {
      note = "Configs uses yants for named public shapes today; richer chain-method runtime typing still needs a dedicated design.";
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

  takeaways = {
    pop = "POP defines object identity and extension behavior.";
    yants = "Yants names the contract surface and guards selected public methods at runtime.";
    flake = "Flake is the clearest current example of both contract types and defun-guarded public methods working together.";
    haumea = "Haumea needs stronger contracts because loader and module experiments carry richer structural risk.";
    configs = "Configs already has public contract names, but its polymorphic chain methods need a more careful runtime typing design than a simple defun retrofit.";
  };
}
