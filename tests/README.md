# Tests

This directory is not only a validation surface. It is also the semantic
reading surface that follows the examples.

The recommended order is:

1. `popConstructors/expr.nix`
2. `yantsContracts/expr.nix`
3. `configs/expr.nix`
4. `flake/expr.nix`
5. `haumeaData/expr.nix`
6. `haumeaNixOSModules/expr.nix`
7. `evalModules/expr.nix`

## What Each Test Teaches

- `popConstructors/expr.nix`: the POP constructor vocabulary used by this repo
- `yantsContracts/expr.nix`: the contract layer and current runtime guard coverage
- `configs/expr.nix`: the configs POP workflow and export semantics
- `flake/expr.nix`: the flake POP workflow and per-system materialization
- `haumeaData/expr.nix`: plain Haumea data loading
- `haumeaNixOSModules/expr.nix`: the Haumea `nixosModules` experiment
- `evalModules/expr.nix`: the later module-evaluation path

## Snapshots

The paired pretty snapshots live under `tests/_snapshots/`:

- `popConstructors`
- `yantsContracts`
- `configs`
- `flake`
- `haumeaData`
- `haumeaNixOSModules`
- `evalModules`

## Validation

The main repository gate is still:

- `direnv exec . namaka check`

## Related Guides

- Reading path: [../docs/practice/reading-path.md](../docs/practice/reading-path.md)
- Examples overview: [../examples/README.md](../examples/README.md)
