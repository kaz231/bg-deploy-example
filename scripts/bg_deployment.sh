#! /usr/bin/env bash
NEXT_COLOR=`./get_next_color.sh tracker ci`

echo "Next color $NEXT_COLOR"

echo "Kill previous release..."
docker-compose -f ../docker-compose.yml kill tracker_$NEXT_COLOR

echo "Setup new release of tracker..."
docker-compose -f ../docker-compose.yml up -d tracker_$NEXT_COLOR

echo "Perform migrations..."
./update_db.sh $NEXT_COLOR

echo "Perform health check..."
RESPONSE_CODE=`./health_check.sh $NEXT_COLOR`

if [ "$RESPONSE_CODE" == "200" ]; then
  echo "Refresh upstreams for tracker..."
  consul-template -consul ci:8500 -template "../config/tracker-upstreams-$NEXT_COLOR.ctmpl:../config/tracker-upstreams.conf" -once

  echo "Reload nginx..."
  docker-compose -f ../docker-compose.yml kill -s HUP lb

  echo "Mark current release with color $NEXT_COLOR..."
  OUT=`curl -X PUT -d $NEXT_COLOR ci:8500/v1/kv/tracker/color`

  echo "Ready!"
else
  echo "health check response code: $RESPONSE_CODE. Deployment procces will be interrupted."
fi
