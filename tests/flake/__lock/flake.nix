{
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixlib.url = "github:nix-community/nixpkgs.lib";
  };
  outputs =
    { self, ... }@inputs:
    {
      inherit inputs;
    };
}
