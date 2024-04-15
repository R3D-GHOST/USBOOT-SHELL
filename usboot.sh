#!/bin/bash

function menu() {
    clear
    echo "USB BOOT ES UN SCRIPT PARA BOOTEAR SYSTEMA BASADO EN LINUX"
    echo ""
    echo "[1] BOOT USB"
    echo "[2] EXIT SCRIPT"
    echo ""
    read -p "-> " opt

    if [ "$opt" = "1" ]; then
        disk
    elif [ "$opt" = "2" ]; then
        clear
        exit 0
    else
        echo "Opción inválida"
        sleep 2
        menu
    fi
}

function disk() {
    clear
    echo "Seleccione el disco para boot:"
    sudo fdisk -l
    echo ""
    read -p "Introduzca el identificador del disco (ej. sda): /dev/sd" fdisk

    clear
    echo "Quieres Formatear el usb"
    echo "[1] Formatear usb fat32"
    echo "[2] No Formatear usb"
    echo ""
    read -p "Elija una opción: " fat32

    if [ "$fat32" = "1" ]; then
        if sudo mkfs.vfat -F 32 /dev/sd$fdisk -I; then
            echo "Formateo exitoso."
        else
            echo "Error al formatear."
            return
        fi
    elif [ "$fat32" = "2" ]; then
        echo "Continuando sin formatear..."
    else
        echo "Opción inválida"
        return
    fi

    boot /dev/sd$fdisk
}

function boot() {
    device_path=$1
    echo "Ejemplo: /home/user/linux.iso"
    echo "Coloca la ruta del archivo iso para boot:"
    read -p "Ruta del ISO: " ruta
    clear

    if dd if="$ruta" of="$device_path" bs=4M; then
        echo "USB booteable creado exitosamente."
    else
        echo "Error al crear el USB booteable."
    fi
}

menu
