---
name: prd-creator
version: 1.1.0 # x-release-please-version
description: >
 Create comprehensive, AI-ready Product Requirements Documents (PRD.md files).
 Use when users want to: (1) Create a new PRD for a feature or product,
 (2) Document requirements for implementation, (3) Generate specifications
 that can be used by any AI coding assistant, (4) Structure a product idea
 into actionable requirements. Triggers on: "create a PRD", "write requirements",
 "document this feature", "PRD for X", "product requirements", "spec out X".
author: Ash
allowed-tools:
 - Read
 - Glob
 - Grep
 - Write
---

# PRD Creator

Create comprehensive Product Requirements Documents that are actionable by any AI system or development team.

## Workflow

1. **Gather context** — Ask clarifying questions about the product/feature
2. **Explore context** — For existing projects: identify patterns, conventions, and relevant file paths. For greenfield: define the intended tech stack and project structure.
3. **Generate PRD** — Create the document following the template structure
4. **Decompose into tasks** — Break requirements into single-session work units with parallel grouping
5. **Validate quality** — Run through the quality checklist

## Gathering Context

Before writing, gather essential information:

- What problem does this solve? Who experiences it?
- What does success look like? How will it be measured?
- Are there technical constraints or preferences?
- What's explicitly out of scope?

Ask 2-3 focused questions at a time. Don't overwhelm with a questionnaire.

## Exploring the Technical Landscape

Before writing the PRD, build a clear picture of the technical environment — whether it already exists or needs to be defined.

### Existing project

Actively explore the repository to ground the document in reality:

- **Project structure** — Use Glob to discover directory layout, file organization, and naming conventions
- **Tech stack** — Identify frameworks, languages, build tools, and configuration patterns
- **Existing patterns** — Use Grep and Read to find reusable utilities, base classes, middleware, and test helpers
- **Conventions** — Note naming styles, error handling approaches, logging patterns, and API design conventions

### Greenfield project

When there is no codebase yet, gather the intended technical direction:

- **Intended tech stack** — Languages, frameworks, and infrastructure choices
- **Framework conventions** — Default directory layouts, naming conventions, and idioms for the chosen stack
- **Testing strategy** — Testing frameworks, coverage expectations, and test organization
- **Reference architectures** — Any boilerplate, starter templates, or existing projects the team wants to follow

### How this feeds the PRD

This exploration feeds two parts of the document:
1. The **Technical Context** section — so anyone (new team member or agent) can orient quickly
2. The **Approach** field in each TASK — so implementation hints reference real patterns (existing code or intended conventions), not hypotheticals

## PRD Structure

Generate the PRD using this structure. See [references/template.md](references/template.md) for the full template with formatting.

### Required Sections

| Section | Purpose |
|---------|---------|
| **Title & Metadata** | Name, date, author, status, version |
| **Executive Summary** | 2-3 sentence overview for quick understanding |
| **Problem Statement** | User pain points with evidence/impact |
| **Goals & Success Metrics** | SMART criteria with measurable targets |
| **User Stories** | Format: "As a [user], I want [goal] so that [benefit]" + acceptance criteria |
| **Functional Requirements** | Numbered (REQ-001), testable, with priority |
| **Non-Functional Requirements** | Performance, security, scalability specs |
| **Technical Considerations** | Architecture notes, data models, API contracts |
| **Technical Context** | Tech stack, project structure, conventions, and (for existing projects) key file paths and reusable patterns — useful for onboarding and implementation |
| **Dependencies** | Internal/external dependencies mapped |
| **Implementation Task Graph** | Self-contained tasks with dependency graph, parallel groups, and approach hints |
| **Out of Scope** | Explicit exclusions to prevent scope creep |
| **Open Questions** | Unresolved items needing decisions |
| **Appendix** | Wireframes, references, research links |

### Optional Sections (include when relevant)

- **Risk Assessment** - Potential blockers and mitigations
- **Rollout Strategy** - Phased release plan
- **Competitive Analysis** - How alternatives solve this

## Quality Checklist

Before finalizing, verify:

- [ ] All requirements are **testable** (no vague terms like "fast", "secure", "user-friendly")
- [ ] Success metrics are **SMART** (Specific, Measurable, Achievable, Relevant, Time-bound)
- [ ] User stories have **acceptance criteria**
- [ ] Requirements are **numbered** for traceability (REQ-001, REQ-002)
- [ ] Dependencies are **mapped** between requirements
- [ ] **Priority** is assigned (P0-Critical, P1-High, P2-Medium, P3-Low)
- [ ] **Out of scope** is explicitly defined
- [ ] Technical constraints are **specific** (e.g., "response time <200ms" not "fast")
- [ ] Each task is **independently completable** (scoped for one person or agent, no further decomposition needed)
- [ ] Each task includes **approach hints** referencing patterns from the Technical Context section
- [ ] Parallel execution groups are **identified** (tasks within a group have no mutual dependencies)
- [ ] **Critical path** is annotated (longest sequential chain of groups)
- [ ] Every requirement has **task coverage** (REQ/NFR ↔ TASK bidirectional traceability)

