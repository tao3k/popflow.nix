---
id: "20260404194500"
title: "Popflow Src Refactor Principles"
category: "practice"
tags:
  - popflow
  - src
  - refactor
  - pop
saliency_base: 8.9
decay_rate: 0.02
metadata:
  title: "Popflow Src Refactor Principles"
---

# Popflow Src Refactor Principles

## Summary

This note records the principles that should guide the `src/` refactor. The
main goal is to make POP object identity obvious in the public namespace while
preserving the strong POP verbs already confirmed in the repository.

## Principle 1: Public Namespace Must Expose POP Objects

The public source shape should center on:

- `configs.pops.*`
- `flake.pops.*`
- `haumea.pops.*`

The point is not aesthetic. The point is that a user should immediately know
they are looking at a POP object and can extend it with POP methods.

## Principle 2: Keep Strong Verbs, Move Them To Method Level

The following should stay prominent:

- `addRecipesExtender`
- `addArgsExtender`
- `addInputsExtender`
- `addLoadExtender`
- `outputsForSystem`
- `outputsForSystems`

These are good POP verbs. They should remain methods on explicit POP objects
instead of being hidden behind abstract group names.

## Principle 3: Builders Are Not The Teaching Surface

If `builders` still exists at all, it should only be an assembly or migration
detail. It should not be the main public story of the repository. The user
should meet objects first, implementation buckets second.

## Principle 4: Separate Heavy Objects From Light Objects

The refactor should study `grafonnix` and apply the same distinction:

- rich objects use `pop`
- behavioral one-parent growth uses `extendPop`
- lightweight constant objects use `kPop`
- object patching uses `kxPop`

The current POP snapshot exports `extendPop`, not a separate `exPop` helper, so
the docs should keep using the real exported name.

Not every value in `popflow` should become a heavy object. Object weight should
match behavior.

## Principle 5: Internal Mechanisms Must Stay Behind The Object Surface

Internal concerns should move behind the public POP objects:

- merge helpers
- normalization helpers
- partitioning logic
- Haumea-specific loading utilities

But two Haumea surfaces remain architecturally important and may stay first
class:

- `moduleImporter`
- `moduleLayouts`

Those are not generic helpers. They are part of the distinctive popflow
experiment.

The reading guide should therefore be:

1. public POP object first
2. contract/type surface second
3. internal algorithm file third

The compact map for that third step lives in
[../reference/internal-algorithms.md](../reference/internal-algorithms.md).

## Principle 6: Checks Must Validate Final Semantics

Future refactor slices should keep validating:

1. the POP object can still be extended correctly
2. the final result shape still matches the intended config semantics
3. Haumea module experiments still survive `evalModules`

The gate stays:

- `direnv exec . namaka check`

## Target Shape

The target source shape is approximately:

```text
src/
  configs/
    pops/
      default.nix
      recipes.nix
      args.nix
      exporter.nix
    contracts/
    internal/

  flake/
    pops/
      default.nix
      inputs.nix
      exporter.nix
    contracts/
    internal/

  haumea/
    pops/
      default.nix
      load.nix
      exporter.nix
    moduleImporter.nix
    moduleLayouts.nix
    contracts/
    internal/
```

## Suggested First Implementation Target

The clearest first teaching target is `haumea.pops.load`, because it makes the
POP object identity visible immediately and connects directly to the most
distinctive experiment in the repo.

## Linked Notes

- Related: [[Grafonnix Style and Namespace Lessons|grafonnix-style.md]]
- Related: [[Popflow as a POP Practice|popflow-as-pop.md]]
- Related: [[Internal Algorithm Map|../reference/internal-algorithms.md]]
- Related: [[Haumea and nixosModules Override Experiments|../experiments/haumea-nixosmodules-overrides.md]]
