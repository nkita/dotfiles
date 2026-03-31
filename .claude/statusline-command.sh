#!/bin/bash
input=$(cat)

user=$(whoami)
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd')
model_name=$(printf '%s' "$input" | jq -r '.model.display_name // ""')
version=$(printf '%s' "$input" | jq -r '.version // ""')
used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
session_id=$(printf '%s' "$input" | jq -r '.session_id // ""')
duration_ms=$(printf '%s' "$input" | jq -r '.cost.total_duration_ms // 0')
input_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0')
worktree_name=$(printf '%s' "$input" | jq -r '.worktree.name // ""')

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

in_fmt=$(fmt_tokens "$input_tokens")
out_fmt=$(fmt_tokens "$output_tokens")
short_session=$(printf '%s' "$session_id" | cut -c1-8)

# Line 1: {whoami} {current_dir} {branch} - {worktree.name}
printf "\033[38;2;69;241;194m%s\033[0m \033[38;2;12;160;216m%s\033[0m" "$user" "$short_cwd"
if [ -n "$branch" ]; then
  printf " \033[38;2;20;165;174m%s\033[0m" "$branch"
fi
if [ -n "$worktree_name" ]; then
  printf " \033[38;2;140;140;140m-\033[0m \033[38;2;200;160;255m%s\033[0m" "$worktree_name"
fi
printf "\n"

# Line 2: {model} status bar **%
printf "\033[38;2;180;180;180m%s\033[0m " "$model_name"
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  filled=$((used_int / 5))
  empty=$((20 - filled))

  if [ "$used_int" -lt 50 ]; then
    bc="38;2;80;200;120"
  elif [ "$used_int" -lt 80 ]; then
    bc="38;2;255;200;60"
  else
    bc="38;2;255;80;80"
  fi

  bar=""
  i=0; while [ $i -lt $filled ]; do bar="${bar}█"; i=$((i + 1)); done
  i=0; while [ $i -lt $empty ]; do bar="${bar}░"; i=$((i + 1)); done

  printf "\033[%sm%s %s%%\033[0m" "$bc" "$bar" "$used_int"
else
  printf "\033[38;2;140;140;140m░░░░░░░░░░░░░░░░░░░░ --%%\033[0m"
fi
printf "\n"

# Line 3: {session_id} time:{dur} in:xx out:xx
printf "\033[38;2;100;100;100m%s\033[0m" "$short_session"
printf " \033[38;2;255;200;60mtime:%s\033[0m" "$dur_str"
printf " \033[38;2;80;200;120min:%s\033[0m" "$in_fmt"
printf " \033[38;2;100;180;255mout:%s\033[0m" "$out_fmt"
printf "\n"

# Line 4: ver:{version}
printf "\033[38;2;140;140;140mver:%s\033[0m\n" "$version"
