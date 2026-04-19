let
  inputs = import ./nix/tamal { };
  callFlake = import inputs.call-flake;

  /*
    Call a pinned flake source directly from the Nixtamal materialized inputs.

    Type: Path -> AttrSet -> AttrSet
  */
  callPinnedFlake = input: args: (import (input + "/flake.nix")).outputs args;
in
/*
  Materialize the repository's pinned external dependencies as plain Nix
  values. This is the non-flake entrypoint the rest of the codebase imports.

  Type: AttrSet
*/
rec {
  inherit inputs;
  call-flake = callFlake;

  nixlib = (callFlake inputs.nixlib).lib;

  haumea = {
    lib = import inputs.haumea { lib = nixlib; };
  };

  yants = callPinnedFlake inputs.yants { nixpkgs.lib = nixlib; };

  namaka = callPinnedFlake inputs.namaka {
    self = null;
    nixpkgs.lib = nixlib;
    inherit haumea;
  };

  dmerge = callPinnedFlake inputs.dmerge {
    self = null;
    inherit
      haumea
      yants
      ;
    nixlib.lib = nixlib;
  };

  POP = import (inputs.POP + "/POP.nix") { lib = nixlib; };

  /*
    Public popflow library layered on top of raw `nixpkgs.lib`.

    Type: AttrSet
  */
  popflowLib = import ./src/__loader.nix {
    call-flake = callFlake;
    inherit
      POP
      dmerge
      haumea
      nixlib
      yants
      ;
  };

  # Keep `nixlib` explicit for callers that need upstream `nixpkgs.lib`.
  lib = popflowLib;
}
