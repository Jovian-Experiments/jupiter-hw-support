#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

(
first=true
for name in *.bin; do
  if "$first"; then
    printf "{ "
  else
    printf "\n, "
  fi
  name="${name%%.*}"
  first=false
  rel="${name##*_}"
  hw="${name%%_*}"
  printf '"%s": "%s"' "$hw" "$rel"
done
printf "\n}\n"
) | tee current.json
