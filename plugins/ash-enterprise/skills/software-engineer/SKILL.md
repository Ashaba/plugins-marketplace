---
name: engineering-standards
version: 1.0.2 # x-release-please-version
description: >
  Software engineering standards for writing, reviewing, and committing code — applicable across any language, framework, or project type.
  Use this skill whenever the user asks to write code, review code or a PR/diff, create a commit message, name a branch, write a pull request description, or asks how code should be structured or documented.
  Also trigger when the user mentions "best practices", "code review", "clean code", "PR description", "branch naming", "refactor" or "commit message".
  When generating any code, always apply the principles in this skill without being explicitly asked.
  If you are on the main branch, make sure you first pull the latest changes and create a branch for the changes you intend to make. 
  If in a branch, make sure its not a stale branch (one that's already merged in base branch), otherwise, checkout master/main and create a new branch for your changes. If the user asks you to review code, a PR, or a diff, always apply the principles in this skill when providing feedback.
---

# Engineering Standards

A Reference for writing, reviewing, and shipping high-quality code — regardless of language or framework.

---

## 1. Core Code Quality Principles

### Clarity Over Cleverness
- Optimize for **readability and maintainability** first.
- Use **descriptive, unambiguous names** for variables, functions, classes, and files. Long names are fine; vague ones are not.
- Avoid abbreviations unless they are universally understood in context (e.g., `id`, `url`, `err`).

### DRY - Don't Repeat Yourself
- Extract repeated logic into shared functions, hooks, utilities, or base classes.
- Shared types, contracts, or DTOs belong in **centralized modules** - never duplicated.

### Single Responsibility
- Each function, class, component, or module should have **one clear purpose**.
- Break complex logic into **small, composable, pure functions** where possible.
- Minimize public surface area — expose only what consumers need.

### Conciseness
- Prefer expressive, idiomatic code over verbose scaffolding.
- Remove dead code, unused imports, and leftover debug statements before committing.

---

## 2. Types & Contracts

- Always use **strict, explicit types**. Avoid `any` / `object` / untyped unless genuinely unavoidable and justified with a comment.
- Keep shared data contracts (DTOs, API types, schema types) in centralized modules — never inline or duplicated.
- Prefer narrower types over broad ones (e.g., a union of string literals over `string` where values are known).

---

## 3. Error Handling

- Handle **all expected error cases explicitly**. Do not swallow errors silently.
- Return typed/structured errors or throw domain-specific exceptions — avoid generic catch-alls with no context.
- Do not expose internal error details (stack traces, system paths) to end users or external callers.
- Prefer failing loudly in development; degrade gracefully in production.

---

## 4. Logging & Observability

- Use **structured logging** (key-value pairs or JSON) wherever possible — avoid plain string concatenation.
- Use the project's existing logging abstraction — don't introduce new loggers.
- Log at appropriate levels: `debug` for development detail, `info` for significant state changes, `warn` for recoverable issues, `error` for failures.
- Include enough context in log messages to trace behavior without a debugger.

---

## 5. Performance & Safety

- Avoid **N+1 query patterns** — batch or preload relational data where needed.
- Avoid **unnecessary allocations** inside loops or hot paths.
- Never block async/reactive flows with synchronous operations.
- Treat **input validation** as a first-class concern — validate at system boundaries (API edges, form inputs, file ingestion).
- Handle **data integrity** explicitly: don't assume upstream data is clean or in the expected shape.

---

## 6. Security

- Never hardcode credentials, secrets, API keys, or tokens — use environment variables or a secrets manager.
- Sanitize all user-supplied input before using it in queries, shell commands, file paths, or rendered output.
- Guard against path traversal, command injection, and XSS based on the context.
- Err on the side of least privilege: request only the permissions and access scopes actually needed.

---

## 7. Testability

- Design code for testability: pure functions, clear boundaries, dependency injection over hard-coded dependencies.
- For **any non-trivial behavior**, propose or write tests alongside the implementation.
- Tests should be independent, deterministic, and fast. Avoid shared mutable state between test cases.
- See [references/testing-guidelines.md](references/testing-guidelines.md) for naming conventions and test structure.

---

## 8. Documentation & Comments

- Only add comments that provide **context or explain non-obvious reasoning**. Do not comment on self-explanatory code.
- Use doc-comment conventions for public APIs (JSDoc, KDoc, docstrings, etc.) — describe parameters, return values, and behavior.
- Avoid redundant comments that restate what the code already says. Focus on *why*, not *what*.

**Good:**
```
// Retry up to 3 times — downstream service has known transient failures under load
```
**Bad:**
```
// Increment counter by 1
counter++
```

---

## 9. Code Review Mode

When asked to review code, a diff, or a PR:

1. **Only comment when you have high confidence (>80%) that a real issue exists.** If uncertain, don't comment.
2. **Be concise** — one sentence per comment when possible.
3. Focus on **actionable feedback**, not observations or style preferences unless they violate a principle above.
4. Do not call submit/publish on reviews. Always leave reviews in **pending/draft state** for the author to submit.

### Priority Areas for Review

| Priority | Examples |
|---|---|
| **Security** | Hardcoded secrets, missing input validation, command/path injection, error messages leaking internals |
| **Correctness** | Logic errors, race conditions, resource leaks, off-by-one errors, incorrect error propagation |
| **Architecture** | Violations of existing codebase patterns, missing error handling, blocking in async contexts |
| **Maintainability** | Unnecessary duplication, overly defensive code, comments restating obvious behavior |

---

## 10. Git Workflow

### Branch-Per-Task Rule
- **Every new task MUST be implemented on its own feature branch.** Never commit directly to base branches (`main`, `master`, or any primary integration branch).
- Before starting any work, check the current branch. If on a base branch, create and switch to a new branch first.
- One branch = one task/ticket. Do not mix unrelated changes on the same branch.

### Branch Naming
- With a Jira ticket: `HMD-1234_short_description_of_change`
- Without a Jira ticket: `NO_JIRA_short_description_of_change`
- Use underscores, lowercase, and keep it concise but descriptive.

### Commit Messages
- Format: `[TICKET-ID or NO_JIRA] present-tense description of change`
- Examples:
    - `HMD-2601 add NLD eligibility check before create`
    - `NO_JIRA fix race condition in session refresh`
- Keep the first line under 72 characters. Add a body if the *why* needs more explanation.

### Before Pushing
- Run all relevant tests locally.
- Ensure all CI checks pass, including code coverage requirements.
- Remove debug logging, commented-out code, and TODO comments that shouldn't be shipped.

### Before Creating a Pull Request
- Run **all** CI checks locally (linting, type checking, tests, build) and verify they pass before pushing changes or opening a PR. Do not rely on remote CI to catch failures.
- Confirm there are no unresolved merge conflicts with the target branch.

### Pull Request Descriptions
Use this template:

```markdown
## Description
{Brief description of the changes and motivation}

## Related Jira Tickets
{Full Jira ticket URL, or NO_JIRA}

## Screenshots (if any)
{Add after testing}
```

- Do not use emojis in PR titles or descriptions.
- Keep the title in the same format as commit messages: `TICKET-ID short description`.

---

## Quick Reference

| Concern | Guideline |
|---|---|
| Naming | Descriptive > short. Long names are fine. |
| Types | Strict and explicit. No `any` without justification. |
| Errors | Handle explicitly. Don't swallow. Don't leak internals. |
| Comments | Explain *why*, not *what*. |
| Tests | Pure functions + DI = testable. Write tests for non-trivial logic. |
| Security | Validate inputs at boundaries. No hardcoded secrets. Least privilege. |
| Commits | `TICKET-ID present-tense description` |
| PRs | No emojis. Use the template. |

---

For extended testing guidelines, see [references/testing-guidelines.md](references/testing-guidelines.md).