# Stocksmith API Docs

Developer documentation portal for the **Stocksmith API**, published at
**https://api.stocksmith.dev**.

Built with [Astro Starlight](https://starlight.astro.build/) — the same stack as the
Stocksmith CLI docs — rendering the API reference from an OpenAPI schema via
[`starlight-openapi`](https://github.com/HiDeoo/starlight-openapi), with an LLM-friendly
`llms.txt` via [`starlight-llms-txt`](https://github.com/HiDeoo/starlight-llms-txt).

## Source of truth

`openapi.json` is **generated** from the rswag request specs in `craftybase-app`
(`docs/api/openapi.json`) and mirrored into this repo by CI on merge to `develop`.

> The `openapi.json` currently committed here is a **placeholder** so the site builds.
> It will be replaced once the rswag pipeline (Workstream A) is wired up.

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
