#!/bin/bash

# ============================================
# File Utils Library - Utilidades para manejo de archivos
# ============================================

# Crear múltiples directorios
create_directory_structure() {
    local base_dir="$1"
    shift
    local dirs=("$@")

    for dir in "${dirs[@]}"; do
        local full_path="${base_dir}/${dir}"
        if mkdir -p "$full_path" 2>/dev/null; then
            print_success "Created: ${dir}/"
        else
            print_error "Failed to create: ${dir}/"
            return 1
        fi
    done
}

# Crear archivo desde template
create_file_from_template() {
    local template_file="$1"
    local output_file="$2"
    shift 2
    local -A replacements=()

    # Parsear los reemplazos (formato: KEY=VALUE KEY2=VALUE2)
    while [ $# -gt 0 ]; do
        local key="${1%%=*}"
        local value="${1#*=}"
        replacements["$key"]="$value"
        shift
    done

    if [ ! -f "$template_file" ]; then
        print_error "Template not found: $template_file"
        return 1
    fi

    # Leer template
    local content
    content=$(cat "$template_file")

    # Reemplazar variables
    for key in "${!replacements[@]}"; do
        content="${content//\{\{${key}\}\}/${replacements[$key]}}"
    done

    # Escribir archivo
    echo "$content" > "$output_file"

    if [ $? -eq 0 ]; then
        print_success "Created: $(basename "$output_file")"
    else
        print_error "Failed to create: $(basename "$output_file")"
        return 1
    fi
}

# Crear archivo con contenido directo
create_file() {
    local file_path="$1"
    local content="$2"

    # Crear directorio padre si no existe
    local dir
    dir=$(dirname "$file_path")
    mkdir -p "$dir"

    echo "$content" > "$file_path"

    if [ $? -eq 0 ]; then
        print_success "Created: $(basename "$file_path")"
    else
        print_error "Failed to create: $(basename "$file_path")"
        return 1
    fi
}

# Agregar contenido a un archivo
append_to_file() {
    local file_path="$1"
    local content="$2"

    echo "$content" >> "$file_path"
}

# Verificar si un directorio está vacío
is_directory_empty() {
    local dir="$1"

    if [ ! -d "$dir" ]; then
        return 0 # No existe, considerarlo "vacío"
    fi

    if [ -z "$(ls -A "$dir" 2>/dev/null)" ]; then
        return 0 # Está vacío
    else
        return 1 # Tiene contenido
    fi
}

# Copiar template completo a destino
copy_template() {
    local template_dir="$1"
    local dest_dir="$2"

    if [ ! -d "$template_dir" ]; then
        print_error "Template directory not found: $template_dir"
        return 1
    fi

    cp -r "$template_dir"/* "$dest_dir/" 2>/dev/null
}

# Crear .gitignore
create_gitignore() {
    local project_dir="$1"
    local language="$2" # typescript o javascript

    local content="# Dependencies
node_modules/
package-lock.json
yarn.lock
pnpm-lock.yaml

# Environment variables
.env
.env.local
.env.*.local

# Build output
dist/
build/
*.tsbuildinfo

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Testing
coverage/
.nyc_output/
"

    if [ "$language" = "typescript" ]; then
        content="${content}
# TypeScript
*.js
*.d.ts
!jest.config.js
"
    fi

    create_file "${project_dir}/.gitignore" "$content"
}

# Crear package.json
create_package_json() {
    local project_dir="$1"
    local project_name="$2"
    local language="$3"
    local dependencies="$4"
    local dev_dependencies="$5"

    local scripts
    if [ "$language" = "typescript" ]; then
        scripts='    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"'
    else
        scripts='    "dev": "nodemon src/index.js",
    "start": "node src/index.js"'
    fi

    local content="{
  \"name\": \"${project_name}\",
  \"version\": \"1.0.0\",
  \"description\": \"Backend project with Express\",
  \"main\": \"src/index.js\",
  \"scripts\": {
${scripts}
  },
  \"keywords\": [],
  \"author\": \"\",
  \"license\": \"ISC\",
  \"dependencies\": {
${dependencies}
  },
  \"devDependencies\": {
${dev_dependencies}
  }
}
"

    create_file "${project_dir}/package.json" "$content"
}

# Crear tsconfig.json
create_tsconfig() {
    local project_dir="$1"

    local content='{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
'

    create_file "${project_dir}/tsconfig.json" "$content"
}

# Crear archivo .env.example
create_env_example() {
    local project_dir="$1"
    local port="$2"

    local content="# Server Configuration
PORT=${port}
NODE_ENV=development

# Add your environment variables here
"

    create_file "${project_dir}/.env.example" "$content"
}
