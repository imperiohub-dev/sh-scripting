#!/bin/bash

# ============================================
# Backend Project Setup Script
# Creates a Node.js backend with Express
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

# Templates directory
TEMPLATES_DIR="${ROOT_DIR}/templates/backend-ts/files"

# ============================================
# Main Function
# ============================================

main() {
    print_header "🚀 Backend Project Setup"

    # Step 1: Validar Node.js instalado
    if ! validate_node_version 14; then
        exit 1
    fi

    # Step 2: Solicitar nombre del proyecto
    local project_name
    while true; do
        project_name=$(input "Project name" "my-backend")
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

    # Step 3: Seleccionar lenguaje
    local language
    language=$(select_option_simple "Select language" "TypeScript" "JavaScript")
    language=$(echo "$language" | tr '[:upper:]' '[:lower:]')

    # Step 4: Seleccionar puerto
    local port
    while true; do
        port=$(input "Server port" "3000")
        if validate_port "$port"; then
            break
        fi
    done

    # Step 5: Seleccionar dependencias opcionales
    echo ""
    local optional_packages
    optional_packages=$(multi_select_simple "Optional packages" \
        "CORS" \
        "dotenv" \
        "helmet (security)" \
        "bcrypt (encryption)" \
        "jsonwebtoken (JWT)" \
        "passport (authentication)" \
        "express-validator (validation)" \
        "zod (validation)" \
        "joi (validation)" \
        "mongoose (MongoDB)" \
        "express-rate-limit (rate limiting)" \
        "compression (response compression)" \
        "cookie-parser (cookie parsing)" \
        "multer (file uploads)" \
        "nodemailer (email)" \
        "axios (HTTP client)" \
        "uuid (unique IDs)" \
        "morgan (logger)" \
        "winston (logger)")

    # Parsear selecciones
    local use_cors=false
    local use_dotenv=false
    local use_helmet=false
    local use_bcrypt=false
    local use_jwt=false
    local use_passport=false
    local use_express_validator=false
    local use_mongoose=false
    local use_rate_limit=false
    local use_compression=false
    local use_cookie_parser=false
    local use_multer=false
    local use_nodemailer=false
    local use_axios=false
    local use_uuid=false
    local logger="none"
    local validator="none"

    IFS=',' read -ra PACKAGES <<< "$optional_packages"
    for package in "${PACKAGES[@]}"; do
        case "$package" in
            *"CORS"*) use_cors=true ;;
            *"dotenv"*) use_dotenv=true ;;
            *"helmet"*) use_helmet=true ;;
            *"bcrypt"*) use_bcrypt=true ;;
            *"jsonwebtoken"*) use_jwt=true ;;
            *"passport"*) use_passport=true ;;
            *"express-validator"*) use_express_validator=true ;;
            *"mongoose"*) use_mongoose=true ;;
            *"express-rate-limit"*) use_rate_limit=true ;;
            *"compression"*) use_compression=true ;;
            *"cookie-parser"*) use_cookie_parser=true ;;
            *"multer"*) use_multer=true ;;
            *"nodemailer"*) use_nodemailer=true ;;
            *"axios"*) use_axios=true ;;
            *"uuid"*) use_uuid=true ;;
            *"morgan"*) logger="morgan" ;;
            *"winston"*) logger="winston" ;;
            *"zod"*) validator="zod" ;;
            *"joi"*) validator="joi" ;;
        esac
    done

    # Step 6: Seleccionar herramienta de desarrollo
    local dev_tool
    if [ "$language" = "typescript" ]; then
        dev_tool=$(select_option_simple "Development tool" "tsx" "ts-node + nodemon")
    else
        dev_tool="nodemon"
    fi

    echo ""
    print_header "📦 Creating Project Structure"

    # Step 7: Crear directorio del proyecto
    mkdir -p "$project_name"
    cd "$project_name"
    local project_dir
    project_dir=$(pwd)

    # Step 8: Crear estructura de carpetas
    create_directory_structure "$project_dir" \
        "src" \
        "src/config" \
        "src/controllers" \
        "src/middlewares" \
        "src/models" \
        "src/routes" \
        "src/services" \
        "src/utils"

    # Step 9: Preparar dependencias
    local dependencies=""
    local dev_dependencies=""

    # Express siempre
    dependencies+="    \"express\": \"^4.18.2\""

    # Opcionales
    if [ "$use_cors" = true ]; then
        dependencies+=",\n    \"cors\": \"^2.8.5\""
    fi

    if [ "$use_dotenv" = true ]; then
        dependencies+=",\n    \"dotenv\": \"^16.3.1\""
    fi

    if [ "$use_helmet" = true ]; then
        dependencies+=",\n    \"helmet\": \"^7.1.0\""
    fi

    if [ "$use_bcrypt" = true ]; then
        dependencies+=",\n    \"bcrypt\": \"^5.1.1\""
    fi

    if [ "$use_jwt" = true ]; then
        dependencies+=",\n    \"jsonwebtoken\": \"^9.0.2\""
    fi

    if [ "$use_passport" = true ]; then
        dependencies+=",\n    \"passport\": \"^0.7.0\",\n    \"passport-local\": \"^1.0.0\""
    fi

    if [ "$use_express_validator" = true ]; then
        dependencies+=",\n    \"express-validator\": \"^7.0.1\""
    fi

    if [ "$use_mongoose" = true ]; then
        dependencies+=",\n    \"mongoose\": \"^8.0.3\""
    fi

    if [ "$use_rate_limit" = true ]; then
        dependencies+=",\n    \"express-rate-limit\": \"^7.1.5\""
    fi

    if [ "$use_compression" = true ]; then
        dependencies+=",\n    \"compression\": \"^1.7.4\""
    fi

    if [ "$use_cookie_parser" = true ]; then
        dependencies+=",\n    \"cookie-parser\": \"^1.4.6\""
    fi

    if [ "$use_multer" = true ]; then
        dependencies+=",\n    \"multer\": \"^1.4.5-lts.1\""
    fi

    if [ "$use_nodemailer" = true ]; then
        dependencies+=",\n    \"nodemailer\": \"^6.9.7\""
    fi

    if [ "$use_axios" = true ]; then
        dependencies+=",\n    \"axios\": \"^1.6.2\""
    fi

    if [ "$use_uuid" = true ]; then
        dependencies+=",\n    \"uuid\": \"^9.0.1\""
    fi

    case "$logger" in
        morgan)
            dependencies+=",\n    \"morgan\": \"^1.10.0\""
            ;;
        winston)
            dependencies+=",\n    \"winston\": \"^3.11.0\""
            ;;
    esac

    case "$validator" in
        zod)
            dependencies+=",\n    \"zod\": \"^3.22.4\""
            ;;
        joi)
            dependencies+=",\n    \"joi\": \"^17.11.0\""
            ;;
    esac

    # DevDependencies según lenguaje
    if [ "$language" = "typescript" ]; then
        dev_dependencies="    \"typescript\": \"^5.3.3\",\n    \"@types/node\": \"^20.10.5\",\n    \"@types/express\": \"^4.17.21\""

        if [ "$use_cors" = true ]; then
            dev_dependencies+=",\n    \"@types/cors\": \"^2.8.17\""
        fi

        if [ "$use_bcrypt" = true ]; then
            dev_dependencies+=",\n    \"@types/bcrypt\": \"^5.0.2\""
        fi

        if [ "$use_jwt" = true ]; then
            dev_dependencies+=",\n    \"@types/jsonwebtoken\": \"^9.0.5\""
        fi

        if [ "$use_passport" = true ]; then
            dev_dependencies+=",\n    \"@types/passport\": \"^1.0.16\",\n    \"@types/passport-local\": \"^1.0.38\""
        fi

        if [ "$use_compression" = true ]; then
            dev_dependencies+=",\n    \"@types/compression\": \"^1.7.5\""
        fi

        if [ "$use_cookie_parser" = true ]; then
            dev_dependencies+=",\n    \"@types/cookie-parser\": \"^1.4.6\""
        fi

        if [ "$use_multer" = true ]; then
            dev_dependencies+=",\n    \"@types/multer\": \"^1.4.11\""
        fi

        if [ "$use_nodemailer" = true ]; then
            dev_dependencies+=",\n    \"@types/nodemailer\": \"^6.4.14\""
        fi

        if [ "$use_uuid" = true ]; then
            dev_dependencies+=",\n    \"@types/uuid\": \"^9.0.7\""
        fi

        if [ "$logger" = "morgan" ]; then
            dev_dependencies+=",\n    \"@types/morgan\": \"^1.9.9\""
        fi

        if [ "$dev_tool" = "tsx" ]; then
            dev_dependencies+=",\n    \"tsx\": \"^4.7.0\""
        else
            dev_dependencies+=",\n    \"ts-node\": \"^10.9.2\",\n    \"nodemon\": \"^3.0.2\""
        fi
    else
        dev_dependencies="    \"nodemon\": \"^3.0.2\""
    fi

    # Step 10: Crear archivos de configuración
    echo ""
    print_info "Creating configuration files..."
    echo ""

    create_package_json "$project_dir" "$project_name" "$language" "$dependencies" "$dev_dependencies"
    create_gitignore "$project_dir" "$language"

    if [ "$language" = "typescript" ]; then
        create_tsconfig "$project_dir"
    fi

    if [ "$use_dotenv" = true ]; then
        create_env_example "$project_dir" "$port"
    fi

    # Step 11: Crear archivo principal (index)
    echo ""
    print_info "Creating source files..."
    echo ""

    local index_template
    local index_file
    local routes_template
    local routes_file

    if [ "$language" = "typescript" ]; then
        index_template="${TEMPLATES_DIR}/index.ts.template"
        index_file="${project_dir}/src/index.ts"
        routes_template="${TEMPLATES_DIR}/user.routes.ts.template"
        routes_file="${project_dir}/src/routes/user.routes.ts"
    else
        index_template="${TEMPLATES_DIR}/index.js.template"
        index_file="${project_dir}/src/index.js"
        routes_template="${TEMPLATES_DIR}/user.routes.js.template"
        routes_file="${project_dir}/src/routes/user.routes.js"
    fi

    # Preparar contenido del index
    local index_content
    index_content=$(cat "$index_template")

    # Reemplazar variables
    index_content="${index_content//\{\{PROJECT_NAME\}\}/$project_name}"
    index_content="${index_content//\{\{PORT\}\}/$port}"

    # Agregar imports según selecciones
    local cors_import=""
    local cors_middleware=""
    local dotenv_import=""
    local dotenv_config=""
    local logger_middleware=""

    if [ "$use_cors" = true ]; then
        if [ "$language" = "typescript" ]; then
            cors_import="\nimport cors from 'cors';"
            cors_middleware="\napp.use(cors());"
        else
            cors_import="\nconst cors = require('cors');"
            cors_middleware="\napp.use(cors());"
        fi
    fi

    if [ "$use_dotenv" = true ]; then
        if [ "$language" = "typescript" ]; then
            dotenv_import="\nimport dotenv from 'dotenv';"
            dotenv_config="\ndotenv.config();"
        else
            dotenv_import="\nconst dotenv = require('dotenv');"
            dotenv_config="\ndotenv.config();"
        fi
    fi

    if [ "$logger" = "morgan" ]; then
        if [ "$language" = "typescript" ]; then
            index_content="${index_content//{{CORS_IMPORT}}/$cors_import\nimport morgan from 'morgan';}"
            logger_middleware="\napp.use(morgan('dev'));"
        else
            index_content="${index_content//{{CORS_IMPORT}}/$cors_import\nconst morgan = require('morgan');}"
            logger_middleware="\napp.use(morgan('dev'));"
        fi
    fi

    index_content="${index_content//{{CORS_IMPORT}}/$cors_import}"
    index_content="${index_content//{{DOTENV_IMPORT}}/$dotenv_import}"
    index_content="${index_content//{{DOTENV_CONFIG}}/$dotenv_config}"
    index_content="${index_content//{{CORS_MIDDLEWARE}}/$cors_middleware}"
    index_content="${index_content//{{LOGGER_MIDDLEWARE}}/$logger_middleware}"

    # Escribir archivo index
    echo "$index_content" > "$index_file"
    print_success "Created: src/$(basename "$index_file")"

    # Crear ruta de ejemplo
    cp "$routes_template" "$routes_file"
    print_success "Created: src/routes/$(basename "$routes_file") (example)"

    # Step 12: Crear README básico
    local readme_content="# ${project_name}

