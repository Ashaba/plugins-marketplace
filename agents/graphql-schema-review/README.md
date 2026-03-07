# graphql-schema-review

A GitHub Copilot agent skill that performs comprehensive reviews of GraphQL schemas. Give it your schema and receive a structured, actionable report covering naming conventions, type design, nullability, deprecations, breaking changes, performance, security, and more.

---

## Features

- **Naming Conventions** — Validates `PascalCase` types, `camelCase` fields, `SCREAMING_SNAKE_CASE` enum values, and proper `Input`/`Payload` suffixes
- **Type Design** — Reviews scalar choices, union/interface usage, and structural evolvability
- **Nullability** — Identifies fields that are incorrectly nullable or non-null, and explains list nullability semantics
- **Deprecations** — Checks that `@deprecated` directives include migration guidance
- **Breaking Changes** — Classifies schema changes as Breaking, Non-Breaking, or Potentially Breaking
- **Performance** — Flags unbounded lists, missing pagination, and N+1-prone designs
- **Security** — Detects sensitive field exposure, missing input types on mutations, and injection-risk patterns
- **Custom Scalars & Directives** — Ensures custom additions are documented and consistently named

---

## Usage

Attach or paste your GraphQL schema and invoke the agent:

```
@graphql-schema-review <your request>
```

The agent accepts:
- SDL text pasted directly into the chat
- `.graphql` or `.graphqls` file attachments
- GraphQL introspection JSON

---

## Example Prompts

- `@graphql-schema-review Review this schema for naming convention issues`
- `@graphql-schema-review What breaking changes would this schema introduce compared to our current version? [attach old schema and new schema]`
- `@graphql-schema-review Are there any security concerns in this schema?`
- `@graphql-schema-review This schema will be a public API — check nullability and pagination thoroughly`
- `@graphql-schema-review Generate a full schema review report for the attached schema.graphql`

---

## Output Format

The agent returns a structured Markdown report with the following sections:

| Section | Description |
|---------|-------------|
| **Summary** | High-level overview of schema health and finding counts |
| 🔴 **Critical Issues** | Bugs, security risks, or breaking changes — fix immediately |
| 🟡 **Warnings** | Best practice violations that will cause problems as the schema grows |
| 🟢 **Suggestions** | Minor improvements for consistency and future-proofing |
| ⚠️ **Breaking Changes** | Explicit list of any breaking changes detected |
| ✅ **Positive Highlights** | Things the schema does well |

Each finding includes the exact field/type path, a description of the issue, and a concrete recommendation.

---

## Limitations

- The agent reviews schema structure only — it cannot analyze resolver logic, runtime behavior, or live API responses
- It does not perform live introspection against a running GraphQL endpoint
- Security findings are based on naming patterns and structural analysis; they do not replace a full security audit
- When only a partial schema is provided, findings are scoped to the supplied types only

