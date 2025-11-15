#!/bin/bash

# ============================================
# Main Launcher - CLI para ejecutar scripts
# ============================================

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import libraries
source "${SCRIPT_DIR}/lib/ui.sh"

# Use simple number-based menus by default (more compatible)
# Set USE_ARROW_KEYS=1 to enable arrow key navigation
USE_ARROW_KEYS="${USE_ARROW_KEYS:-0}"

# Select the appropriate menu function
if [ "$USE_ARROW_KEYS" = "1" ]; then
    select_menu() { select_option "$@"; }
else
    select_menu() { select_option_simple "$@"; }
fi

# ============================================
# Script Registry
# Aquí se registran todos los scripts disponibles
# ============================================

# Formato: "Categoría|Nombre del Script|Descripción|Ruta del script"
declare -a SCRIPTS=(
    "Backend|Setup Backend Project|Create a Node.js backend with Express (TS/JS)|scripts/backend/setup-backend.sh"
    "Frontend|Setup React + Vite Project|Create a React application with Vite (TS/JS)|scripts/frontend/setup-react.sh"
    # Agregar más scripts aquí en el futuro
    # "Database|Setup PostgreSQL|Configure PostgreSQL database|scripts/database/setup-postgres.sh"
)

# ============================================
# Funciones
# ============================================

# Mostrar banner principal
show_banner() {
    clear
    echo -e "${COLOR_CYAN}${COLOR_BOLD}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║           🚀  Shell Scripting Utilities  🚀          ║
║                                                       ║
║         Your Swiss Army Knife for Dev Tasks          ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${COLOR_RESET}"
    echo ""
}

# Obtener categorías únicas
get_categories() {
    local -a categories=()
    for script in "${SCRIPTS[@]}"; do
        IFS='|' read -r category name description path <<< "$script"
        if [[ ! " ${categories[@]} " =~ " ${category} " ]]; then
            categories+=("$category")
        fi
    done
    echo "${categories[@]}"
}

# Obtener scripts de una categoría
get_scripts_by_category() {
    local target_category="$1"
    local -a scripts=()

    for script in "${SCRIPTS[@]}"; do
        IFS='|' read -r category name description path <<< "$script"
        if [ "$category" = "$target_category" ]; then
            scripts+=("$name|$description|$path")
        fi
    done

    printf '%s\n' "${scripts[@]}"
}

# Mostrar menú de categorías
show_category_menu() {
    local -a categories
    IFS=' ' read -ra categories <<< "$(get_categories)"

    # Agregar opción de salir
    categories+=("Exit")

    # Redirigir print_header a stderr para que no se capture en el subshell
    print_header "📂 Select a Category" >&2

    select_menu "Choose a category" "${categories[@]}"
}

# Mostrar menú de scripts
show_scripts_menu() {
    local category="$1"
    local scripts_data
    scripts_data=$(get_scripts_by_category "$category")

    if [ -z "$scripts_data" ]; then
        print_error "No scripts found in category: $category" >&2
        return 1
    fi

    # Preparar opciones para el menú
    local -a script_names=()
    local -a script_descriptions=()
    local -a script_paths=()

    while IFS= read -r line; do
        IFS='|' read -r name description path <<< "$line"
        script_names+=("$name")
        script_descriptions+=("$description")
        script_paths+=("$path")
    done <<< "$scripts_data"

    # Agregar opción de volver
    script_names+=("← Back")
    script_descriptions+=("Return to categories")
    script_paths+=("")

    # Mostrar menú con descripciones (todo a stderr para no capturar en subshell)
    echo "" >&2
    print_header "🔧 ${category} Scripts" >&2
    echo "" >&2

    # Mostrar descripción de cada script
    for i in "${!script_names[@]}"; do
        if [ "${script_names[$i]}" != "← Back" ]; then
            echo -e "${COLOR_BOLD}${script_names[$i]}${COLOR_RESET}" >&2
            echo -e "  ${COLOR_BLUE}→${COLOR_RESET} ${script_descriptions[$i]}" >&2
            echo "" >&2
        fi
    done

    local selected_script
    selected_script=$(select_menu "Choose a script to run" "${script_names[@]}")

    # Encontrar el índice del script seleccionado
    for i in "${!script_names[@]}"; do
        if [ "${script_names[$i]}" = "$selected_script" ]; then
            echo "${script_paths[$i]}"
            return 0
        fi
    done
}

