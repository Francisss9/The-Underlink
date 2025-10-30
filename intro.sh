#!/bin/bash

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

echo "You weren't cautious and now you are stuck."
echo

sleep 2.5

echo "You are now linked. There is no exit!"
echo

sleep 2.5

echo "Watch out for the dangers while crossing the Link."
echo

sleep 2.5

echo "Good Luck!"
echo

sleep 2.5

echo "Start game? (Y/n)"
stty echo

read -r -n1 answer
stty -echo
echo

if [[ $answer == "y" || $answer == "Y" ]]; then

  echo
  echo "Making connection to link..."
  echo
  sleep 2.5

else

  echo
  echo "I said you can't escape! Making connection to link..."
  echo
  sleep 2.5

fi

i=0

while [[ $i -le 100 ]]; do

  echo -ne "\rConnecting: $i%"
  sleep 0.05
  sleep 0.03
  ((i++))
done

echo
echo -e "\nLinked successfully!!"
sleep 1
echo
stty echo
