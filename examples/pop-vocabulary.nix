/*
  POP vocabulary example. Read this first to understand how `popflow` expects you
  to think about `pop`, `kPop`, `extendPop`, and `kxPop`.

  Type: { inputs = AttrSet; } -> AttrSet
*/
{ inputs }:
let
  inherit (inputs.POP)
    pop
    kPop
    extendPop
    kxPop
    ;

  richObject = pop {
    defaults = {
      baseValue = 5;
      coordinateSet = {
        x = 1;
        y = 2;
      };
    };
    extension = self: super: {
      baseValue = super.baseValue + 1;
      derivedValue = self.baseValue + self.coordinateSet.x;
    };
  };

  behavioralExtension = extendPop richObject (
    self: _: {
      extensionKind = "behavioral";
      mirroredBaseValue = self.baseValue;
    }
  );

  constantObject = kPop {
    label = "constant-leaf";
    enabled = true;
  };

  constantPatch = kxPop richObject {
    extensionKind = "constant";
    leaf = constantObject;
  };

  templateStyleValue = kPop {
    name = "environment";
    label = "Environment";
    query = "label_values(up, env)";
    type = "query";
    includeAll = true;
  };

  templateStyleBehavior = pop {
    defaults = {
      name = "resolution";
      options = [
        "5m"
        "15m"
        "1h"
      ];
      type = "interval";
    };
    extension = self: _: {
      label = "Resolution";
      current = builtins.elemAt self.options 1;
      optionCount = builtins.length self.options;
    };
  };

  templateStylePatch = kxPop templateStyleValue {
    current = "prod";
    hide = "label";
  };
in
{
  inherit
    richObject
    behavioralExtension
    constantObject
    constantPatch
    ;

  grafonnixTemplateStyle = {
    valueObject = templateStyleValue;
    behaviorObject = templateStyleBehavior;
    patchedValueObject = templateStylePatch;
  };

  takeaways = {
    pop = "Use for rich POP objects with defaults, parents, and behavior.";
    kPop = "Use for lightweight constant-like POP objects.";
    extendPop = "Use when you need one more behavioral POP step.";
    kxPop = "Use when you only need a constant patch over an existing POP object.";
    templateNix = "Grafonnix template.nix is a good reading guide: value-like template objects lean on kPop, richer template variants use pop, and constant follow-up changes should prefer kxPop.";
  };
}
