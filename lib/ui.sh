#!/bin/bash

# ============================================
# UI Library - Funciones de interfaz de usuario
# ============================================

# Colores
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_BOLD='\033[1m'

# ============================================
# Mensajes formateados
# ============================================

print_success() {
    echo -e "${COLOR_GREEN}✓${COLOR_RESET} $1"
}

print_error() {
    echo -e "${COLOR_RED}✗${COLOR_RESET} $1"
}

print_info() {
    echo -e "${COLOR_BLUE}ℹ${COLOR_RESET} $1"
}

print_warning() {
    echo -e "${COLOR_YELLOW}⚠${COLOR_RESET} $1"
}

print_header() {
    echo ""
    echo -e "${COLOR_BOLD}${COLOR_CYAN}$1${COLOR_RESET}"
    echo -e "${COLOR_CYAN}$(printf '=%.0s' {1..50})${COLOR_RESET}"
    echo ""
}

# ============================================
# Input de texto con valor por defecto
# ============================================

input() {
    local prompt="$1"
    local default="$2"
    local result

    if [ -n "$default" ]; then
        echo -ne "${COLOR_CYAN}?${COLOR_RESET} ${prompt} ${COLOR_BOLD}(${default})${COLOR_RESET}: "
    else
        echo -ne "${COLOR_CYAN}?${COLOR_RESET} ${prompt}: "
    fi

    read -r result

    if [ -z "$result" ] && [ -n "$default" ]; then
        echo "$default"
    else
        echo "$result"
    fi
}

# ============================================
# Confirmación Sí/No
# ============================================

confirm() {
    local prompt="$1"
    local default="${2:-y}" # y or n
    local response

    if [ "$default" = "y" ]; then
        echo -ne "${COLOR_CYAN}?${COLOR_RESET} ${prompt} ${COLOR_BOLD}(Y/n)${COLOR_RESET}: "
    else
        echo -ne "${COLOR_CYAN}?${COLOR_RESET} ${prompt} ${COLOR_BOLD}(y/N)${COLOR_RESET}: "
    fi

    read -r response
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

    if [ -z "$response" ]; then
        response="$default"
    fi

    [[ "$response" =~ ^(y|yes|si|s)$ ]]
}

# ============================================
# Menú de selección con flechas
# ============================================

select_option() {
    local prompt="$1"
    shift
    local options=("$@")
    local selected=0
    local key

    # Ocultar cursor
    tput civis

    # Función para limpiar las líneas del menú
    clear_menu() {
        for i in "${!options[@]}"; do
            tput cuu1  # Mover cursor arriba
            tput el    # Limpiar línea
        done
        tput cuu1
        tput el
    }

    # Mostrar menú
    render_menu() {
        echo -e "${COLOR_CYAN}?${COLOR_RESET} ${prompt}"
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e "  ${COLOR_CYAN}❯ ${options[$i]}${COLOR_RESET}"
            else
                echo -e "    ${options[$i]}"
            fi
        done
    }

    # Renderizar inicial
    render_menu

    # Capturar teclas
    while true; do
        # Leer una tecla sin esperar Enter
        read -rsn1 key

        # Manejar secuencias de escape (flechas)
        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
            case "$key" in
                '[A') # Flecha arriba
                    if [ $selected -gt 0 ]; then
                        ((selected--))
                    fi
                    ;;
                '[B') # Flecha abajo
                    if [ $selected -lt $((${#options[@]} - 1)) ]; then
                        ((selected++))
                    fi
                    ;;
            esac
            clear_menu
            render_menu
        elif [[ $key == "" ]]; then
            # Enter presionado
            break
        fi
    done

    # Mostrar cursor nuevamente
    tput cnorm

    # Limpiar y mostrar selección final
    clear_menu
    echo -e "${COLOR_CYAN}?${COLOR_RESET} ${prompt} ${COLOR_GREEN}${options[$selected]}${COLOR_RESET}"

    # Retornar opción seleccionada
    echo "${options[$selected]}"
}

# ============================================
# Spinner para procesos largos
# ============================================

show_spinner() {
    local pid=$1
    local message="$2"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    tput civis # Ocultar cursor

    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r${COLOR_CYAN}${spin:$i:1}${COLOR_RESET} ${message}..."
        sleep 0.1
    done

    tput cnorm # Mostrar cursor
    printf "\r"
}

# ============================================
# Menú multi-selección con espaciadora
# ============================================

multi_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local selected=0
    local -a checked=()
    local key

    # Inicializar array de checked
    for i in "${!options[@]}"; do
        checked[$i]=false
    done

    tput civis

    clear_menu() {
        for i in "${!options[@]}"; do
            tput cuu1
            tput el
        done
        tput cuu1
        tput el
        tput cuu1
        tput el
    }

    render_menu() {
        echo -e "${COLOR_CYAN}?${COLOR_RESET} ${prompt} ${COLOR_BOLD}(use space to select, enter to confirm)${COLOR_RESET}"
        for i in "${!options[@]}"; do
            local check_mark="[ ]"
            if [ "${checked[$i]}" = true ]; then
                check_mark="${COLOR_GREEN}[✓]${COLOR_RESET}"
            fi

            if [ $i -eq $selected ]; then
                echo -e "  ${COLOR_CYAN}❯${COLOR_RESET} $check_mark ${options[$i]}"
            else
                echo -e "    $check_mark ${options[$i]}"
            fi
        done
    }

    render_menu

    while true; do
        read -rsn1 key

        if [[ $key == $'\x1b' ]]; then
            read -rsn2 key
            case "$key" in
                '[A') # Arriba
                    if [ $selected -gt 0 ]; then
                        ((selected--))
                    fi
                    ;;
                '[B') # Abajo
                    if [ $selected -lt $((${#options[@]} - 1)) ]; then
                        ((selected++))
                    fi
                    ;;
            esac
            clear_menu
            render_menu
        elif [[ $key == " " ]]; then
            # Espaciadora - toggle selección
            if [ "${checked[$selected]}" = true ]; then
                checked[$selected]=false
            else
                checked[$selected]=true
            fi
            clear_menu
            render_menu
        elif [[ $key == "" ]]; then
            # Enter
            break
        fi
    done

    tput cnorm
    clear_menu

    # Mostrar seleccionados
    local selected_items=()
    for i in "${!options[@]}"; do
        if [ "${checked[$i]}" = true ]; then
            selected_items+=("${options[$i]}")
        fi
    done

    echo -e "${COLOR_CYAN}?${COLOR_RESET} ${prompt} ${COLOR_GREEN}${selected_items[*]}${COLOR_RESET}"

    # Retornar items seleccionados separados por coma
    IFS=','
    echo "${selected_items[*]}"
}