# Ejecutar script
run_script() {
    local script_path="$1"
    local full_path="${SCRIPT_DIR}/${script_path}"

    if [ ! -f "$full_path" ]; then
        print_error "Script not found: $script_path"
        return 1
    fi

    if [ ! -x "$full_path" ]; then
        print_warning "Making script executable..."
        chmod +x "$full_path"
    fi

    echo ""
    print_info "Running: ${script_path}"
    echo ""
    echo -e "${COLOR_CYAN}$(printf '─%.0s' {1..60})${COLOR_RESET}"
    echo ""

    # Ejecutar el script
    bash "$full_path"

    local exit_code=$?

    echo ""
    echo -e "${COLOR_CYAN}$(printf '─%.0s' {1..60})${COLOR_RESET}"
    echo ""

    if [ $exit_code -eq 0 ]; then
        print_success "Script completed successfully!"
    else
        print_error "Script exited with code: $exit_code"
    fi

    return $exit_code
}

# Mostrar ayuda
show_help() {
    show_banner

    echo -e "${COLOR_BOLD}USAGE:${COLOR_RESET}"
    echo "  ./run.sh [OPTIONS]"
    echo ""

    echo -e "${COLOR_BOLD}OPTIONS:${COLOR_RESET}"
    echo "  -h, --help              Show this help message"
    echo "  -l, --list              List all available scripts"
    echo "  -r, --run <path>        Run a specific script directly"
    echo ""

    echo -e "${COLOR_BOLD}EXAMPLES:${COLOR_RESET}"
    echo "  ./run.sh                           # Interactive mode (recommended)"
    echo "  ./run.sh --list                    # List all scripts"
    echo "  ./run.sh --run scripts/backend/setup-backend.sh"
    echo ""

    echo -e "${COLOR_BOLD}INTERACTIVE MODE:${COLOR_RESET}"
    echo "  When run without arguments, you'll see an interactive menu where you can:"
    echo "  1. Browse categories using arrow keys (↑/↓)"
    echo "  2. Select a script to run"
    echo "  3. The script will execute and return to the menu"
    echo ""

    echo -e "${COLOR_BOLD}ADDING NEW SCRIPTS:${COLOR_RESET}"
    echo "  See CONTRIBUTING.md for information on how to add new scripts"
    echo ""
}

# Listar todos los scripts
list_scripts() {
    show_banner

    local -a categories
    IFS=' ' read -ra categories <<< "$(get_categories)"

    for category in "${categories[@]}"; do
        print_header "${category}"
        echo ""

        local scripts_data
        scripts_data=$(get_scripts_by_category "$category")

        while IFS= read -r line; do
            IFS='|' read -r name description path <<< "$line"
            echo -e "${COLOR_GREEN}●${COLOR_RESET} ${COLOR_BOLD}${name}${COLOR_RESET}"
            echo -e "  ${description}"
            echo -e "  ${COLOR_BLUE}Path:${COLOR_RESET} ${path}"
            echo ""
        done <<< "$scripts_data"
    done
}

# ============================================
# Main Function
# ============================================

main() {
    # Parsear argumentos
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_scripts
            exit 0
            ;;
        -r|--run)
            if [ -z "${2:-}" ]; then
                print_error "Please provide a script path"
                echo "Usage: ./run.sh --run <path>"
                exit 1
            fi
            run_script "$2"
            exit $?
            ;;
        "")
            # Modo interactivo
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac

    # Modo interactivo
    show_banner

    while true; do
        # Mostrar menú de categorías
        category=$(show_category_menu)

        # Si seleccionó Exit, salir
        if [ "$category" = "Exit" ]; then
            echo ""
            print_info "Thanks for using Shell Scripting Utilities! 👋"
            echo ""
            exit 0
        fi

        # Mostrar menú de scripts
        local script_path
        script_path=$(show_scripts_menu "$category")

        # Si seleccionó Back, volver al menú de categorías
        if [ -z "$script_path" ]; then
            clear
            show_banner
            continue
        fi

        # Ejecutar el script
        run_script "$script_path"

        # Preguntar si quiere ejecutar otro
        echo ""
        if confirm "Run another script?" "y"; then
            clear
            show_banner
            continue
        else
            echo ""
            print_info "Thanks for using Shell Scripting Utilities! 👋"
            echo ""
            exit 0
        fi
    done
}

# Ejecutar
main "$@"
