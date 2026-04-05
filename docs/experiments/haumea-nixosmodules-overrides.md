---
id: "20260404192000"
title: "Haumea and nixosModules Override Experiments"
category: "experiment"
tags:
  - popflow
  - haumea
  - nixosModules
  - overrides
  - pop
saliency_base: 8.8
decay_rate: 0.02
metadata:
  title: "Haumea and nixosModules Override Experiments"
---

# Haumea and `nixosModules` Override Experiments

## Summary

This is the most `popflow`-specific part of the repository. It pushes POP beyond
plain attrset composition into Haumea-loaded module trees, then experiments
with path-aware override and export behavior for `nixosModules`.

## The Main Mechanism

`popflow` splits the experiment into two pieces:

- `moduleImporter`: normalize imported modules, find the matching extender by
  path, and apply it lazily
- `moduleLayouts`: load the tree either as a plain default layout or as an
  extender-aware layout

## What The Importer Adds

The importer is doing more than plain file loading:

- convert filesystem paths into module paths
- look up extenders by module path
- call extenders as values, files, or functions
- pass `selfModule`, `selfModule'`, `dmerge`, and module args to the extender

That lets POP-style overrides happen at module-path granularity instead of only
at the final top-level attrset.

## Why This Matters

This is where `popflow` differs from a generic builder library. It explores how
prototype extension can participate in NixOS module loading, profile loading,
and `evalModules` integration.

## Where The Experiment Is Verified

The current proof points are:

- `tests/haumeaNixOSModules/expr.nix`
- `tests/evalModules/expr.nix`

These tests show that the loaded module tree can be exported and then fed back
into `nixpkgs.lib.evalModules`.

## Linked Notes

- Related: [[Popflow as a POP Practice|../practice/popflow-as-pop.md]]
- Related: [[Haumea POP Surface|../reference/haumea.md]]
- Related: [[POP Checks and Invariants|../pop/checks-driven-model.md]]
