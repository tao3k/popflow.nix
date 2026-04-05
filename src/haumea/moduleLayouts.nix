{
  haumea,
  lib,
  dmerge,
  super,
}:
{ cfg, initLoad }:
let
  inherit (haumea.lib)
    loaders
    matchers
    ;
  inherit (lib)
    isList
    optionals
    ;

  defaultTransformer = _cursor: dir: if dir ? default then dir.default else dir;

  resolveLoader =
    extender:
    (optionals (initLoad.loader != loaders.default) [
      (matchers.nix (super.moduleImporter cfg extender cfg.nixosModuleImporter))
    ])
    ++ (optionals (isList cfg.loader) cfg.loader);

  resolveTransformer = if cfg.transformer != [ ] then cfg.transformer else [ defaultTransformer ];

  loadWith =
    {
      extender ? [ ],
    }:
    haumea.lib.load {
      inherit (cfg) inputs src;
      loader = resolveLoader extender;
      transformer = resolveTransformer;
    };
in
{
  default = loadWith { };
  __extender = extender: loadWith { inherit extender; };
}
