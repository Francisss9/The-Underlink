#!/bin/bash

source ./functions/text.sh

link_init() {


  trap 'echo -e "\n[Underlink terminated]"; stty echo; exit 0' SIGINT

  stty -echo

  echo
  echo
  echo "====================================="
  echo
  echo "      Welcome to The Under-link"
  echo
  echo "====================================="
  echo
  echo

  sleep 1

  type_text "You weren't cautious and now you are stuck."
  echo
  sleep 2.5
 

  type_text "You are now linked. There is no exit!"
  echo
  random_sleep
 

  type_text "Watch out for the dangers while crossing the Link."
  echo
  random_sleep
 

  type_text "Good Luck!"
  echo
  random_sleep


  type_text "Start game? (Y/n)"
  stty echo

  read -r -n1 answer
  stty -echo
  echo

  if [[ $answer == "y" || $answer == "Y" ]]; then

    echo
    type_text "Making connection to link..."
    echo
    random_sleep

  else

    echo
    type_text "I said you can't escape! Making connection to link..."
    echo
    random_sleep

  fi

  i=0

  while [[ $i -le 100 ]]; do

    echo -ne "\rConnecting: $i%"
    sleep 0.03
      ((i++))
  done
  echo

  echo
  type_text "Linked successfully!!"
  random_sleep

  echo

  read -t 0.01 -n 10000 discard
  stty echo
}

#  link_init
