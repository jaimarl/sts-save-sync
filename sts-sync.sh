#!/bin/bash

PC_DIR="$HOME/.local/share/Steam/steamapps/common/SlayTheSpire"
ANDROID_DIR="/storage/emulated/0/Android/data/com.humble.SlayTheSpire"

SUBDIRS=("preferences" "saves" "runs")

if ! command -v adb &> /dev/null; then
    echo "Error: adb command not found"
    exit 1
fi

if [ -z "$(adb devices | grep -w 'device')" ]; then
    echo "Error: Connect your phone to PC, enable USB debugging and allow file transfer"
    exit 1
fi

if [ ! -d "$PC_DIR" ]; then
    echo "Ошибка: Slay The Spire folder not found ($PC_DIR)"
    exit 1
fi

case "$1" in
    to_pc)
        mkdir -p "$PC_DIR/sync_backup"
        rm -rf "$PC_DIR/sync_backup/*"

        for DIR in "${SUBDIRS[@]}"; do
            mv "$PC_DIR/$DIR" "$PC_DIR/sync_backup"
            adb pull "$ANDROID_DIR/files/$DIR" "$PC_DIR"
        done

        echo -e "\nSave files transfered from PC to Android"
        ;;
    to_phone)
        adb shell mkdir -p "$ANDROID_DIR/files"
        adb shell mkdir -p "$ANDROID_DIR/sync_backup"
        adb shell rm -rf "$ANDROID_DIR/sync_backup"

        for DIR in "${SUBDIRS[@]}"; do
            adb shell mv "$ANDROID_DIR/files/$DIR" "$ANDROID_DIR/sync_backup"
            adb push "$PC_DIR/$DIR" "$ANDROID_DIR/files"
        done

        echo -e "\nSave files transfered from Android to PC"
        ;;
    restore)
        case "$2" in
            pc)
                if [ -d "$PC_DIR/sync_backup" ] && [ "$(ls -A "$PC_DIR/sync_backup")" ]; then
                    for DIR in "${SUBDIRS[@]}"; do
                        rm -rf "$PC_DIR/$DIR"
                        mv "$PC_DIR/sync_backup/$DIR" "$PC_DIR"
                    done
                    echo "Backup restored successfully"
                else
                    echo "Backups not found"
                    exit 1
                fi
                ;;
            phone)
                BACKUP_FILES=$(adb shell "ls -A '$ANDROID_DIR/sync_backup' 2>/dev/null | tr -d '\r'")
                
                if [ -n "$BACKUP_FILES" ]; then
                    for DIR in "${SUBDIRS[@]}"; do
                        adb shell rm -rf "$ANDROID_DIR/files/$DIR"
                        adb shell mv "$ANDROID_DIR/sync_backup/$DIR" "$ANDROID_DIR/files"
                    done
                    echo "Backup restored successfully"
                else
                    echo "Backups not found"
                    exit 1
                fi
                ;;
            *)
                echo "Usage: $0 restore {pc|phone}"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Usage: $0 {to_pc|to_phone|restore pc|restore phone}"
        exit 1
        ;;
esac
