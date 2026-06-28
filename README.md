# Stocksmith API Docs

Developer documentation portal for the **Stocksmith API**, published at
**https://api.stocksmith.dev**.

Built with [Astro Starlight](https://starlight.astro.build/) — the same stack as the
Stocksmith CLI docs — rendering the API reference from an OpenAPI schema via
[`starlight-openapi`](https://github.com/HiDeoo/starlight-openapi), with an LLM-friendly
`llms.txt` via [`starlight-llms-txt`](https://github.com/HiDeoo/starlight-llms-txt).

## Source of truth

`openapi.json` is **generated** from the rswag request specs in `craftybase-app`
(`docs/api/openapi.json`, via `RAILS_ENV=test bundle exec rake rswag:specs:swaggerize`).
It is the contract this site renders.

Syncing is **manual for now** (no CI mirror yet). After the schema changes have merged in
craftybase-app, publish them here with:

```bash
bin/sync-schema.sh   # copies ../craftybase-app/docs/api/openapi.json, builds, commits, pushes
```

Narrative guides live in `src/content/docs/`.

## Local development

```bash
npm install
npm run dev      # http://localhost:4321
npm run build    # static build -> dist/
```

## Deployment

Built and deployed to GitHub Pages by `.github/workflows/deploy.yml` on push to `main`.
The custom domain is set in `public/CNAME` (`api.stocksmith.dev`).
