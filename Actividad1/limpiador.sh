#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Contadores
CONTADOR_IMGS=0
CONTADOR_DOCS=0
CONTADOR_TXTS=0
CONTADOR_PDFS=0
CONTADOR_VACIOS=0
ARCHIVOS_NO_MOVIDOS=0
CARPETAS_VACIAS=0

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
ANTES_IMGS=$(find IMGS -maxdepth 1 -type f 2>/dev/null | wc -l)
find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -print0 | xargs -0 -r mv -t IMGS/ 2>/dev/null
CONTADOR_IMGS=$(($(find IMGS -maxdepth 1 -type f 2>/dev/null | wc -l) - ANTES_IMGS))

# Mover documentos (docx, odt) a DOCS/
echo "Moviendo documentos..."
ANTES_DOCS=$(find DOCS -maxdepth 1 -type f 2>/dev/null | wc -l)
find . -maxdepth 1 -type f \( -iname "*.docx" -o -iname "*.odt" \) -print0 | xargs -0 -r mv -t DOCS/ 2>/dev/null
CONTADOR_DOCS=$(($(find DOCS -maxdepth 1 -type f 2>/dev/null | wc -l) - ANTES_DOCS))

# Mover archivos de texto (txt) a TXTS/
echo "Moviendo archivos de texto..."
ANTES_TXTS=$(find TXTS -maxdepth 1 -type f 2>/dev/null | wc -l)
find . -maxdepth 1 -type f -iname "*.txt" -print0 | xargs -0 -r mv -t TXTS/ 2>/dev/null
CONTADOR_TXTS=$(($(find TXTS -maxdepth 1 -type f 2>/dev/null | wc -l) - ANTES_TXTS))

# Mover PDFs a PDFS/
echo "Moviendo PDFs..."
ANTES_PDFS=$(find PDFS -maxdepth 1 -type f 2>/dev/null | wc -l)
find . -maxdepth 1 -type f -iname "*.pdf" -print0 | xargs -0 -r mv -t PDFS/ 2>/dev/null
CONTADOR_PDFS=$(($(find PDFS -maxdepth 1 -type f 2>/dev/null | wc -l) - ANTES_PDFS))

# Mover archivos vacíos (0 bytes) a VACIOS/
echo "Moviendo archivos vacíos..."
ANTES_VACIOS=$(find VACIOS -maxdepth 1 -type f 2>/dev/null | wc -l)
find . -maxdepth 1 -type f -size 0 -print0 | xargs -0 -r mv -t VACIOS/ 2>/dev/null
CONTADOR_VACIOS=$(($(find VACIOS -maxdepth 1 -type f 2>/dev/null | wc -l) - ANTES_VACIOS))

# Contar archivos no movidos
ARCHIVOS_NO_MOVIDOS=$(find . -maxdepth 1 -type f 2>/dev/null | wc -l)

# Contar carpetas vacías
for carpeta in "${CARPETAS[@]}"; do
    if [ -d "$carpeta" ]; then
        cantidad=$(find "$carpeta" -maxdepth 1 -type f 2>/dev/null | wc -l)
        if [ "$cantidad" -eq 0 ]; then
            CARPETAS_VACIAS=$((CARPETAS_VACIAS + 1))
        fi
    fi
done

echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}${MAGENTA}   📊 INFORME DE ORGANIZACIÓN       ${NC}${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Variables para mensaje
TOTAL_MOVIDOS=$((CONTADOR_IMGS + CONTADOR_DOCS + CONTADOR_TXTS + CONTADOR_PDFS + CONTADOR_VACIOS))

# Mensaje personalizado
MENSAJE="Se han movido"
[ $CONTADOR_IMGS -gt 0 ] && MENSAJE="$MENSAJE ${GREEN}$CONTADOR_IMGS imagen$([ $CONTADOR_IMGS -eq 1 ] && echo "" || echo "s")${NC}"
[ $CONTADOR_DOCS -gt 0 ] && [ $CONTADOR_IMGS -gt 0 ] && MENSAJE="$MENSAJE, " || MENSAJE="$MENSAJE "
[ $CONTADOR_DOCS -gt 0 ] && MENSAJE="$MENSAJE${YELLOW}$CONTADOR_DOCS documento$([ $CONTADOR_DOCS -eq 1 ] && echo "" || echo "s")${NC}"
[ $CONTADOR_TXTS -gt 0 ] && [ $((CONTADOR_IMGS + CONTADOR_DOCS)) -gt 0 ] && MENSAJE="$MENSAJE, " || [ $CONTADOR_TXTS -gt 0 ] && MENSAJE="$MENSAJE "
[ $CONTADOR_TXTS -gt 0 ] && MENSAJE="$MENSAJE${BLUE}$CONTADOR_TXTS archivo$([ $CONTADOR_TXTS -eq 1 ] && echo "" || echo "s") TXT${NC}"
[ $CONTADOR_PDFS -gt 0 ] && [ $((CONTADOR_IMGS + CONTADOR_DOCS + CONTADOR_TXTS)) -gt 0 ] && MENSAJE="$MENSAJE, " || [ $CONTADOR_PDFS -gt 0 ] && MENSAJE="$MENSAJE "
[ $CONTADOR_PDFS -gt 0 ] && MENSAJE="$MENSAJE${RED}$CONTADOR_PDFS PDF$([ $CONTADOR_PDFS -eq 1 ] && echo "" || echo "s")${NC}"
[ $CONTADOR_VACIOS -gt 0 ] && [ $((CONTADOR_IMGS + CONTADOR_DOCS + CONTADOR_TXTS + CONTADOR_PDFS)) -gt 0 ] && MENSAJE="$MENSAJE y " || [ $CONTADOR_VACIOS -gt 0 ] && MENSAJE="$MENSAJE "
[ $CONTADOR_VACIOS -gt 0 ] && MENSAJE="$MENSAJE${MAGENTA}$CONTADOR_VACIOS elemento$([ $CONTADOR_VACIOS -eq 1 ] && echo "" || echo "s") vacío$([ $CONTADOR_VACIOS -eq 1 ] && echo "" || echo "s")${NC}"

if [ $TOTAL_MOVIDOS -gt 0 ]; then
    echo -e "$MENSAJE"
else
    echo -e "${YELLOW}No se encontraron archivos para mover${NC}"
fi

echo ""

# Resumen de carpetas
echo -e "${YELLOW}Contenido de carpetas:${NC}"
echo -e "  ${GREEN}📁 IMGS${NC}............ $CONTADOR_IMGS archivo$([ $CONTADOR_IMGS -eq 1 ] && echo "" || echo "s")"
echo -e "  ${YELLOW}📁 DOCS${NC}............ $CONTADOR_DOCS archivo$([ $CONTADOR_DOCS -eq 1 ] && echo "" || echo "s")"
echo -e "  ${BLUE}📁 TXTS${NC}............ $CONTADOR_TXTS archivo$([ $CONTADOR_TXTS -eq 1 ] && echo "" || echo "s")"
echo -e "  ${RED}📁 PDFS${NC}............ $CONTADOR_PDFS archivo$([ $CONTADOR_PDFS -eq 1 ] && echo "" || echo "s")"
echo -e "  ${MAGENTA}📁 VACIOS${NC}......... $CONTADOR_VACIOS archivo$([ $CONTADOR_VACIOS -eq 1 ] && echo "" || echo "s")"

echo ""

# Información adicional
if [ $ARCHIVOS_NO_MOVIDOS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Hay $ARCHIVOS_NO_MOVIDOS archivo$([ $ARCHIVOS_NO_MOVIDOS -eq 1 ] && echo "" || echo "s") sin clasificar${NC}"
fi

if [ $CARPETAS_VACIAS -gt 0 ]; then
    echo -e "${BLUE}ℹ️  $CARPETAS_VACIAS carpeta$([ $CARPETAS_VACIAS -eq 1 ] && echo "" || echo "s") vacía$([ $CARPETAS_VACIAS -eq 1 ] && echo "" || echo "s")${NC}"
fi

echo ""
echo -e "${GREEN}✓ ¡Organización completada con éxito!${NC}"
echo ""

# Preguntar si desea eliminar vacíos
if [ $CONTADOR_VACIOS -gt 0 ] || [ $CARPETAS_VACIAS -gt 0 ]; then
    ELEMENTOS_A_BORRAR=$((CONTADOR_VACIOS + CARPETAS_VACIAS))
    echo -e "${YELLOW}───────────────────────────────────────${NC}"
    echo -e "${RED}🗑️  Se encontraron $ELEMENTOS_A_BORRAR elemento$([ $ELEMENTOS_A_BORRAR -eq 1 ] && echo "" || echo "s") vacío$([ $ELEMENTOS_A_BORRAR -eq 1 ] && echo "" || echo "s")${NC}"
    echo ""
    
    # Listar archivos vacíos
    if [ $CONTADOR_VACIOS -gt 0 ]; then
        echo -e "${MAGENTA}Archivos vacíos:${NC}"
        find VACIOS -maxdepth 1 -type f -print0 2>/dev/null | while IFS= read -r -d '' archivo; do
            nombre_archivo=$(basename "$archivo")
            echo -e "  ${RED}•${NC} $nombre_archivo"
        done
        echo ""
    fi
    
    # Listar carpetas vacías
    if [ $CARPETAS_VACIAS -gt 0 ]; then
        echo -e "${MAGENTA}Carpetas vacías:${NC}"
        for carpeta in "${CARPETAS[@]}"; do
            if [ -d "$carpeta" ] && [ -z "$(find "$carpeta" -maxdepth 1 -type f 2>/dev/null)" ]; then
                echo -e "  ${BLUE}📁${NC} $carpeta"
            fi
        done
        echo ""
    fi
    
    read -p "¿Deseas eliminarlos? (s/n): " respuesta
    echo ""
    
    case "$respuesta" in
        [sS]|[sS][iI]|[yY]|[yY][eE][sS])
            # Eliminar archivos en VACIOS/
            if [ $CONTADOR_VACIOS -gt 0 ]; then
                rm -f VACIOS/* 2>/dev/null
                echo -e "${GREEN}✓ Se han eliminado los $CONTADOR_VACIOS archivo$([ $CONTADOR_VACIOS -eq 1 ] && echo "" || echo "s") vacío$([ $CONTADOR_VACIOS -eq 1 ] && echo "" || echo "s")${NC}"
            fi
            
            # Eliminar carpetas vacías
            for carpeta in "${CARPETAS[@]}"; do
                if [ -d "$carpeta" ] && [ -z "$(find "$carpeta" -maxdepth 1 -type f 2>/dev/null)" ]; then
                    rmdir "$carpeta" 2>/dev/null
                fi
            done
            
            if [ $CARPETAS_VACIAS -gt 0 ]; then
                echo -e "${GREEN}✓ Se han eliminado las $CARPETAS_VACIAS carpeta$([ $CARPETAS_VACIAS -eq 1 ] && echo "" || echo "s") vacía$([ $CARPETAS_VACIAS -eq 1 ] && echo "" || echo "s")${NC}"
            fi
            
            echo -e "${GREEN}¡Limpieza completada!${NC}"
            ;;
        [nN]|[nN][oO])
            echo -e "${BLUE}✓ Se mantienen los elementos vacíos${NC}"
            ;;
        *)
            echo -e "${YELLOW}⚠️  Opción no válida. Se mantienen los elementos vacíos${NC}"
            ;;
    esac
fi
