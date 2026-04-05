---
id: "20260404191000"
title: "Grafonnix Style and Namespace Lessons"
category: "practice"
tags:
  - popflow
  - grafonnix
  - style
  - pop
saliency_base: 8.2
decay_rate: 0.02
metadata:
  title: "Grafonnix Style and Namespace Lessons"
---

# Grafonnix Style and Namespace Lessons

## Summary

`grafonnix` is a strong POP practice reference because it turns POP into a
configuration DSL without making users think in implementation buckets first.
The strongest lessons are object namespace design, method design, object
weight separation, internal adaptation, and result-oriented checks.

## Object-First Namespace

The public surface is organized around domain objects:

- `dashboard`
- `row`
- `template`
- `link`
- `prometheus`

This is why `grafonnix` feels clean. Users first discover what they are
building, not how the library was implemented.

## Constructor And Method Grammar

The next layer is stable and predictable:

- constructors such as `dashboard.new`, `row.new`, and `template.new`
- methods such as `addPanel`, `addTemplate`, `addLink`, `addTarget`
- plural forms such as `addPanels`, `addTemplates`, `addTargets`

This turns POP extension into a recognizable DSL grammar:

1. create an object
2. keep extending the same object
3. unpop the final result

## POP Weight Separation

`grafonnix` does not use one POP constructor weight for everything.

- `pop` is used for rich objects with behavior and internal state
- `kPop` is used for lighter constant-like value objects
- `extendPop` is used for behavioral method growth over an existing object
- `kxPop` is used for patching an existing object with a constant extension

This is one of its deepest strengths. The DSL stays expressive without turning
every value into the heaviest possible object.

One precise vocabulary note matters here: the current POP snapshot exports
`extendPop`, not `exPop`. If `exPop` is used informally in conversation, the
code-level reference in this repository should still be `extendPop`.

## `template.nix` As The Sharpest Example

`grafonnix/grafonnix/template.nix` is one of the clearest files to study
because it shows constructor-weight choices side by side.

- `template.new`, `template.text`, and `template.adhoc` lean on `kPop`
  because they mainly materialize value objects
- `template.interval`, `template.datasource`, and `template.custom` stay on
  `pop` because they normalize or compute fields from richer behavior
- follow-up constant adjustments elsewhere in grafonnix then use `kxPop`
  rather than wrapping a constant patch in `extendPop`

For `popflow`, this means the first adoption target should be real constant
patches in examples and tests. Behavior-rich domain objects should keep
`extendPop` until they truly become constant-only objects.

## Internal Adaptation Stays Internal

`grafonnix` keeps adaptation logic inside the object implementation:

- compatibility branches stay inside the object file
- helper machinery such as recursive unpop lives under `internal/`
- public names stay stable even when internal structure changes

`visibility` exists, but it is not the most important lesson for `popflow`.
`__unpop__` and recursive unpop already carry most of the important result
separation.

## Documentation Style

Java-style `@param` and `@method` comments are used heavily. This works well
for configuration systems because users search for:

- what can I pass
- what methods exist
- what object shape comes back

That makes object files double as API references.

## Checks Validate DSL Semantics

The checks do not focus on internal helpers. They focus on:

1. building an object graph through POP methods
2. calling `.__unpop__`
3. comparing the resulting JSON shape with expected compiled output

That is the right validation target for a configuration DSL.

## What Popflow Should Learn

For `popflow`, the strongest takeaways are:

- public namespace should advertise POP objects directly
- verbs such as `addLoadExtender` and `outputsForSystem` should stay method-level
- `pops` is a better public grouping than `builders`
- helper and compatibility logic should move behind object files
- tests should validate final configuration semantics, not only intermediate attrsets
- `pop / kPop / kxPop` should guide object-weight choices in `popflow`
- `extendPop` should stay the explicit behavioral extension primitive
- `template.nix` is a good litmus test: if the change is only a constant patch,
  do not reach for a behavioral extender first

## Linked Notes

- Related: [[POP Checks and Invariants|../pop/checks-driven-model.md]]
- Related: [[POP Constructor Vocabulary|../pop/constructor-vocabulary.md]]
- Related: [[Popflow as a POP Practice|popflow-as-pop.md]]
- Related: [[Popflow Src Refactor Principles|src-refactor-principles.md]]
- Related: [[Haumea POP Surface|../reference/haumea.md]]
