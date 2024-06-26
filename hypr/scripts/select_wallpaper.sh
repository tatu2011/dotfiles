#!/bin/bash

# Запуск waypaper для выбора обоев
waypaper &

# Ожидание завершения выбора обоев в waypaper
wait $!

# Получение выбранного обоев (путь к файлу)
SELECTED_WALLPAPER=$(cat /home/tatu/.cache/swww/HDMI-A-1)

# Проверка, был ли выбран файл
if [ -n "$SELECTED_WALLPAPER" ]; then
    echo "Setting wallpaper with swww: $SELECTED_WALLPAPER"
    
    # Установка обоев с помощью swww
    swww img "$SELECTED_WALLPAPER"
    if [ $? -ne 0 ]; then
        echo "Failed to set wallpaper with swww."
        exit 1
    fi

    # Запуск pywal для генерации цветовой схемы
    echo "Generating color scheme with wal: $SELECTED_WALLPAPER"
    wal -i "$SELECTED_WALLPAPER"
    if [ $? -ne 0 ]; then
        echo "Failed to generate color scheme with wal."
        exit 1
    fi

    # Создание темы для Telegram
    echo "Creating Telegram theme with wal-telegram: $SELECTED_WALLPAPER"
    wal-telegram -g "$SELECTED_WALLPAPER"
    if [ $? -ne 0 ]; then
        echo "Failed to create Telegram theme with wal-telegram."
        exit 1
    fi
    
    echo "All operations completed successfully."
else
    echo "No wallpaper selected or failed to get wallpaper path from waypaper."
fi

