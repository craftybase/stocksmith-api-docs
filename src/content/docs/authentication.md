---
title: Authentication
description: Authenticating with the Stocksmith API using personal API keys.
---

The Stocksmith API authenticates with **personal API keys** passed as a Bearer token.

## Generating a key

Go to **Settings → API Keys** in Stocksmith and create a key. Copy it immediately — the
full key (`live_…`) is shown only once; after that only a masked form is displayed. Keys
are managed by the account's primary user.

API access is currently in beta and is enabled per account, independent of plan. Requests
from an account without access return `403` with
`API access is not enabled for this account`.

## Making authenticated requests

Pass the key in the `Authorization` header:

```bash
curl https://app.craftybase.com/api/v1/materials \
  -H "Authorization: Bearer live_your_key_here"
```

A missing or malformed header returns `401` with
`Missing or invalid Authorization header. Expected: Bearer <token>`. An unrecognized or
revoked key returns `401` with `Invalid or revoked API key`.

## Permissions

API keys act on behalf of the user that created them, and that user's permissions carry
through to the API: **view-only** users receive responses with financial fields (costs,
prices) omitted.
