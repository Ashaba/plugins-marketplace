# Testing Guidelines

A reference for writing consistent, reliable tests across any language or framework.

---

## Test Naming

Tests should read like a sentence describing the scenario:

- **Pattern:** `[unit under test] [condition/scenario] [expected outcome]`
- **Examples:**
    - `calculateDiscount when user is premium returns 20 percent off`
    - `createUser when email already exists throws DuplicateEmailError`
    - `fetchOrders when API times out retries up to 3 times`

Avoid names like `test1`, `happyPath`, or `works`. Names should describe *what* is being tested and *why* it might fail.

---

## Test Structure (Arrange / Act / Assert)

```
// Arrange — set up inputs, mocks, and preconditions
// Act — invoke the unit under test
// Assert — verify the outcome
```

Each test should cover exactly one behavior. If you find yourself writing "and" in a test name, split it.

---

## Test Isolation

- Tests must not share mutable state. Each test should be fully independent.
- Reset mocks, stubs, and database state between tests.
- Avoid test ordering dependencies — tests must pass in any order.
- Prefer in-memory fakes over real databases or external services for unit tests.

---

## What to Test

| Type | What to cover |
|---|---|
| **Unit** | Pure logic, edge cases, error branches, boundary values |
| **Integration** | Correct wiring between components, data flow across layers |
| **Contract** | API shape matches what consumers expect (especially for shared services) |
| **E2E** | Critical user journeys only — keep this layer thin |

## What Not to Test

- Implementation details (private methods, internal state) — test behavior, not structure.
- Framework code you didn't write.
- Trivial getters/setters with no logic.

---

## Coverage Guidance

- Aim for **meaningful** coverage, not high percentages. 100% coverage with weak assertions is noise.
- Prioritize covering: error paths, branching logic, boundary conditions, and security-sensitive code.
- Uncovered code is a signal — either it needs a test, or it needs to be deleted.

---

## Mocking

- Mock at the boundary of your system (e.g., HTTP clients, DB adapters) — not deep inside business logic.
- Prefer dependency injection so mocks can be passed in cleanly.
- Don't mock what you own — write a real implementation or a fake instead.

---

## Test Doubles Cheat Sheet

| Type | Use when |
|---|---|
| **Stub** | You need a controlled return value |
| **Mock** | You need to verify a call was made |
| **Fake** | You need a working lightweight implementation (e.g., in-memory DB) |
| **Spy** | You need to observe calls without fully replacing behavior |

---

## Flaky Tests

A flaky test is worse than no test — it erodes trust and slows down CI.

Common causes and fixes:
- **Time-dependent logic** → inject a clock or use fixed timestamps in tests
- **Random values** → seed your RNG or use fixed test data
- **Async timing issues** → await properly, avoid arbitrary sleeps
- **Shared state** → isolate tests, reset before each run
- **External service calls** → mock or stub at the boundary

If a test is intermittently failing, fix or delete it. Don't skip it indefinitely.