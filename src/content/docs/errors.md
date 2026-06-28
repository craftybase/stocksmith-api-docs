---
title: Errors & Validation
description: HTTP status codes and error response shapes.
---

The API uses conventional HTTP status codes.

| Status | Meaning |
|--------|---------|
| `200` | Success. |
| `201` | Resource created. |
| `400` | Malformed request. |
| `401` | Missing, invalid, or revoked API key. |
| `403` | Authenticated, but not permitted (plan or user permission). |
| `404` | Not found, or not visible to your account. |
| `422` | Validation failed. |
| `429` | Rate limited — see [Rate Limiting](/rate-limiting/). |
| `500` | Server error. |

## Error body

Most errors return a simple object:

```json
{ "error": "Invalid or revoked API key" }
```

Validation errors (`422`) return field-level detail so you can map problems back to inputs.
Field names use the customer-facing vocabulary (e.g. `material_id`, not `item_id`).
