---
id: "20260404193100"
title: "Flake POP Surface"
category: "reference"
tags:
  - popflow
  - flake
  - reference
  - pop
saliency_base: 8.1
decay_rate: 0.02
metadata:
  title: "Flake POP Surface"
---

# Flake POP Surface

## Summary

The `flake` domain uses POP to start from an initial flake-like input set,
extend that input graph, and materialize system-scoped outputs.

## Canonical Surface

- `lib.flake.pops.inputs`
- `lib.flake.pops.exporter`
- `lib.flake.pops.default`
- `lib.flake.contracts`

Legacy compatibility remains under `lib.flake.builders.*`, but the POP-first
surface is `lib.flake.pops.*`.
The contracts surface now also exposes POP-first type aliases such as
`inputsPop`, `exporterPop`, and `defaultPop`, while keeping the older
compatibility names.

## Yants Contract Layer

The `flake` domain uses [../../src/flake/contracts.nix](../../src/flake/contracts.nix)
as its `yants` contract surface.

- `openStruct` describes the POP object shapes
- `struct` describes narrower patch shapes such as `inputsPatch`
- `defun` constrains methods such as `withInputs`, `addInputsExtender`, and `outputsForSystem`
- the compact cross-domain map lives in [yants-contracts.md](yants-contracts.md)

## POP Objects

### `lib.flake.pops.inputs`

Role:
the seed object that resolves the first flake-like input graph.

Constructor:
`withInitInputs initInputs`

Use this when:
you want to start from a path, lock fixture, or already-called flake and turn
it into `initInputs` plus `initFlake`.

### `lib.flake.pops.exporter`

Role:
the export object that binds resolved inputs and, optionally, one concrete
system.

Main methods:
`withInputs inputs`
`withSystem system`

Use this when:
an exporter needs the de-systemized input graph or one concrete system before
computing exports.

### `lib.flake.pops.default`

Role:
the main workflow object for flake input extension and output rendering.

Parents:
`inputs`
`exporter`

Main methods:
`withInitInputs initInputs`
`addInputsExtender inputsExtender`
`addInputsExtenders inputsExtenders`
`addExporter exporter`
`addExporters exporters`
`outputsForSystem system`
`outputsForSystems systems`

Main fields:
`initInputs`
`initFlake`
`inputs`
`sysInputs`
`exports`

Use this when:
you want the whole flake POP workflow in one object.

## Constructor And Method Grammar

The normal reading order is:

1. call `default.withInitInputs`
2. add input extenders
3. add exporters
4. optionally derive one `withSystem` view
5. read `outputsForSystem` or `outputsForSystems`

Here too, `withInputs` and `withSystem` are constant rebinding helpers, while
`addInputsExtender(s)` and the output renderers carry the important workflow
behavior. This domain is also the clearest current example of `kxPop`-backed
rebinding plus `defun` runtime guards working together on one public object.

## Best Mental Model

Treat this domain as POP for flake input graphs. The important result API is
`outputsForSystem`, because it makes the instantiated export shape explicit.

## Executable Companions

- Example: [../../examples/flake-workflow.nix](../../examples/flake-workflow.nix)
- Test: [../../tests/flake/expr.nix](../../tests/flake/expr.nix)
- Snapshot: [../../tests/_snapshots/flake](../../tests/_snapshots/flake)
- Contract manual: [yants-contracts.md](yants-contracts.md)

## Linked Notes

- Related: [[Popflow as a POP Practice|../practice/popflow-as-pop.md]]
- Related: [[Grafonnix Style and Namespace Lessons|../practice/grafonnix-style.md]]
