function forget() { history -c && history -w; }

# mkdir and cd
function mkcd() { mkdir -p "$@" && cd "$_"; }

# use fd to search only in mounted Volumes
function fdm() {
  fd -E "/Volumes/Macintosh HD" "$1" /Volumes --exec-batch exa -al --color=always --group-directories-first --icons --no-permissions --no-user --time-style=long-iso
}

function perf() {
  curl -o /dev/null -s -w "time_total: %{time_total} sec\nsize_download: %{size_download} bytes\n" "$1"
}

# check who is listening to a certain port
function listening() {
  if [ $# -eq 0 ]; then
    lsof -iTCP -sTCP:LISTEN -n -P
  elif [ $# -eq 1 ]; then
    lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color=auto "$1"
  else
    echo "Usage: listening [pattern]"
  fi
}

# download website for offline use
function download-page() {
  wget -E -H -k -K -p -e robots=off $1
}

function erase() {
  local shell_name=$0
  if [ $shell_name == 'bash' ]; then
    history -c && history -w
  else
    echo -n >~/.zsh_history
  fi
}

function backtick-remap() {
  if [ "$1" = "on" ] || [ "$1" = "true" ] || [ "$1" = "1" ] || [ "$1" = "yes" ]; then
    hidutil property --matching '{"ProductID":0x0340}' --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'
  else
    hidutil property --set '{"UserKeyMapping":[]}'
  fi
}

function fail() {
  echo $1 >&2
  exit 1
}

function retry() {
  local n=1
  local max=20
  local delay=4
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Command failed. Attempt $n/$max:"
        sleep $delay
      else
        fail "The command has failed after $n attempts."
      fi
    }
  done
}

## Docker
function do.bash() {
  docker exec -it $(docker ps -aqf "name=$1") bash
}

# -- MISC FUNCTIONS ------------------------------------------------------------

# Generate a random string ('A-Za-z0-9') with the given length
#
# Usage:
#   $ ./random 32
#
function random() {
  chars='A-Za-z0-9'
  length=${1:-32}

  cat /dev/urandom | env LC_ALL=C tr -dc $chars | fold -w $length | head -n 1
}

# Convert a decimal number to a byte unit
#
# Usage:
#   echo 1234567890 | byte-me
#
function byte-me() {
  numfmt --to=iec --padding="1" "$1"
}

# Get gzipped file size
function gz() {
  local ORIGSIZE=$(wc -c <"$1")
  local GZIPSIZE=$(gzip -c "$1" | wc -c)

  local RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
  local SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)

  echo -e "Original: $(byte-me $ORIGSIZE)   ($ORIGSIZE bytes)"
  echo -e "Gzipped: $(byte-me $GZIPSIZE)   ($GZIPSIZE bytes)"
  printf "Save: %2.0f%% (%2.0f%%)\n" "$SAVED" "$RATIO"
}

# prompt to source .bashrc files from mounted drives
# but always require user input
function stick() {
  for file_path in /Volumes/*; do
    local file_name=$(basename "$file_path")

    # ignore actual HDD
    if [[ "$file_name" == "Macintosh HD" ]]; then continue; fi

    local bashrc_path="/Volumes/${file_name}/.bashrc"

    if [ ! -f "${bashrc_path}" ]; then continue; fi

    echo -n "Found '${bashrc_path}'. Do you want to load it? "
    read load_file_choice

    if is_truthy "$load_file_choice"; then
      source "$bashrc_path"
    fi
  done

  return 0
}

function snakecase() {
  local array=("$@")
  local input="'${array[@]}'"

  echo "$input" | sed -e 's/[^0-9a-zA-Z .-]*//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/  */_/g'
}

function kebapcase() {
  local array=("$@")
  local input="'${array[@]}'"

  echo "$input" | sed -e 's/[^0-9a-zA-Z .-]*//g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/  */-/g'
}

function jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<<"$1"
}

function desmont() {
  echo "Unmounting ${1}..."
  echo "  ... But actually not implemented yet :P"
}

function _desmont_completions() {
  local volumes
  volumes=$(/bin/ls /Volumes)
  COMPREPLY=($(compgen -W "$volumes" "${COMP_WORDS[1]}"))
}

complete -F _desmont_completions desmont
