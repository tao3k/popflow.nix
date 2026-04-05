/*
  Exercise the POP constructor vocabulary directly. This keeps the repository
  learning path executable: users can compare `pop`, `extendPop`, `kPop`, and
  `kxPop` side by side and see the `grafonnix/template.nix` lesson reflected in
  a concrete snapshot.

  Type: AttrSet -> AttrSet
*/
{ inputs, ... }:
let
  example = import ../../examples/pop-vocabulary.nix { inherit inputs; };
in
{
  constructors = {
    pop = {
      meta = example.richObject.__meta__.name;
      baseValue = example.richObject.baseValue;
      derivedValue = example.richObject.derivedValue;
    };

    extendPop = {
      meta = example.behavioralExtension.__meta__.name;
      kind = example.behavioralExtension.extensionKind;
      mirroredBaseValue = example.behavioralExtension.mirroredBaseValue;
    };

    kPop = {
      meta = example.constantObject.__meta__.name;
      label = example.constantObject.label;
      enabled = example.constantObject.enabled;
    };

    kxPop = {
      meta = example.constantPatch.__meta__.name;
      kind = example.constantPatch.extensionKind;
      leafMeta = example.constantPatch.leaf.__meta__.name;
      leafLabel = example.constantPatch.leaf.label;
    };
  };

  grafonnixTemplateStyle = {
    valueObject = {
      meta = example.grafonnixTemplateStyle.valueObject.__meta__.name;
      name = example.grafonnixTemplateStyle.valueObject.name;
      type = example.grafonnixTemplateStyle.valueObject.type;
      includeAll = example.grafonnixTemplateStyle.valueObject.includeAll;
    };

    behaviorObject = {
      meta = example.grafonnixTemplateStyle.behaviorObject.__meta__.name;
      name = example.grafonnixTemplateStyle.behaviorObject.name;
      type = example.grafonnixTemplateStyle.behaviorObject.type;
      current = example.grafonnixTemplateStyle.behaviorObject.current;
      optionCount = example.grafonnixTemplateStyle.behaviorObject.optionCount;
    };

    patchedValueObject = {
      meta = example.grafonnixTemplateStyle.patchedValueObject.__meta__.name;
      current = example.grafonnixTemplateStyle.patchedValueObject.current;
      hide = example.grafonnixTemplateStyle.patchedValueObject.hide;
    };
  };

  takeaways = example.takeaways;
}
