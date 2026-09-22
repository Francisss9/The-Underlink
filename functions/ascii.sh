#!/bin/bash

# Tiny 5-row bitmap font, built letter by letter instead of hand-drawn
# multi-line ASCII art. This avoids the copy/paste artifacts (stray
# characters, misaligned letters) that a hardcoded block of ASCII art
# is prone to, and lets us render any word we need ("The", "Underlink",
# future level names...) from the same glyphs.
declare -A GLYPH=(
  [T]="#####|  #  |  #  |  #  |  #  "
  [H]="#   #|#   #|#####|#   #|#   #"
  [E]="#####|#    |#### |#    |#####"
  [U]="#   #|#   #|#   #|#   #|#####"
  [N]="#   #|##  #|# # #|#  ##|#   #"
  [D]="#### |#   #|#   #|#   #|#### "
  [R]="#### |#   #|#### |#  # |#   #"
  [L]="#    |#    |#    |#    |#####"
  [I]="###| # | # | # |###"
  [K]="#   #|#  # |###  |#  # |#   #"
  [" "]="   |   |   |   |   "
)

# Builds 5 rows of ascii-art text for a word into the array named by $2.
# Usage: render_word_rows "Underlink" my_array
render_word_rows() {
  local word="${1^^}"
  local -n out_rows="$2"
  out_rows=("" "" "" "" "")

  local i ch glyph
  local -a g
  for (( i=0; i<${#word}; i++ )); do
    ch="${word:$i:1}"
    glyph="${GLYPH[$ch]:-${GLYPH[" "]}}"
    IFS='|' read -r -a g <<< "$glyph"
    for r in 0 1 2 3 4; do
      out_rows[$r]+="${g[$r]} "
    done
  done
}

term_width() {
  tput cols 2>/dev/null || echo 80
}

# Prints a single line centered on the terminal width.
center_line() {
  local line="$1"
  local width pad
  width=$(term_width)
  pad=$(( (width - ${#line}) / 2 ))
  (( pad < 0 )) && pad=0
  printf '%*s%s\n' "$pad" "" "$line"
}

# Prints a word's ascii-art rows, centered, with a brief glitch flicker
# before each row settles into its clean form. Always clears the line
# (\033[K) before redrawing so no stray characters from a previous,
# longer draw are left behind.
glitch_print_word() {
  local -a rows
  render_word_rows "$1" rows

  local glitch_chars='#@%&$?/\|*'
  local width line pad len i ch glitched pass

  for line in "${rows[@]}"; do
    width=$(term_width)
    pad=$(( (width - ${#line}) / 2 ))
    (( pad < 0 )) && pad=0
    len=${#line}

    for pass in 1 2; do
      glitched=""
      for (( i=0; i<len; i++ )); do
        ch="${line:$i:1}"
        if [[ "$ch" != " " ]] && (( RANDOM % 5 == 0 )); then
          glitched+="${glitch_chars:$((RANDOM % ${#glitch_chars})):1}"
        else
          glitched+="$ch"
        fi
      done
      printf '\r\033[K%*s%s' "$pad" "" "$glitched"
      sleep 0.03
    done

    printf '\r\033[K%*s%s\n' "$pad" "" "$line"
  done
}

# Prints the repo's "bridge" divider style (two "====" bars with a gap
# line between), centered on the terminal.
bridge_line() {
  local len=40
  local bar
  bar=$(printf '%0.s=' $(seq 1 $len))
  center_line "$bar"
}

print_bridge() {
  bridge_line
  echo
  bridge_line
}

# Full logo: bridge divider, "The" on top, "Underlink" below, another
# bridge divider — mirroring the README's title layout — all centered,
# with a glitch-in on each word.
print_ascii_logo() {
  echo
  print_bridge
  echo
  glitch_print_word "The"
  echo
  glitch_print_word "Underlink"
  echo
  print_bridge
  echo
}
