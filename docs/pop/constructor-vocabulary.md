---
id: "20260404221500"
title: "POP Constructor Vocabulary"
category: "concept"
tags:
  - popflow
  - pop
  - constructors
saliency_base: 8.8
decay_rate: 0.02
metadata:
  title: "POP Constructor Vocabulary"
---

# POP Constructor Vocabulary

## Summary

To read `popflow` well, it is not enough to know that POP supports inheritance.
You also need to know which POP constructor is being used and why. The current
POP snapshot under `.data/POP/POP.nix` makes four constructors especially
important for `popflow` and `grafonnix`:

- `pop`
- `kPop`
- `extendPop`
- `kxPop`

## The Important Clarification

The current upstream POP snapshot exports `extendPop`. It does not export a
separate `exPop` helper. If team discussion says `exPop`, the precise code term
in this repository should still be `extendPop` unless a new helper is
deliberately introduced later.

## `pop`

`pop` is the general constructor for a real POP object.

- it can have `parents`
- it can have `defaults`
- it can have a behavioral `extension = self: super: ...`
- it computes an instantiated object with `__meta__`

Use `pop` when the object has real behavior, not just static data.

## `kPop`

`kPop` is the constant-object constructor. It wraps a constant attrset as a POP
object.

- use it for lightweight values
- use it when you need a POP-shaped object but not a behavioral object
- remember that POP also treats a plain attrset like an implicit `kPop` when it
  extracts metadata

This is why `grafonnix` uses `kPop` heavily for small value objects and patches.
`grafonnix/grafonnix/template.nix` is a particularly clear example:

- `template.new` is mostly a value object, so it uses `kPop`
- `template.text` and `template.adhoc` also stay lightweight and use `kPop`

## `extendPop`

`extendPop` is the single-parent behavioral extension constructor.

- start from an existing pop
- add or override behavior with `self: super: ...`
- keep the original object model, but extend it one more step

This is the normal choice when you are implementing methods such as
`addInputsExtender`, `addLoadExtender`, or exporter behavior that depends on
current instance state.

`grafonnix/grafonnix/template.nix` also shows the opposite case: variants such
as `template.interval`, `template.datasource`, and `template.custom` stay on
`pop` because they compute and normalize richer state.

## `kxPop`

`kxPop` is the constant patch form of single-parent extension.

- start from an existing pop
- apply a constant attrset patch
- do not write a new behavioral `self: super:` extension when you only need a
  constant override

This is especially visible in `grafonnix`, where rows and panels often get
constant patches such as `gridPos`, `id`, or other layout fields.

The practical reading rule is simple: if you do not need `self` or `super`,
there is a good chance you are looking at a `kxPop` site rather than an
`extendPop` site.

## Secondary Constructors

The current POP snapshot also exports helpers such as:

- `selfPop`
- `simplePop`
- `mergePops`
- `defaultsPop`
- `namePop`

These matter, but they are not the primary teaching vocabulary for `popflow`.
The four constructors above explain most of the POP design choices that show up
in this repository.

## What Grafonnix Teaches

`grafonnix` uses the vocabulary in a clean way:

- `pop` for rich objects like dashboards, rows, and panels
- `kPop` for lightweight constant values
- `extendPop` for behavior-rich object methods
- `kxPop` for constant patches on existing objects

That separation is one reason the namespace stays clean without flattening
everything into one object weight.

## What Popflow Should Learn

For `popflow`, the practical guidance is:

- public domain objects stay under `domain.pops.*`
- those public objects are usually built with `pop`
- method implementations usually rely on `extendPop`
- future lightweight constant objects should use `kPop` deliberately
- future constant patch operations should prefer `kxPop` over a needlessly
  heavier behavioral extension

The executable companion for this note is
[`tests/popConstructors/expr.nix`](../../tests/popConstructors/expr.nix).

## Linked Notes

- Related: [[What POP Means Here|what-is-pop.md]]
- Related: [[POP Checks and Invariants|checks-driven-model.md]]
- Related: [[Grafonnix Style and Namespace Lessons|../practice/grafonnix-style.md]]
- Related: [[Popflow as a POP Practice|../practice/popflow-as-pop.md]]
