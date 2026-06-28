// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightOpenAPI, { openAPISidebarGroups } from 'starlight-openapi';
import starlightLlmsTxt from 'starlight-llms-txt';

export default defineConfig({
  site: 'https://api.stocksmith.dev',
  integrations: [
    starlight({
      title: 'Stocksmith API',
      description: 'REST API for materials, products, recipes, and manufactures.',
      favicon: '/favicon.svg',
      // Logos are named by their own colour, so map by theme function:
      // black wordmark on light backgrounds, white wordmark on dark backgrounds.
      logo: {
        light: './src/assets/logo-dark.svg',
        dark: './src/assets/logo-light.svg',
        replacesTitle: true,
        alt: 'Stocksmith API',
      },
      head: [
        { tag: 'meta', attrs: { property: 'og:image', content: 'https://api.stocksmith.dev/favicon.svg' } },
        { tag: 'meta', attrs: { name: 'theme-color', content: '#EE8F38' } },
      ],
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/craftybase/stocksmith-api-docs' },
      ],
      plugins: [
        starlightLlmsTxt(),
        // Renders docs/api/openapi.json (mirrored from craftybase-app) at /reference/.
        starlightOpenAPI([
          { base: 'reference', schema: './openapi.json' },
        ]),
      ],
      sidebar: [
        { label: 'Getting Started', slug: 'getting-started' },
        { label: 'Authentication', slug: 'authentication' },
        { label: 'Pagination', slug: 'pagination' },
        { label: 'Migration Order', slug: 'migration-order' },
        { label: 'Stock Side-Effects', slug: 'stock-side-effects' },
        { label: 'Errors & Validation', slug: 'errors' },
        { label: 'Rate Limiting', slug: 'rate-limiting' },
        { label: 'Agents & LLMs', slug: 'agents' },
        // API reference groups generated from the OpenAPI schema.
        ...openAPISidebarGroups,
      ],
    }),
  ],
});
