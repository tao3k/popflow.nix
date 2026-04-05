{ lib }:
let
  l = lib // builtins;
  mergeAttrs = builtins.zipAttrsWith (
    _: values:
    if l.tail values == [ ] then
      l.head values
    else if l.all l.isList values then
      l.unique (l.concatLists values)
    else if l.all l.isAttrs values then
      mergeAttrs values
    else
      l.last values
  );
in
/*
  Recursively merge a list of attrsets. Nested attrsets are merged, lists are
  concatenated in input order with duplicates removed, and non-attr values use
  the last value.

  Type: [AttrSet] -> AttrSet

  Example:
    recursiveMerge [
      { packages = [ "hello" ]; nested.a = 1; }
      { packages = [ "git" ]; nested.b = 2; }
    ]
    => {
      packages = [ "hello" "git" ];
      nested = { a = 1; b = 2; };
    }
*/
attrList:
if attrList == [ ] then
  { }
else if l.tail attrList == [ ] then
  l.head attrList
else
  mergeAttrs attrList
