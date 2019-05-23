containsElement () {
  local array match="$1"
  shift
  for array; do [[ "$array" == "$match" ]] && return 0; done
  return 1
}
