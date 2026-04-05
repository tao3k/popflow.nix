---
id: "20260405001500"
title: "Downstream Quickstart"
category: "practice"
tags:
  - popflow
  - downstream
  - quickstart
  - haumea
saliency_base: 8.3
decay_rate: 0.02
metadata:
  title: "Downstream Quickstart"
---

# Downstream Quickstart

This is the shortest practical downstream pattern in the current repository.

The key idea is:

1. start from one public POP object
2. configure one reusable workflow
3. consume that workflow from your concrete outputs

## The Smallest Useful Pattern

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    popflow.url = "github:tao3k/popflow.nix";
  };

  outputs = { nixpkgs, popflow, ... }:
    let
      loadModules = popflow.lib.haumea.pops.default.withInitLoad {
        src = ./nixosModules;
        type = "nixosModules";
      };
    in
    {
      eval = nixpkgs.lib.evalModules {
        modules = [ loadModules.outputs.default.programs.git ];
      };

      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ loadModules.outputs.default.programs.git ];
      };
    };
}
```

## Why This Is The Recommended First Step

- `popflow.lib.haumea.pops.default` is a public POP object, not an internal helper
- `withInitLoad` gives you one reusable workflow object
- `loadModules.outputs.default` is the practical bridge into downstream Nix consumers

This matches the same POP-first story used across the repo:

- public POP object first
- contract layer behind it
- internal algorithm layer behind that

## Read It In Three Steps

### Step 1

Create `loadModules` with:

- `popflow.lib.haumea.pops.default`
- `withInitLoad`
- `type = "nixosModules"`

### Step 2

Read the materialized module tree from:

- `loadModules.outputs.default`

### Step 3

Feed that tree into the downstream consumer you actually care about:

- `nixpkgs.lib.evalModules`
- `nixpkgs.lib.nixosSystem`

## Where To Go Next

- Template file: [../../templates/default/flake.nix](../../templates/default/flake.nix)
- Templates overview: [../../templates/README.md](../../templates/README.md)
- Haumea experiment note: [../experiments/haumea-nixosmodules-overrides.md](../experiments/haumea-nixosmodules-overrides.md)
- Full reading path: [reading-path.md](reading-path.md)

## Linked Notes

- Related: [[Popflow Reading Path|reading-path.md]]
- Related: [[Haumea POP Surface|../reference/haumea.md]]
- Related: [[Haumea and nixosModules Override Experiments|../experiments/haumea-nixosmodules-overrides.md]]
