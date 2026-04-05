{ lib, ... }:
with lib;

let
  reverseConcatLists = values: concatLists (reverseList values);

  mergeAttrs = zipAttrsWith (
    _: values:
    if tail values == [ ] then
      head values
    else if all isList values then
      unique (reverseConcatLists values)
    else if all isAttrs values then
      mergeAttrs values
    else
      last values
  );

  /*
    Variant of `recursiveMerge` that still merges nested attrsets recursively,
    but concatenates lists in reverse precedence so later list fragments come
    first.

    Type: [AttrSet] -> AttrSet

    Example:
      recursiveMerge' [
        { packages = [ "hello" ]; }
        { packages = [ "git" ]; }
      ]
      => { packages = [ "git" "hello" ]; }
  */
  recursiveMerge =
    attrList:
    if attrList == [ ] then
      { }
    else if tail attrList == [ ] then
      head attrList
    else
      mergeAttrs attrList;
in
recursiveMerge
