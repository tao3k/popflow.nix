---
id: "20260404193000"
title: "Configs POP Surface"
category: "reference"
tags:
  - popflow
  - configs
  - reference
  - pop
saliency_base: 8.0
decay_rate: 0.02
metadata:
  title: "Configs POP Surface"
---

# Configs POP Surface

## Summary

The `configs` domain uses POP to compose recipe trees and optional exporter
arguments before producing exported config fragments.

## Canonical Surface

- `lib.configs.pops.recipes`
- `lib.configs.pops.args`
- `lib.configs.pops.exporter`
- `lib.configs.pops.default`
- `lib.configs.contracts`

Legacy compatibility remains under `lib.configs.builders.*`, but the POP-first
surface is `lib.configs.pops.*`.
The contracts surface now also exposes POP-first type aliases such as
`recipesPop`, `argsPop`, `exporterPop`, and `defaultPop`, while keeping the
older compatibility names.

## Yants Contract Layer

The `configs` domain uses [../../src/configs/contracts.nix](../../src/configs/contracts.nix)
as its `yants` contract surface.

- `openStruct` describes the POP object shapes
- the contracts layer already names the public object shapes and compatibility aliases
- deeper runtime `defun` coverage is more straightforward in `flake` and `haumea`; `configs` needs a more careful contract design because its workflow methods are inherited and highly polymorphic
- the compact cross-domain map lives in [yants-contracts.md](yants-contracts.md)

## POP Objects

### `lib.configs.pops.recipes`

Role:
the seed object for the recipe tree.

Constructor:
`withInitRecipes initRecipes`

Use this when:
you want to choose the initial recipe attrset before any extenders run.

Returns:
a new recipe POP object with a different `initRecipes` seed.

### `lib.configs.pops.args`

Role:
the exporter-side argument object.

Main methods:
`addArgsExtender argsExtender`
`addArgsExtenders argsExtenders`

Use this when:
exporters need extra computed context under `self.args`.

Returns:
a POP object whose `args` field is the left-to-right fold of all arg extenders.

### `lib.configs.pops.exporter`

Role:
the export object that binds recipes and args, then emits final exports.

Main methods:
`withRecipes recipes`
`withArgs args`
`addExporter exporter`
`addExporters exporters`

Use this when:
you want one exporter object to read a resolved recipe or args view before
computing `exports`.

### `lib.configs.pops.default`

Role:
the main workflow object for the `configs` domain.

Parents:
`recipes`
`args`
`exporter`

Main methods:
`withInitRecipes initRecipes`
`addRecipesExtender recipesExtender`
`addRecipesExtenders recipesExtenders`
`addArgsExtender argsExtender`
`addArgsExtenders argsExtenders`
`addExporter exporter`
`addExporters exporters`

Main fields:
`recipes`
`args`
`exports`

Use this when:
you want the whole recipe pipeline in one object.

## Constructor And Method Grammar

The normal reading order is:

1. call `default.withInitRecipes`
2. add recipe extenders
3. optionally add args extenders
4. optionally add exporters
5. read `recipes`, `args`, or `exports`

`withInitRecipes` is a seed-reset helper, but it still uses `extendPop` so the
workflow keeps the expected recursive POP view. Likewise, `withRecipes` and
`withArgs` are rebinding helpers conceptually, yet their implementation stays
behavioral because the exporter path expects a full recursive POP object rather
than a shallow constant patch.

The `add*Extender(s)` helpers remain the main workflow growth points.

## Best Mental Model

Treat this domain as POP for configuration recipe sets. The extenders are the
prototype increments; `exports` is the instantiated result chosen for
consumers.

## Executable Companions

- Example: [../../examples/configs-workflow.nix](../../examples/configs-workflow.nix)
- Test: [../../tests/configs/expr.nix](../../tests/configs/expr.nix)
- Snapshot: [../../tests/_snapshots/configs](../../tests/_snapshots/configs)
- Contract manual: [yants-contracts.md](yants-contracts.md)

## Linked Notes

- Related: [[Popflow as a POP Practice|../practice/popflow-as-pop.md]]
- Related: [[What POP Means Here|../pop/what-is-pop.md]]
