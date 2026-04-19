# Examples

This directory is the code-first learning surface for `popflow`.

If you want the full repository reading order, start with
[../docs/practice/reading-path.md](../docs/practice/reading-path.md) and then
return here for the code-first pass.

It is intentionally curated around one reading order:

1. `pop-vocabulary.nix`
2. `yants-contracts.nix`
3. `configs-workflow.nix`
4. `flake-workflow.nix`
5. `haumea-data-workflow.nix`
6. `haumea-module-experiment.nix`

Those examples are also exported through the flake `examples` output:

- `examples.pop`
- `examples.yants`
- `examples.configs`
- `examples.flake`
- `examples.haumea.data`
- `examples.haumea.modules`

## What Each Example Teaches

- `pop-vocabulary.nix`: how to read `pop`, `kPop`, `extendPop`, and `kxPop`, including the `grafonnix/template.nix` constructor-weight lesson
- `yants-contracts.nix`: how `popflow` uses `yants` to name POP contracts and guard selected public methods at runtime
- `configs-workflow.nix`: how recipe extenders and exporter args become config outputs
- `flake-workflow.nix`: how flake inputs are extended and then materialized per system
- `haumea-data-workflow.nix`: how filesystem-backed data loading and exporters fit together
- `haumea-module-experiment.nix`: how `popflow` experiments with `nixosModules`-style override behavior

## Support Files

- `default.nix`: explicit assembly of the public example surface
- `__nixpkgsFlake/`: pinned fixture flake used by the flake examples and tests

## Continue Reading

After these examples, continue with:

- [../tests/README.md](../tests/README.md)
- [../docs/reference/internal-algorithms.md](../docs/reference/internal-algorithms.md)

Files that do not belong to this teaching path should not live here unless they
are clearly fixtures or support code.
