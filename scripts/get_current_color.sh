#! /usr/bin/env bash

SERVICE_NAME=$1
CONSUL_NODE=$2

CURRENT_COLOR=`curl http://$CONSUL_NODE:8500/v1/kv/$SERVICE_NAME/color?raw`

if [ "$CURRENT_COLOR" == "blue" ]; then
    echo "blue"
else
    echo "green"
fi
