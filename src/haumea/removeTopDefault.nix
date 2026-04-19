/*
  Remove only the top-level `default` leaf from a Haumea-loaded tree. Use this
  when the root `default.nix` exists as the Nix import interface, but should
  not appear as part of the loaded data surface.

  Type: AttrPath -> AttrPath -> AttrSet -> AttrSet
*/
_: cursor: dir:
if builtins.length cursor == 0 && dir ? default then removeAttrs dir [ "default" ] else dir
