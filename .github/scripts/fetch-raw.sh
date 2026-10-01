#!/usr/bin/env bash
# Pre-fetch the page behind each raw inbox item so the sandboxed ingest agent
# can read it offline. Output goes to $OUT_DIR (outside the repo, so it is never
# picked up as an inbox item or committed). Failures are non-fatal.
set -uo pipefail

RAW_DIR="${RAW_DIR:-inbox/raw}"
OUT_DIR="${OUT_DIR:-/tmp/gh-aw/fetched}"

# Start clean so a failed fetch never leaves a stale sidecar the agent would trust.
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

while IFS= read -r -d '' item; do
  # `resource:` from the item's own YAML frontmatter (first block only).
  url=$(awk '
    /^---[[:space:]]*$/ { fm++; next }
    fm == 1 && /^resource:/ { sub(/^resource:[[:space:]]*/, ""); gsub(/["'\'']/, ""); print; exit }
    fm >= 2 { exit }
  ' "$item")

  case "$url" in
    http://*|https://*) ;;
    *) continue ;;
  esac

  rel="${item#"$RAW_DIR"/}"
  dest="$OUT_DIR/$rel"
  mkdir -p "$(dirname "$dest")"

  if trafilatura -u "$url" --output-format markdown --links > "$dest.tmp" 2>/dev/null \
     && [ -s "$dest.tmp" ]; then
    {
      printf -- '---\nfetched_from: %s\nfetched_at: %s\n---\n\n' "$url" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
      cat "$dest.tmp"
    } > "$dest"
    echo "fetched: $url -> $dest"
  else
    echo "::warning::could not fetch $url (item: $item)"
  fi
  rm -f "$dest.tmp"
done < <(find "$RAW_DIR" -type f -name '*.md' -print0 | sort -z)
