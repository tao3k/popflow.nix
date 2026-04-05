{ lib, root }:
let
  inherit (lib) mapAttrs isAttrs;

  /*
    Merge two attrsets recursively until the requested depth. Once the depth
    limit is reached, the right-hand side wins with a plain `//` merge.

    Type: Int -> AttrSet -> AttrSet -> AttrSet

    Example:
      mergeToDepth 2
        { a.b = 1; a.c = 2; }
        { a.b = 3; a.d = 4; }
      => { a = { b = 3; c = 2; d = 4; }; }
  */
  mergeToDepth =
    depth: lhs: rhs:
    if rhs == { } then
      lhs
    else if lhs == { } then
      rhs
    else if depth == 1 then
      lhs // rhs
    else
      lhs // (mapAttrs (n: v: if isAttrs v then mergeToDepth (depth - 1) (lhs.${n} or { }) v else v) rhs);
in
mergeToDepth
