---
title: Agents & LLMs
description: Using the Stocksmith API with AI agents and LLMs.
---

The Stocksmith API is built to be consumed by automation and AI agents.

## llms.txt

This site publishes an [`/llms.txt`](/llms.txt) (and `/llms-full.txt`) — a compact,
LLM-friendly index of the documentation. Point your agent or retrieval pipeline at it to
give the model accurate, current context about the API.

## Tips for agents

- Authenticate with a Bearer token (see [Authentication](/authentication/)).
- Respect pagination — iterate using the `meta` envelope (see [Pagination](/pagination/)).
- Handle `429` with `Retry-After` backoff (see [Rate Limiting](/rate-limiting/)).
- Treat the machine-readable [OpenAPI schema](/reference/) as the contract.
