---
id: "20260404233000"
title: "Yants Contract Surface"
category: "reference"
tags:
  - popflow
  - yants
  - reference
  - contracts
saliency_base: 8.4
decay_rate: 0.02
metadata:
  title: "Yants Contract Surface"
---

# Yants Contract Surface

## Summary

`popflow` uses [`yants`](https://github.com/NixOS/yants) as the executable
contract layer behind its POP objects. POP answers object identity and
extension; `yants` answers which object shapes are accepted and which public
methods are already guarded at runtime.

## How To Read The Contract Layer

There are two main contract idioms in this repository:

- `openStruct`: validates an open POP object surface that may still carry POP metadata and methods
- `struct`: validates a narrower plain shape such as one patch or one load fragment

The practical reading order is:

1. identify the public POP object under `lib.<domain>.pops.*`
2. find the matching named contract in `contracts.types` or `haumea.types`
3. check whether the public method is only documented, or also guarded by `defun`

## Domain Map

### `configs`

Source:
- [../../src/configs/contracts.nix](../../src/configs/contracts.nix)

Named contracts:
- `pop`
- `recipesPop`
- `argsPop`
- `exporterPop`
- `defaultPop`

Compatibility aliases:
- `recipesExtender`
- `argsExtender`
- `exporter`
- `pipeline`

Current status:
- strong named POP shape coverage
- runtime method typing is intentionally conservative because naive `defun`
  retrofits disturbed the more polymorphic chained workflow view

### `flake`

Source:
- [../../src/flake/contracts.nix](../../src/flake/contracts.nix)

Named contracts:
- `pop`
- `inputsPop`
- `exporterPop`
- `inputsPatch`
- `defaultPop`

Compatibility aliases:
- `inputsExtenderPop`
- `inputsExtender`
- `exporter`
- `pipeline`

Current status:
- strong named POP shape coverage
- strong runtime method guard coverage through `defun`
- clearest current example of `yants` and POP working together in one public workflow

### `haumea`

Source:
- [../../src/haumea/structAttrs.nix](../../src/haumea/structAttrs.nix)
- [../../src/haumea/types.nix](../../src/haumea/types.nix)

Named contracts:
- `pop`
- `loadExtender`
- `loadExtenderPop`
- `loadPop`
- `exporterPop`
- `defaultPop`
- `initLoadPop`

Compatibility aliases:
- `haumeaLoadExtender`
- `haumeaLoadExtenderPop`
- `haumeaLoadPop`
- `haumeaExporterPop`
- `haumeaDefaultPop`
- `haumeaInitLoadPop`

Current status:
- strong shape coverage on the richer load surface
- strong runtime guards on `withLoad`, `addLoadExtender`, `outputs`, and related methods
- especially important because the module-oriented experiment carries more structural risk

## Runtime Guard Coverage Today

The current project story is:

- `configs`: named shape contracts first, deeper method guards deferred for now
- `flake`: named shape contracts plus method guards are both active
- `haumea`: named shape contracts plus method guards are both active

This is not a weakness in the docs. It is the current technical reality of the
repo and should stay explicit.

## Best Mental Model

Treat the contract layer like this:

- POP object files tell you what the object does
- contract/type files tell you what the object is allowed to look like
- `defun` tells you where the repo is already enforcing that story at runtime

## Executable Companions

- Example: [../../examples/yants-contracts.nix](../../examples/yants-contracts.nix)
- Test: [../../tests/yantsContracts/expr.nix](../../tests/yantsContracts/expr.nix)
- Snapshot: [../../tests/_snapshots/yantsContracts](../../tests/_snapshots/yantsContracts)

## Linked Notes

- Related: [[Yants Contracts in Popflow|../practice/yants-contracts.md]]
- Related: [[Configs POP Surface|configs.md]]
- Related: [[Flake POP Surface|flake.md]]
- Related: [[Haumea POP Surface|haumea.md]]
