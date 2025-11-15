# Contributing Guide

¡Gracias por contribuir al proyecto! Esta guía te ayudará a agregar nuevos scripts al repositorio.

## 📋 Tabla de Contenidos

- [Estructura del Proyecto](#estructura-del-proyecto)
- [Cómo Agregar un Nuevo Script](#cómo-agregar-un-nuevo-script)
- [Usar las Librerías](#usar-las-librerías)
- [Registrar el Script en el Launcher](#registrar-el-script-en-el-launcher)
- [Mejores Prácticas](#mejores-prácticas)
- [Ejemplos](#ejemplos)

## 🏗️ Estructura del Proyecto

```
sh-scripting/
├── run.sh                 # ⭐ Launcher principal
├── lib/                   # 📚 Librerías reutilizables
│   ├── ui.sh             # Funciones de UI
│   ├── file-utils.sh     # Utilidades de archivos
│   ├── package-manager.sh # Gestión de paquetes
│   └── validators.sh     # Validaciones
├── scripts/              # 📁 Scripts organizados por categoría
│   ├── backend/
│   ├── frontend/
│   ├── database/
│   └── utils/
├── templates/            # 📄 Templates para generar archivos
└── CONTRIBUTING.md       # 📖 Esta guía
```

## 🚀 Cómo Agregar un Nuevo Script

### Paso 1: Crear la Categoría (si es nueva)

Si tu script pertenece a una nueva categoría, crea el directorio:

```bash
mkdir -p scripts/tu-categoria
```

Ejemplos de categorías:
- `backend` - Scripts para backend
- `frontend` - Scripts para frontend (React, Vue, etc.)
- `database` - Scripts para bases de datos
- `devops` - Scripts de CI/CD, Docker, etc.
- `utils` - Utilidades generales

### Paso 2: Crear el Script

Crea tu script en la categoría correspondiente:

```bash
touch scripts/tu-categoria/tu-script.sh
chmod +x scripts/tu-categoria/tu-script.sh
```

### Paso 3: Estructura Básica del Script

Tu script debe seguir esta estructura:

```bash
#!/bin/bash

# ============================================
# Nombre del Script - Descripción breve
# ============================================

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Import libraries (solo las que necesites)
source "${ROOT_DIR}/lib/ui.sh"
source "${ROOT_DIR}/lib/file-utils.sh"
source "${ROOT_DIR}/lib/package-manager.sh"
source "${ROOT_DIR}/lib/validators.sh"

# ============================================
# Main Function
# ============================================

main() {
    print_header "🎯 Tu Script"

    # Tu lógica aquí
    project_name=$(input "Project name" "my-project")

    # Más lógica...

    print_success "¡Completado!"
}

# Ejecutar
main "$@"
```

### Paso 4: Registrar en el Launcher

Edita [run.sh](run.sh) y agrega tu script al array `SCRIPTS`:

```bash
declare -a SCRIPTS=(
    "Backend|Setup Backend Project|Create a Node.js backend with Express (TS/JS)|scripts/backend/setup-backend.sh"
    "Tu-Categoria|Nombre del Script|Descripción corta|scripts/tu-categoria/tu-script.sh"
    # ↑ Agrega tu script aquí
)
```

**Formato:**
```
"Categoría|Nombre para mostrar|Descripción|ruta/del/script.sh"
```

**Ejemplo:**
```bash
"Frontend|Setup React App|Create a React application with Vite|scripts/frontend/setup-react.sh"
"Database|Setup PostgreSQL|Configure PostgreSQL with Docker|scripts/database/setup-postgres.sh"
"DevOps|Setup Docker|Create Dockerfile and docker-compose|scripts/devops/setup-docker.sh"
```

### Paso 5: Crear README (Opcional pero Recomendado)

Crea documentación para tu categoría:

```bash
touch scripts/tu-categoria/README.md
```

### Paso 6: Crear Templates (Si aplica)

Si tu script genera archivos, crea templates:

```bash
mkdir -p templates/tu-categoria/files
touch templates/tu-categoria/files/archivo.template
```

## 📚 Usar las Librerías

### UI Library ([lib/ui.sh](lib/ui.sh))

```bash
source "${ROOT_DIR}/lib/ui.sh"

# Mensajes
print_success "Operación exitosa"
print_error "Algo salió mal"
print_info "Información importante"
print_warning "Advertencia"
print_header "Sección Principal"

# Input
nombre=$(input "Nombre del proyecto" "valor-default")

# Confirmación
if confirm "¿Continuar?" "y"; then
    echo "Confirmado"
fi

# Menú de selección (flechas arriba/abajo)
opcion=$(select_option "Elige una opción" "Opción 1" "Opción 2" "Opción 3")

# Multi-selección (espacio para seleccionar)
seleccionados=$(multi_select "Selecciona varios" "Item 1" "Item 2" "Item 3")
```

### File Utils Library ([lib/file-utils.sh](lib/file-utils.sh))

```bash
source "${ROOT_DIR}/lib/file-utils.sh"

# Crear directorios
create_directory_structure "$base_dir" "src" "dist" "config"

# Crear archivo simple
create_file "$path/file.txt" "Contenido del archivo"

# Crear desde template
create_file_from_template \
    "$template_file" \
    "$output_file" \
    "VAR1=valor1" \
    "VAR2=valor2"

# Crear .gitignore
create_gitignore "$project_dir" "typescript"

# Crear package.json
create_package_json "$project_dir" "$name" "$language" "$deps" "$devDeps"

# Crear tsconfig.json
create_tsconfig "$project_dir"

# Crear .env.example
create_env_example "$project_dir" "$port"

# Verificar directorio vacío
if is_directory_empty "$dir"; then
    echo "Directorio vacío"
fi
```

### Package Manager Library ([lib/package-manager.sh](lib/package-manager.sh))

```bash
source "${ROOT_DIR}/lib/package-manager.sh"

# Detectar package manager
pm=$(detect_package_manager)  # npm, yarn, o pnpm

# Instalar dependencias
install_dependencies "$project_dir"

# Obtener comando de instalación
cmd=$(get_install_command)  # "npm install" o "yarn" o "pnpm install"

# Obtener comando para ejecutar scripts
run_cmd=$(get_run_command "dev")  # "npm run dev" o "yarn dev" etc.
```

### Validators Library ([lib/validators.sh](lib/validators.sh))

```bash
source "${ROOT_DIR}/lib/validators.sh"

# Validar nombre de proyecto
if validate_project_name "$nombre"; then
    echo "Nombre válido"
fi

# Validar puerto
if validate_port "$puerto"; then
    echo "Puerto válido"
fi

# Validar versión de Node.js
if validate_node_version 16; then
    echo "Node.js >= 16 instalado"
fi

# Verificar comando instalado
if validate_command_exists "docker" "Docker"; then
    echo "Docker está instalado"
fi

# Verificar directorio disponible
if check_directory_available "$dir"; then
    echo "Directorio disponible"
fi
```

## ✅ Mejores Prácticas

### 1. **Usa `set -e`**
   Haz que el script termine ante errores:
   ```bash
   set -e
   ```

### 2. **Valida entradas del usuario**
   Siempre valida antes de usar:
   ```bash
   while true; do
       port=$(input "Puerto" "3000")
       if validate_port "$port"; then
           break
       fi
   done
   ```

### 3. **Usa rutas absolutas**
   No uses rutas relativas:
   ```bash
   # ✅ Bien
   ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
   source "${ROOT_DIR}/lib/ui.sh"

   # ❌ Mal
   source "../../lib/ui.sh"
   ```

### 4. **Proporciona valores por defecto**
   Facilita el uso con defaults razonables:
   ```bash
   project_name=$(input "Project name" "my-project")
   port=$(input "Port" "3000")
   ```

### 5. **Mensajes claros**
   Usa los helpers de UI para mensajes consistentes:
   ```bash
   print_info "Creating project structure..."
   print_success "Project created successfully!"
   ```

### 6. **Maneja errores**
   Informa al usuario cuando algo falla:
   ```bash
   if ! install_dependencies "$project_dir"; then
       print_error "Failed to install dependencies"
       print_info "You can install them manually later with: npm install"
   fi
   ```

### 7. **Documenta tu script**
   Agrega comentarios y un README:
   ```bash
   # ============================================
   # Setup React App - Descripción
   # Crea un proyecto React con Vite y TS
   # ============================================
   ```

### 8. **Usa templates para archivos complejos**
   No generes código complejo con echo/cat:
   ```bash
   # ✅ Bien
   create_file_from_template "$template" "$output" "NAME=$name"

   # ❌ Evita
   cat > file.js << EOF
   // código muy largo aquí
   EOF
   ```

## 📝 Ejemplos

### Ejemplo 1: Script Simple

```bash
#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${ROOT_DIR}/lib/ui.sh"
source "${ROOT_DIR}/lib/validators.sh"

main() {
    print_header "🎨 Color Theme Generator"

    theme_name=$(input "Theme name" "my-theme")

    if ! validate_project_name "$theme_name"; then
        exit 1
    fi

    primary_color=$(input "Primary color" "#3B82F6")

    print_success "Theme '${theme_name}' created!"
}

main "$@"
```

### Ejemplo 2: Script con Selección

```bash
#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${ROOT_DIR}/lib/ui.sh"
source "${ROOT_DIR}/lib/file-utils.sh"

main() {
    print_header "📦 Component Generator"

    framework=$(select_option "Framework" "React" "Vue" "Svelte")
    component_name=$(input "Component name")

    create_directory_structure "." "components"

    # Crear componente según framework
    case "$framework" in
        React)
            create_file "components/${component_name}.tsx" "export const ${component_name} = () => {}"
            ;;
        Vue)
            create_file "components/${component_name}.vue" "<template></template>"
            ;;
        Svelte)
            create_file "components/${component_name}.svelte" "<script></script>"
            ;;
    esac

    print_success "Component created!"
}

main "$@"
```

### Ejemplo 3: Script Completo

Ver [scripts/backend/setup-backend.sh](scripts/backend/setup-backend.sh) como referencia completa.

## 🎯 Checklist antes de Commit

- [ ] Script funciona correctamente
- [ ] Usa las librerías cuando es apropiado
- [ ] Tiene validaciones de entrada
- [ ] Maneja errores apropiadamente
- [ ] Está registrado en `run.sh`
- [ ] Tiene permisos de ejecución (`chmod +x`)
- [ ] Tiene comentarios claros
- [ ] (Opcional) Tiene README en su categoría
- [ ] (Opcional) Tiene templates si genera archivos

## 🤝 Proceso de Contribución

1. **Fork** el repositorio
2. **Crea** tu script siguiendo esta guía
3. **Prueba** que funcione correctamente
4. **Documenta** en README de la categoría
5. **Commit** con mensaje descriptivo
6. **Push** a tu fork
7. **Crea** Pull Request

## 💡 Ideas para Nuevos Scripts

- **Frontend**: Setup React, Vue, Angular, Svelte
- **Backend**: Setup FastAPI, Django, Laravel, Rails
- **Database**: Setup MongoDB, Redis, MySQL
- **DevOps**: Setup Docker, Kubernetes, CI/CD
- **Testing**: Setup Jest, Cypress, Playwright
- **Utils**: Git hooks, code formatters, linters
- **Mobile**: Setup React Native, Flutter

## 📞 Soporte

Si tienes preguntas o problemas:
1. Revisa los scripts existentes como ejemplo
2. Lee la documentación de las librerías
3. Abre un issue en GitHub

¡Gracias por contribuir! 🎉
