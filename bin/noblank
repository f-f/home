#!/usr/bin/env bash

sleep_period=60s 

while true; do
    until top -bn 2 -d 0.01 | sed -nrs '8p' | awk '{if($9>5){exit 1}else{exit 0}}'; do
      xdotool mousemove 0 100
      xdotool mousemove 0 50
      sleep ${sleep_period}
    done
   sleep ${sleep_period}
done
