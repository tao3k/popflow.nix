---
id: "20260404193200"
title: "Haumea POP Surface"
category: "reference"
tags:
  - popflow
  - haumea
  - reference
  - pop
saliency_base: 8.3
decay_rate: 0.02
metadata:
  title: "Haumea POP Surface"
---

# Haumea POP Surface

## Summary

The `haumea` domain uses POP to extend load configuration for filesystem trees
and to materialize either plain data layouts or module-aware outputs.

## Canonical Surface

- `lib.haumea.pops.load`
- `lib.haumea.pops.exporter`
- `lib.haumea.pops.default`
- `lib.haumea.contracts`
- `lib.haumea.moduleImporter`
- `lib.haumea.moduleLayouts`

The contracts/type surface also exposes POP-first aliases such as `loadPop`,
`exporterPop`, `defaultPop`, and `initLoadPop`, while retaining the older
`haumea*` compatibility names.

## Yants Contract Layer

The `haumea` domain uses [../../src/haumea/structAttrs.nix](../../src/haumea/structAttrs.nix)
and [../../src/haumea/types.nix](../../src/haumea/types.nix) as its `yants`
contract layer.

- `struct` and `openStruct` describe load, exporter, and workflow shapes
- `defun` constrains methods such as `withInitLoad`, `withLoad`, `addLoadExtender`, and `outputs`
- this matters especially on the module-oriented path, where the load surface is richer
- the compact cross-domain map lives in [yants-contracts.md](yants-contracts.md)

## POP Objects

### `lib.haumea.pops.load`

Role:
the seed object that answers how a filesystem tree should be loaded.

Constructor:
`withInitLoad initLoad`

Use this when:
you want to set the source tree, loader, transformer chain, inputs, or load
type before exporters are involved.

### `lib.haumea.pops.exporter`

Role:
the export object that binds a normalized load, computed layouts, and optional
output views.

Main methods:
`withLoad load`
`withLayouts layouts`
`withOutputs outputs`

Use this when:
an exporter needs later pipeline results rebound onto one object before it
computes `exports`.

### `lib.haumea.pops.default`

Role:
the main workflow object for plain Haumea data loads and the popflow-specific
module experiment.

Parents:
`load`
`exporter`

Main methods:
`withInitLoad initLoad`
`addLoadExtender loadExtender`
`addLoadExtenders loadExtenders`
`addExporter exporter`
`addExporters exporters`
`outputs ext`

Main fields:
`load`
`layouts`
`outputs`
`exports`

Use this when:
you want the whole Haumea workflow in one object.

## Experiment Helpers

### `lib.haumea.moduleImporter`

Role:
the module-aware importer used when load type is `nixosModules`.

### `lib.haumea.moduleLayouts`

Role:
the layout adapter that turns loaded Haumea trees into module-oriented
structures and extenders.

## Constructor And Method Grammar

The normal reading order is:

1. call `default.withInitLoad`
2. add load extenders
3. optionally add exporters
4. read `load`, `layouts`, `outputs`, or `exports`

`withLayouts` and `withOutputs` are constant rebinding helpers. `withLoad`
stays behavior-rich because it normalizes the incoming load config before it is
reused, which is exactly why `haumea` benefits so much from explicit `yants`
contracts around the richer load surface.

## Best Mental Model

This is POP for filesystem loading. The plain-data path is already useful, but
the distinctive path is the module experiment through `moduleImporter` and
`moduleLayouts`.

The key public teaching shape is:

- `pops.load`: the load-extender object
- `pops.exporter`: the exporter object
- `pops.default`: the composed default Haumea POP object

## Executable Companions

- Example: [../../examples/haumea-data-workflow.nix](../../examples/haumea-data-workflow.nix)
- Example: [../../examples/haumea-module-experiment.nix](../../examples/haumea-module-experiment.nix)
- Test: [../../tests/haumeaData/expr.nix](../../tests/haumeaData/expr.nix)
- Test: [../../tests/haumeaNixOSModules/expr.nix](../../tests/haumeaNixOSModules/expr.nix)
- Test: [../../tests/evalModules/expr.nix](../../tests/evalModules/expr.nix)
- Snapshots: [../../tests/_snapshots/haumeaData](../../tests/_snapshots/haumeaData), [../../tests/_snapshots/haumeaNixOSModules](../../tests/_snapshots/haumeaNixOSModules), [../../tests/_snapshots/evalModules](../../tests/_snapshots/evalModules)
- Contract manual: [yants-contracts.md](yants-contracts.md)

## Linked Notes

- Related: [[Haumea and nixosModules Override Experiments|../experiments/haumea-nixosmodules-overrides.md]]
- Related: [[Popflow as a POP Practice|../practice/popflow-as-pop.md]]
