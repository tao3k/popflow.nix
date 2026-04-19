/*
  Public popflow library entrypoint for `import ./src`.

  This file also serves as the root `default.nix` interface inside the Haumea
  source tree. When Haumea traverses `src`, the reserved `self/super/root`
  bindings are present; in that case we return a lightweight placeholder and
  let `removeTopDefault` hide this root interface from the final library
  surface.

  Type: AttrSet -> AttrSet
*/
inputs@{
  haumea ? null,
  nixlib ? null,
  self ? null,
  super ? null,
  root ? null,
  ...
}:
if inputs ? self || inputs ? super || inputs ? root then
  { }
else
  let
    removeTopDefault = import ./haumea/removeTopDefault.nix { };
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
    transformer = [ removeTopDefault ];
    inputs = inputs // {
      inherit lib;
    };
  }
