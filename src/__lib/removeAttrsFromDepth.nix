{ lib, super }:
from:
let
  inherit (lib) recursiveUpdate;
  inherit (super) concatMapAttrsWith;

  getPath = l: n: lib.elemAt l n;
in
/*
  Remove an attribute at the requested path from the current attrset cursor.
  A one-segment path removes a top-level key; a two-segment path removes a key
  from the matching nested attrset.

  Type: [String] -> AttrSet -> AttrSet

  Example:
    removeAttrsFromDepth [ "packages" "hello" ] {
      packages = { hello = 1; git = 2; };
      checks = { ok = true; };
    }
    => {
      packages = { git = 2; };
      checks = { ok = true; };
    }
*/
cursor:
concatMapAttrsWith recursiveUpdate (
  file: value:
  if file == getPath from 0 && lib.length from == 1 then
    { }
  else if file == getPath from 0 && (lib.hasAttr (getPath from 1) value) then
    { ${file} = removeAttrs value [ (getPath from 1) ]; }
  else
    { ${file} = value; }
)
