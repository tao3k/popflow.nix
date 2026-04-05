/*
  Load the popflow library in two phases: first the base helpers under `__lib`,
  then the higher-level modules under `src` with that composed lib in scope.

  Type: AttrSet -> AttrSet
*/
inputs@{
  haumea,
  nixlib,
  ...
}:
let
  selfLib = haumea.lib.load {
    src = ./__lib;
    inputs = {
      lib = nixlib;
    };
  };
  lib = nixlib // selfLib;
in
selfLib
// haumea.lib.load {
  src = ./.;
  inputs = inputs // {
    inherit lib;
  };
}
