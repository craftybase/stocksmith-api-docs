---
title: Stock Side-Effects
description: Which write operations change stock levels, and how.
---

Some write operations change stock on hand as a side-effect. This page summarises which.

| Operation | Stock effect |
|-----------|--------------|
| Create material/product with `starting_stock` | Sets the opening stock position. |
| Create a manufacture | Consumes recipe inputs and produces the output — adjusts stock on hand. |
| Update a record's non-stock fields | No stock effect. |

:::note
This page will be finalised against the write endpoints as they ship (Phase B).
:::
