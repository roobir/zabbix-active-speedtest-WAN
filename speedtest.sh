#!/usr/bin/env bash

set -e

DATA_FILE=/tmp/speedtest.json

usage() {
  echo "Usage: \"$(basename "$0")\" OPTION"
  echo
  echo "-u: Display last measured upload speed"
  echo "-d: Display last measured download speed"
  echo "-j: Display last measured jitter"
  echo "-p: Display last measured ping latency"
  echo "-s: Display last server used for measurements"
  echo "-m X: Fail/don't display data if it is older than X seconds"
  echo
  echo "-r|--run: Run speedtest"
}

bytes_to_mbit() {
  echo "scale=2; $1 / 1000000" | bc -l
}

ms_to_s() {
  echo "scale=6; $1 / 1000" | bc -l
}

get_last_ping_time() {
### roob changed the below .latency removed
  jq -r '.ping' "$DATA_FILE"
### roob going to destry this line
###   ms_to_s "$(jq -r '.ping' "$DATA_FILE")"
}

get_last_jitter_time() {
  jq -r '.ping.jitter' "$DATA_FILE"
}

show_last_download_speed() {
####  roob fubar the below
####  bytes_to_mbit "$(jq -r '.download.bandwidth' "$DATA_FILE")"
   bytes_to_mbit "$(jq -r '.download' "$DATA_FILE")"
}

show_last_upload_speed() {
### roob did the same fubar here :(
  bytes_to_mbit "$(jq -r '.upload' "$DATA_FILE")"
}

show_server_info() {
  data="$(jq -r '.server' "$DATA_FILE")"
  id="$(echo "$data" | jq -r '.id')"
  name="$(echo "$data" | jq -r '.name')"
  location="$(echo "$data" | jq -r '.location')"
  country="$(echo "$data" | jq -r '.country')"
  echo "$id: $name @$location ($country)"
}

data_is_outdated() {
  local data_ts
  local now

  data_ts=$(get_data_timestamp)
  now=$(date '+%s')

  [[ "$(( now - data_ts ))" -gt "$MAX_AGE" ]]
}

case "$1" in
  -f|--data-file)
    DATA_FILE="$2"
    shift 2
    ;;
esac

# Default values
ACTION=run
MAX_AGE=3600

while test "$#" -gt 0
do
  case "$1" in
    -h|--help|help)
      usage
      exit 0
      ;;
    -m|--max-age)
      MAX_AGE="$2"
      shift 2
      ;;
    -d|--download)
      ACTION=show_dl
      shift
      ;;
    -u|--upload)
      ACTION=show_ul
      shift
      ;;
    -j|--jitter)
      ACTION=show_jitter
      shift
      ;;
    -p|--ping)
      ACTION=show_ping
      shift
      ;;
    -s|--server)
      ACTION=show_server
      shift
      ;;
    -r|--run)
      ACTION=run
      shift
      ;;
    --)
      # end argument parsing
      shift
      break
      ;;
    --*=|-*) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      usage
      exit 1
      ;;
    *)
      # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"


case "$ACTION" in
  show_dl)
    show_last_download_speed
    ;;
  show_ul)
    show_last_upload_speed
    ;;
  show_jitter)
    get_last_jitter_time
    ;;
  show_ping)
    get_last_ping_time
    ;;
  show_server)
    show_server_info
    ;;
  show_timestamp)
    get_data_timestamp
    ;;
  run)
    if speedtest --secure --json > "${DATA_FILE}.new"
    then
      mv "${DATA_FILE}.new" "$DATA_FILE"
    fi
    ;;
  *)
    usage
    exit 2
esac
