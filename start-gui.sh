#!/bin/bash
# start-gui.sh

# Set environment variables
export DISPLAY=:1
export QT_QPA_PLATFORM=xcb
export QT_X11_NO_MITSHM=1
export QT_AUTO_SCREEN_SCALE_FACTOR="1"

# Wait for the X server (Xvfb) to be ready
echo "Waiting for Xvfb to be ready..."
while ! xdpyinfo -display $DISPLAY > /dev/null 2>&1; do
  sleep 0.5
  echo -n "."
done
echo "Xvfb is ready."

# Launch the application
echo "Starting CommonRoad Scenario Designer..."
exec crdesigner gui
