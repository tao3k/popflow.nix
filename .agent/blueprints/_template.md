# Blueprint Title

> This file is an architecture blueprint template.
>
> A blueprint captures the durable architectural design for a workstream: the
> target shape, governing boundaries, invariants, and approved direction for
> the next 1-3 slices.
>
> A blueprint is not an ExecPlan, not a task checklist, and not a change log.
> Slice-local commands, validation logs, and progress journals belong in
> `$PRJ_CACHE_HOME/agent/execplans/`, not here.

- Owner:
- Status: draft
- Workstream:
  - `name/of/lane_or_architecture_theme`
- Governs:
  - `path/or/domain`
- Time horizon:
  - next 1-3 implementation slices only
- Governing ExecPlans:
  - `relative/path/to/active_execplan.md`
- Related stable references:
  - `relative/path/to/readme_or_doc.md`

## 1. Architectural Objective

Describe the architectural problem this blueprint governs and the durable
outcome it is meant to secure.

Record:

1. why this workstream exists
2. what architectural condition must become true
3. why this belongs in a blueprint instead of only in an ExecPlan

## 2. System Context and Design Drivers

### 2.1 Current Reality

Describe the current architecture, pain points, or constraints that make this
blueprint necessary.

### 2.2 Design Drivers

List the forces that should shape the design. Examples:

1. public API clarity
2. test and template consistency
3. docs and learning-path coherence
4. migration pressure from legacy naming
5. verification or tooling limits

## 3. Target Architecture

### 3.1 Target Shape

Describe the intended architectural shape in durable terms.

### 3.2 Responsibilities and Ownership

State which domain, file family, or layer owns each major responsibility.

### 3.3 Interfaces and Data Contracts

Record the stable interfaces, naming contracts, or data boundaries this
blueprint expects.

### 3.4 Failure Model and Operational Expectations

State the expected failure handling, migration safety, and verification signals
that must remain coherent with the architecture.

## 4. Design Principles and Invariants

List the non-negotiable architectural rules every ExecPlan under this blueprint
must preserve.

### 4.1 Principle / Invariant

State one durable rule and explain why it must remain true.

## 5. Governed Boundaries

List what this blueprint explicitly governs.

### 5.1 Ownership Boundaries

State which domain or file family owns which concern.

### 5.2 Interface Boundaries

State which APIs, doc surfaces, or templates are in scope.

### 5.3 Repository Boundaries

State the concrete package, module, or directory edges that must stay explicit.

### 5.4 Non-Goals

List what this blueprint does not attempt to solve so later ExecPlans do not
silently widen scope.

## 6. Key Decisions and Rejected Alternatives

### 6.1 Chosen Direction

Record the primary architectural decision.

### 6.2 Rejected or Deferred Alternatives

Record the main alternatives considered and why they were rejected or deferred.

### 6.3 Revisit Triggers

State the conditions that would justify revisiting the design.

## 7. Immediate Evolution Slices

Define the next 1-3 slices this blueprint authorizes.

For each slice, record:

1. architectural purpose
2. prerequisite dependencies or proofs
3. expected completion signal

Do not turn this section into a step-by-step execution script.

## 8. Risks, Unknowns, and Required Evidence

### 8.1 Risks and Unknowns

List architectural risks, open questions, or assumptions that still need proof.

### 8.2 Required Evidence

Record the evidence needed before the architecture can be considered stable.

Examples:

1. `nix flake check`
2. API migration proofs across examples and templates
3. docs consistency review
4. compatibility or non-goal confirmation

## 9. Alignment Audit Rules

Record the conditions that must remain true when an ExecPlan or implementation
claims alignment to this blueprint.

Minimum checks:

1. target architecture remains the guiding shape
2. invariants are preserved
3. governed boundaries stay explicit
4. no hidden coupling or scope drift is introduced
5. slice-level execution details stay in the ExecPlan, not in the blueprint
