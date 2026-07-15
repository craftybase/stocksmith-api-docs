---
title: Errors & Validation
description: HTTP status codes and error response shapes.
---

The API uses conventional HTTP status codes.

| Status | Meaning |
|--------|---------|
| `200` | Success. |
| `401` | Missing or malformed `Authorization` header, or an invalid/revoked API key. |
| `403` | Authenticated, but API access is not enabled for the account. |
| `404` | Not found, or not visible to your account. |
| `429` | Rate limited — see [Rate Limiting](/rate-limiting/). |
| `500` | Server error. |

The API is currently read-only, so write-related statuses (`201 Created`,
`422 Unprocessable Entity`) do not occur yet.

## Error body

Errors return a single-key JSON object:

```json
{ "error": "Invalid or revoked API key" }
```

Error messages use the customer-facing vocabulary (`material`, not `item`).
