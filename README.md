# Linux Kernel: Custom System Call Implementation

![Linux](https://img.shields.io/badge/Linux-Kernel-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![Shell](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)

## 📋 Descripción del Proyecto

Este proyecto demuestra la manipulación directa del **Linux Kernel Source Code** para implementar una nueva **Llamada al Sistema (System Call)** personalizada en la arquitectura x86_64.

El objetivo es demostrar la comprensión de la arquitectura del sistema operativo, específicamente:
* La separación entre **User Space** y **Kernel Space**.
* La modificación de la **System Call Table** (`syscall_64.tbl`).
* La integración de código C personalizado en el árbol de compilación del Kernel (Makefiles).
* La interacción mediante `syscall()` desde un programa en espacio de usuario.

## 🛠️ Estructura del Proyecto

* **`inyector_syscall.sh`**: Script de automatización en Bash que:
    * Crea el directorio y el código fuente de la syscall dentro del árbol del kernel.
    * Modifica quirúrgicamente los `Makefile` para incluir el nuevo objeto en la compilación.
    * Registra la syscall en la tabla de interrupciones (`arch/x86/entry/syscalls/syscall_64.tbl`).
    * Añade los prototipos a los headers globales.
* **`prueba_kernel.c`**: Herramienta en espacio de usuario para invocar la nueva syscall y verificar la respuesta del núcleo.

## 🚀 Instalación y Compilación

### Prerrequisitos
* Código fuente del Linux Kernel (versión 6.x recomendada).
* Entorno de compilación (`build-essential`, `libncurses-dev`, etc.).

### 1. Inyección del Código
Coloca el script `inyector_syscall.sh` en la raíz del código fuente del kernel y ejecútalo:

```bash
chmod +x inyector_syscall.sh
./inyector_syscall.sh
