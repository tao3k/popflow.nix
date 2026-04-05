{
  POP,
  ...
}:
let
  inherit (builtins) foldl';
  inherit (POP) pop extendPop;

  appendPopList =
    field: values: target:
    extendPop target (_: super: { ${field} = super.${field} ++ values; });
in
/*
  Helper object for exporter-side arguments. Use this when a configs workflow
  needs extra context that exporters can read through `self.args`.

  Matching yants contract:
  - `root.configs.contracts.types.argsPop`

  Guard coverage:
  - this file currently teaches named POP shapes more than runtime method guards
*/
pop {
  defaults = {
    args = { };
    argsExtenders = [ ];
  };
  extension = self: _: {
    # Fold arg patches left-to-right into one exporter-facing attrset.
    args = foldl' (args: extender: args // extender) { } self.argsExtenders;

    /*
       * @name configs.args.addArgsExtenders
       *
       * @param argsExtenders A list of attrset patches to fold into `self.args`.
       *
      * @return A `configs.pops.args` object with one longer arg-extender list.
    */
    # Mirror the `addX` / `addXs` grammar used across the repo.
    # The resulting object should keep matching `argsPop`.
    addArgsExtenders = argsExtenders: appendPopList "argsExtenders" argsExtenders self;

    /*
      * @name configs.args.addArgsExtender
      *
      * @param argsExtender One attrset patch to append to `argsExtenders`.
      *
      * @return A `configs.pops.args` object with one additional arg extender.
    */
    addArgsExtender = argsExtender: self.addArgsExtenders [ argsExtender ];
  };
}
