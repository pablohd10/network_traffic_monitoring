#!/bin/bash
# Script para monitorear el tráfico de red
# Autor: Pablo Hidalgo Delgado
# Fecha: 16/10/2024

ELAPSED_TRAFFIC_FILE="$HOME/PABLO/proyectos_personales/monitoreo_trafico_red/elapsed_traffic.txt"

TOTAL_TRAFFIC_FILE="$HOME/PABLO/proyectos_personales/monitoreo_trafico_red/total_traffic.txt"

INITIAL_TRAFFIC_FILE="$HOME/PABLO/proyectos_personales/monitoreo_trafico_red/initial_traffic.txt"

get_initial_traffic() {
    # Obtenemos el tráfico inicial
    netstat -ib | grep en0 -m 1 | awk '{print $7}' > "$INITIAL_TRAFFIC_FILE"
}

get_current_traffic() {
    # Obtenemos el tráfico actual
    netstat -ib | grep -e en0 -m 1 | awk '{print $7}' > "$TOTAL_TRAFFIC_FILE"
}

calculate_total_traffic() {
    local total_traffic=0
    local elapsed_traffic=0
    local initial_traffic=0

    # Si no existe el archivo con el tráfico inicial, lo obtenemos
    if [ ! -f "$INITIAL_TRAFFIC_FILE" ]; then
        get_initial_traffic
        return
    fi

    # Obtenemos el tráfico actual
    get_current_traffic
    total_traffic=$(cat "$TOTAL_TRAFFIC_FILE")
    initial_traffic=$(cat "$INITIAL_TRAFFIC_FILE")
    # Calculamos el tráfico transcurrido desde que se obtuvo el tráfico inicial
    elapsed_traffic=$((total_traffic - initial_traffic))
    echo "Bytes transmitidos: $elapsed_traffic" > "$ELAPSED_TRAFFIC_FILE" # Guardamos el tráfico transcurrido
}

calculate_total_traffic