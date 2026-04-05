{
  root,
  POP,
  ...
}:
let
  inherit (POP) pop extendPop;
in
/*
  Seed object for the flake domain. It is responsible for resolving the first
  flake-like input graph from a path, lock fixture, or already-called flake.

  Matching yants contract:
  - `root.flake.contracts.types.inputsPop`

  Guard coverage:
  - this file defines the resulting POP shape
  - the stricter runtime method guards live mainly on `flake.exporter` and
    `flake.default`, where the method inputs are narrower
*/
pop {
  defaults = {
    initInputs = { };
    inputs = { };
    sysInputs = { };
    initFlake = {
      inputs = { };
      outputs = { };
    };
  };
  extension = self: super: {
    /*
       * @name flake.inputs.withInitInputs
       *
       * @param initInputs A path, lock fixture, or already-called flake input graph.
       *
      * @return A `flake.pops.inputs` object with resolved `initFlake` and `initInputs`.
    */
    # Resolve the initial flake once, then expose its input graph as initInputs.
    # The resolved object should keep matching `inputsPop`.
    withInitInputs =
      initInputs:
      extendPop self (
        self: _: {
          initFlake = root.flake.internal.default.resolveInitFlake initInputs super.initFlake;
          initInputs = root.flake.internal.default.resolveInitInputs initInputs self.initFlake;
        }
      );
  };
}
