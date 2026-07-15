---
title: Getting Started
description: How to start using the Stocksmith API.
---

The Stocksmith API is a REST API that returns JSON. It gives you programmatic read access
to your inventory — materials, products, components, recipes, manufactures, and expenses.

The API is currently **read-only**: every endpoint is a `GET`. Write endpoints are planned
but not yet available.

## Base URL

```
https://api.stocksmith.io/api/v1
```

The previous base URL (`https://app.craftybase.com/api/v1`) returns a `302` redirect to
the new host. Update your clients rather than relying on it — many HTTP clients drop the
`Authorization` header when following cross-host redirects.

## Quick start

1. **Generate an API key** in Stocksmith under **Settings → API Keys**. See [Authentication](/authentication/).
2. **Verify the key** with the ping endpoint, passing it as a Bearer token:

   ```bash
   curl https://api.stocksmith.io/api/v1/ping \
     -H "Authorization: Bearer live_your_key_here"
   ```

3. **Explore the endpoints** in the [API Reference](/reference/).

## Resources

| Resource | Endpoints |
|----------|-----------|
| Ping | `GET /ping` — health check, verifies the token |
| Account | `GET /account` |
| Materials | `GET /materials`, `GET /materials/{id}` |
| Products | `GET /products`, `GET /products/{id}` |
| Components | `GET /components`, `GET /components/{id}` |
| Recipes | `GET /recipes`, `GET /recipes/{id}` |
| Manufactures | `GET /manufactures`, `GET /manufactures/{id}` |
| Expenses | `GET /expenses`, `GET /expenses/{id}` |

## Filtering catalog lists

The catalog list endpoints (`/materials`, `/products`, `/components`) accept these
optional filters, combined with AND:

| Parameter | Behaviour |
|-----------|-----------|
| `state` | `active` (default), `archived`, or `all`. |
| `name` | Substring match on name. |
| `sku` | Exact SKU match. |
| `category_name` | Substring match on category name. |

## Conventions

- All responses are JSON.
- The API uses **customer-facing names**: `materials` and `products` (not the internal
  "items" / "projects").
- List endpoints are paginated — see [Pagination](/pagination/).
- Money values are objects with a decimal-string `amount` and a `currency_code` — never
  bare floats: `{ "amount": "8.75", "currency_code": "USD" }`.
- Timestamps are ISO 8601 strings.
