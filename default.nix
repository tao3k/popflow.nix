let
  sources = import ./nix/tamal { };
  callFlake = import sources.call-flake;

  /*
    Call a pinned flake source directly from the Nixtamal materialized inputs.

    Type: Path -> AttrSet -> AttrSet
  */
  callPinnedFlake = source: args: (import (source + "/flake.nix")).outputs args;
in
/*
  Materialize the repository in two layers:
  - `sources`: raw Nixtamal-pinned source trees
  - `inputs`: plain imported dependency values built from those sources

  Type: AttrSet
*/
rec {
  inherit sources;

  inputs = rec {
    call-flake = callFlake;

    nixlib = (callFlake sources.nixlib).lib;

    haumea = {
      lib = import sources.haumea { lib = nixlib; };
    };

    yants = callPinnedFlake sources.yants { nixpkgs.lib = nixlib; };

    namaka = callPinnedFlake sources.namaka {
      self = null;
      nixpkgs.lib = nixlib;
      inherit haumea;
    };

    dmerge = callPinnedFlake sources.dmerge {
      self = null;
      inherit
        haumea
        yants
        ;
      nixlib.lib = nixlib;
    };

    POP = import (sources.POP + "/POP.nix") { lib = nixlib; };
  };

  inherit (inputs)
    POP
    dmerge
    haumea
    namaka
    nixlib
    yants
    ;
  call-flake = inputs.call-flake;

  /*
    Public popflow library layered on top of raw `nixpkgs.lib`.

    Type: AttrSet
  */
  popflowLib = import ./src inputs;

  # Keep `nixlib` explicit for callers that need upstream `nixpkgs.lib`.
  lib = popflowLib;
}
