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
