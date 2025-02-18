#!/bin/bash

DIRECTION=$1
WINDOW_NUMBER=$(hyprctl activeworkspace -j | jq '.id')

if [ $DIRECTION = "up" ] && [ $WINDOW_NUMBER -lt 9 ]; then
  hyprctl dispatch workspace +1
fi

if [ $DIRECTION = "down" ]; then
  hyprctl dispatch workspace -1
fi
