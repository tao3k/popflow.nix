{
  POP,
  yants,
  root,
  ...
}:
let
  inherit (POP) pop extendPop kxPop;
  inherit (yants) defun;
  # Reuse the named Haumea contracts directly in exporter method signatures.
  types = yants // root.haumea.types;
in
/*
  Export object for the haumea domain. It normalizes load config, binds layouts,
  and exposes the final exported views.

  Matching yants contract:
  - `root.haumea.types.exporterPop`

  Guard coverage:
  - `withLoad` and `withOutputs` are runtime-guarded with `defun`
  - `withLayouts` is a plain `kxPop` rebinding helper over already-computed data
*/
pop {
  defaults = {
    exports = { };
    load = { };
  };
  parents = [ ];
  extension = self: _: {
    /*
       * @name haumea.exporter.withLoad
       *
       * @param load Current load config to normalize and rebind.
       *
      * @return A `haumea.pops.exporter` object with normalized `load`.
    */
    # Normalize and bind the current load before layouts or outputs are read.
    # This stays behavioral because normalization is part of the public contract.
    withLoad =
      defun
        (with types; [
          haumeaLoadPop
          haumeaExporterPop
        ])
        (
          load:
          extendPop self (
            self: _: {
              load = root.haumea.internal.default.normalizeLoadConfig load self.load;
            }
          )
        );

    /*
       * @name haumea.exporter.withLayouts
       *
       * @param layouts Computed Haumea layouts.
       *
      * @return A `haumea.pops.exporter` object rebound to the given layouts.
    */
    # These helpers bind later pipeline results back onto the exporter object.
    withLayouts = layouts: kxPop self { inherit layouts; };

    /*
      * @name haumea.exporter.withOutputs
      *
      * @param outputs Exporter-visible output view.
      *
      * @return A `haumea.pops.exporter` object rebound to the given outputs.
    */
    withOutputs = defun (with types; [
      (attrs any)
      haumeaExporterPop
    ]) (outputs: kxPop self { inherit outputs; });
  };
}
