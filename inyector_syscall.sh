#!/bin/bash

# Configuración
SYSCALL_NAME="jeanantony"
SYSCALL_FUNC="sys_jeanantony"
DIR_NAME="jeanantony"
# OJO: Cambia este número si el 451 ya está ocupado en tu versión
SYSCALL_NUM=451 

echo "--- Iniciando Inyección de System Call: $SYSCALL_NAME ($SYSCALL_NUM) ---"

# 1. Verificar que estamos en la raíz del kernel
if [ ! -f "Makefile" ] || [ ! -d "arch" ]; then
    echo "ERROR: No pareces estar en la raíz del código fuente del Kernel."
    exit 1
fi

# 2. Crear el directorio y el código C
echo "[+] Creando directorio y archivos fuente..."
mkdir -p $DIR_NAME

# Crear el archivo .c
cat > $DIR_NAME/misyscall.c <<EOF
#include <linux/kernel.h>
#include <linux/syscalls.h>

SYSCALL_DEFINE0($SYSCALL_NAME)
{
    printk(KERN_INFO "Hola Kernel! La syscall $SYSCALL_NAME ha sido ejecutada con exito.\n");
    return 0;
}
EOF

# Crear el Makefile local
echo "obj-y := misyscall.o" > $DIR_NAME/Makefile

# 3. Modificar el Makefile principal
# Busca la línea "core-y" y añade nuestra carpeta al final
echo "[+] Modificando Makefile principal..."
if grep -q "$DIR_NAME/" Makefile; then
    echo "    -> El Makefile ya contiene $DIR_NAME, saltando..."
else
    # Hacemos backup por si acaso
    cp Makefile Makefile.bak
    # Usamos sed para buscar la linea core-y y agregar la carpeta
    sed -i "/core-y[[:space:]]*+=/ s/$/ $DIR_NAME\//" Makefile
    echo "    -> Makefile modificado."
fi

# 4. Registrar en la Tabla de Syscalls (x86_64)
TBL_FILE="arch/x86/entry/syscalls/syscall_64.tbl"
echo "[+] Registrando en la tabla de syscalls ($TBL_FILE)..."

if grep -q "$SYSCALL_NAME" "$TBL_FILE"; then
    echo "    -> La syscall ya está en la tabla, saltando..."
else
    cp $TBL_FILE $TBL_FILE.bak
    # Añadimos la línea al final de la sección common (esto es un append simple)
    # Formato: <numero> <abi> <nombre> <punto_entrada>
    echo -e "$SYSCALL_NUM\tcommon\t$SYSCALL_NAME\t\t$SYSCALL_FUNC" >> $TBL_FILE
    echo "    -> Tabla actualizada con el ID $SYSCALL_NUM."
fi

# 5. Agregar el prototipo al Header
HEADER_FILE="include/linux/syscalls.h"
echo "[+] Agregando prototipo al header ($HEADER_FILE)..."

if grep -q "$SYSCALL_FUNC" "$HEADER_FILE"; then
    echo "    -> El prototipo ya existe en el header, saltando..."
else
    cp $HEADER_FILE $HEADER_FILE.bak
    # Insertar antes de la última línea (que suele ser #endif)
    sed -i "\$i asmlinkage long $SYSCALL_FUNC(void);" $HEADER_FILE
    echo "    -> Header modificado."
fi

echo "--- ¡Inyección completada! ---"
echo "Pasos siguientes:"
echo "1. Ejecuta: make -j\$(nproc)"
echo "2. Instala: sudo make modules_install && sudo make install"
echo "3. Reinicia y prueba con tu programa en C."
