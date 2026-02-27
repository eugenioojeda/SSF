#!/bin/bash

# Comprobar si se ha pasado un mensaje
if [ $# -eq 0 ]; then
    echo "Error: Debes proporcionar un mensaje para el commit."
    echo "Uso: $0 Tu mensaje de commit"
    exit 1
fi

# Unir todos los argumentos en una sola variable de mensaje
# $@ captura todos los parámetros pasados (incluso con espacios)
MENSAJE="$@"

# Ejecutar comandos de Git
echo "Añadiendo cambios..."
git add .

echo "Creando commit con el mensaje: '$MENSAJE'..."
git commit -m "$MENSAJE"

echo "Subiendo al repositorio remoto..."
git push

echo "¡Listo! Todo actualizado."
