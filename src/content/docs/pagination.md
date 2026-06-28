---
title: Pagination
description: How list endpoints paginate results.
---

List endpoints return a page of results plus a `meta` envelope describing the full set.

## Parameters

| Parameter | Default | Notes |
|-----------|---------|-------|
| `page` | `1` | The page number to fetch. |
| `per_page` | `25` | Results per page. Maximum `100`; larger values are clamped. |

## The `meta` envelope

```json
{
  "materials": [ /* … */ ],
  "meta": {
    "current_page": 1,
    "total_pages": 4,
    "total_count": 87,
    "per_page": 25
  }
}
```

## Iterating through all results

Request `page=1`, then keep incrementing `page` until `current_page` equals `total_pages`.
An empty result set returns an empty array (not an error) with `total_count: 0`.
