#!/usr/bin/bash

MQTT_HOST=localhost
MQTT_TOPIC='/ropty'

if ! command -v mosquitto_pub > /dev/null; then
  echo "Fatal: missing mosquitto_pub"
  exit 1
fi

if ! command -v fortune > /dev/null; then
  echo "Fatal: missing fortune"
  exit 1
fi

if ! command -v figlet > /dev/null; then
  echo "Fatal: missing figlet"
  exit 1
fi

function pub() {
  echo "$1"
  echo "$1" | mosquitto_pub -h "$MQTT_HOST" -t "$MQTT_TOPIC" -l
}

while(true) do
  pub "###################################"
  fortune | while IFS= read -r line; do
    pub "$line"
    sleep 0.5 # Delay of 1 second between each line
  done
  sleep 1
  if [[ $(( (RANDOM % 10) )) -eq 0 ]]; then
    pub "###################################"
    sleep 1
    figlet '#-[ROPTY]-#' | mosquitto_pub -h "$MQTT_HOST" -t $MQTT_TOPIC -l 
    pub "###################################"
    sleep 1
  fi
done
