---
id: "20260404191100"
title: "Popflow as a POP Practice"
category: "practice"
tags:
  - popflow
  - pop
  - configs
  - flake
  - haumea
saliency_base: 8.4
decay_rate: 0.02
metadata:
  title: "Popflow as a POP Practice"
---

# Popflow as a POP Practice

## Summary

`popflow` is a practical POP project for Nix configuration. It takes the POP
model and applies it to three recurring configuration problems: config trees,
flake inputs, and Haumea-driven filesystem loading.

## The Shared POP Shape

Each `popflow` domain follows the same broad pattern:

1. define an initial value
2. extend it with one or more extenders
3. run exporters or materializers
4. read the final instantiated result

That POP story is paired with a contract story. Public methods are not only
named; many of them are also constrained through `yants` and `defun`.

## Constructor Vocabulary Matters Too

The POP story in `popflow` is not only about object names. It is also about which
constructor is being used:

- `pop` for the main domain objects
- `extendPop` for behavioral extension of those objects
- `kPop` for lightweight constant objects
- `kxPop` for constant patches on existing objects

The current POP snapshot exports `extendPop`, not a separate `exPop` helper, so
that is the term `popflow` should teach precisely.

## Yants Matters Too

`popflow` is not only shaped by POP constructors. It also uses `yants` as a
public contract layer:

- `openStruct` and `struct` define POP object and patch shapes
- `defun` constrains public method arguments and return kinds
- `contracts` and `types` make those expectations explicit in source

That is why `*.contracts` should not be treated as secondary trivia. They are
part of the public architecture.

## Domain Translation

### `configs`

- start from `withInitRecipes`
- extend with `recipesExtender` and `argsExtender`
- export with `exporter`

### `flake`

- start from `withInitInputs`
- extend with `inputsExtender`
- materialize with `outputsForSystem` or `outputsForSystems`

### `haumea`

- start from `withInitLoad`
- extend with `loadExtender`
- export plain data layouts or module-aware outputs

## What Makes Popflow Distinct

The distinctive part is the `haumea` domain. `popflow` is not only composing
attrsets; it is experimenting with how POP-style extenders can control module
loading, module normalization, and override behavior in a filesystem-backed
tree.

## Why `pops` Should Be Primary

The core public idea is not `builders`. The core public idea is the POP
object. For teaching and source structure, the cleaner target shape is:

- `configs.pops.recipes`
- `configs.pops.args`
- `configs.pops.exporter`
- `configs.pops.default`
- `flake.pops.inputs`
- `flake.pops.exporter`
- `flake.pops.default`
- `haumea.pops.load`
- `haumea.pops.exporter`
- `haumea.pops.default`

Stable verbs such as `addRecipesExtender`, `addLoadExtender`, and
`outputsForSystem` then live on those objects.

## Current State And Target State

Today parts of the repository still teach `builders` as the public grouping.
The target direction is to keep the verbs and POP semantics, but move the
source teaching surface toward `domain.pops.*`.

## Linked Notes

- Related: [[What POP Means Here|../pop/what-is-pop.md]]
- Related: [[POP Constructor Vocabulary|../pop/constructor-vocabulary.md]]
- Related: [[Yants Contracts in Popflow|yants-contracts.md]]
- Related: [[Grafonnix Style and Namespace Lessons|grafonnix-style.md]]
- Related: [[Popflow Src Refactor Principles|src-refactor-principles.md]]
- Related: [[Haumea and nixosModules Override Experiments|../experiments/haumea-nixosmodules-overrides.md]]
