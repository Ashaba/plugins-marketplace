# Changelog

All notable changes to the `graphql-schema-review` skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2026-03-05

### Added

- Initial release of the `graphql-schema-review` agent skill
- **Naming Conventions** review: validates `PascalCase` types, `camelCase` fields, `SCREAMING_SNAKE_CASE` enum values, `Input`/`Payload` suffixes, and verb-first mutation naming
- **Type Design** review: scalar specificity, union/interface guidance, evolvability warnings, redundant type detection
- **Nullability** review: incorrect nullable/non-null field detection, list nullability semantics, non-null chain warnings
- **Deprecations** review: missing `reason` argument detection, missing replacement guidance, stale deprecation warnings
- **Breaking Changes** classification: Breaking, Non-Breaking, and Potentially Breaking change detection; explicit diff support
- **Performance** review: unbounded list detection, Relay Connection pattern recommendations, N+1 design warnings
- **Security** review: sensitive field name detection, over-permissive root fields, injection-risk pattern flagging, missing mutation input type warnings
- **Custom Scalars & Directives** review: undocumented scalar detection, directive naming consistency checks
- Structured Markdown report output with 🔴 Critical / 🟡 Warning / 🟢 Suggestion severity levels and ✅ Positive Highlights section

