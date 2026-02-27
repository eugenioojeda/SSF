#!/bin/bash

while true; do
    # Leer la contraseña (usamos -s para que no se vea mientras se escribe)
    read -sp "Introduce la contraseña: " PASS1
    echo ""
    read -sp "Confirma la contraseña: " PASS2
    echo ""

    # Comparar las variables
    if [ "$PASS1" == "$PASS2" ]; then
        echo "OK: Las contraseñas coinciden."
        break  
    else
        echo "ERROR: Las contraseñas son diferentes. Inténtalo de nuevo."
        echo "--------------------------------------------------------"
    fi
done