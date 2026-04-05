{
  yants,
  root,
  lib,
  self,
}:
let
  types = root.haumea.types // yants;
  l = lib // builtins;

  enum' =
    o: e: v:
    (with yants; enum o e)
    // {
      toError =
        x:
        throw ''
          Invalid value for '${v}': "${x}"
          Valid values are: [ ${l.concatStringsSep " " e} ]
        '';
    };
  # Raw shape tables for the richer Haumea load/config surface. `types.nix`
  # turns these into the public named contracts.
  structAttrs = with yants; {
    # Shared POP metadata available on every Haumea POP object.
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

    # The composed Haumea workflow object.
    haumeaDefaultPop = structAttrs.pop // {
      exports = attrs any;

      loadExtenders = list any;

      addLoadExtender = function;
      addLoadExtenders = function;

      addExporters = function;
      addExporter = function;
      load = attrs any;
      initLoad = struct "haumea.load" structAttrs.haumeaLoad;

      outputs = function;
      layouts = attrs any;
    };

    # Exporters rebind load/layout/output views before computing exports.
    haumeaExporterPop = structAttrs.pop // {
      exports = attrs any;
      load = attrs any;

      withLoad = function;
      withLayouts = function;
      withOutputs = function;
    };

    # The plain load shape accepted by `initLoad` and load extenders.
    haumeaLoad = {
      src = either path (either string (openStruct "srcAttrs" { outPath = either path string; }));
      transformer = either function (list any);
      inputsTransformer = either function (list any);
      inputs = attrs any;
      loader = either function (list any);
      type = enum' "options" [
        "nixosModules"
        "default"
        "nixosProfiles"
        "evalModules"
        "nixosProfilesOmnibus"
      ] "type";
      nixosModuleImporter = function;
    };

    # One plain attrset patch over the load surface.
    haumeaLoadExtender = {
      load = structOption "haumea.load" structAttrs.haumeaLoad;
    };

    # One POP object that can contribute load initialization state.
    haumeaLoadExtenderPop = structAttrs.pop // structAttrs.haumeaInitLoadPop;

    # Public POP contracts for the load seed and its initialized variant.
    haumeaLoadPop = structAttrs.pop // structAttrs.haumeaLoad;
    haumeaInitLoadPop = structAttrs.pop // rec {
      initLoad = struct "haumea.load" structAttrs.haumeaLoad;
      load = structAttrs.haumeaLoadExtender.load;
      withInitLoad = function;
    };
  };
in
structAttrs
