#! /usr/bin/env bash

OUT=`curl -X DELETE ci:8500/v1/kv/tracker/color`

CURRENT_COLOR=`./get_current_color.sh tracker ci`

echo "Current color $CURRENT_COLOR"

docker-compose -f ../docker-compose.yml up -d db

echo "Setup tracker..."
docker-compose -f ../docker-compose.yml up -d tracker_$CURRENT_COLOR

echo "Setup database..."
./update_db.sh $CURRENT_COLOR

echo "Refresh upstreams for tracker..."
consul-template -consul ci:8500 -template "../config/tracker-upstreams-$CURRENT_COLOR.ctmpl:../config/tracker-upstreams.conf" -once

echo "Setup nginx..."
docker-compose -f ../docker-compose.yml up -d lb

echo "Ready!";
