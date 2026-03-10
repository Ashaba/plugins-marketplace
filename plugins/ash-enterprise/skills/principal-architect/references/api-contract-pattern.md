# API Contract Patterns

Reference for common API design patterns to use when specifying contracts in a TDD.

---

## REST (OpenAPI Style)

### Standard CRUD Resource

```
POST   /v1/{resources}           → 201 Created  (create)
GET    /v1/{resources}           → 200 OK        (list, paginated)
GET    /v1/{resources}/{id}      → 200 OK        (get single)
PUT    /v1/{resources}/{id}      → 200 OK        (full replace)
PATCH  /v1/{resources}/{id}      → 200 OK        (partial update)
DELETE /v1/{resources}/{id}      → 204 No Content (soft or hard delete)
```

### Pagination (cursor-based preferred for large datasets)
```json
GET /v1/orders?cursor=abc123&limit=50
{
  "data": [...],
  "pagination": {
    "next_cursor": "def456",
    "has_more": true,
    "total": null
  }
}
```

### Standard Error Envelope
```json
{
  "error": {
    "code": "VALIDATION_ERROR",          // machine-readable, SCREAMING_SNAKE_CASE
    "message": "Human-readable message.",
    "details": [                          // optional, for field-level errors
      { "field": "email", "issue": "Invalid format." }
    ],
    "request_id": "req_abc123"           // for tracing
  }
}
```

### HTTP Status Code Guide
| Code | When to Use |
|---|---|
| 200 | Successful GET, PATCH, PUT |
| 201 | Resource created (POST) |
| 202 | Accepted for async processing |
| 204 | Success, no body (DELETE) |
| 400 | Client validation error |
| 401 | Missing / invalid auth token |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Conflict (duplicate, state mismatch) |
| 422 | Semantically invalid input |
| 429 | Rate limit exceeded |
| 500 | Unexpected server error |
| 503 | Service temporarily unavailable |

---

## gRPC / Protobuf

### Service Definition Template
```protobuf
syntax = "proto3";
package order.v1;

service OrderService {
  rpc CreateOrder(CreateOrderRequest) returns (Order);
  rpc GetOrder(GetOrderRequest) returns (Order);
  rpc ListOrders(ListOrdersRequest) returns (ListOrdersResponse);
  rpc CancelOrder(CancelOrderRequest) returns (Order);
  rpc StreamOrderUpdates(GetOrderRequest) returns (stream OrderEvent);
}

message CreateOrderRequest {
  string customer_id = 1;
  repeated OrderItem items = 2;
  Address shipping_address = 3;
  string payment_method_id = 4;
}

message Order {
  string id = 1;
  string customer_id = 2;
  string status = 3;
  repeated OrderItem items = 4;
  google.protobuf.Timestamp created_at = 5;
}

message OrderEvent {
  string order_id = 1;
  string event_type = 2;   // e.g., "STATUS_CHANGED", "ITEM_SHIPPED"
  google.protobuf.Timestamp occurred_at = 3;
}
```

### gRPC Status Codes (use instead of HTTP codes)
| Code | When to Use |
|---|---|
| OK | Success |
| INVALID_ARGUMENT | Bad input (like 400) |
| NOT_FOUND | Resource missing (like 404) |
| ALREADY_EXISTS | Duplicate (like 409) |
| PERMISSION_DENIED | Not authorized (like 403) |
| UNAUTHENTICATED | No/invalid token (like 401) |
| RESOURCE_EXHAUSTED | Rate limited (like 429) |
| INTERNAL | Server error (like 500) |
| UNAVAILABLE | Service down (like 503) |

---

## Event-Driven / Async Contracts

### Event Envelope Schema
```json
{
  "event_id": "evt_abc123",
  "event_type": "order.confirmed",         // {resource}.{verb}, past tense
  "schema_version": "1.0",
  "occurred_at": "2024-01-15T10:30:00Z",
  "producer": "order-service",
  "correlation_id": "req_xyz789",          // ties to originating request
  "payload": {
    "order_id": "ord_456",
    "customer_id": "cust_789",
    "total_amount": 99.99
  }
}
```

### Event Naming Convention
- Format: `{resource}.{past_tense_verb}`
- Examples: `order.created`, `order.confirmed`, `order.cancelled`, `payment.failed`, `user.registered`

### Consumer Contract (for documentation)
| Event | Producer | Consumer(s) | Action |
|---|---|---|---|
| `order.confirmed` | Order Service | Notification Service, Inventory Service | Send email; decrement stock |
| `payment.failed` | Payment Service | Order Service | Mark order as payment_failed |
| `shipment.created` | Shipping Service | Notification Service | Send tracking email |

---

## Webhook Contracts (outbound to customer systems)

### Webhook Payload
```json
{
  "webhook_id": "wh_abc123",
  "event_type": "order.status_changed",
  "api_version": "2024-01-01",
  "created_at": "2024-01-15T10:30:00Z",
  "data": {
    "object": "order",
    "id": "ord_456",
    "status": "shipped",
    "previous_status": "processing"
  }
}
```

### Security: Signature Verification
- Sign payload with HMAC-SHA256 using webhook secret.
- Include signature in header: `X-Signature: sha256=<hex_digest>`
- Consumer verifies before processing.

### Retry Policy
- On non-2xx response: retry with exponential backoff.
- Max retries: 5 (at 5s, 30s, 5m, 30m, 2h intervals).
- After 5 failures: mark webhook endpoint as disabled, notify account owner.

---

## GraphQL (when applicable)

### When to use GraphQL
- Client needs vary significantly (mobile vs. web fetch different fields).
- Multiple entity types need to be fetched in one round trip.
- Team is already familiar with it.

### Schema Template
```graphql
type Query {
  order(id: ID!): Order
  orders(customerId: ID!, first: Int, after: String): OrderConnection
}

type Mutation {
  createOrder(input: CreateOrderInput!): CreateOrderPayload
  cancelOrder(id: ID!): CancelOrderPayload
}

type Order {
  id: ID!
  status: OrderStatus!
  items: [OrderItem!]!
  customer: Customer!
  createdAt: DateTime!
}

enum OrderStatus {
  PENDING
  CONFIRMED
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
}

input CreateOrderInput {
  customerId: ID!
  items: [OrderItemInput!]!
  shippingAddress: AddressInput!
}
```

### Error Handling in GraphQL
```json
{
  "data": null,
  "errors": [
    {
      "message": "Order not found.",
      "extensions": {
        "code": "NOT_FOUND",
        "field": "id"
      }
    }
  ]
}
```

---

## Auth Patterns

### JWT Structure (for internal services)
```
Header: { "alg": "RS256", "typ": "JWT" }
Payload: {
  "sub": "user_abc123",
  "iss": "auth-service",
  "aud": ["order-service", "inventory-service"],
  "scope": "orders:write inventory:read",
  "iat": 1705312200,
  "exp": 1705315800    // short-lived: 1 hour max
}
```

### Service-to-Service Auth Options
| Pattern | When to Use |
|---|---|
| mTLS | High-security internal mesh; pairs well with service mesh (Istio) |
| JWT with service account | Simpler; sufficient for most internal APIs |
| API Key (static) | Legacy systems or third-party integrations only; avoid for new services |
| OAuth2 Client Credentials | When external OAuth2 provider manages service identities |