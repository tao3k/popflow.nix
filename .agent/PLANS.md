# Execution Plan Policy

This repository uses ExecPlans for work that is large, uncertain, or cross-domain.

## Blueprint Adherence

When a task falls under an existing strategic blueprint in `$PRJ_CACHE_HOME/agent/blueprints/` (default `.cache/agent/blueprints/`), the ExecPlan must:

1. Reference the governing blueprint path.
2. Derive architectural decisions from that blueprint.
3. State alignment in `Reflection and Quality Audit`.
4. Record any deviation only after the blueprint is updated or the user explicitly approves it.
5. Keep active blueprints and ExecPlans in cache tracking paths until the governed work is finished.

If no blueprint applies, the plan must say so explicitly and explain why the task is bounded enough to proceed without one.

## Plan First Gate

Before broad code changes or verification sweeps:

1. Use a **Micro Plan** for small, isolated tasks.
2. Use an **ExecPlan** for risky, multi-step, or cross-domain work.
3. Update the plan when new scope, files, or commands are introduced.
4. Complete the plan self check before large edits or validation runs.

Small reads to orient the repository are allowed, but implementation should not proceed without the appropriate plan level.

## Plan Types

1. **Micro Plan**
   Use for isolated edits with low regression risk. Keep it inside the assistant response and list files to read, commands to run, and stop conditions.
2. **ExecPlan**
   Use for namespace migrations, docs restructures, template changes, or any work spanning multiple surfaces. Store it as a file and keep it current.

## When an ExecPlan Is Required

1. The task changes multiple public surfaces such as `src/`, `tests/`, `examples/`, `templates/`, or `docs/`.
2. The task introduces or modifies durable governance rules.
3. The task changes public API naming or repository structure.
4. The task has meaningful regression risk or unclear architecture.

## Where Plans Live

1. Policy file: `$PRJ_ROOT/.agent/PLANS.md`
2. Blueprint template: `$PRJ_ROOT/.agent/blueprints/_template.md`
3. ExecPlan template: `$PRJ_ROOT/.agent/execplans/_template.md`
4. Active blueprints: `$PRJ_CACHE_HOME/agent/blueprints/<slug>.md`
5. Active ExecPlans: `$PRJ_CACHE_HOME/agent/execplans/<slug>.md`
6. Archived plans: the corresponding `archives/` subdirectories under those cache paths

## Required Plan Structure

Each ExecPlan file should contain these sections:

1. `# Title`
2. `## Purpose / Big Picture`
3. `## Scope and Boundaries`
4. `## Plan Self Check`
5. `## Context and Orientation`
6. `## Plan of Work`
7. `## Concrete Steps`
8. `## Validation and Acceptance`
9. `## Reflection and Quality Audit`
10. `## Final Validation Gate`
11. `## Idempotence and Recovery`
12. `## Interfaces and Dependencies`
13. `## Progress`
14. `## Decision Log`
15. `## Surprises & Discoveries`
16. `## Artifacts and Notes`
17. `## Outcomes & Retrospective`
18. `## Change Log`

## Scope and Boundaries Requirements

This section must list:

1. Files or directories to read
2. Commands or tools to run
3. Expected outputs
4. Stop conditions

Anything outside that scope requires a plan update.

## Plan Self Check

Every plan must confirm:

1. scope matches the request and risk
2. files or dirs to read are complete and minimal
3. commands or tools to run are complete and safe
4. expected outputs are concrete and testable
5. stop conditions are explicit
6. dependencies and constraints are recorded
7. validation is proportional to risk
8. the chosen plan type is correct

## Authoring Rules

1. Keep plans self-contained.
2. Update `Progress`, `Decision Log`, and `Change Log` while work evolves.
3. Prefer checkpoints over vague progress notes.
4. Include exact validation commands.
5. Record retry or rollback behavior in `Idempotence and Recovery`.

## Reflection and Quality Audit

This section must cover:

1. code audit: correctness, maintainability, and regression risk
2. plan audit: scope adherence and deviations
3. verification audit: what ran, what did not run, and why

## Final Validation Gate

Before marking a slice done:

1. confirm validation is complete
2. confirm reflection and audit are recorded
3. record a final go or no-go decision with rationale

## Quick Start

1. Copy `$PRJ_ROOT/.agent/execplans/_template.md` to `$PRJ_CACHE_HOME/agent/execplans/<slug>.md`.
2. Fill in purpose, scope, context, and validation before implementation.
3. If the workstream needs a durable architecture contract, create or update a blueprint from `$PRJ_ROOT/.agent/blueprints/_template.md`.
