type_text() {
 local text="$1"
 for ((i=0; i<${#text}; i++)); do
  echo -n "${text:$i:1}"
  sleep 0.05
 done
 echo
}
