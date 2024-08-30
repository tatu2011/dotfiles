#!/bin/bash

# Убедитесь, что скрипт выполняется от имени суперпользователя
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите этот скрипт с правами суперпользователя (sudo)."
  exit
fi

# Установка необходимых пакетов через pacman
echo "Устанавливаем необходимые пакеты..."
pacman -S --needed --noconfirm swww hyprland waybar waypaper paru

# Установка пакетов из AUR через paru
echo "Устанавливаем пакеты из AUR..."
paru -S --needed --noconfirm rofi-wayland wal-telegram pywal-git \
  ttf-material-design-icons-gi telegram-desktop-bin ttf-jetbrains-mono-nerd \
  nerd-fonts-iosevka



# Перемещение конфигурационных файлов
echo "Перемещаем конфигурационные файлы..."
cp -r ~/dotfiles/.config/hypr ~/.config/
cp -r ~/dotfiles/.config/fastfetch ~/.config/
cp -r ~/dotfiles/.config/rofi ~/.config/
cp -r ~/dotfiles/.config/waybar ~/.config/

# Завершение
echo "Установка завершена! Перезапустите систему или выйдите и зайдите в сессию Wayland для применения изменений."
