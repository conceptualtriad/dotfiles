#!/bin/bash

LCDVALUE=$(brightnessctl -d intel_backlight g)
type=$1

if [[ "$type" = "up" ]]; then
  NEWVALUE='14%+'
fi

if [[ "$type" = "down" ]]; then
  NEWVALUE='14%-'
fi

brightnessctl -d intel_backlight s $NEWVALUE
LCDVALUE=$(brightnessctl -d intel_backlight g)
echo "Brightness Level: $LCDVALUE (out of 4882)"
