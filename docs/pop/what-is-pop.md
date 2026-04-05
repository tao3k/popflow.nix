---
id: "20260404190000"
title: "What POP Means Here"
category: "concept"
tags:
  - popflow
  - pop
  - concepts
saliency_base: 8.5
decay_rate: 0.02
metadata:
  title: "What POP Means Here"
---

# What POP Means Here

## Summary

POP is the core idea behind `popflow`. It is not just a helper for `extendPop`.
It is a prototype object model for Nix where defaults, inheritance, and final
instances are computed together.

## Core Terms

- `defaults`: the base bindings a pop contributes
- `extension`: the `self: super:` computation that overrides or adds fields
- `parents`: the direct super pops
- `instance`: the fully computed value after POP resolves inheritance
- `unpop`: the operation that erases POP metadata and returns the plain attrset

## Constructor Vocabulary

The most useful constructor vocabulary for `popflow` is:

- `pop`: the full POP object constructor
- `kPop`: the constant-object constructor
- `extendPop`: behavioral single-parent extension
- `kxPop`: constant patching over an existing pop

The current upstream POP snapshot exports `extendPop`, not a separate `exPop`
helper. If people say `exPop` informally, the precise code term in this
repository is still `extendPop`.

## Why POP Matters For Nix Config

Nix configuration systems often want three things at once:

1. a reusable base value
2. local overrides
3. composable inheritance between multiple concerns

POP gives all three in one model. That is why it fits configuration work much
better than ad-hoc one-off extension helpers.

## The Important Shift

The most important POP shift is that inheritance is not just a linear chain of
extensions. POP treats prototypes as a graph with defaults and ordering rules.
That is why names like `recipesExtender`, `inputsExtender`, and `loadExtender`
fit `popflow`: they describe incremental prototype extension instead of generic
"layers".

## How Popflow Uses POP

`popflow` applies the same POP shape across three domains:

- `configs`: extend recipes and exporter args
- `flake`: extend flake inputs and materialize system outputs
- `haumea`: extend load configuration and module-aware exports

## Linked Notes

- Related: [[POP Checks and Invariants|checks-driven-model.md]]
- Related: [[POP Constructor Vocabulary|constructor-vocabulary.md]]
- Related: [[Popflow as a POP Practice|../practice/popflow-as-pop.md]]
- Related: [[Haumea and nixosModules Override Experiments|../experiments/haumea-nixosmodules-overrides.md]]
