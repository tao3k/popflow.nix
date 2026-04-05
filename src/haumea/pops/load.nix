{
  POP,
  haumea,
  yants,
  root,
  ...
}:
let
  inherit (POP) pop extendPop;
  inherit (yants) defun;
  # Haumea methods draw their signatures from the richer named load contracts.
  types = yants // root.haumea.types;
in
/*
  Seed object for the haumea domain. It answers how a filesystem tree should
  be loaded before exporters or module experiments are applied.

  Matching yants contracts:
  - `root.haumea.types.initLoadPop`
  - `root.haumea.types.loadPop`

  Guard coverage:
  - `withInitLoad` is runtime-guarded
  - later load validation becomes stricter once callers move onto
    `addLoadExtender` or `withLoad`
*/
pop {
  defaults = {
    initLoad = rec {
      src = ../.;
      loader = haumea.lib.loaders.default;
      inputs = { };
      inputsTransformer = [ ];
      transformer = [ ];
      type = "default";
      nixosModuleImporter = haumea.lib.loaders.scoped;
    };
    load = { };
  };
  extension = self: super: {
    /*
       * @name haumea.load.withInitLoad
       *
       * @param initLoad Initial load config with source, type, loaders, or inputs.
       *
      * @return A `haumea.pops.load` object with a merged `initLoad`.
    */
    # Merge a caller-provided initLoad over the domain defaults.
    # The resulting seed object should still match `initLoadPop`.
    withInitLoad = defun (with types; [
      (attrs any)
      haumeaInitLoadPop
    ]) (initLoad: extendPop self (_: _: { initLoad = super.initLoad // initLoad; }));
  };
}
