---
id: "20260404234500"
title: "Internal Algorithm Map"
category: "reference"
tags:
  - popflow
  - internal
  - algorithms
  - pop
saliency_base: 8.1
decay_rate: 0.02
metadata:
  title: "Internal Algorithm Map"
---

# Internal Algorithm Map

## Summary

`popflow` teaches public POP objects first, but the object files are not the
whole story. Each domain also has one `internal/default.nix` file that carries
the compact algorithmic steps behind the public workflow.

The key rule is:

- `pops/*` is the public object surface
- `contracts/types` is the public contract surface
- `internal/default.nix` is the algorithm layer those public objects delegate to

## `configs`

Source:
- [../../src/configs/internal/default.nix](../../src/configs/internal/default.nix)

Public-to-internal map:
- `configs.pops.default.recipes` -> `mergeRecipesExtenders`
- `configs.pops.default.exports` -> `foldRecipeExporters`

What this means:
- the public object owns the POP vocabulary
- the internal helper owns the actual left-to-right merge and export fold

## `flake`

Source:
- [../../src/flake/internal/default.nix](../../src/flake/internal/default.nix)

Public-to-internal map:
- `flake.pops.inputs.withInitInputs` -> `resolveInitFlake`, `resolveInitInputs`
- `flake.pops.default.sysInputs` -> `extendInputs`
- `flake.pops.default.inputs` -> `deSystemizeInput`
- `flake.pops.default.exports` -> `foldExporters`, `partitionExporters`

What this means:
- the public POP workflow stays readable
- the input-graph and exporter-partition algorithms stay centralized

## `haumea`

Source:
- [../../src/haumea/internal/default.nix](../../src/haumea/internal/default.nix)

Public-to-internal map:
- `haumea.pops.exporter.withLoad` -> `normalizeLoadConfig`
- `haumea.pops.default.load` -> `mergeLoadConfig`
- `haumea.pops.default.exports` -> `foldGeneralExports`
- `haumea.pops.default.layouts` -> `computeLayouts`

What this means:
- the public POP objects keep the learning surface clean
- the experimental algorithm layer for plain data and module-like loading stays explicit

## Best Mental Model

When reading source, use this order:

1. open the public POP object
2. note the matching named contract
3. jump to `internal/default.nix` only when you want the algorithm behind one field or method

That keeps the repo readable without turning `internal` into a competing public namespace.

## Linked Notes

- Related: [[Popflow Src Refactor Principles|../practice/src-refactor-principles.md]]
- Related: [[Yants Contract Surface|yants-contracts.md]]
- Related: [[Configs POP Surface|configs.md]]
- Related: [[Flake POP Surface|flake.md]]
- Related: [[Haumea POP Surface|haumea.md]]
