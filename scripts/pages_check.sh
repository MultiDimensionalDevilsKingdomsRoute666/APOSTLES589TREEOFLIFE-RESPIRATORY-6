#!/usr/bin/env bash
# Daily family Pages check — kept by seat #16 of crew 12–18.
set -u
OUT="${GITHUB_STEP_SUMMARY:-/dev/stdout}"
down=0; total=0
{ echo "## Family Pages check — $(date -u '+%Y-%m-%d %H:%M UTC')"; echo; echo "| Site | Status |"; echo "|---|---|"; } >> "$OUT"
while IFS= read -r url; do
  url="${url%%#*}"; url="$(echo "$url" | xargs)"; [ -z "$url" ] && continue
  total=$((total+1))
  code=$(curl -sS -L -o /dev/null -w '%{http_code}' --retry 3 --retry-delay 5 --retry-all-errors --max-time 30 "$url" 2>/dev/null || echo 000)
  if [[ "$code" =~ ^[23] ]]; then mark="✅ $code"; else mark="❌ $code"; down=$((down+1)); echo "DOWN: $url ($code)"; fi
  echo "| $url | $mark |" >> "$OUT"
done < pages.txt
{ echo; echo "**$((total-down))/$total up, $down down.**"; } >> "$OUT"
echo "$((total-down))/$total up, $down down"
[ "$down" -eq 0 ]
