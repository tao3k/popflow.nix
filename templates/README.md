# Templates

This directory is the downstream starting point for `popflow`.

If the rest of the repository is the learning path, `templates/` is the
smallest practical entry once that path is clear.

## Recommended Reading Order

1. [../docs/practice/reading-path.md](../docs/practice/reading-path.md)
2. [../docs/practice/downstream-quickstart.md](../docs/practice/downstream-quickstart.md)
3. [default/flake.nix](default/flake.nix)

## What The Default Template Shows

The default template demonstrates one compact POP-first downstream setup:

- `popflow.lib.haumea.pops.default.withInitLoad` as the public entrypoint
- `type = "nixosModules"` as the Haumea experiment mode
- one reusable `loadModules` workflow that can feed both `evalModules` and
  `nixosSystem`

That means the template is not only a file generator. It is also the minimal
practical example of the repo's current public API.

## Three-Step Downstream Flow

1. Create one reusable workflow through `popflow.lib.haumea.pops.default.withInitLoad`.
2. Read the materialized module tree from `loadModules.outputs.default`.
3. Feed that tree into `evalModules` or `nixosSystem`.

## Related Guides

- Repository reading path: [../docs/practice/reading-path.md](../docs/practice/reading-path.md)
- Downstream quickstart: [../docs/practice/downstream-quickstart.md](../docs/practice/downstream-quickstart.md)
- Internal algorithm map: [../docs/reference/internal-algorithms.md](../docs/reference/internal-algorithms.md)
- Haumea experiment note: [../docs/experiments/haumea-nixosmodules-overrides.md](../docs/experiments/haumea-nixosmodules-overrides.md)
