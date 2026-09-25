#!/bin/bash

# Reusable first-person raycasting engine (Doom/Wolfenstein style),
# pure bash + awk, no graphics — any level can define its own RC_MAP
# and drop into rc_game_loop.

RC_AWK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/raycast.awk"

# --- Default demo map. '#' = wall, '.' = floor. Levels can override
# RC_MAP before calling rc_reset_player / rc_game_loop. ---
RC_MAP=(
  "################"
  "#..............#"
  "#..###....###..#"
  "#..#........#..#"
  "#..#..####..#..#"
  "#..#..#..#..#..#"
  "#..#..####..#..#"
  "#..#........#..#"
  "#..###....###..#"
  "#..............#"
  "################"
)

RC_W=60       # render width  (chars)
RC_H=20       # render height (chars)
RC_FOV=1.0    # field of view (radians)
RC_DEPTH=16   # max ray distance (map cells)

RC_MOVE_STEP=0.35
RC_TURN_STEP=0.30

rc_px=2.5
rc_py=1.5
rc_pa=0.0

rc_map_h() { echo "${#RC_MAP[@]}"; }
rc_map_w() { echo "${#RC_MAP[0]}"; }

# Returns the map character at integer cell (x, y); '#' (wall) if
# out of bounds, so the player can never walk off the map.
rc_map_char() {
  local x=$1 y=$2
  local h w
  h=$(rc_map_h); w=$(rc_map_w)
  if (( x < 0 || y < 0 || y >= h || x >= w )); then
    printf '#'
    return
  fi
  local row="${RC_MAP[$y]}"
  printf '%s' "${row:$x:1}"
}

# Places the player at a given (x, y, angle-in-degrees).
rc_reset_player() {
  rc_px="$1"
  rc_py="$2"
  rc_pa=$(awk -v d="${3:-0}" 'BEGIN{printf "%.4f", d * 3.14159265 / 180}')
}

# Renders one frame of the current player view to stdout.
rc_render() {
  printf '%s\n' "${RC_MAP[@]}" |
    awk -v PX="$rc_px" -v PY="$rc_py" -v PA="$rc_pa" \
        -v FOV="$RC_FOV" -v SW="$RC_W" -v SH="$RC_H" -v DEPTH="$RC_DEPTH" \
        -f "$RC_AWK"
}

# Attempts to move the player by (dx, dy) in map units; blocked by walls.
rc_try_move() {
  local dx=$1 dy=$2
  local nx ny ix iy ch
  read -r nx ny < <(awk -v px="$rc_px" -v py="$rc_py" -v dx="$dx" -v dy="$dy" \
    'BEGIN{printf "%.4f %.4f", px+dx, py+dy}')
  ix="${nx%.*}"
  iy="${ny%.*}"
  ch=$(rc_map_char "$ix" "$iy")
  if [[ "$ch" != "#" ]]; then
    rc_px="$nx"
    rc_py="$ny"
  fi
}

rc_move_forward() {
  local step=$1
  local dx dy
  read -r dx dy < <(awk -v a="$rc_pa" -v s="$step" 'BEGIN{printf "%.4f %.4f", cos(a)*s, sin(a)*s}')
  rc_try_move "$dx" "$dy"
}

rc_turn() {
  local delta=$1
  rc_pa=$(awk -v a="$rc_pa" -v d="$delta" 'BEGIN{printf "%.4f", a+d}')
}

# Main input/render loop. Runs until the player quits ('x') or hits
# an exit tile ('E' on the map, if RC_ON_EXIT is set to a function name).
rc_game_loop() {
  local key
  while true; do
    clear
    rc_render
    echo
    echo "[w] frente  [s] tras  [a] virar esq  [d] virar dir  [x] desconectar"

    if ! read -rsn1 key; then
      break
    fi

    case "$key" in
      w) rc_move_forward "$RC_MOVE_STEP" ;;
      s) rc_move_forward "-$RC_MOVE_STEP" ;;
      a) rc_turn "-$RC_TURN_STEP" ;;
      d) rc_turn "$RC_TURN_STEP" ;;
      x) break ;;
    esac

    if [[ -n "$RC_ON_EXIT" ]]; then
      local ix="${rc_px%.*}" iy="${rc_py%.*}"
      if [[ "$(rc_map_char "$ix" "$iy")" == "E" ]]; then
        "$RC_ON_EXIT"
        break
      fi
    fi
  done
}
