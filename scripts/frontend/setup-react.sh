#!/bin/bash

# ============================================
# React + Vite Project Setup Script
# Creates a React application with Vite
# Supports TypeScript or JavaScript
# ============================================

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Import libraries
source "${ROOT_DIR}/lib/ui.sh"
source "${ROOT_DIR}/lib/file-utils.sh"
source "${ROOT_DIR}/lib/package-manager.sh"
source "${ROOT_DIR}/lib/validators.sh"

# ============================================
# Main Function
# ============================================

main() {
    print_header "⚛️  React + Vite Project Setup"

    # Step 1: Validar Node.js instalado
    if ! validate_node_version 16; then
        exit 1
    fi

    # Step 2: Preguntar si usar carpeta actual o crear nueva
    echo ""
    local use_current_dir
    use_current_dir=$(select_option_simple "Project location" "Create new folder" "Use current directory")

    local project_name
    local project_dir

    if [ "$use_current_dir" = "Use current directory" ]; then
        # Usar directorio actual
        project_dir=$(pwd)
        project_name=$(basename "$project_dir")

        # Verificar que el directorio actual esté vacío o casi vacío
        local file_count=$(find . -maxdepth 1 -not -name '.' -not -name '..' -not -name '.git' | wc -l)
        if [ "$file_count" -gt 0 ]; then
            print_warning "Current directory is not empty"
            if ! confirm "Continue anyway? This will add files to the current directory."; then
                print_info "Setup cancelled"
                exit 0
            fi
        fi

        print_info "Using current directory: $project_dir"
        echo ""
    else
        # Crear nuevo directorio
        while true; do
            project_name=$(input "Project name" "my-react-app")
            if validate_project_name "$project_name"; then
                break
            fi
        done

        # Verificar que el directorio no exista o esté vacío
        if ! check_directory_available "$project_name"; then
            if ! confirm "Directory exists. Continue anyway?"; then
                print_info "Setup cancelled"
                exit 0
            fi
        fi

        project_dir="$project_name"
    fi

    # Step 3: Seleccionar lenguaje
    local language
    language=$(select_option_simple "Select language" "TypeScript" "JavaScript")
    language=$(echo "$language" | tr '[:upper:]' '[:lower:]')

    # Step 4: Seleccionar puerto de desarrollo
    local port
    while true; do
        port=$(input "Development server port" "5173")
        if validate_port "$port"; then
            break
        fi
    done

    # Step 5: Seleccionar dependencias opcionales
    echo ""
    local optional_packages
    optional_packages=$(multi_select_simple "Optional packages" \
        "React Router (routing)" \
        "TailwindCSS (styling)" \
        "Zustand (state management)" \
        "Redux Toolkit (state management)" \
        "TanStack Query (data fetching)" \
        "Axios (HTTP client)" \
        "React Hook Form (forms)" \
        "Zod (validation)" \
        "Framer Motion (animations)" \
        "React Icons (icon library)" \
        "date-fns (date utilities)" \
        "clsx (className utility)")

    # Parsear selecciones
    local use_router=false
    local use_tailwind=false
    local use_zustand=false
    local use_redux=false
    local use_tanstack_query=false
    local use_axios=false
    local use_react_hook_form=false
    local use_zod=false
    local use_framer_motion=false
    local use_react_icons=false
    local use_date_fns=false
    local use_clsx=false

    IFS=',' read -ra PACKAGES <<< "$optional_packages"
    for package in "${PACKAGES[@]}"; do
        case "$package" in
            *"React Router"*) use_router=true ;;
            *"TailwindCSS"*) use_tailwind=true ;;
            *"Zustand"*) use_zustand=true ;;
            *"Redux Toolkit"*) use_redux=true ;;
            *"TanStack Query"*) use_tanstack_query=true ;;
            *"Axios"*) use_axios=true ;;
            *"React Hook Form"*) use_react_hook_form=true ;;
            *"Zod"*) use_zod=true ;;
            *"Framer Motion"*) use_framer_motion=true ;;
            *"React Icons"*) use_react_icons=true ;;
            *"date-fns"*) use_date_fns=true ;;
            *"clsx"*) use_clsx=true ;;
        esac
    done

    echo ""
    print_header "📦 Creating Project with Vite"

    # Step 6: Crear proyecto con Vite
    if [ "$use_current_dir" != "Use current directory" ]; then
        # Crear con Vite en nuevo directorio
        if [ "$language" = "typescript" ]; then
            npm create vite@latest "$project_name" -- --template react-ts
        else
            npm create vite@latest "$project_name" -- --template react
        fi
        cd "$project_name"
        project_dir=$(pwd)
    else
        # Crear en directorio actual
        if [ "$language" = "typescript" ]; then
            npm create vite@latest . -- --template react-ts
        else
            npm create vite@latest . -- --template react
        fi
    fi

    echo ""
    print_info "Installing additional packages..."
    echo ""

    # Preparar dependencias adicionales
    local dependencies=""
    local dev_dependencies=""

    # Agregar paquetes seleccionados
    if [ "$use_router" = true ]; then
        dependencies+=" react-router-dom"
        if [ "$language" = "typescript" ]; then
            dev_dependencies+=" @types/react-router-dom"
        fi
    fi

    if [ "$use_zustand" = true ]; then
        dependencies+=" zustand"
    fi

    if [ "$use_redux" = true ]; then
        dependencies+=" @reduxjs/toolkit react-redux"
        if [ "$language" = "typescript" ]; then
            dev_dependencies+=" @types/react-redux"
        fi
    fi

    if [ "$use_tanstack_query" = true ]; then
        dependencies+=" @tanstack/react-query"
        dev_dependencies+=" @tanstack/eslint-plugin-query"
    fi

    if [ "$use_axios" = true ]; then
        dependencies+=" axios"
    fi

    if [ "$use_react_hook_form" = true ]; then
        dependencies+=" react-hook-form"
    fi

    if [ "$use_zod" = true ]; then
        dependencies+=" zod"
    fi

    if [ "$use_framer_motion" = true ]; then
        dependencies+=" framer-motion"
    fi

    if [ "$use_react_icons" = true ]; then
        dependencies+=" react-icons"
    fi

    if [ "$use_date_fns" = true ]; then
        dependencies+=" date-fns"
    fi

    if [ "$use_clsx" = true ]; then
        dependencies+=" clsx"
    fi

    if [ "$use_tailwind" = true ]; then
        dev_dependencies+=" tailwindcss postcss autoprefixer"
    fi

    # Instalar dependencias adicionales
    if [ -n "$dependencies" ]; then
        print_info "Installing dependencies..."
        npm install $dependencies
    fi

    if [ -n "$dev_dependencies" ]; then
        print_info "Installing dev dependencies..."
        npm install -D $dev_dependencies
    fi

    # Configurar TailwindCSS si fue seleccionado
    if [ "$use_tailwind" = true ]; then
        echo ""
        print_info "Configuring TailwindCSS..."
        npx tailwindcss init -p

        # Crear configuración de Tailwind
        cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

        # Agregar Tailwind al CSS principal
        local css_file="src/index.css"
        cat > "$css_file" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

        print_success "TailwindCSS configured!"
    fi

    # Actualizar vite.config para usar el puerto personalizado
    local vite_config_file="vite.config.${language:0:1}s"
    if [ -f "$vite_config_file" ]; then
        # Añadir configuración de puerto
        if grep -q "server:" "$vite_config_file"; then
            print_info "Vite config already has server configuration"
        else
            # Insertar configuración de servidor antes del último }
            sed -i "/export default defineConfig/a\  server: {\n    port: ${port},\n  }," "$vite_config_file"
        fi
    fi

    # Crear estructura de carpetas adicionales
    mkdir -p src/components
    mkdir -p src/hooks
    mkdir -p src/utils

    if [ "$use_router" = true ]; then
        mkdir -p src/pages
    fi

    if [ "$use_zustand" = true ] || [ "$use_redux" = true ]; then
        mkdir -p src/store
    fi

    if [ "$use_tanstack_query" = true ] || [ "$use_axios" = true ]; then
        mkdir -p src/services
        mkdir -p src/api
    fi

    # Crear README personalizado
    local readme_content="# ${project_name}

