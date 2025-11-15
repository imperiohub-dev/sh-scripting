# Shell Scripting Utilities

A collection of useful shell scripts to automate common development tasks.

## 📦 Installation

Clone this repository to your local machine:

```bash
git clone <repository-url>
cd sh-scripting
```

Make sure the scripts have execution permissions:

```bash
chmod +x scripts/**/*.sh
```

## 📚 Available Scripts

### Backend Scripts

- **setup-backend.sh** - Create a Node.js backend project with Express
  - Supports TypeScript or JavaScript
  - Interactive configuration
  - Optional packages: CORS, dotenv, loggers, validators
  - Ready-to-use project structure

[View Backend Scripts Documentation](scripts/backend/README.md)

## 🚀 Usage

### Create a Backend Project

```bash
./scripts/backend/setup-backend.sh
```

The script will guide you through an interactive setup:
1. Choose project name
2. Select language (TypeScript or JavaScript)
3. Configure server port
4. Select optional packages
5. Choose development tool

The script will:
- Create a complete project structure
- Generate configuration files
- Install dependencies
- Leave everything ready to start coding

## 📁 Project Structure

```
sh-scripting/
├── lib/                    # Reusable libraries
│   ├── ui.sh              # UI functions (menus, prompts, colors)
│   ├── file-utils.sh      # File operations utilities
│   ├── package-manager.sh # Package manager detection and usage
│   └── validators.sh      # Input validation functions
├── scripts/               # Executable scripts
│   └── backend/          # Backend-related scripts
│       ├── setup-backend.sh
│       └── README.md
├── templates/            # File templates
│   └── backend-ts/      # Backend templates
│       └── files/
└── README.md            # This file
```

## 🛠️ Library Functions

### UI Library (`lib/ui.sh`)

Interactive UI components:
- `select_option` - Menu with arrow key navigation
- `multi_select` - Multi-selection menu with spacebar
- `input` - Text input with default values
- `confirm` - Yes/No confirmation
- `print_success/error/info/warning` - Colored messages
- `print_header` - Formatted section headers

### File Utils (`lib/file-utils.sh`)

File and directory operations:
- `create_directory_structure` - Create multiple directories
- `create_file_from_template` - Generate files from templates
- `create_file` - Create file with content
- `create_gitignore` - Generate .gitignore
- `create_package_json` - Generate package.json
- `create_tsconfig` - Generate tsconfig.json

### Package Manager (`lib/package-manager.sh`)

Package manager operations:
- `detect_package_manager` - Auto-detect npm/yarn/pnpm
- `install_dependencies` - Install with detected manager
- `get_run_command` - Get correct run command for scripts

### Validators (`lib/validators.sh`)

Input validation:
- `validate_project_name` - Validate project names
- `validate_port` - Validate port numbers
- `validate_node_version` - Check Node.js version
- `check_directory_available` - Verify directory is available

## 🔧 Creating New Scripts

When creating new scripts, you can reuse the library functions:

```bash
#!/bin/bash

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Import libraries
source "${ROOT_DIR}/lib/ui.sh"
source "${ROOT_DIR}/lib/file-utils.sh"
source "${ROOT_DIR}/lib/package-manager.sh"
source "${ROOT_DIR}/lib/validators.sh"

# Your script logic here
print_header "My Script"

project_name=$(input "Project name" "my-project")
language=$(select_option "Language" "TypeScript" "JavaScript")

# ... more logic
```

## 🎨 Features

- **Interactive UI** - User-friendly menus with arrow key navigation
- **Validation** - Input validation for all user inputs
- **Flexible** - Support for multiple package managers (npm, yarn, pnpm)
- **Modular** - Reusable library functions
- **Colorful** - Color-coded messages for better readability
- **Error Handling** - Proper error checking and user feedback

## 📝 Requirements

- **Node.js** >= 14.x (for backend scripts)
- **Bash** >= 4.0
- **Package Manager** (npm, yarn, or pnpm)

## 🤝 Contributing

Feel free to add new scripts and utilities! Follow the existing structure:

1. Place reusable functions in `lib/`
2. Create script-specific code in `scripts/[category]/`
3. Add templates in `templates/[category]/`
4. Update documentation

## 📄 License

MIT

## 🔮 Future Scripts

Planned additions:
- Frontend setup scripts (React, Vue, Angular)
- Database setup scripts
- Docker configuration generators
- CI/CD pipeline generators
- Testing setup scripts
