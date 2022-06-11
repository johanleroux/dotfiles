#!/bin/bash
echo $(($(cat /home/johan/.config/dunst/discord_notifs.txt) + 1)) > /home/johan/.config/dunst/discord_notifs.txt

