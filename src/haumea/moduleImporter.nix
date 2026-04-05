{
  haumea,
  lib,
  dmerge,
}:
cfg: extender: importer:
let
  l = lib // builtins;
  inherit (builtins)
    foldl'
    mapAttrs
    ;
  inherit (lib) functionArgs pipe;

  isModule = l.elem cfg.type [
    "nixosModules"
    "evalModules"
  ];

  lazyArgsPerParameter =
    f: inputs:
    pipe f [
      functionArgs
      (mapAttrs (name: _: inputs.${name}))
      f
    ];

  /*
    Normalize a filesystem path under `cfg.src` into the paths used for module
    placement and extender lookup.

    Type: Path -> {
      modulePath = [ String ];
      path = Path;
      extenderPath = [ String ];
      isTopLevel = Bool;
    }
  */
  mkPathInfo =
    path:
    let
      relativeSourcePath = l.last (l.splitString cfg.src (toString path));
      relativeSourceSegments = l.splitString "/" relativeSourcePath;
      relativeModulePath =
        transform: l.drop 1 (l.splitString "/" (transform (l.removeSuffix ".nix" relativeSourcePath)));
      modulePath = relativeModulePath (l.removeSuffix "/default");
      profilePath = relativeModulePath l.id;
    in
    {
      inherit modulePath path;
      extenderPath = if isModule then modulePath else profilePath;
      isTopLevel = l.length relativeSourceSegments == 2;
    };

  extendersByPath = foldl' (
    index: item:
    let
      valuePath = item.path ++ [ "__value__" ];
    in
    if l.hasAttrByPath valuePath index then
      index
    else
      l.recursiveUpdate index (l.setAttrByPath valuePath item)
  ) { } extender;

  findExtender =
    pathInfo: l.attrByPath (pathInfo.extenderPath ++ [ "__value__" ]) null extendersByPath;

  /*
    Strip a raw imported module down to the shape expected by the downstream
    NixOS module system or by profile-style exports.

    Type: Path -> AttrSet -> (AttrSet -> AttrSet) -> AttrSet
  */
  winnowModule =
    path: module: transform:
    ({
      config =
        if module ? config then
          module.config
        else
          transform (
            removeAttrs module [
              "options"
              "imports"
            ]
          );
      imports = module.imports or [ ];
    })
    // {
      _file = path;
      options = transform (module.options or { });
    };

  /*
    Apply the extender matching the current module path, if any. Extenders may
    be plain values, module files, or functions receiving lazy module args.

    Type: AttrSet -> PathInfo -> AttrSet -> AttrSet
  */
  extendModuleWith =
    moduleArgs: pathInfo: module:
    let
      matchedExtender = findExtender pathInfo;
      callValueModuleLazily =
        value: extraArgs:
        if l.isFunction value then
          lazyArgsPerParameter value (moduleArgs // extraArgs)
        else if l.isPath value then
          importer (moduleArgs // extraArgs) value
        else
          value;
    in
    if matchedExtender == null then
      module
    else
      let
        removedOptionModule = removeAttrs module [ "options" ];
      in
      callValueModuleLazily matchedExtender.value {
        selfModule = module;
        selfModule' = x: module // (x removedOptionModule);
        inherit dmerge;
      };
in
/*
  Wrap a Haumea importer so modules can be normalized, extended by path, and
  called with NixOS-style module arguments.

  Type: AttrSet -> Path -> AttrSet | Function
*/
inputs: path:
let
  pathInfo = mkPathInfo path;
in
if pathInfo.isTopLevel && cfg.type == "nixosProfilesOmnibus" then
  importer inputs path
else
  {
    config ? { },
    options ? { },
    ...
  }@args:
  let
    inherit (pathInfo) modulePath;
    mkModulePath = attrs': l.setAttrByPath modulePath attrs';
    baseModuleArgs =
      inputs
      // args
      // {
        cfg = l.attrByPath modulePath { } config;
        opt = l.attrByPath modulePath { } options;
        inherit mkModulePath;
        moduleArgs = config._module.args // config._module.specialArgs;
        self = inputs.self { };
        pkgs = config._module.args.pkgs;
      };
    moduleArgs = baseModuleArgs // {
      loadSubmodule =
        subPath: extendModuleWith moduleArgs (mkPathInfo subPath) (importer baseModuleArgs subPath);
    };
    defaultModule = importer moduleArgs path;
    extendedModule = extendModuleWith moduleArgs pathInfo (
      winnowModule path defaultModule mkModulePath
    );
    extendedProfile = extendModuleWith moduleArgs pathInfo (winnowModule path defaultModule lib.id);
  in
  if isModule then extendedModule else extendedProfile