## Writing Guidelines

### Be Specific and Testable

```markdown
# Bad - Vague
The system should be fast and secure.

# Good - Testable
REQ-001: API responses shall return within 200ms at p95 under 1000 concurrent users.
REQ-002: All user passwords shall be hashed using bcrypt with cost factor 12.
```

### Structure User Stories Properly

```markdown
## User Story: US-001 - User Login

**As a** registered user
**I want to** log in with my email and password
**So that** I can access my personalized dashboard

### Acceptance Criteria
- [ ] User can enter email and password
- [ ] Invalid credentials show error message within 2 seconds
- [ ] Successful login redirects to dashboard
- [ ] Session expires after 24 hours of inactivity
- [ ] Failed attempts are rate-limited (5 per minute)
```

### Map Dependencies Clearly

```markdown
## Dependencies

| Requirement | Depends On | Blocked By |
|-------------|------------|------------|
| REQ-003 (Payment UI) | REQ-001 (Auth) | - |
| REQ-004 (Notifications) | REQ-002 (User Preferences) | External: Email service API |
```

### Decompose Tasks for Parallel Execution

```markdown
## Execution Summary

| Group | Tasks | Starts After | Description |
|-------|-------|--------------|-------------|
| GRP-A | TASK-001, TASK-002 | — | Foundation: data model + API scaffold |
| GRP-B | TASK-003, TASK-004 | GRP-A | Core features |

**Critical path:** GRP-A → GRP-B (2 sequential rounds, max 2 parallel agents)

---

### TASK-001: Create user entity and migration

| Field | Value |
|-------|-------|
| **Implements** | REQ-001 |
| **Priority** | P0 |
| **Group** | GRP-A |
| **Depends on** | — |
| **Blocks** | TASK-003 |

**Objective:** Define the User data model with persistence and migration.

**Approach:** Extend `BaseRepository` in `src/repositories/`. Follow the existing `OrderRepository` pattern. Use the migration framework in `db/migrations/` — see Technical Context for conventions.

**File scope:**
- `src/models/User.ts` — Create
- `src/repositories/UserRepository.ts` — Create
- `db/migrations/003_create_users.ts` — Create

**Input contract:**
- None (foundation task)

**Output contract:**
- [ ] `User` type exported from `src/models/User.ts`
- [ ] Migration runs without error
- [ ] Unit tests pass: `npm test -- --grep "User"`

**Verification:**
npm run migrate && npm test -- --grep "User"
```

## Task Decomposition Guidelines

### Hybrid Readability

The PRD is a product document first. Write for humans; structure for machines.

- Use natural language descriptions alongside structured fields
- Every section should be scannable by a PM and actionable by an engineer or agent
- Avoid jargon that only serves machine parsing — if it wouldn't make sense in a sprint planning meeting, rewrite it

### Sizing Tasks for Independent Execution

- **One logical concern per task** — one endpoint, one model, one component, one integration
- **Touches at most 5-8 files** — all listed explicitly in the File scope field
- **Single-session scope** — one person or agent can implement and test it without needing to pause for external input
- **Self-contained** — the TASK block plus Technical Context provides full implementation context; no need to read the entire PRD

### Defining Task Boundaries

Each TASK must define clear boundaries:

- **Input contract** — what files, interfaces, or artifacts must exist before starting
- **Output contract** — checklist of specific deliverables (exported types, passing tests, endpoints responding)
- **Approach** — brief implementation notes referencing patterns from the Technical Context section (existing code patterns, or intended conventions for greenfield)
- **Verification** — concrete command or test to confirm completion

### Identifying Parallel Groups

- Assign `GRP-X` labels; tasks in the same group have NO mutual dependencies and CAN run simultaneously
- Groups execute sequentially: all tasks in GRP-A must complete before GRP-B starts
- Annotate the **critical path** (longest sequential chain of groups) and **max parallelism** (largest group size)

### Linking Tasks to Requirements

- Every TASK references at least one REQ or NFR in its `Implements` field
- Every REQ and NFR is covered by at least one TASK
- Include a **Requirements Traceability** table at the end of the Implementation Task Graph section

## Output Location

Before writing, check whether a PRD file already exists at the target path or whether the project uses a specific directory for PRDs (e.g., `docs/`, `prd/`). If a file would be overwritten or a convention already exists, ask the user to confirm the output path.

Save the PRD as `PRD-[feature-name].md` in the project root, or a user-specified location.
