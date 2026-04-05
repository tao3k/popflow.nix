---
id: "20260405002500"
title: "Flake Input Workflow"
category: "practice"
tags:
  - popflow
  - flake
  - workflow
  - pop
saliency_base: 8.2
decay_rate: 0.02
metadata:
  title: "Flake Input Workflow"
---

# Flake Input Workflow

This is the shortest practical way to read the `flake` domain in `popflow`.

The core idea is:

1. start from `popflow.lib.flake.pops.default`
2. initialize one flake-like input graph with `withInitInputs`
3. optionally grow that graph and export from it
4. materialize one or more systems with `outputsForSystem(s)`

## The Smallest Useful Pattern

```nix
let
  workflow =
    popflow.lib.flake.pops.default
      .withInitInputs ./__lock;
in
workflow.outputsForSystem "x86_64-linux"
```

That is the smallest POP-first entry into the flake workflow.

## Read It In Four Steps

### Step 1

Start from the public workflow object:

- `popflow.lib.flake.pops.default`

### Step 2

Resolve the initial flake-like input graph:

- `withInitInputs ./__lock`
- `withInitInputs some-called-flake`
- `withInitInputs some-path`

### Step 3

Optionally grow the workflow:

- `addInputsExtender`
- `addInputsExtenders`
- `addExporter`
- `addExporters`

### Step 4

Materialize the result:

- `outputsForSystem "x86_64-linux"`
- `outputsForSystems [ "x86_64-linux" "x86_64-darwin" ]`

## Why This Matches The Repository Story

- the public POP object comes first
- the `yants` contract layer sits behind that object
- the internal algorithms stay behind `src/flake/internal/default.nix`

So even this small workflow still fits the same learning path as the rest of
the repository.

## Where To Go Next

- Flake reference: [../reference/flake.md](../reference/flake.md)
- Flake example: [../../examples/flake-workflow.nix](../../examples/flake-workflow.nix)
- Flake semantic test: [../../tests/flake/expr.nix](../../tests/flake/expr.nix)
- Full reading path: [reading-path.md](reading-path.md)

## Linked Notes

- Related: [[Popflow Reading Path|reading-path.md]]
- Related: [[Flake POP Surface|../reference/flake.md]]
- Related: [[Yants Contract Surface|../reference/yants-contracts.md]]
