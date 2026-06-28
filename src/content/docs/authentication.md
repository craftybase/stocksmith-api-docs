---
title: Authentication
description: Authenticating with the Stocksmith API using personal API keys.
---

The Stocksmith API authenticates with **personal API keys** passed as a Bearer token.

## Generating a key

Go to **Settings → API Keys** in Stocksmith and create a key. Copy it immediately — the
full key (`cb_live_…`) is shown only once.

API access requires an eligible plan (or the `public_api` feature flag enabled for your
account).

## Making authenticated requests

Pass the key in the `Authorization` header:

```bash
curl https://app.craftybase.com/api/v1/materials \
  -H "Authorization: Bearer cb_live_your_key_here"
```

A missing or malformed header returns `401 Unauthorized`. Revoked keys also return `401`.

## Permissions

API keys act on behalf of the user that created them. That user's permissions carry
through to the API — for example, a user without financial visibility receives responses
with cost and price fields omitted.
