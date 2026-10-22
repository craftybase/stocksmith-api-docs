#!/usr/bin/env bash
#
# Detect drift between this docs site and the craftybase-app source of truth.
#
# Checks:
#   1. openapi.json here matches the committed schema in craftybase-app
#   2. every API path mentioned in the prose exists in openapi.json
#   3. every path in openapi.json is mentioned somewhere in the prose
#   4. the base URL in the prose sits on the schema's servers host, and the MCP
#      URL is the app's MCP host (config/initializers/mcp.rb)
#   5. facts quoted in the prose match the app code:
#      - rate limits (config/initializers/rack_attack.rb)
#      - the API key prefix (app/models/api_key.rb), in prose and in the
#        schema's own bearer_auth description
#
# Usage:
#   bin/check-drift.sh [path-to-craftybase-app]   # default: ../craftybase-app
#
# Prints every failure and exits non-zero if any check failed. Checks that need
# the app repo are skipped with a note when it isn't checked out.
#
set -uo pipefail
cd "$(dirname "$0")/.."

APP="${1:-../craftybase-app}"
DOCS="src/content/docs"
FAILURES=0

fail() { echo "FAIL: $*"; FAILURES=$((FAILURES + 1)); }
ok()   { echo "  ok: $*"; }
skip() { echo "skip: $*"; }

# -- 1. schema copy is current ------------------------------------------------
if [ -f "$APP/docs/api/openapi.json" ]; then
  if cmp -s openapi.json "$APP/docs/api/openapi.json"; then
    ok "openapi.json matches $APP/docs/api/openapi.json"
  else
    fail "openapi.json differs from $APP/docs/api/openapi.json — run bin/sync-schema.sh"
  fi
else
  skip "schema comparison ($APP not checked out)"
fi

# -- 2 & 3. prose endpoints <-> schema paths ----------------------------------
python3 - "$DOCS" <<'PY'
import json, pathlib, re, sys

docs = pathlib.Path(sys.argv[1])
schema_paths = set(json.load(open("openapi.json"))["paths"])
prose = "\n".join(p.read_text() for p in list(docs.glob("*.md")) + list(docs.glob("*.mdx")))

# Paths mentioned in prose: absolute (/api/v1/...) or as `VERB /resource` code spans.
mentioned = set(re.findall(r"/api/v1/[a-z_{}/]+[a-z_{}]", prose))
mentioned |= {
    "/api/v1/" + m
    for m in re.findall(r"`(?:GET|POST|PATCH|PUT|DELETE) /([a-z_{}/]+)`", prose)
}

failures = 0
for path in sorted(mentioned - schema_paths):
    print(f"FAIL: prose mentions {path}, which is not in openapi.json")
    failures += 1
for path in sorted(schema_paths - mentioned):
    print(f"FAIL: {path} is in openapi.json but never mentioned in the prose")
    failures += 1
if not failures:
    print(f"  ok: {len(schema_paths)} schema paths and prose mentions agree")
sys.exit(1 if failures else 0)
PY
[ $? -ne 0 ] && FAILURES=$((FAILURES + 1))

# -- 4. base URL matches the schema servers entry; MCP URL matches the app -----
python3 - "$DOCS" "$APP" <<'PY'
import json, pathlib, re, sys

docs = pathlib.Path(sys.argv[1])
initializer = pathlib.Path(sys.argv[2]) / "config/initializers/mcp.rb"
server = json.load(open("openapi.json"))["servers"][0]["url"].rstrip("/")
failures = 0

def block_after(heading, text):
    m = re.search(re.escape(heading) + r".*?```\s*\n(\S+)\s*\n```", text, re.S)
    return m.group(1) if m else None

base = block_after("## Base URL", (docs / "getting-started.md").read_text())
if base != f"{server}/api/v1":
    print(f"FAIL: getting-started base URL is {base}, but schema servers[0] implies "
          f"{server}/api/v1 — if the prose is right, fix servers in spec/swagger_helper.rb "
          f"(craftybase-app), regenerate, and sync")
    failures += 1
