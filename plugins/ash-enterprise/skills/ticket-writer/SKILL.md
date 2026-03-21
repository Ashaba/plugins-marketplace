---
name: ticket-writer
version: 1.1.0 # x-release-please-version
description: >
  Convert rough ideas, bugs, or feature requests into well-structured engineering tickets.
  Use this skill whenever a user wants to: write a Jira/Linear/GitHub issue, document a bug
  report, define a feature request, or break down work into a ticket format with clear
  acceptance criteria. Trigger on: "write a ticket", "create an issue", "document this bug",
  "turn this into a ticket", "write up a story", "create a task for", or when the user
  describes a problem or feature and wants it structured for a backlog.
author: Ash
allowed-tools:
  - Read
---

# Ticket Writer

Transforms rough ideas, bugs, or feature descriptions into clean, developer-ready engineering tickets.

The user provides a rough description of a problem, bug, or feature. They may paste a Slack message, a brain dump, or just a sentence. Your job is to structure it into a high-quality ticket.

---

## Output Format

Always produce a ticket with the following sections. Omit a section only if it is genuinely not applicable.

```
## [Ticket Title]
_A concise, action-oriented title. E.g. "Add rate limiting to the /auth endpoint"_

**Type:** Bug | Feature | Chore | Spike
**Priority:** Critical | High | Medium | Low

---

### Summary
One or two sentences describing the problem or goal from a product or user perspective.

### Background / Context
_(Optional)_ Why this matters. Links to related tickets, relevant decisions, or prior discussion.

### Acceptance Criteria
- [ ] Criterion 1 — specific, testable, written from the user/system perspective
- [ ] Criterion 2
- [ ] Criterion 3

### Technical Notes
_(Optional)_ Suggested approach, known constraints, files or services likely involved, potential gotchas.

### Out of Scope
_(Optional)_ Explicitly state what this ticket does NOT cover to prevent scope creep.
```

---

## Writing Guidelines

**Title**
- Start with a verb: *Add*, *Fix*, *Remove*, *Migrate*, *Refactor*, *Investigate*
- Be specific — "Fix login bug" is bad; "Fix session token not refreshing after password reset" is good

**Acceptance Criteria**
- Each criterion must be independently verifiable
- Write from the perspective of observable behaviour: "When X happens, Y should occur"
- Avoid vague words like "properly", "correctly", "works as expected"
- Include edge cases and error states where relevant
- Aim for 3–6 criteria; if you need more, the ticket is probably too large

**Technical Notes**
- Only include if there is genuine technical signal in the user's description
- Do not invent technical details — flag unknowns as questions: "❓ Does this require a DB migration?"

**Type & Priority**
- Bug: something is broken that was previously working
- Feature: new capability
- Chore: maintenance, refactor, dependency update, no user-facing change
- Spike: investigation or proof-of-concept with a time-box
- Priority should reflect user impact and urgency, not just effort

---

## Handling Ambiguity

If the description is too vague to write meaningful acceptance criteria, ask ONE clarifying question before proceeding. Do not ask multiple questions — pick the most important unknown.

If the user provides enough context, produce the ticket immediately without asking.

