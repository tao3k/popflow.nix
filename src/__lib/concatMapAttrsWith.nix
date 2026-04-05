{ lib }:
/*
  Map each attribute in the input set into a new attribute set and then merge
  all mapped results with the provided merge function.

  Type: (AttrSet -> AttrSet -> AttrSet) -> (String -> a -> AttrSet) -> AttrSet -> AttrSet

  Example:
    concatMapAttrsWith (mergeAttrsButConcatOn "mykey")
      (name: value: {
        ${name} = value;
        mykey = [ value value ];
      })
      { x = "a"; y = "b"; }
    => { x = "a"; y = "b"; mykey = [ "a" "a" "b" "b" ]; }
*/
let
  inherit (builtins) attrValues foldl' mapAttrs;
  inherit (lib) flip pipe;
in
merge: f:
flip pipe [
  (mapAttrs f)
  attrValues
  (foldl' merge { })
]