else:
    print(f"  ok: base URL matches schema servers entry ({base})")

# The MCP transport answers 403 on any host but this one, so it is not the REST host.
mcp = block_after("## MCP server", (docs / "agents.md").read_text())
if mcp and initializer.exists():
    host = re.search(r'ENV\.fetch\("MCP_HOST",\s*"([^"]+)"\)', initializer.read_text())
    expected = f"https://{host.group(1)}/mcp" if host else "(no MCP_HOST default found)"
    if mcp != expected:
        print(f"FAIL: agents.md MCP URL {mcp} is not the app's MCP endpoint {expected}")
        failures += 1
    else:
        print(f"  ok: MCP URL matches the app's MCP host ({mcp})")
elif mcp:
    print("skip: MCP URL check (app not checked out)")

sys.exit(1 if failures else 0)
PY
[ $? -ne 0 ] && FAILURES=$((FAILURES + 1))

# -- 5a. rate limits quoted in prose match rack_attack.rb ----------------------
RACK_ATTACK="$APP/config/initializers/rack_attack.rb"
if [ -f "$RACK_ATTACK" ]; then
  # Ruby allows digit separators (1_000), so read the value after the '=' and strip
  # them — a bare [0-9]+ stops at the underscore and yields 1.
  rack_limit() { sed -nE "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*([0-9_]+).*/\1/p" "$RACK_ATTACK" | head -1 | tr -d '_'; }
  per_key=$(rack_limit api_rate_limit)
  per_ip=$(rack_limit api_unauthenticated_limit)
  for pair in "$per_key:per API key" "$per_ip:per IP"; do
    limit="${pair%%:*}" label="${pair#*:}"
    # Commas stripped from the prose so "1,000 requests per minute" still matches.
    if tr -d ',' < "$DOCS/rate-limiting.md" | grep -q "$limit requests per minute"; then
      ok "rate limit $limit/min ($label) documented"
    else
      fail "rate-limiting.md does not say '$limit requests per minute' ($label, per rack_attack.rb)"
    fi
  done
else
  skip "rate-limit check ($RACK_ATTACK not found)"
fi

# -- 5b. API key prefix in prose and schema matches api_key.rb -----------------
API_KEY_RB="$APP/app/models/api_key.rb"
if [ -f "$API_KEY_RB" ]; then
  prefix=$(grep -Eo 'KEY_PREFIX *= *"[^"]+"' "$API_KEY_RB" | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -n "$prefix" ]; then
    # Key-shaped tokens only (must contain "_") — skips prose like "a Bearer token".
    bad_tokens=$(grep -rhoE 'Bearer [A-Za-z0-9]*_[A-Za-z0-9_…]+' "$DOCS" | awk '{print $2}' | grep -v "^$prefix" || true)
    if [ -n "$bad_tokens" ]; then
      fail "prose Bearer examples don't start with '$prefix': $(echo "$bad_tokens" | sort -u | tr '\n' ' ')"
    else
      ok "all prose Bearer examples use the '$prefix' prefix"
    fi
    # Known stale value from before the prefix was finalised.
    if grep -rq "cb_live_" "$DOCS"; then
      fail "prose still contains the stale 'cb_live_' key prefix"
    fi
    if python3 -c "
import json, sys
desc = json.load(open('openapi.json'))['components']['securitySchemes']['bearer_auth'].get('description', '')
sys.exit(0 if '$prefix' in desc and 'cb_$prefix' not in desc else 1)
"; then
      ok "schema bearer_auth description mentions the '$prefix' prefix"
    else
      fail "schema bearer_auth description doesn't match prefix '$prefix' — fix spec/swagger_helper.rb in craftybase-app and re-run rswag + sync"
    fi
  else
    skip "key-prefix check (KEY_PREFIX not found in $API_KEY_RB)"
  fi
else
  skip "key-prefix check ($API_KEY_RB not found)"
fi

echo
if [ "$FAILURES" -gt 0 ]; then
  echo "$FAILURES drift check(s) failed — see FAIL lines above."
  exit 1
fi
echo "No drift detected."
