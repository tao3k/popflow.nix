{
  outputs =
    _:
    let
      popflow = import ./.;
      checkContext = popflow // {
        inputs = popflow;
        popflowLib = popflow.lib;
      };
    in
    /*
      Assemble the public flake outputs from the plain imported popflow inputs.

      Type: AttrSet
    */
    {
      inherit popflow;
      inherit (popflow)
        lib
        popflowLib
        ;
      examples = import ./examples/_loader.nix {
        inputs = popflow;
        lib = popflow.lib;
      };
      checks = popflow.namaka.lib.load {
        src = ./tests;
        inputs = checkContext;
      };
    };
}
