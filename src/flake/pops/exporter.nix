{
  root,
  POP,
  yants,
  ...
}:
let
  inherit (POP) pop kxPop;
  inherit (yants) defun;
  # Reuse the named flake contracts directly in `defun` signatures.
  types = root.flake.contracts.types // yants;
in
/*
  Export object for the flake domain. It binds a resolved input graph and an
  optional concrete system before rendering exports.

  Matching yants contract:
  - `root.flake.contracts.types.exporterPop`

  Guard coverage:
  - both public methods are runtime-guarded with `defun`
  - rebinding uses `kxPop` because these are true constant-view updates
*/
pop {
  defaults = {
    inputs = { };
    exports = { };
    system = "";
  };
  extension = self: _: {
    /*
       * @name flake.exporter.withInputs
       *
       * @param inputs Resolved de-systemized input graph.
       *
      * @return A `flake.pops.exporter` object rebound to the given inputs.
    */
    # Bind the resolved input graph before this exporter computes outputs.
    # This is the clean `kxPop` + `defun` pattern used throughout flake.
    withInputs = defun (with types; [
      (attrs any)
      exporter
    ]) (inputs: kxPop self { inherit inputs; });

    /*
       * @name flake.exporter.withSystem
       *
       * @param system Concrete system string such as `x86_64-linux`.
       *
      * @return A `flake.pops.exporter` object rebound to one concrete system.
    */
    # Bind one concrete system when a caller wants desystemized views.
    withSystem = defun (with types; [
      string
      exporter
    ]) (system: kxPop self { inherit system; });
  };
}
