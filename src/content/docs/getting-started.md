---
title: Getting Started
description: How to start using the Stocksmith API.
---

The Stocksmith API is a REST API that returns JSON. It lets you read and write your
inventory — materials, products, recipes, and manufactures — programmatically.

## Base URL

```
https://app.craftybase.com/api/v1
```

## Quick start

1. **Generate an API key** in Stocksmith under **Settings → API Keys**. See [Authentication](/authentication/).
2. **Make a request**, passing your key as a Bearer token:

   ```bash
   curl https://app.craftybase.com/api/v1/account \
     -H "Authorization: Bearer cb_live_your_key_here"
   ```

3. **Explore the endpoints** in the [API Reference](/reference/).

## Conventions

- All responses are JSON.
- The API uses **customer-facing names**: `materials` and `products` (not the internal "items" / "projects").
- List endpoints are paginated — see [Pagination](/pagination/).
- Money values are returned as objects with `amount` and `currency_code`.
