#!/bin/sh

SCRIPT_DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )

NEW_RELIC_KEY=$(cat $SCRIPT_DIR/new_relic_key)
SCREEN_ID=$(cat /sys/class/net/eth0/address | /usr/bin/md5sum | cut -f1 -d" ")

curl -X POST \
  --header "X-Insert-Key: $NEW_RELIC_KEY" \
  --header "Content-Type: application/json" \
  --data "{\"eventType\":\"FlowBalance\", \"screenId\": \"$SCREEN_ID\"}" \
  https://insights-collector.eu01.nr-data.net/v1/accounts/2584304/events