React application built with Vite and ${language^}

## Features

- ⚡️ Vite - Lightning fast HMR
- ⚛️ React 18
- 🎨 ${language^}
"

    if [ "$use_tailwind" = true ]; then
        readme_content+="- 🎨 TailwindCSS - Utility-first CSS framework
"
    fi

    if [ "$use_router" = true ]; then
        readme_content+="- 🚦 React Router - Client-side routing
"
    fi

    if [ "$use_zustand" = true ]; then
        readme_content+="- 🐻 Zustand - Simple state management
"
    fi

    if [ "$use_redux" = true ]; then
        readme_content+="- 🔄 Redux Toolkit - State management
"
    fi

    if [ "$use_tanstack_query" = true ]; then
        readme_content+="- 🔄 TanStack Query - Data fetching & caching
"
    fi

    readme_content+="
## Getting Started

1. Install dependencies:
\`\`\`bash
npm install
\`\`\`

2. Start development server:
\`\`\`bash
npm run dev
\`\`\`

3. Build for production:
\`\`\`bash
npm run build
\`\`\`

## Project Structure

\`\`\`
src/
├── components/   # Reusable components
├── hooks/        # Custom React hooks
├── utils/        # Utility functions"

    if [ "$use_router" = true ]; then
        readme_content+="
├── pages/        # Route pages"
    fi

    if [ "$use_zustand" = true ] || [ "$use_redux" = true ]; then
        readme_content+="
├── store/        # State management"
    fi

    if [ "$use_tanstack_query" = true ] || [ "$use_axios" = true ]; then
        readme_content+="
├── api/          # API clients
├── services/     # Business logic"
    fi

    readme_content+="
├── App.${language:0:1}sx
└── main.${language:0:1}sx
\`\`\`

## Available Scripts

- \`npm run dev\` - Start development server
- \`npm run build\` - Build for production
- \`npm run preview\` - Preview production build
- \`npm run lint\` - Run ESLint
"

    echo "$readme_content" > README.md
    print_success "Created: README.md"

    # Step 7: Mensaje final
    echo ""
    print_header "✅ Project Created Successfully!"
    echo ""
    print_success "Project '${project_name}' is ready!"
    echo ""
    print_info "Next steps:"
    echo ""

    if [ "$use_current_dir" != "Use current directory" ]; then
        echo "  cd ${project_name}"
    fi

    echo "  $(get_run_command dev)        # Start development server"
    echo ""
    print_info "Your app will be running at: http://localhost:${port}"
    echo ""

    if [ "$use_tailwind" = true ]; then
        print_info "TailwindCSS is configured and ready to use!"
    fi

    if [ "$use_router" = true ]; then
        print_info "React Router is installed. Create your routes in src/pages/"
    fi

    echo ""
}

# Run main function
main "$@"
