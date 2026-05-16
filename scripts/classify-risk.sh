#!/usr/bin/env bash

set -euo pipefail

base_ref="${BASE_REF:-main}"
comparison_ref="origin/${base_ref}"

if ! git rev-parse --verify "${comparison_ref}" >/dev/null 2>&1; then
  printf 'risk=%s\n' 'risk: low'
  printf 'reason=%s\n' "Base ref ${comparison_ref} is unavailable in the current clone"
  exit 0
fi

diff_range="${comparison_ref}...HEAD"

if ! git merge-base "${comparison_ref}" HEAD >/dev/null 2>&1; then
  diff_range="${comparison_ref}..HEAD"
fi

mapfile -t changed_files < <(git diff --name-only "${diff_range}")
diff_stat="$(git diff --shortstat "${diff_range}")"
total_lines="$(printf '%s\n' "${diff_stat}" | grep -Eo '[0-9]+ insertions?\(\+\)|[0-9]+ deletions?\(-\)' | grep -Eo '^[0-9]+' | awk '{sum += $1} END {print sum + 0}')"

high_risk_patterns=(
  'Migrations/'
  '/Auth/'
  '/Domain/'
  'Program.cs'
  'appsettings'
  '.github/workflows/'
)

reason='Small or standard change set'
risk='risk: low'

for file in "${changed_files[@]}"; do
  for pattern in "${high_risk_patterns[@]}"; do
    if [[ "${file}" == *"${pattern}"* ]]; then
      risk='risk: high'
      reason="Sensitive path changed: ${file}"
      printf 'risk=%s\n' "${risk}"
      printf 'reason=%s\n' "${reason}"
      exit 0
    fi
  done
done

if (( total_lines > 250 )); then
  risk='risk: high'
  reason="Large change set: ${total_lines} lines changed"
fi

printf 'risk=%s\n' "${risk}"
printf 'reason=%s\n' "${reason}"
