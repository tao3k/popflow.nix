---
type: knowledge
metadata:
  title: "Popflow Engineering Protocol"
---

# Popflow Engineering Protocol

## 1. Engineering Values

- **Clarity**: public APIs, file names, and docs should explain intent without requiring historical context.
- **Pragmatism**: prioritize repository-wide coherence over clever abstractions.
- **Rigor**: every structural change must be backed by executable verification.

## 2. Communication and Documentation

- **English primary**: committed docs, READMEs, comments, and commit messages stay in English.
- **Repository-relative links**: Markdown committed into the repo must use portable relative links.
- **Canonical-doc hidden-path ban**: stable docs must not link directly to hidden tracking surfaces such as `$PRJ_CACHE_HOME/*` or `$PRJ_RUNTIME_DIR/*`.
- **Wendao-friendly docs**: every committed Markdown note should keep stable titles, deterministic filenames, useful headings, and at least one explicit outbound link when practical.

## 3. Repository Reality

`popflow` is a Nix library repository. Its durable boundaries are:

- `$PRJ_ROOT/src/`: public library domains and shared helpers.
- `$PRJ_ROOT/tests/`: executable Namaka coverage and snapshots.
- `$PRJ_ROOT/examples/`: learning-oriented usage surfaces.
- `$PRJ_ROOT/templates/`: starter layouts for downstream consumers.
- `$PRJ_ROOT/docs/`: canonical project docs for humans and Wendao indexing.
- `$PRJ_DATA_HOME/POP/`: upstream conceptual source for Pure Object Prototypes.
- `$PRJ_DATA_HOME/grafonnix/`: style reference for object-oriented Nix API design.

## 4. Project Directory Layout

Use project-local paths through these variables when governance text or plans refer to repo surfaces:

| Environment variable | Default | Purpose |
| --- | --- | --- |
| `PRJ_ROOT` | git toplevel | Project root |
| `PRJ_CONFIG_HOME` | `.config` | Project-local config |
| `PRJ_CACHE_HOME` | `.cache` | Ephemeral caches and tracking artifacts |
| `PRJ_DATA_HOME` | `.data` | Persistent local reference data |
| `PRJ_PATH` | `.bin` | Project-local executables |
| `PRJ_RUNTIME_DIR` | `.run` | Runtime logs, sockets, PID files |

When no dedicated `PRJ_*` variable exists, derive the path from `$PRJ_ROOT`.

## 5. Structure and Namespace Rules

- **Domain first**: top-level code under `$PRJ_ROOT/src/` should group by capability boundary, not by implementation accident.
- **Namespace reflects responsibility**: prefer explicit public object groupings such as `pops`, and keep names like `contracts` or `moduleImporter` for their real support roles. If `builders` still exists, treat it as compatibility or assembly detail rather than the main teaching surface.
- **Avoid hierarchical redundancy**: do not repeat parent domain names in child file names unless it resolves a real collision.
- **One learning path**: README, examples, tests, templates, and docs must point to the same public API vocabulary.
- **Reference-only vendor data**: do not modify `$PRJ_DATA_HOME/POP/` or `$PRJ_DATA_HOME/grafonnix/` unless explicitly requested; they are study inputs, not popflow-owned source.

## 6. Exploration and Environment Protocol

- **Codebase first**: inspect source and tests before deciding a refactor shape.
- **Project environment first**: prefer `direnv exec "$PRJ_ROOT" <command>` for project-scoped verification when the environment is available.
- **High-performance search**: prefer `rg` and `rg --files`.
- **Parallelize reads**: parallelize independent `sed`, `rg`, `ls`, and similar read-only commands when practical.

## 7. Verification Protocol

- **Tests follow structure changes**: public API or layout changes must update tests, examples, and templates in the same slice.
- **Primary gate**: `direnv exec "$PRJ_ROOT" nix flake check` is the default repository-wide validation command.
- **Targeted probes**: use `nix eval`, `nix repl`, or focused example/test evaluations when narrowing scope before the full gate.
- **Formatting hygiene**: keep Nix formatting compatible with the repo’s configured hooks and style.

## 8. Git Safety

- **Sacred user changes**: never revert unrelated work in a dirty worktree.
- **No destructive commands**: do not use `git reset --hard` or `git checkout --` without explicit approval.
- **Non-interactive preference**: prefer non-interactive git commands.

## 9. Planning, Blueprints, and ExecPlans

Use the policy in `$PRJ_ROOT/.agent/PLANS.md` for work that is large, risky, or cross-domain.

- **Blueprints** capture the durable target architecture for the next 1-3 slices.
- **ExecPlans** capture one bounded execution slice under that architecture.
- **Canonical vs. tracking surfaces**: stable docs explain the architecture; hidden tracking files record current execution state.

For large namespace migrations, public API realignments, or docs-and-code restructures, create or update the appropriate blueprint and ExecPlan before implementation.
