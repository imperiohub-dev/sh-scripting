#!/bin/bash

# ============================================
# Validators Library - Validaciones
# ============================================

# Validar nombre de proyecto
# - No puede estar vacío
# - Solo letras, números, guiones y guiones bajos
# - No puede empezar con número
validate_project_name() {
    local name="$1"

    if [ -z "$name" ]; then
        print_error "Project name cannot be empty"
        return 1
    fi

    # Verificar que no empiece con número
    if [[ "$name" =~ ^[0-9] ]]; then
        print_error "Project name cannot start with a number"
        return 1
    fi

    # Verificar caracteres válidos
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        print_error "Project name can only contain letters, numbers, hyphens, and underscores"
        return 1
    fi

    return 0
}

# Validar número de puerto
validate_port() {
    local port="$1"

    if [ -z "$port" ]; then
        print_error "Port cannot be empty"
        return 1
    fi

    # Verificar que sea un número
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        print_error "Port must be a number"
        return 1
    fi

    # Verificar rango válido (1024-65535)
    if [ "$port" -lt 1024 ] || [ "$port" -gt 65535 ]; then
        print_error "Port must be between 1024 and 65535"
        return 1
    fi

    return 0
}

# Verificar si un directorio existe y está vacío
check_directory_available() {
    local dir="$1"

    if [ -d "$dir" ]; then
        if ! is_directory_empty "$dir"; then
            print_error "Directory '$dir' already exists and is not empty"
            return 1
        fi
    fi

    return 0
}

# Validar que un comando/programa esté instalado
validate_command_exists() {
    local command="$1"
    local name="${2:-$command}"

    if ! command -v "$command" &> /dev/null; then
        print_error "${name} is not installed"
        return 1
    fi

    return 0
}

# Validar versión de Node.js
validate_node_version() {
    local min_version="${1:-14}"

    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed"
        return 1
    fi

    local current_version
    current_version=$(node -v | sed 's/v//' | cut -d'.' -f1)

    if [ "$current_version" -lt "$min_version" ]; then
        print_error "Node.js version must be >= ${min_version} (current: ${current_version})"
        return 1
    fi

    return 0
}

# Validar input no vacío
validate_not_empty() {
    local value="$1"
    local field_name="${2:-Value}"

    if [ -z "$value" ]; then
        print_error "${field_name} cannot be empty"
        return 1
    fi

    return 0
}

# Validar que un path sea válido
validate_path() {
    local path="$1"

    # Verificar caracteres inválidos básicos
    if [[ "$path" =~ [\<\>\"\|\?\*] ]]; then
        print_error "Path contains invalid characters"
        return 1
    fi

    return 0
}
