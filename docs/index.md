---
id: "20260404170000"
title: "Popflow Documentation Index"
category: "reference"
tags:
  - docs
  - index
  - popflow
  - pop
saliency_base: 7.0
decay_rate: 0.03
metadata:
  title: "Popflow Documentation Index"
---

# Popflow Documentation Index

`popflow` is best read as a POP practice project for Nix configuration systems.
The shortest useful reading path is:

1. what POP is
2. what POP checks prove
3. how `yants` turns POP into an executable contract surface
4. how popflow applies POP to `configs`, `flake`, and `haumea`
5. how the internal algorithm layer supports those public objects
6. how popflow experiments with Haumea-driven `nixosModules` overrides

## Start Here

- [Popflow Reading Path](practice/reading-path.md)
- [Downstream Quickstart](practice/downstream-quickstart.md)
- [Examples Overview](../examples/README.md)
- [Tests Overview](../tests/README.md)
- [Templates Overview](../templates/README.md)

## POP

- [What POP Means Here](pop/what-is-pop.md)
- [POP Checks and Invariants](pop/checks-driven-model.md)
- [POP Constructor Vocabulary](pop/constructor-vocabulary.md)

## Practice

- [Popflow Reading Path](practice/reading-path.md)
- [Downstream Quickstart](practice/downstream-quickstart.md)
- [Flake Input Workflow](practice/flake-input-workflow.md)
- [Grafonnix Style and Namespace Lessons](practice/grafonnix-style.md)
- [Popflow as a POP Practice](practice/popflow-as-pop.md)
- [Yants Contracts in Popflow](practice/yants-contracts.md)
- [Popflow Src Refactor Principles](practice/src-refactor-principles.md)

## Code Examples

- [Examples Overview](../examples/README.md)
- [Tests Overview](../tests/README.md)
- [Yants Contract Example](../examples/yants-contracts.nix)
- [POP Constructor Semantic Test](../tests/popConstructors/expr.nix)
- [Yants Contract Semantic Test](../tests/yantsContracts/expr.nix)

## Experiments

- [Haumea and `nixosModules` Override Experiments](experiments/haumea-nixosmodules-overrides.md)

## Reference

- [Internal Algorithm Map](reference/internal-algorithms.md)
- [Yants Contract Surface](reference/yants-contracts.md)
- [Configs POP Surface](reference/configs.md)
- [Flake POP Surface](reference/flake.md)
- [Haumea POP Surface](reference/haumea.md)

## Linked Notes

- Related: [[What POP Means Here|pop/what-is-pop.md]]
- Related: [[Popflow as a POP Practice|practice/popflow-as-pop.md]]
- Related: [[Haumea and nixosModules Override Experiments|experiments/haumea-nixosmodules-overrides.md]]
