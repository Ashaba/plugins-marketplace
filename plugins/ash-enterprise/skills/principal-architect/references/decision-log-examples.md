# Decision Log Examples

A collection of common "Build vs. Buy" and technology trade-off decisions, grouped by category. Use as a reference when populating the Decision Log in a TDD.

---

## Auth & Identity

| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| Auth provider | Build custom, Auth0, Cognito, Okta | Auth0 | Faster time-to-market; handles MFA, social login, OIDC out of the box. Custom build estimated at 3+ months. |
| Token format | Session cookies, JWT, opaque tokens | JWT (short-lived) | Stateless verification; works across microservices without shared session store. |
| MFA | TOTP, SMS OTP, hardware key | TOTP + SMS fallback | TOTP is free and secure; SMS fallback for user recovery. Hardware key deferred to Phase 2. |

---

## Databases & Storage

| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| Primary DB | PostgreSQL, MySQL, MongoDB, DynamoDB | PostgreSQL | ACID compliance, strong consistency, JSON support, team expertise. |
| Cache layer | Redis, Memcached, in-process | Redis | Persistence, pub/sub, richer data structures vs. Memcached. |
| Object storage | S3, GCS, Azure Blob, self-hosted MinIO | S3 | De facto standard, CDN integration, lifecycle policies. |
| Search engine | Elasticsearch, OpenSearch, Typesense, Algolia | OpenSearch | Self-hosted option, cost control, compatible with Elasticsearch clients. Algolia rejected: per-record pricing too high at scale. |
| Time-series data | InfluxDB, TimescaleDB, Prometheus + Thanos | TimescaleDB | Built on PostgreSQL (familiar ops model), good compression, continuous aggregates. |

---

## Messaging & Queuing

| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| Task queue | SQS, RabbitMQ, Kafka, Celery+Redis | SQS | Managed; auto-scaling; sufficient for < 50k msg/s. No ops burden vs. self-hosted Kafka. |
| Streaming | Kafka, Kinesis, Pulsar | Kafka (MSK) | Existing team expertise; strong ecosystem; MSK removes ops overhead. |
| Event bus | SNS+SQS fan-out, EventBridge, Kafka topics | EventBridge | Low throughput fan-out to multiple consumers; native AWS integrations; no cluster management. |

---

## API Design

| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| API style | REST, GraphQL, gRPC, tRPC | REST (JSON) | Widest client compatibility; simplest to document; team experience. GraphQL deferred — overkill for current query patterns. |
| Internal service comms | REST, gRPC, message queue | gRPC | Strong typing via protobufs; efficient binary encoding; streaming support. |
| API versioning | URL path (/v1/), header, query param | URL path | Most visible; simplest to route; widely understood by clients. |
| Rate limiting | App-layer (custom), API Gateway, Nginx, Kong | Kong | Handles rate limiting + auth plugin in one place; reduces app-layer complexity. |

---

## Infrastructure & Deployment

| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| Container orchestration | Kubernetes (EKS), ECS Fargate, Nomad | ECS Fargate | Lower ops overhead vs. K8s for current team size (< 10 engineers); sufficient for scale targets. Revisit at 50+ microservices. |
| CI/CD | Jenkins, GitHub Actions, CircleCI, Buildkite | GitHub Actions | Already using GitHub; no separate infra; marketplace actions ecosystem. |
| IaC | Terraform, Pulumi, CloudFormation, CDK | Terraform | Industry standard; large module ecosystem; team familiarity. |
| Secrets management | AWS Secrets Manager, HashiCorp Vault, Parameter Store | AWS Secrets Manager | Native IAM integration; automatic rotation; simpler than Vault for AWS-centric stack. |
| Observability | Datadog, New Relic, Grafana+Prometheus, CloudWatch | Datadog | Unified logs/metrics/traces; APM with auto-instrumentation; cost justified at current scale. |

---

## Architecture Patterns

| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| Service communication | Synchronous REST/gRPC, async messaging, hybrid | Hybrid | Sync for user-facing reads (latency-sensitive); async for writes/side effects (resilience). |
| Transaction management | 2PC, Saga (choreography), Saga (orchestration) | Saga (choreography) | Avoids distributed locks; better fault isolation. Orchestration considered but adds a single point of failure. |
| Data ownership | Shared DB, DB-per-service, CQRS | DB-per-service | Strong service isolation; prevents schema coupling. CQRS added for read-heavy services in Phase 2. |
| Caching strategy | Cache-aside, write-through, write-behind | Cache-aside | Explicit control; simpler invalidation; acceptable cache-miss rate for read patterns. |

---

## ML / AI Components

| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| LLM provider | OpenAI, Anthropic, self-hosted (Llama) | Anthropic (Claude) | Best performance on structured extraction tasks; SOC2 compliance; per-token pricing fits budget. |
| Embedding model | OpenAI ada-002, Cohere, local sentence-transformers | Cohere Embed v3 | Good benchmark performance; batch embedding API; cost-effective vs. OpenAI. |
| Vector store | Pinecone, Weaviate, pgvector, Qdrant | pgvector | Already using PostgreSQL; avoids new infrastructure; sufficient for < 10M vectors. Revisit at scale. |
| ML serving | SageMaker, BentoML, Triton, vLLM | vLLM + ECS | Best throughput for self-hosted LLMs; PagedAttention reduces memory waste. |