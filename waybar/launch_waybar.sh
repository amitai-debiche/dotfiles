#!/bin/sh
#
# -------------------------------------------
#               START WAYBAR
# ------------------------------------------
# Amitai Debiche (2023)
# Super simple script, but useful

killall waybar
waybar -c ~/dotfiles/waybar/config.jsonc -s ~/dotfiles/waybar/style.css &
