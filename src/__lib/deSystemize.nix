{ lib }:
let
  l = lib // builtins;
  /*
    Collapse system-scoped attribute sets into the surrounding attrset for up to
    three levels, so callers can work with `packages.<system>` style outputs as
    plain attrs.

    Type: String -> AttrSet -> AttrSet

    Example:
      deSystemize "x86_64-linux" {
        packages = {
          x86_64-linux = { hello = "drv"; };
        };
      }
      => {
        packages = {
          x86_64-linux = { hello = "drv"; };
          hello = "drv";
        };
      }
  */
  deSystemize =
    let
      iteration =
        cutoff: system: fragment:
        if cutoff == 0 || !(l.isAttrs fragment) then
          fragment
        else
          let
            systemKey = "${system}";
            hasSystemFragment = l.hasAttr systemKey fragment;
            systemFragment = fragment.${systemKey};
          in
          if !hasSystemFragment then
            l.mapAttrs (_: iteration (cutoff - 1) system) fragment
          else if l.isFunction systemFragment then
            fragment // { __functor = _: systemFragment; }
          else
            fragment // systemFragment;
    in
    iteration 3;
in
deSystemize
