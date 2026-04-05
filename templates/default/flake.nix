/*
  Minimal downstream flake that uses the current public Haumea POP workflow.

  Reading order:
  1. define `loadModules` through `popflow.lib.haumea.pops.default.withInitLoad`
  2. reuse that workflow for `evalModules`
  3. reuse the same workflow again for `nixosSystem`

  This template intentionally teaches one POP-first entrypoint instead of
  several parallel helper namespaces.
*/
{
  inputs = {
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixlib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    popflow.url = "github:tao3k/popflow.nix";
  };

  outputs =
    {
      self,
      haumea,
      nixlib,
      nixpkgs,
      popflow,
    }:
    let
      # Step 1: create one reusable Haumea POP workflow from the public
      # `haumea.pops.default` entrypoint.
      loadModules = popflow.lib.haumea.pops.default.withInitLoad {
        src = ./nixosModules;
        type = "nixosModules";
      };
    in
    {
      # Step 2: consume the materialized module tree through plain evalModules.
      eval = nixpkgs.lib.evalModules {
        modules = [ loadModules.outputs.default.programs.git ];
      };

      # Step 3: reuse the same workflow again for a full nixosSystem.
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ loadModules.outputs.default.programs.git ];
      };

      inherit loadModules;
    };
}
