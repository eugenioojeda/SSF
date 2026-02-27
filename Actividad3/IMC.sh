#!/bin/bash

# Validar que se pasaron 2 argumentos
if [ $# -ne 2 ]; then
    echo "Uso: $0 [ALTURA_CM] [PESO_KG]"
    echo "Ejemplo: $0 182 72"
    exit 1
fi

ALTURA_CM=$1
PESO=$2

# Calcular IMC usando 'bc' para manejar decimales
# Fórmula: peso / (altura_m * altura_m)
ALTURA_M=$(echo "scale=2; $ALTURA_CM / 100" | bc)
IMC=$(echo "scale=2; $PESO / ($ALTURA_M * $ALTURA_M)" | bc)

echo "Tu IMC es: $IMC"

# Clasificación según la OMS
# Usamos 'bc' para las comparaciones decimales
if (( $(echo "$IMC < 18.5" | bc -l) )); then
    RESULTADO="Bajo peso"
elif (( $(echo "$IMC < 25.0" | bc -l) )); then
    RESULTADO="Peso saludable (Normal)"
elif (( $(echo "$IMC < 30.0" | bc -l) )); then
    RESULTADO="Sobrepeso"
else
    RESULTADO="Obesidad"
fi

echo "Clasificación OMS: $RESULTADO"