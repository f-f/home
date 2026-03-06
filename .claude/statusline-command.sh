#!/usr/bin/env bash
# Claude Code status line - inspired by the Prezto Paradox theme

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Directory segment
dir_seg=$(printf '\033[38;5;75m%s\033[0m' "$cwd")

# Model segment
model_seg=$(printf '\033[38;5;176m%s\033[0m' "$model")

# Context window usage (only if available)
if [ -n "$used_pct" ]; then
  ctx_seg=$(printf '\033[38;5;245mctx:%s%%\033[0m' "$(printf '%.0f' "$used_pct")")
else
  ctx_seg=""
fi

# Total session cost (only if available)
if [ -n "$total_cost" ]; then
  cost_seg=$(printf '\033[38;5;245m$%s\033[0m' "$(printf '%.2f' "$total_cost")")
else
  cost_seg=""
fi

# Build and print the final status line
parts=("$dir_seg" "$model_seg")
[ -n "$ctx_seg" ]  && parts+=("$ctx_seg")
[ -n "$cost_seg" ] && parts+=("$cost_seg")

printf '%s\n' "$(IFS='  '; echo "${parts[*]}")"
