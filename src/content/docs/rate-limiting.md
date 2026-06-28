---
title: Rate Limiting
description: API rate limits and how to handle them.
---

When you exceed the rate limit, the API responds with `429 Too Many Requests` and a
`Retry-After` header indicating how many seconds to wait before retrying.

```
HTTP/1.1 429 Too Many Requests
Retry-After: 30
```

Back off and retry after the indicated delay. Build exponential backoff into any
automated client.

:::note
Current limits per plan will be documented here once finalised.
:::
