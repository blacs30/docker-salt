#!/bin/bash

# Variables from environement
: "${SALT_USE:=master}"
: "${SALT_NAME:=master}"
: "${LOG_LEVEL:=info}"
: "${OPTIONS:=}"
: "${LOGS:=/var/log/salt/minion}"

# Set minion id and master
echo $SALT_NAME > /etc/salt/minion_id
sed -i "s/^id:\ .*$/id: ${SALT_NAME}/g" /etc/salt/minion
sed -i "s/^master:\ .*$/master: master/g" /etc/salt/minion

# Set salt grains
if [ ! -z "$SALT_GRAINS" ]; then
  echo "INFO: Set grains on $SALT_NAME to: $SALT_GRAINS"
  echo $SALT_GRAINS > /etc/salt/grains
fi

# If salt master also start minion in background
if [ $SALT_USE == "master" ]; then
  LOGS="/var/log/salt/minion /var/log/salt/master"
  echo "INFO: Starting salt-minion and auto connect to salt-master"
  /usr/bin/salt-minion --daemon --log-level=$LOG_LEVEL $OPTIONS
  echo "INFO: Starting salt-api"
  /usr/bin/salt-api --daemon --log-level=$LOG_LEVEL
fi

# Start salt-$SALT_USE
echo "INFO: Starting salt-$SALT_USE with log level $LOG_LEVEL with hostname $SALT_NAME"
/usr/bin/salt-$SALT_USE --daemon --log-level=$LOG_LEVEL $OPTIONS

# Tailing logs to not bind docker process on salt process
# To be able to restart salt with salt without killing container
tail -f $LOGS
