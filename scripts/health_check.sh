#! /usr/bin/env bash

COLOR=$1

SERVICE_DATA=`curl ci:8500/v1/catalog/service/tracker_$COLOR-80`
SERVICE_ADDRESS=$(echo "$SERVICE_DATA" | jq -r '.[0].ServiceAddress')
SERVICE_PORT=$(echo "$SERVICE_DATA"| jq -r '.[0].ServicePort')

RESPONSE=`curl -I $SERVICE_ADDRESS:$SERVICE_PORT/health/check`
RESPONSE_CODE=$(echo "$RESPONSE" | head -n 1 | cut -d$' ' -f2)

echo $RESPONSE_CODE
