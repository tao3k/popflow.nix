{
  outputs =
    _:
    let
      inputs = import ./.;
      lib = import ./src/__loader.nix inputs;
      examplesLib = lib // inputs.nixlib;
      checkInputs = lib // {
        inherit inputs;
        popflowLib = inputs.nixlib // lib;
        lib = inputs.nixlib // lib;
      };
    in
    /*
      Assemble the public flake outputs from the plain imported popflow inputs.

      Type: AttrSet
    */
    {
      inherit lib;
      popflow = inputs;
      examples = import ./examples/_loader.nix {
        inherit inputs;
        lib = examplesLib;
      };
      checks = inputs.namaka.lib.load {
        src = ./tests;
        inputs = checkInputs;
      };
    };
}
