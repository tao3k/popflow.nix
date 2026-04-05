---
id: "20260404190100"
title: "POP Checks and Invariants"
category: "concept"
tags:
  - popflow
  - pop
  - checks
saliency_base: 8.7
decay_rate: 0.02
metadata:
  title: "POP Checks and Invariants"
---

# POP Checks and Invariants

## Summary

The fastest way to understand POP is not only the essay but the checks. The
author's checks show what must stay true when a POP object is instantiated.

## What The Checks Prove

From `.data/POP/checks.nix`, the important invariants are:

- a pop exposes both normal fields and `__meta__`
- `defaults` contribute real instance values
- `extension` can read `super` and override inherited state
- `unpop` returns the plain final attrset
- `parents` are real multiple-inheritance inputs, not just naming sugar
- precedence order is computed and testable

Those checks explain why `pop` is more than a convenience wrapper, but they
also point to a constructor vocabulary:

- use `pop` when you need defaults, parents, and behavioral extension
- use `extendPop` when one more prototype step is enough
- use `kPop` when a constant object is sufficient
- use `kxPop` when you are patching an existing object with constants

## The Key Checks

### `testInstantiation`

This proves POP is not a raw attrset merge. `defaults.a = 5` plus
`extension = self: super: { a = super.a + 1; }` yields a final `a = 6`.

### `testInheritance`

This proves one parent can supply defaults while another parent can derive a
new field from `self` and override the inherited value.

### `testMultipleInheritance`

This is the most important check for `popflow`. POP computes a precedence list
for a DAG of parents, not just a left-to-right extension chain. That is the
real reason POP can support modular configuration composition.

## Why This Matters For Popflow

`popflow` should document and structure itself around these semantics:

- extenders are prototype increments
- outputs are instantiated results
- module override experiments depend on path-aware precedence and extension

If docs forget these checks, POP turns into branding language instead of a
verified model.

## Linked Notes

- Related: [[What POP Means Here|what-is-pop.md]]
- Related: [[POP Constructor Vocabulary|constructor-vocabulary.md]]
- Related: [[Grafonnix Style and Namespace Lessons|../practice/grafonnix-style.md]]
- Related: [[Popflow as a POP Practice|../practice/popflow-as-pop.md]]
