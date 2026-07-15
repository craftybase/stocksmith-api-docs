---
title: Agents & LLMs
description: Using the Stocksmith API with AI agents and LLMs.
---

The Stocksmith API is built to be consumed by automation and AI agents.

## MCP server

Stocksmith exposes the same read-only capabilities as a hosted
[MCP](https://modelcontextprotocol.io) server using the Streamable HTTP transport:

```
https://mcp.craftybase.com/mcp
```

Authenticate with the same Bearer API key you use for the REST API (see
[Authentication](/authentication/)). The server exposes read-only tools that mirror the
REST endpoints — `ping`, `get_account`, plus `list_*` / `get_*` for materials, products,
components, recipes, manufactures, and expenses. The same
[rate limits](/rate-limiting/) apply.

Example client configuration:

```json
{
  "mcpServers": {
    "stocksmith": {
      "type": "http",
      "url": "https://mcp.craftybase.com/mcp",
      "headers": { "Authorization": "Bearer live_your_key_here" }
    }
  }
}
```

## llms.txt

This site publishes an [`/llms.txt`](/llms.txt) (and `/llms-full.txt`) — a compact,
LLM-friendly index of the documentation. Point your agent or retrieval pipeline at it to
give the model accurate, current context about the API.

## Tips for agents

- Authenticate with a Bearer token (see [Authentication](/authentication/)).
- Respect pagination — iterate using the `meta` envelope (see [Pagination](/pagination/)).
- Handle `429` with `Retry-After` backoff (see [Rate Limiting](/rate-limiting/)).
- Treat the machine-readable [OpenAPI schema](/reference/) as the contract.
