# PRD Template

Copy and customize this template when creating a new PRD.

---

# PRD: [Feature/Product Name]

> **Version:** 1.0
> **Status:** Draft | In Review | Approved
> **Author:** [Name]
> **Created:** [Date]
> **Last Updated:** [Date]

---

## Executive Summary

[2-3 sentences describing what this feature/product does and why it matters. This should give any reader immediate context.]

---

## Problem Statement

### The Problem

[Clear description of the user pain point or business need]

### Who Is Affected

| User Segment | Impact | Frequency |
|--------------|--------|-----------|
| [Segment 1] | [How they're affected] | [Daily/Weekly/etc.] |
| [Segment 2] | [How they're affected] | [Daily/Weekly/etc.] |

### Evidence

- [Data point, user research finding, or support ticket trend]
- [Competitive pressure or market demand]
- [Business impact: revenue loss, churn risk, etc.]

### Current Workarounds

[How users currently solve this problem, if at all, and why it's inadequate]

---

## Goals & Success Metrics

### Primary Goal

[One sentence describing the main objective]

### Success Metrics

| Metric | Current | Target | Timeframe |
|--------|---------|--------|-----------|
| [Metric 1] | [Baseline] | [Goal] | [When] |
| [Metric 2] | [Baseline] | [Goal] | [When] |
| [Metric 3] | [Baseline] | [Goal] | [When] |

### Non-Goals

- [Explicitly state what success does NOT look like]
- [Metrics we are NOT optimizing for]

---

## User Stories

### US-001: [Story Title]

**As a** [user type]
**I want to** [action/goal]
**So that** [benefit/outcome]

#### Acceptance Criteria

- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]
- [ ] [Testable criterion 3]

**Priority:** P0 | P1 | P2 | P3

---

### US-002: [Story Title]

**As a** [user type]
**I want to** [action/goal]
**So that** [benefit/outcome]

#### Acceptance Criteria

- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]

**Priority:** P0 | P1 | P2 | P3

---

## Functional Requirements

### Core Functionality

| ID | Requirement | Priority | Depends On |
|----|-------------|----------|------------|
| REQ-001 | [Specific, testable requirement] | P0 | - |
| REQ-002 | [Specific, testable requirement] | P0 | REQ-001 |
| REQ-003 | [Specific, testable requirement] | P1 | REQ-001 |

### Detailed Requirements

#### REQ-001: [Requirement Title]

**Description:** [Detailed explanation of what this requirement entails]

**Implemented by:** TASK-NNN

**Validation Criteria:**
- [How to verify this requirement is met]
- [Specific test case or condition]

**Edge Cases:**
- [Edge case 1 and expected behavior]
- [Edge case 2 and expected behavior]

---

## Non-Functional Requirements

### Performance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-001 | Response time (p95) | < 200ms |
| NFR-002 | Throughput | 1000 req/s |
| NFR-003 | Availability | 99.9% |

### Security

| ID | Requirement |
|----|-------------|
| NFR-004 | [Specific security requirement with standard/protocol] |
| NFR-005 | [Data encryption requirement] |

### Scalability

| ID | Requirement |
|----|-------------|
| NFR-006 | [Horizontal scaling requirement] |
| NFR-007 | [Data volume handling] |

### Accessibility

| ID | Requirement |
|----|-------------|
| NFR-008 | WCAG 2.1 AA compliance |
| NFR-009 | [Specific accessibility requirement] |

---

## Technical Considerations

### Architecture Overview

```
[ASCII diagram or description of system architecture]

┌─────────┐     ┌─────────┐     ┌─────────┐
│ Client  │────▶│   API   │────▶│   DB    │
└─────────┘     └─────────┘     └─────────┘
```

### Data Model

```
[Entity relationship or data structure]

Entity: [Name]
├── field_1: type (constraints)
├── field_2: type (constraints)
└── field_3: type (constraints)
```

### API Contracts

```
[Endpoint]: [METHOD] /api/v1/resource
Request:
{
 "field": "type"
}

Response:
{
 "field": "type"
}
```

### Technology Constraints

- [Required framework/language]
- [Infrastructure constraints]
- [Integration requirements]

---

## Technical Context

Tech stack, project structure, and conventions for anyone implementing this feature — whether onboarding a new team member or handing tasks to an agent.

### Project Structure

- [Key directory layout and file organization patterns]

### Tech Stack & Conventions

| Layer | Technology | Convention |
|-------|-----------|------------|
| [e.g., API] | [e.g., Express + TypeScript] | [e.g., route handlers in `src/routes/`, controllers in `src/controllers/`] |

### Patterns to Follow

| Pattern | Location | Usage |
|---------|----------|-------|
| [e.g., Repository pattern] | [e.g., `src/repositories/BaseRepository.ts` or "to be created"] | [e.g., Extend for new data models] |
| [e.g., Error handling middleware] | [e.g., `src/middleware/errorHandler.ts`] | [e.g., Follows RFC 7807 Problem Details] |

### Reusable Utilities

*For existing projects, list utilities to reuse. For greenfield, list planned shared utilities or omit this subsection.*

- `path/to/utility.ts` — [What it does, when to use it]
- `path/to/helper.ts` — [What it does, when to use it]

### Test Patterns

- Unit tests: [location, framework, naming convention]
- Integration tests: [location, framework, patterns]
- Run command: [e.g., `npm test`, `pytest`]

---

## Dependencies

### Internal Dependencies

| Dependency | Owner | Status | Risk Level |
|------------|-------|--------|------------|
| [Service/Team] | [Owner] | Ready | Low |
| [Service/Team] | [Owner] | In Progress | Medium |

### External Dependencies

| Dependency | Type | Status | Mitigation |
|------------|------|--------|------------|
| [Third-party API] | API | Available | [Fallback plan] |
| [Vendor service] | SaaS | Contracted | [Alternative] |

### Requirement Dependencies

```
REQ-001 (Auth)
   └── REQ-002 (User Profile)
       ├── REQ-003 (Settings)
       └── REQ-004 (Notifications)
```

*See Implementation Task Graph below for execution-order dependency graph including parallel grouping.*

---

## Out of Scope

The following are explicitly **NOT** part of this implementation:

| Item | Reason | Future Consideration |
|------|--------|---------------------|
| [Feature X] | [Why excluded] | Phase 2 |
| [Feature Y] | [Why excluded] | Not planned |
| [Feature Z] | [Why excluded] | Separate initiative |

---

## Implementation Task Graph

Self-contained tasks organized for parallel execution. Each task is scoped so one person or agent can complete it independently. Tasks within the same group can be worked on simultaneously.

### Execution Summary

| Group | Tasks | Starts After | Description |
|-------|-------|--------------|-------------|
| GRP-A | TASK-001, TASK-002, TASK-003 | — | Foundation |
| GRP-B | TASK-004, TASK-005 | GRP-A | Core features |
| GRP-C | TASK-006, TASK-007 | GRP-B | Integration |
| GRP-D | TASK-008 | GRP-C | Hardening |

**Critical path:** GRP-A → GRP-B → GRP-C → GRP-D (4 sequential rounds)
**Max parallelism:** 3 agents (GRP-A)

### Dependency Graph

```
TASK-001 ─┐
TASK-002 ─┼──▶ TASK-004 ──┐
TASK-003 ─┘    TASK-005 ──┼──▶ TASK-006 ──▶ TASK-008
                         └──▶ TASK-007 ──┘
```

---

### TASK-001: [Task Title]

| Field | Value |
|-------|-------|
| **Implements** | REQ-001 |
| **Priority** | P0 |
| **Group** | GRP-A |
| **Depends on** | — |
| **Blocks** | TASK-004 |

**Objective:** [One sentence: what this task accomplishes]

**Approach:** [Brief implementation notes referencing patterns from Technical Context, e.g., "Extend BaseRepository in `src/repositories/`. Follow the UserRepository pattern. Use the existing migration framework in `db/migrations/`." For greenfield: reference intended conventions.]

**File scope:**
- `path/to/file1.ts` — Create
- `path/to/file2.ts` — Modify (add interface)

**Input contract:**
- None (foundation task)

**Output contract:**
- [ ] `EntityName` type exported from `path/to/file1.ts`
- [ ] Migration runs without error
- [ ] Unit tests pass: `npm test -- --grep "entity"`

**Verification:**
```bash
npm run migrate && npm test -- --grep "entity"
```

---

[Repeat TASK-NNN blocks for each task]

---

### Requirements Traceability

| Requirement | Covered By | Status |
|-------------|------------|--------|
| REQ-001 | TASK-001 | Full |
| REQ-002 | TASK-002, TASK-005 | Full |
| NFR-001 | TASK-002 | Full |

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [Mitigation strategy] |
| [Risk 2] | High/Med/Low | High/Med/Low | [Mitigation strategy] |

---

## Open Questions

| # | Question | Owner | Due Date | Resolution |
|---|----------|-------|----------|------------|
| 1 | [Question needing decision] | [Who decides] | [When] | [TBD/Resolved] |
| 2 | [Question needing decision] | [Who decides] | [When] | [TBD/Resolved] |

---

## Appendix

### A. Wireframes / Mockups

[Links or embedded images]

### B. Research & References

- [Link to user research]
- [Link to competitive analysis]
- [Link to technical RFC]

### C. Glossary

| Term | Definition |
|------|------------|
| [Term 1] | [Definition] |
| [Term 2] | [Definition] |

---

## Changelog

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [Date] | [Author] | Initial draft |
