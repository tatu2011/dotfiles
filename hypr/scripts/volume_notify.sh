#!/bin/bash

ICON_PATH="/home/tatu/Загрузки/icons"  # Укажите путь к вашим иконкам
NOTIFY_ID=2593

change_volume() {
    pamixer "$1" "$2"
    close_notification
    send_notification
}

close_notification() {
    dunstctl close "$NOTIFY_ID"
}

send_notification() {
    volume=$(pamixer --get-volume)
    if [ "$(pamixer --get-mute)" = "true" ]; then
        dunstify -r "$NOTIFY_ID" -u low -i "$ICON_PATH/audio-volume-muted-symbolic.svg" "Volume muted"
    else
        if [ "$volume" -eq 0 ]; then
            icon="audio-volume-muted-symbolic.svg"
        elif [ "$volume" -lt 30 ]; then
            icon="audio-volume-low-symbolic.svg"
        else
            icon="audio-volume-high-symbolic.svg"
        fi
        dunstify -r "$NOTIFY_ID" -u low -i "$ICON_PATH/$icon" "Volume: ${volume}%"
    fi
}

case $1 in
    up)
        change_volume -i "$2"
        ;;
    down)
        change_volume -d "$2"
        ;;
    mute)
        pamixer -t
        close_notification
        send_notification
        ;;
esac
