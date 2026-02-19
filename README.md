# 🚀 Laravel Docker Installer

Este script automatiza la instalación y configuración de un entorno **Laravel** con **PostgreSQL** utilizando Docker. Ideal para levantar el proyecto desde cero con un solo comando.

---

## 📋 Requisitos Previos

Antes de empezar, asegúrate de tener instalado:
* **Docker** y **Docker Compose**.
* Un archivo `.env` en la raíz del proyecto que contenga las credenciales de la base de datos (se usarán para configurar Laravel automáticamente).

## 🛠️ Instalación

1. **Dar permisos de ejecución al script:**
   ```bash
   chmod +x install.sh
   ./install.sh dev
