#!/bin/bash
# X11 környezet
export DISPLAY=:1
export QT_QPA_PLATFORM=xcb
export QT_X11_NO_MITSHM=1

# Kis várakozás, hogy Xvfb felálljon
sleep 3

# Crdesigner GUI indítása
exec crdesigner gui
