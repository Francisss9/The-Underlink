#!/bin/bash

# Level 1: The Subnet Abyss
# A raycasted "node" of the network, rendered in pure ASCII. Playable
# with the shared engine in functions/raycast.sh.

phase1_intro() {
  clear
  type_text "Handshake accepted. Routing you into an unindexed subnet..."
  random_sleep
  type_text "The walls of the node resolve around you."
  random_sleep
  echo
}

phase1_run() {
  phase1_intro

  # Small enclosed node, open corridor around the outside, a locked
  # inner chamber. Placeholder layout — will grow with the story.
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

  rc_reset_player 2.5 1.5 0
  unset RC_ON_EXIT

  rc_game_loop

  clear
  type_text "Connection to this node closed."
}
