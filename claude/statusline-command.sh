#!/bin/bash
input=$(cat)

user=$(whoami)
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd')
model_name=$(printf '%s' "$input" | jq -r '.model.display_name // ""')
version=$(printf '%s' "$input" | jq -r '.version // ""')
ctx_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // ""')
session_id=$(printf '%s' "$input" | jq -r '.session_id // ""')
duration_ms=$(printf '%s' "$input" | jq -r '.cost.total_duration_ms // 0')
input_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0')
worktree_name=$(printf '%s' "$input" | jq -r '.worktree.name // ""')
rl5h_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // ""')
rl7d_pct=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // ""')
rl5h_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // ""')
rl7d_reset=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at // ""')

short_cwd=$(printf '%s' "$cwd" | sed "s|^$HOME|~|")

# Git branch
branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree --no-optional-locks 2>/dev/null | grep -q true; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Human-readable token count
fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf "%.1fM" "$(awk "BEGIN{printf \"%.1f\", $n/1000000}")"
  elif [ "$n" -ge 1000 ]; then
    printf "%.1fK" "$(awk "BEGIN{printf \"%.1f\", $n/1000}")"
  else
    printf "%s" "$n"
  fi
}

# Duration h/m/s
dur_str="0s"
if [ "$duration_ms" != "0" ] && [ "$duration_ms" != "null" ]; then
  total_sec=$((duration_ms / 1000))
  hrs=$((total_sec / 3600))
  mins=$(( (total_sec % 3600) / 60 ))
  secs=$((total_sec % 60))
  if [ $hrs -gt 0 ]; then
    dur_str="${hrs}h${mins}m${secs}s"
  elif [ $mins -gt 0 ]; then
    dur_str="${mins}m${secs}s"
  else
    dur_str="${secs}s"
  fi
fi

# Remaining time until reset
time_until() {
  local ts="$1"
  if [ -z "$ts" ] || [ "$ts" = "null" ]; then printf "--"; return; fi
  local now reset_sec remaining
  now=$(date +%s)
  # Support both Unix timestamp and ISO 8601
  case "$ts" in
    [0-9]*) reset_sec="$ts" ;;
    *) local ts_clean
       ts_clean=$(printf '%s' "$ts" | sed 's/\.[0-9]*Z$/Z/')
       reset_sec=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$ts_clean" "+%s" 2>/dev/null || date -d "$ts_clean" +%s 2>/dev/null) ;;
  esac
  if [ -z "$reset_sec" ]; then printf "--"; return; fi
  remaining=$((reset_sec - now))
  if [ "$remaining" -le 0 ]; then printf "now"; return; fi
  local h m
  h=$((remaining / 3600))
  m=$(( (remaining % 3600) / 60 ))
  if [ $h -gt 0 ]; then printf "%dh%dm" $h $m; else printf "%dm" $m; fi
}

# Print: label:bar pct% [↺remaining(HH:MM)]  (width=10, reset_ts optional)
pct_bar() {
  local label="$1" pct="$2" reset_ts="$3"
  local width=5
  printf "\033[38;2;140;140;140m%s:\033[0m" "$label"
  if [ -n "$pct" ] && [ "$pct" != "null" ]; then
    local pct_int filled empty bar c
    pct_int=$(printf "%.0f" "$pct")
    filled=$((pct_int * width / 100))
    empty=$((width - filled))
    if [ "$pct_int" -lt 50 ]; then c="38;2;80;200;120"
    elif [ "$pct_int" -lt 80 ]; then c="38;2;255;200;60"
    else c="38;2;255;80;80"; fi
    bar=""
    i=0; while [ $i -lt $filled ]; do bar="${bar}█"; i=$((i+1)); done
    i=0; while [ $i -lt $empty ];  do bar="${bar}░"; i=$((i+1)); done
    printf "\033[%sm%s %s%%\033[0m" "$c" "$bar" "$pct_int"
    if [ -n "$reset_ts" ] && [ "$reset_ts" != "null" ]; then
      local remaining_str clock_str
      remaining_str=$(time_until "$reset_ts")
      case "$reset_ts" in
        [0-9]*) clock_str=$(date -r "$reset_ts" "+%H:%M" 2>/dev/null || date -d "@$reset_ts" "+%H:%M" 2>/dev/null) ;;
        *) local reset_ts_clean
           reset_ts_clean=$(printf '%s' "$reset_ts" | sed 's/\.[0-9]*Z$/Z/')
           clock_str=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$reset_ts_clean" "+%H:%M" 2>/dev/null || date -d "$reset_ts_clean" "+%H:%M" 2>/dev/null) ;;
      esac
      printf " \033[38;2;100;100;100m↺%s(%s)\033[0m" "$remaining_str" "$clock_str"
    fi
  else
    local bar=""
    i=0; while [ $i -lt $width ]; do bar="${bar}░"; i=$((i+1)); done
    printf "\033[38;2;140;140;140m%s --%%\033[0m" "$bar"
  fi
}

in_fmt=$(fmt_tokens "$input_tokens")
out_fmt=$(fmt_tokens "$output_tokens")
short_session=$(printf '%s' "$session_id" | cut -c1-8)

# Line 1: {whoami} {current_dir} {branch} [- worktree]
printf "\033[38;2;69;241;194m%s\033[0m \033[38;2;12;160;216m%s\033[0m" "$user" "$short_cwd"
if [ -n "$branch" ]; then
  printf " \033[38;2;20;165;174m%s\033[0m" "$branch"
fi
if [ -n "$worktree_name" ]; then
  printf " \033[38;2;140;140;140m-\033[0m \033[38;2;200;160;255m%s\033[0m" "$worktree_name"
fi
printf "\n"

# Line 2: ctx:bar%  5h:bar% ↺remaining(HH:MM)  7d:bar% ↺remaining(HH:MM)
pct_bar "ctx" "$ctx_pct"
printf "  "
pct_bar "5h" "$rl5h_pct" "$rl5h_reset"
printf "  "
pct_bar "7d" "$rl7d_pct" "$rl7d_reset"
printf "\n"

# Line 3: ver:x  model  session  time:dur
printf "\033[38;2;140;140;140mver:%s\033[0m" "$version"
printf "  \033[38;2;180;180;180m%s\033[0m" "$model_name"
printf "  \033[38;2;100;100;100m%s\033[0m" "$short_session"
printf "  \033[38;2;255;200;60mtime:%s\033[0m" "$dur_str"
printf "\n"
