#!/bin/bash

source functions/text.sh

trap 'echo -e "\n[Underlink terminated]"; stty echo; exit 0' SIGINT

stty -echo

echo
echo
echo "====================================="
echo
echo "      Welcome to the Underlink"
echo
echo "====================================="
echo
echo

sleep 2.5

type_text "You weren't cautious and now you are stuck."
echo

sleep 0.5

type_text "You are now linked. There is no exit!"
echo

sleep 0.5

type_text "Watch out for the dangers while crossing the Link."
echo

sleep 0.5

type_text "Good Luck!"
echo

sleep 0.5

type_text "Start game? (Y/n)"
stty echo

read -r -n1 answer
stty -echo
echo

if [[ $answer == "y" || $answer == "Y" ]]; then

  echo
  type_text "Making connection to link..."
  echo
  sleep 0.5

else

  echo
  type_text "I said you can't escape! Making connection to link..."
  echo
  sleep 0.5

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
sleep 1
echo

read -t 0.01 -n 10000 discard
stty echo
