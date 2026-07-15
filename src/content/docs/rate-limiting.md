---
title: Rate Limiting
description: API rate limits and how to handle them.
---

Authenticated requests are limited to **120 requests per minute per API key**.
Unauthenticated requests (missing or malformed token) are limited to
**20 requests per minute per IP**.

The same limits apply to the hosted [MCP server](/agents/).

When you exceed a limit the API responds with `429 Too Many Requests`, a `Retry-After`
header indicating how many seconds to wait, and a JSON error body:

```
HTTP/1.1 429 Too Many Requests
Retry-After: 60
Content-Type: application/json

{ "error": "Rate limit exceeded. Retry after 60 seconds." }
```

Back off and retry after the indicated delay. Build exponential backoff into any
automated client.
