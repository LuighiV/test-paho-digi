#/bin/bash -x

mkdir -p broker/data
mkdir -p broker/log

BROKER_DIR=$PWD/broker

docker run -d -p 1883:1883 -p 9001:9001 \
  --mount type=bind,source=$BROKER_DIR/mosquitto.conf,target=/mosquitto/config/mosquitto.conf \
  --mount type=bind,source=$BROKER_DIR/data,target=/mosquitto/data \
  --mount type=bind,source=$BROKER_DIR/log,target=/mosquitto/log \
   eclipse-mosquitto


