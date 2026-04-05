---
id: "20260405000500"
title: "Popflow Reading Path"
category: "practice"
tags:
  - popflow
  - reading-path
  - pop
  - yants
saliency_base: 8.6
decay_rate: 0.02
metadata:
  title: "Popflow Reading Path"
---

# Popflow Reading Path

`popflow` is easiest to understand when you read it as one continuous story:

1. POP as the object model
2. `yants` as the contract layer
3. public POP objects by domain
4. internal algorithms behind those objects
5. Haumea experiments as the most distinctive implementation path

This note turns that story into one stable repository path.

## Step 1: Learn POP First

Start with the POP idea itself:

- [../pop/what-is-pop.md](../pop/what-is-pop.md)
- [../pop/checks-driven-model.md](../pop/checks-driven-model.md)
- [../../examples/pop-vocabulary.nix](../../examples/pop-vocabulary.nix)
- [../../tests/popConstructors/expr.nix](../../tests/popConstructors/expr.nix)

If you want the upstream conceptual source, read
[POP](https://github.com/divnix/POP/blob/main/POP.md) after those local notes.

## Step 2: Learn The Contract Layer

Once POP is clear, read how `popflow` adds contracts:

- [yants-contracts.md](yants-contracts.md)
- [../reference/yants-contracts.md](../reference/yants-contracts.md)
- [../../examples/yants-contracts.nix](../../examples/yants-contracts.nix)
- [../../tests/yantsContracts/expr.nix](../../tests/yantsContracts/expr.nix)

This is where `popflow` stops being only a POP exercise and becomes a typed POP
practice.

## Step 3: Read The Public Objects By Domain

Then move domain by domain:

- `configs`
  - [../reference/configs.md](../reference/configs.md)
  - [../../examples/configs-workflow.nix](../../examples/configs-workflow.nix)
  - [../../tests/configs/expr.nix](../../tests/configs/expr.nix)
- `flake`
  - [flake-input-workflow.md](flake-input-workflow.md)
  - [../reference/flake.md](../reference/flake.md)
  - [../../examples/flake-workflow.nix](../../examples/flake-workflow.nix)
  - [../../tests/flake/expr.nix](../../tests/flake/expr.nix)
- `haumea`
  - [../reference/haumea.md](../reference/haumea.md)
  - [../../examples/haumea-data-workflow.nix](../../examples/haumea-data-workflow.nix)
  - [../../tests/haumeaData/expr.nix](../../tests/haumeaData/expr.nix)

## Step 4: Read The Internal Algorithm Layer

After the public objects make sense, open the algorithm layer:

- [../reference/internal-algorithms.md](../reference/internal-algorithms.md)
- [../../src/configs/internal/default.nix](../../src/configs/internal/default.nix)
- [../../src/flake/internal/default.nix](../../src/flake/internal/default.nix)
- [../../src/haumea/internal/default.nix](../../src/haumea/internal/default.nix)

This is where the repository explains how the public POP objects stay small
while the implementation logic stays centralized.

## Step 5: Finish With The Distinctive Haumea Experiments

The final stop is the most project-specific part of the repo:

- [../experiments/haumea-nixosmodules-overrides.md](../experiments/haumea-nixosmodules-overrides.md)
- [../../examples/haumea-module-experiment.nix](../../examples/haumea-module-experiment.nix)
- [../../tests/haumeaNixOSModules/expr.nix](../../tests/haumeaNixOSModules/expr.nix)
- [../../tests/evalModules/expr.nix](../../tests/evalModules/expr.nix)

## Companion Guides

- Examples overview: [../../examples/README.md](../../examples/README.md)
- Tests overview: [../../tests/README.md](../../tests/README.md)
- Templates overview: [../../templates/README.md](../../templates/README.md)
- Downstream quickstart: [downstream-quickstart.md](downstream-quickstart.md)
- Docs index: [../index.md](../index.md)

## Linked Notes

- Related: [[Popflow as a POP Practice|popflow-as-pop.md]]
- Related: [[Yants Contracts in Popflow|yants-contracts.md]]
- Related: [[Internal Algorithm Map|../reference/internal-algorithms.md]]
