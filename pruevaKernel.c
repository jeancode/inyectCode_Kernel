#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

// Asegurate que este numero sea el mismo que pusiste en el script (451)
#define SYS_JEANANTONY 451 

int main() {
    printf("--- Intentando contactar al Kernel ---\n");
    
    // Invocamos la syscall directamente por su numero
    long resultado = syscall(SYS_JEANANTONY);
    
    if (resultado == 0) {
        printf("¡Éxito! El Kernel respondió correctamente.\n");
        printf("Ejecuta 'dmesg | tail' para ver el mensaje secreto.\n");
    } else {
        printf("Error: La syscall falló o no existe (¿Reiniciaste con el nuevo kernel?).\n");
        perror("Detalle");
    }
    
    return 0;
}
