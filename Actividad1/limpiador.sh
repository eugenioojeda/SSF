#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Iniciando organización de archivos ===${NC}"

# Crear directorio de trabajo (el script se ejecuta en su propia carpeta)
TRABAJO="$(cd "$(dirname "$0")" && pwd)"
cd "$TRABAJO"

# Crear carpetas si no existen
CARPETAS=("IMGS" "DOCS" "TXTS" "PDFS" "VACIOS")
for carpeta in "${CARPETAS[@]}"; do
    if [ ! -d "$carpeta" ]; then
        mkdir -p "$carpeta"
        echo -e "${GREEN}✓ Carpeta creada: $carpeta${NC}"
    fi
done

echo ""

# Mover imágenes (jpg, png, gif) a IMGS/
echo "Moviendo imágenes..."
find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -exec mv {} IMGS/ \;

# Mover documentos (docx, odt) a DOCS/
echo "Moviendo documentos..."
find . -maxdepth 1 -type f \( -iname "*.docx" -o -iname "*.odt" \) -exec mv {} DOCS/ \;

# Mover archivos de texto (txt) a TXTS/
echo "Moviendo archivos de texto..."
find . -maxdepth 1 -type f -iname "*.txt" -exec mv {} TXTS/ \;

# Mover PDFs a PDFS/
echo "Moviendo PDFs..."
find . -maxdepth 1 -type f -iname "*.pdf" -exec mv {} PDFS/ \;

# Mover archivos vacíos (0 bytes) a VACIOS/
echo "Moviendo archivos vacíos..."
find . -maxdepth 1 -type f -size 0 -exec mv {} VACIOS/ \;

echo ""
echo -e "${BLUE}=== Organización completada ===${NC}"
echo ""

# Mostrar resumen
echo "Resumen de carpetas:"
for carpeta in "${CARPETAS[@]}"; do
    if [ -d "$carpeta" ]; then
        cantidad=$(find "$carpeta" -maxdepth 1 -type f | wc -l)
        echo "  $carpeta: $cantidad archivos"
    fi
done
