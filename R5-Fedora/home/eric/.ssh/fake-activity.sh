#!/bin/bash

export XDG_RUNTIME_DIR=/run/user/$(id -u eric)
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

while true; do
    dbus-send --session --dest=org.freedesktop.ScreenSaver --type=method_call \
      /ScreenSaver org.freedesktop.ScreenSaver.SimulateUserActivity
    sleep 300
done

