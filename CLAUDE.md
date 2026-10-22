# Stocksmith API Docs

Starlight (Astro) docs site for the **Stocksmith API** — the public REST API of
craftybase-app — published to https://api.stocksmith.dev via GitHub Pages on push to
`main`.

## Source of truth

The API lives in `../craftybase-app` (Rails). `openapi.json` here is a **copy** of
`../craftybase-app/docs/api/openapi.json`, which rswag generates from request specs.
Never hand-edit `openapi.json`; fix the specs/`spec/swagger_helper.rb` upstream and
re-sync.

- `bin/check-drift.sh` — audits this repo against `../craftybase-app` (schema copy,
  prose↔schema endpoint agreement, rate limits, key prefix). Run it before and after
  any docs change.
- `bin/sync-schema.sh [--regenerate]` — copies the schema in, builds, commits, **pushes**
  (which deploys the live site).

## Content rules

- Guides in `src/content/docs/` describe only **shipped** behavior — no placeholders,
  no "will be documented later", no planned-endpoint pages. The API is read-only during
  the current beta (all endpoints GET); write endpoints are Phase B and not yet built.
- Verify claims against the code, not memory: auth in
  `app/controllers/concerns/api/api_key_authentication.rb`, limits in
  `config/initializers/rack_attack.rb` (1,000/min per key, 20/min per IP), pagination and
  errors in `app/controllers/api/v1/base_controller.rb`, key format in
  `app/models/api_key.rb` (`live_` prefix), MCP server in
  `app/controllers/api/mcp/server_controller.rb` (served at mcp.stocksmith.io/mcp only, the
  host in `config/initializers/mcp.rb`; `api.stocksmith.io/mcp` answers 403).
- Hosts: the API is served at **api.stocksmith.io** (path `/api/v1`); old
  app.craftybase.com URLs 302-redirect (post-rebrand). The schema's `servers` entry comes
  from `spec/swagger_helper.rb` upstream — the LB/DNS decides the real host, so verify
  with `curl` when in doubt.
- Customer-facing vocabulary only: materials/products (not the internal items/projects).
