#!/bin/bash
# Script para monitorear el tráfico de red
# Autor: Pablo Hidalgo Delgado
# Fecha: 16/10/2024

ELAPSED_TRAFFIC_FILE="$HOME/PABLO/proyectos_personales/monitoreo_trafico_red/elapsed_traffic.txt"
TOTAL_TRAFFIC_FILE="$HOME/PABLO/proyectos_personales/monitoreo_trafico_red/total_traffic.txt"
INITIAL_TRAFFIC_FILE="$HOME/PABLO/proyectos_personales/monitoreo_trafico_red/initial_traffic.txt"

get_initial_traffic() {
    # Obtenemos el tráfico inicial
    netstat -ib | grep en0 -m 1| awk '{print $5, $7}' > "$INITIAL_TRAFFIC_FILE"
}

get_current_traffic() {
    # Obtenemos el tráfico actual
    netstat -ib | grep en0 -m 1| awk '{print $5, $7}' > "$TOTAL_TRAFFIC_FILE"
}

calculate_total_traffic() {
    local total_traffic_received=0
    local total_traffic_sent=0
    local initial_traffic_received=0
    local initial_traffic_sent=0
    local elapsed_traffic_received=0
    local elapsed_traffic_sent=0
    local bytes_to_gb=1073741824  # 1 GiB = 2^30 bytes

    # Si no existe el archivo con el tráfico inicial, lo obtenemos
    if [ ! -f "$INITIAL_TRAFFIC_FILE" ]; then
        get_initial_traffic
        return
    fi

    # Obtenemos el tráfico actual
    get_current_traffic

    # Leer valores actuales y iniciales desde los archivos
    read -r initial_traffic_sent initial_traffic_received < "$INITIAL_TRAFFIC_FILE"
    read -r total_traffic_sent total_traffic_received < "$TOTAL_TRAFFIC_FILE"

    # Calculamos el tráfico transcurrido desde que se obtuvo el tráfico inicial
    elapsed_traffic_sent=$((total_traffic_sent - initial_traffic_sent))
    elapsed_traffic_received=$((total_traffic_received - initial_traffic_received))

    # Convertimos bytes a gigabytes
    elapsed_traffic_sent_gb=$(echo "scale=6; $elapsed_traffic_sent / $bytes_to_gb" | bc)
    elapsed_traffic_received_gb=$(echo "scale=6; $elapsed_traffic_received / $bytes_to_gb" | bc)

    # Guardamos el tráfico transcurrido en el archivo
    echo "Bytes enviados: $elapsed_traffic_sent" > "$ELAPSED_TRAFFIC_FILE"
    echo "Gigabytes enviados: $elapsed_traffic_sent_gb" >> "$ELAPSED_TRAFFIC_FILE"
    echo "Bytes recibidos: $elapsed_traffic_received" >> "$ELAPSED_TRAFFIC_FILE"
    echo "Gigabytes recibidos: $elapsed_traffic_received_gb" >> "$ELAPSED_TRAFFIC_FILE"
}

calculate_total_traffic
