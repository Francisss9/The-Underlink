#!/bin/bash

random_sleep() {
    sleep $(awk -v min=0.25 -v max=0.7 'BEGIN{srand(); print min+rand()*(max-min)}')
}

type_text() {
 local text="$1"
 for ((i=0; i<${#text}; i++)); do
  echo -n "${text:$i:1}"
 sleep 0.03 
 done
 echo
}

# Renders a filling progress bar, e.g. [########----------] 40%
# Args: $1 = label to show before the bar (optional)
progress_bar() {
  local label="${1:-Connecting}"
  local width=30
  local i=0

  while [[ $i -le 100 ]]; do
    local filled=$(( i * width / 100 ))
    local empty=$(( width - filled ))
    local bar=""
    local gap=""
    (( filled > 0 )) && bar=$(printf '%0.s#' $(seq 1 $filled))
    (( empty > 0 )) && gap=$(printf '%0.s-' $(seq 1 $empty))

    echo -ne "\r$label: [${bar}${gap}] ${i}%"
    sleep 0.025
    ((i++))
  done
  echo
}
