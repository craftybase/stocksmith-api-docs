# Stocksmith API Docs

Developer documentation portal for the **Stocksmith API**, published at
**https://api.stocksmith.dev**.

Built with [Astro Starlight](https://starlight.astro.build/) — the same stack as the
Stocksmith CLI docs — rendering the API reference from an OpenAPI schema via
[`starlight-openapi`](https://github.com/HiDeoo/starlight-openapi), with an LLM-friendly
`llms.txt` via [`starlight-llms-txt`](https://github.com/HiDeoo/starlight-llms-txt).

## Source of truth

The API lives in [`craftybase-app`](../craftybase-app) (expected as a sibling checkout).
Two things flow from there:

- **`openapi.json`** — a verbatim copy of `craftybase-app/docs/api/openapi.json`, which
  rswag generates from the request specs (`RAILS_ENV=test bundle exec rake
  rswag:specs:swaggerize`). Never hand-edit the copy here; fix the specs or
  `spec/swagger_helper.rb` upstream and re-sync. Note that the schema's *description
  strings* (e.g. the `bearer_auth` blurb) come from `swagger_helper.rb` and render
  directly on the `/reference/` pages.
- **The narrative guides** (`src/content/docs/`) — hand-written, so they only stay true
  by discipline: they must describe **shipped behavior only**. No placeholders, no
  "will be documented later", no pages for planned endpoints. If it isn't in the code,
  it isn't in the docs.

## Runbook: updating the docs after an API change

Run this whenever API-touching work merges in craftybase-app (or periodically to check):

```bash
# 1. See what has drifted (schema copy, endpoints, quoted facts):
bin/check-drift.sh

# 2. Pull in the new schema — builds, commits, and PUSHES (= deploys the live site):
bin/sync-schema.sh              # copy the schema craftybase-app has committed
bin/sync-schema.sh --regenerate # or re-run rswag in ../craftybase-app first

# 3. If the change is prose-relevant (new resource, changed limits, auth changes),
#    update the affected guide in the same push — the table below says where each
#    fact comes from. Then re-run:
bin/check-drift.sh && npm run build
```

`bin/check-drift.sh` needs the sibling `../craftybase-app` checkout and verifies:

- `openapi.json` matches the app's committed schema,
- every endpoint mentioned in the prose exists in the schema **and vice versa** — a
  newly shipped endpoint fails the check until a guide mentions it,
- the base URL and MCP URL in the prose sit on the schema's `servers` host,
- facts quoted in the prose match the code: rate limits and the API key prefix,
  including the schema's own `bearer_auth` description.

There is no CI mirror yet — syncing is manual. (Future option: a GitHub Action in
craftybase-app that pushes the schema here on change.)

## Where each documented fact lives in craftybase-app

When one of these source files changes, the corresponding guide page probably needs an
edit — this map is how the docs were written and audited:

| Guide page | Source of truth in craftybase-app |
|---|---|
| Getting Started (base URL) | `spec/swagger_helper.rb` (`servers`) — but the LB/DNS decides the real host; verify with `curl` |
| Getting Started (endpoints, filters) | `config/routes.rb` (`namespace :api`), `app/lib/api/v1/catalog_query.rb` |
| Authentication (key format, 401/403, beta gating) | `app/models/api_key.rb` (`KEY_PREFIX`), `app/controllers/concerns/api/api_key_authentication.rb`, `Account#public_api_enabled?` |
| Permissions (financial field omission) | `app/lib/api/v1/base_serializer.rb` (`can_view_financials?`) |
| Pagination (defaults, clamp, `meta` envelope) | `app/controllers/api/v1/base_controller.rb` |
| Errors (statuses, body shape, vocabulary) | `base_controller.rb` (`render_error`, `FIELD_TRANSLATIONS`), the controllers' 404s |
| Rate Limiting (limits, 429 response) | `config/initializers/rack_attack.rb` |
| Agents & LLMs (MCP server, tools) | `app/controllers/api/mcp/server_controller.rb`, `app/lib/api/mcp/` |
| API Reference (everything under `/reference/`) | `docs/api/openapi.json` ← rswag specs + `spec/swagger_helper.rb` |

Current state worth knowing: the API is **read-only** (beta, "Phase A" — every endpoint
is a `GET`; access is for the Business and Growth plans, trial accounts on those plans
included, via the `public_api` flag). When Phase B ships write endpoints, the guides gain
the write-side story (validation errors, stock side-effects, migration ordering) — as
shipped behavior, not before.

## Local development

```bash
npm install
npm run dev      # http://localhost:4321
npm run build    # static build -> dist/
```

## Deployment

Built and deployed to GitHub Pages by `.github/workflows/deploy.yml` on push to `main`.
The custom domain is set in `public/CNAME` (`api.stocksmith.dev`). Any push to `main`
that changes content or the schema goes live within a few minutes — there is no separate
publish step beyond `git push`.
