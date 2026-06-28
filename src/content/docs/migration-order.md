---
title: Migration Order
description: The recommended order for importing your data via the API.
---

When seeding an account through the API, create records in this order so references
resolve and stock lands correctly:

1. **Materials** — with `starting_stock` for opening quantities.
2. **Products** — with `starting_stock` (per variation where relevant).
3. **Recipes** — link materials and components to products.
4. **Manufactures** — record production events.

## Starting stock vs. manufactures

- **Starting stock** sets an *opening position* at creation time — a one-off baseline.
- **Manufactures** are *production events* that consume inputs and produce outputs,
  adjusting stock on hand each time.

Use starting stock to represent what you already had on day one; use manufactures for
ongoing production. See [Stock Side-Effects](/stock-side-effects/).
