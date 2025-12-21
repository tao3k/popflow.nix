{ yants, root }:
let
  types = root.configs.types // yants;

  structAttrs = with yants; {
    pop = {
      __meta__ = option (
        struct "__meta__" {
          __id__ = list any;
          name = string;
          parents = list types.pop;
          defaults = attrs any;
          extension = function;
          precedenceList = list (attrs any);
        }
      );
    };
  };
in
structAttrs
