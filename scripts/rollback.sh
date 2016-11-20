#! /usr/bin/env bash
PREV_COLOR=`./get_next_color.sh tracker ci`

echo "Rollback to $PREV_COLOR..."

echo "Refresh upstreams for tracker..."
consul-template -consul ci:8500 -template "../config/tracker-upstreams-$PREV_COLOR.ctmpl:../config/tracker-upstreams.conf" -once

echo "Reload nginx..."
docker-compose -f ../docker-compose.yml kill -s HUP lb
