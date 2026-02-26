#!/bin/bash

extensiones=("jpg" "txt" "doc" "pdf" "bmp" "gif" "png" "java" "odt")

echo "Generando archivos con tamaños aleatorios (0KB a 200KB)..."

for i in {1..200}
do
    nombre=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1)
    ext=${extensiones[$RANDOM % ${#extensiones[@]}]}
    tamano=$(shuf -i 1024-204800 -n 1)
    head -c "$tamano" /dev/urandom > "${nombre}.${ext}"
done

blankFiles=$(( RANDOM % 26 ))
for (( i=0; i<=$blankFiles; i++ )) do
    nombre=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1)
    touch "${nombre}.txt"
done
printf "Listo!"
