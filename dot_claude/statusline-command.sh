#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
session_name=$(echo "$input" | jq -r '.session_name // empty')

# dogenpunk-style: blue hostname, white OM symbol, cyan cwd
host_part="\033[34m$(hostname -s)\033[0m"
om_part="\033[1;37m \xe0\xa5\x90  \033[0m"
cwd_part="\033[36m${cwd}:\033[0m"

# Git branch info (skip optional locks)
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c core.hooksPath=/dev/null rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_info="\033[1;32mgit\033[0m@\033[40m\033[30m${branch}\033[0m"
  fi
fi

# Model info
model_part=""
if [ -n "$model" ]; then
  model_part=" \033[35m[${model}]\033[0m"
fi

# Session name
session_part=""
if [ -n "$session_name" ]; then
  session_part=" \033[1;36m(${session_name})\033[0m"
fi

printf "${host_part}${om_part}${cwd_part}${git_info}${model_part}${session_part}"
