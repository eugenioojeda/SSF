#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validar parámetros
if [ $# -gt 1 ]; then
    echo -e "${RED}Error: Demasiados parámetros${NC}"
    echo "Uso: $0 [directorio]"
    echo "Ejemplo: $0 ~/Downloads"
    exit 1
fi

# Establecer directorio de trabajo
if [ -z "$1" ]; then
    # Si no se proporciona parámetro, usar la carpeta actual
    TRABAJO="."
else
    # Validar que el directorio exista
    if [ ! -d "$1" ]; then
        echo -e "${RED}Error: El directorio '$1' no existe${NC}"
        exit 1
    fi
    TRABAJO="$1"
fi

# Convertir a ruta absoluta
TRABAJO="$(cd "$TRABAJO" && pwd)"

echo -e "${BLUE}=== Iniciando organización de archivos ===${NC}"
echo -e "${YELLOW}Directorio: $TRABAJO${NC}"
echo ""

cd "$TRABAJO" || exit 1

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
find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -print0 | xargs -0 -r mv -t IMGS/ 2>/dev/null

# Mover documentos (docx, odt) a DOCS/
echo "Moviendo documentos..."
find . -maxdepth 1 -type f \( -iname "*.docx" -o -iname "*.odt" \) -print0 | xargs -0 -r mv -t DOCS/ 2>/dev/null

# Mover archivos de texto (txt) a TXTS/
echo "Moviendo archivos de texto..."
find . -maxdepth 1 -type f -iname "*.txt" -print0 | xargs -0 -r mv -t TXTS/ 2>/dev/null

# Mover PDFs a PDFS/
echo "Moviendo PDFs..."
find . -maxdepth 1 -type f -iname "*.pdf" -print0 | xargs -0 -r mv -t PDFS/ 2>/dev/null

# Mover archivos vacíos (0 bytes) a VACIOS/
echo "Moviendo archivos vacíos..."
find . -maxdepth 1 -type f -size 0 -print0 | xargs -0 -r mv -t VACIOS/ 2>/dev/null

echo ""
echo -e "${BLUE}=== Organización completada ===${NC}"
echo ""

# Mostrar resumen
echo -e "${YELLOW}Resumen de carpetas:${NC}"
for carpeta in "${CARPETAS[@]}"; do
    if [ -d "$carpeta" ]; then
        cantidad=$(find "$carpeta" -maxdepth 1 -type f 2>/dev/null | wc -l)
        if [ "$cantidad" -gt 0 ]; then
            echo -e "  ${GREEN}✓${NC} $carpeta: $cantidad archivos"
        else
            echo "  $carpeta: vacía"
        fi
    fi
done

echo -e "${GREEN}¡Listo!${NC}"
