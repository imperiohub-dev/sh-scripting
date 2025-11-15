#!/bin/bash

# ============================================
# Package Manager Library - Gestión de paquetes
# ============================================

# Detectar qué package manager está disponible
detect_package_manager() {
    # Verificar si existe yarn.lock, pnpm-lock.yaml o package-lock.json
    if [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "package-lock.json" ]; then
        echo "npm"
    # Verificar qué está instalado en el sistema
    elif command -v pnpm &> /dev/null; then
        echo "pnpm"
    elif command -v yarn &> /dev/null; then
        echo "yarn"
    elif command -v npm &> /dev/null; then
        echo "npm"
    else
        print_error "No package manager found (npm, yarn, or pnpm)"
        return 1
    fi
}

# Instalar dependencias
install_dependencies() {
    local project_dir="$1"
    local package_manager

    cd "$project_dir" || return 1

    package_manager=$(detect_package_manager)

    if [ $? -ne 0 ]; then
        return 1
    fi

    print_info "Using package manager: ${package_manager}"
    echo ""

    case "$package_manager" in
        npm)
            npm install
            ;;
        yarn)
            yarn install
            ;;
        pnpm)
            pnpm install
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo ""
        print_success "Dependencies installed successfully"
        return 0
    else
        echo ""
        print_error "Failed to install dependencies"
        return 1
    fi
}

# Obtener comando de instalación
get_install_command() {
    local package_manager
    package_manager=$(detect_package_manager)

    case "$package_manager" in
        npm)
            echo "npm install"
            ;;
        yarn)
            echo "yarn"
            ;;
        pnpm)
            echo "pnpm install"
            ;;
    esac
}

# Obtener comando para ejecutar scripts
get_run_command() {
    local package_manager
    local script="$1"

    package_manager=$(detect_package_manager)

    case "$package_manager" in
        npm)
            echo "npm run ${script}"
            ;;
        yarn)
            echo "yarn ${script}"
            ;;
        pnpm)
            echo "pnpm ${script}"
            ;;
    esac
}

# Verificar si un paquete está instalado globalmente
is_package_installed_globally() {
    local package="$1"
    local package_manager

    package_manager=$(detect_package_manager)

    case "$package_manager" in
        npm)
            npm list -g "$package" &> /dev/null
            ;;
        yarn)
            yarn global list | grep -q "$package"
            ;;
        pnpm)
            pnpm list -g "$package" &> /dev/null
            ;;
    esac
}
