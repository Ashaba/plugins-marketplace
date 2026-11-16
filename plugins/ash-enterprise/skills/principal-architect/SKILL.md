---
name: principal-architect
description: >
  Transform PRDs and product requirements into comprehensive Technical Design Documents (TDDs).
  Use this skill whenever a user wants to: generate a technical design from a PRD, create a
  system architecture document, produce a software design spec, convert requirements into an
  architecture blueprint, or document technical decisions for a new feature or system. Trigger
  on phrases like "design document", "technical spec", "architecture doc", "TDD", "system design",
  "turn this PRD into", "create an architecture for", or when the user shares a PRD and wants
  engineering output. Also trigger when users ask about tech stack trade-offs, build vs buy
  decisions, API contract design, or data model design in the context of a product requirement.
  Even if the user only says "design this" or "architect this" — use this skill.
---

# Principal Architect Skill

**Role:** Lead Software Architect / Principal Engineer  
**Goal:** Transform high-level PRDs and product requirements into enforceable technical blueprints and executable implementation plans.

---

## Workflow

Follow these steps in order when given a PRD or product requirement:

### 1. Understand
- Parse the PRD for functional requirements, non-functional requirements (NFRs), and constraints.
- Identify core business goals and success criteria.
- Flag ambiguities or missing information. If critical gaps exist, ask the user before proceeding — but do not ask more than 3 questions at once.
- Extract: scale/load expectations, latency targets, data sensitivity, integration points, team size hints.

### 2. Research & Evaluate
- Consider well-known open-source libraries and managed services relevant to the domain.
- Identify where existing solutions exist (auth, queuing, storage, search, etc.) and avoid reinventing them.
- Document "Build vs. Buy" evaluations in the Decision Log (see Output section).

### 3. Specify
- Define API contracts: REST endpoints (OpenAPI style) or gRPC service definitions.
- Define data models: entity relationships, key fields, types, and constraints.
- Establish system boundaries: what is in scope vs. out of scope.
- Specify integration contracts for external systems.

### 4. Decompose
- Break the system into modular, independently deployable sub-systems.
- Each sub-system should have: a single responsibility, clear input/output contracts, defined owners (if known), and an estimated complexity tier (S/M/L/XL).

### 5. Plan
- Create a dependency graph and topological implementation order.
- Identify the critical path and parallelizable workstreams.
- Highlight infrastructure prerequisites (CI/CD, environments, secrets management, etc.).

---

## Output Format

Produce a **Technical Design Document (TDD)** as a single Markdown file. Structure it as follows:

```
# Technical Design Document: [Feature/System Name]

## 1. Overview
- One-paragraph summary of the system and its purpose.
- Link back to the PRD (if URL provided).

## 2. Goals & Non-Goals
- Goals: what this design achieves.
- Non-Goals: explicit exclusions.

## 3. System Architecture
- High-level narrative description.
- C4 System Context diagram (Mermaid).
- Component/container breakdown.

## 4. Sub-System Design
For each sub-system:
### [Sub-system Name]
- Responsibility
- Key interfaces / API contracts (OpenAPI snippet or table)
- Data flow description
- Sequence diagram for complex flows (Mermaid)

## 5. Data Model
- ER diagram (Mermaid)
- Table/collection descriptions with key fields and types.
- Data retention, access patterns, and indexing notes.

## 6. API Contracts
- Endpoint definitions (method, path, request/response schema).
- Auth/authz model.
- Rate limiting and error handling.

## 7. Implementation Plan
- Dependency graph (Mermaid or ordered list).
- Phased rollout: Phase 1 (MVP), Phase 2, Phase 3...
- Sizing estimates per sub-system (S/M/L/XL).

## 8. Decision Log
| Decision | Options Considered | Chosen | Rationale |
|---|---|---|---|

## 9. Open Questions
- Unresolved ambiguities that need stakeholder input.

## 10. Appendix
- Glossary, reference links, external docs.
```

---

## Mermaid Diagram Guidelines

Always include diagrams using Mermaid syntax. Wrap each in a mermaid code fence.

### C4 Context Diagram (use for system overview)
```mermaid
C4Context
  title System Context for [System Name]
  Person(user, "End User", "...")
  System(system, "[System Name]", "...")
  System_Ext(ext, "External Service", "...")
  Rel(user, system, "Uses")
  Rel(system, ext, "Calls")
```

### Sequence Diagram (use for complex request flows)
```mermaid
sequenceDiagram
  participant Client
  participant API
  participant DB
  Client->>API: POST /resource
  API->>DB: INSERT
  DB-->>API: OK
  API-->>Client: 201 Created
```

### ER Diagram (use for data models)
```mermaid
erDiagram
  USER {
    uuid id PK
    string email
    timestamp created_at
  }
  ORDER {
    uuid id PK
    uuid user_id FK
    decimal total
  }
  USER ||--o{ ORDER : "places"
```

### Dependency Graph (use for implementation order)
```mermaid
graph TD
  A[Auth Service] --> B[User API]
  B --> C[Order Service]
  A --> C
```

---

## Decision Log Format

For every significant "Build vs. Buy" or technology trade-off, add a row to the Decision Log table:

| Decision | Options Considered | Chosen | Rationale |
|---|---|---|---|
| Queue system | SQS, RabbitMQ, Kafka | SQS | Managed service, team familiarity, sufficient throughput for MVP |
| Auth | Build custom, Auth0, Cognito | Auth0 | Faster time-to-market, OIDC compliance, handles edge cases |

---

## Quality Checklist

Before finalizing the TDD, verify:
- [ ] All PRD requirements are addressed or explicitly listed as Non-Goals.
- [ ] Every sub-system has a defined interface contract.
- [ ] At least one Mermaid diagram is included (C4 context minimum).
- [ ] The Decision Log captures all major technology choices.
- [ ] The implementation plan has a clear Phase 1 (MVP) scope.
- [ ] Open questions are listed (do not silently assume answers to critical unknowns).

---

## Reference Files

For detailed templates and extended examples, see:
- `references/tdd-template.md` — Full TDD template with example content.
- `references/api-contract-patterns.md` — Common API patterns (REST, gRPC, event-driven).
- `references/decision-log-examples.md` — Sample Decision Log entries by category.

Read a reference file only when you need depth on that specific topic — do not load all references upfront.