#!/bin/bash

# Comprobar que se han pasado 3 argumentos
if [ $# -ne 3 ]; then
    echo "Uso: $0 DÍAS HORAS SEGUNDOS"
    exit 1
fi

# Asignar parámetros a variables
DIAS=$1
HORAS=$2
SEGUNDOS=$3

# Realizar el cálculo
# 1 día = 86400 segundos (24 * 3600)
# 1 hora = 3600 segundos
TOTAL=$(( (DIAS * 86400) + (HORAS * 3600) + SEGUNDOS ))

echo "El número total de segundos es: $TOTAL "