let
  inputs = import ./nix/tamal { };
  callFlake = import inputs.call-flake;

  /*
    Call a pinned flake source directly from the Nixtamal materialized inputs.

    Type: Path -> AttrSet -> AttrSet
  */
  callPinnedFlake = input: args: (import (input + "/flake.nix")).outputs args;
  nixlib = (callFlake inputs.nixlib).lib;
  haumea = {
    lib = import inputs.haumea { lib = nixlib; };
  };
  yants = callPinnedFlake inputs.yants { nixpkgs.lib = nixlib; };
  namaka = callPinnedFlake inputs.namaka {
    self = null;
    nixpkgs = {
      lib = nixlib;
    };
    inherit haumea;
  };
  dmerge = callPinnedFlake inputs.dmerge {
    inherit yants;
    self = null;
    nixlib.lib = nixlib;
    inherit haumea;
  };
in
/*
  Materialize the repository's pinned external dependencies as plain Nix
  values. This is the non-flake entrypoint the rest of the codebase imports.

  Type: AttrSet
*/
{
  call-flake = callFlake;
  inherit
    nixlib
    yants
    haumea
    namaka
    dmerge
    ;
  lib = nixlib;
  POP = import (inputs.POP + "/POP.nix") { lib = nixlib; };
}
