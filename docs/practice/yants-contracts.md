---
id: "20260404235500"
title: "Yants Contracts in Popflow"
category: "practice"
tags:
  - popflow
  - yants
  - contracts
  - pop
saliency_base: 8.7
decay_rate: 0.02
metadata:
  title: "Yants Contracts in Popflow"
---

# Yants Contracts in Popflow

## Summary

`popflow` is not only a POP practice project. It is also a `yants` contract
project. POP gives the object model; `yants` gives the executable type layer
for those objects and their public methods.

## Why Yants Matters Here

In this repository, `yants` is important for three reasons:

1. it defines the contract shapes behind `configs.contracts`, `flake.contracts`, and `haumea.types`
2. it powers `defun` on public methods such as `addInputsExtender`, `withLoad`, and `outputsForSystem`
3. it makes the POP surface easier to reason about because method inputs and return kinds are explicit

Without that layer, the repo would still have POP objects, but it would lose a
large part of its public contract discipline.

## POP And Yants Are Complementary

The practical split is:

- POP answers: what object is this, who are its parents, and how does it extend?
- `yants` answers: what shape does this object have, and what arguments may its public methods accept?

That is why both layers belong in the public project story.

## Where The Contract Layer Lives

### `configs`

- [../../src/configs/contracts.nix](../../src/configs/contracts.nix)
- `openStruct` defines POP object shapes such as `recipesPop`, `argsPop`, `exporterPop`, and `defaultPop`
- today the strongest runtime `defun` coverage is still in `flake` and `haumea`
- in `configs`, the contracts file already defines the public shapes, but deeper method-level runtime contracts need a dedicated design because the workflow is more polymorphic

### `flake`

- [../../src/flake/contracts.nix](../../src/flake/contracts.nix)
- `inputsPop`, `exporterPop`, `inputsPatch`, and `defaultPop` define the flake object surface
- `defun` constrains methods such as `withInputs`, `withSystem`, `addInputsExtender`, and `outputsForSystem`

### `haumea`

- [../../src/haumea/structAttrs.nix](../../src/haumea/structAttrs.nix)
- [../../src/haumea/types.nix](../../src/haumea/types.nix)
- the Haumea contract layer is split because it has richer structural needs for load configs and module experiments

## Why This Is Especially Important For Haumea

The Haumea path is where `popflow` gets most experimental. Load types, module
import behavior, and layout extenders are more complex than plain recipe or
flake input graphs. That makes explicit type contracts more valuable, not less.

## What The Reader Should Expect

When you read a public POP object file in `popflow`, expect two layers:

1. POP structure in the object definition itself
2. `yants` contracts through `defun`, `openStruct`, or `struct`

If one of those layers is missing, the public story is incomplete.

## Executable Companions

- Yants learning example: [../../examples/yants-contracts.nix](../../examples/yants-contracts.nix)
- POP constructor semantics: [../../tests/popConstructors/expr.nix](../../tests/popConstructors/expr.nix)
- Yants contract semantics: [../../tests/yantsContracts/expr.nix](../../tests/yantsContracts/expr.nix)
- Configs semantics: [../../tests/configs/expr.nix](../../tests/configs/expr.nix)
- Flake semantics: [../../tests/flake/expr.nix](../../tests/flake/expr.nix)
- Haumea semantics: [../../tests/haumeaData/expr.nix](../../tests/haumeaData/expr.nix), [../../tests/haumeaNixOSModules/expr.nix](../../tests/haumeaNixOSModules/expr.nix), [../../tests/evalModules/expr.nix](../../tests/evalModules/expr.nix)

## Linked Notes

- Related: [[Yants Contract Surface|../reference/yants-contracts.md]]
- Related: [[Popflow as a POP Practice|popflow-as-pop.md]]
- Related: [[Popflow Src Refactor Principles|src-refactor-principles.md]]
- Related: [[Configs POP Surface|../reference/configs.md]]
- Related: [[Flake POP Surface|../reference/flake.md]]
- Related: [[Haumea POP Surface|../reference/haumea.md]]