Backend project with Express and ${language^}

## Getting Started

1. Install dependencies:
\`\`\`bash
npm install
\`\`\`
"

    if [ "$use_dotenv" = true ]; then
        readme_content+="
2. Create \`.env\` file from template:
\`\`\`bash
cp .env.example .env
\`\`\`

3. Run development server:
"
    else
        readme_content+="
2. Run development server:
"
    fi

    readme_content+="\`\`\`bash
npm run dev
\`\`\`

## Available Scripts

- \`npm run dev\` - Start development server
- \`npm run build\` - Build for production (TypeScript only)
- \`npm start\` - Start production server

## Project Structure

\`\`\`
src/
├── config/       # Configuration files
├── controllers/  # Route controllers
├── middlewares/  # Custom middlewares
├── models/       # Data models
├── routes/       # API routes
├── services/     # Business logic
└── utils/        # Utility functions
\`\`\`
"

    echo "$readme_content" > "${project_dir}/README.md"
    print_success "Created: README.md"

    # Step 13: Instalar dependencias
    echo ""
    print_header "📥 Installing Dependencies"
    echo ""

    if ! install_dependencies "$project_dir"; then
        print_warning "Failed to install dependencies. You can install them manually later."
    fi

    # Step 14: Mensaje final
    echo ""
    print_header "✅ Project Created Successfully!"
    echo ""
    print_success "Project '${project_name}' is ready!"
    echo ""
    print_info "Next steps:"
    echo ""
    echo "  cd ${project_name}"

    if [ "$use_dotenv" = true ]; then
        echo "  cp .env.example .env    # Configure your environment variables"
    fi

    echo "  $(get_run_command dev)        # Start development server"
    echo ""
    print_info "Your API will be running at: http://localhost:${port}"
    echo ""
}

# Run main function
main "$@"
