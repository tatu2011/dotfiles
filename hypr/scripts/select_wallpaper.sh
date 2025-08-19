#!/bin/bash

# Запуск waypaper для выбора обоев
waypaper &

# Ожидание завершения выбора обоев в waypaper
wait $!

# Получение пути к выбранному обою из второй строки файла кэша
#SELECTED_WALLPAPER=$(sed -n '2p' /home/tatu/.cache/swww/HDMI-A-1)
SELECTED_WALLPAPER=$(awk 'NR==2' /home/tatu/.cache/swww/HDMI-A-1)

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

    # Проверка наличия файла colors-waybar.css
    if [ ! -f /home/tatu/.cache/wal/colors-waybar.css ]; then
        echo "colors-waybar.css not found."
        exit 1
    fi

    # Извлечение цвета @color3 из colors-waybar.css
    COLOR3_HEX=$(grep '@define-color color3' /home/tatu/.cache/wal/colors-waybar.css | awk '{print $3}' | tr -d ';')
    
    if [ -z "$COLOR3_HEX" ]; then
        echo "Failed to extract @color3 from colors-waybar.css."
        exit 1
    fi

    echo "Extracted @color3: $COLOR3_HEX"

    # Удаление символа # из значения цвета
    COLOR3_HEX_NO_HASH=$(echo "$COLOR3_HEX" | tr -d '#')

    # Сохранение цвета в файл для использования в конфигурации Hyprland
    echo "\$border_color_active=$COLOR3_HEX_NO_HASH" > /home/tatu/.config/hypr/color_active_border
    echo "Saved active border color to /home/tatu/.config/hypr/color_active_border"

    # Создание конфигурации для Rofi
    echo "* {
    active-background: $COLOR3_HEX;
}" > /home/tatu/.config/rofi/color.rasi

    echo "Saved Rofi configuration to /home/tatu/.config/rofi/color.rasi"

    # Обновление Pywalfox
    pywalfox update

    echo "All operations completed successfully."
else
    echo "No wallpaper selected or failed to get wallpaper path from waypaper."
fi

