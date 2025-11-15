# @imperiohub/cli

> CLI tool for quickly setting up backend projects with Express, TypeScript/JavaScript, and popular packages

A collection of useful shell scripts to automate common development tasks through an interactive terminal interface.

## 🚀 Quick Start

### Via NPM (Recommended)

```bash
# Run directly with npx (no installation needed)
npx @imperiohub/cli

# Or install globally
npm install -g @imperiohub/cli

# Then run
imperiohub
```

### Via Git Clone

```bash
# Clone the repository
git clone https://github.com/imperiohub-dev/sh-scripting.git
cd sh-scripting

# Run the interactive launcher
./run.sh
```

That's it! The launcher will guide you through all available scripts with an interactive menu.

## 📦 Installation

### Option 1: NPM Package (Recommended)

Install globally to use anywhere:

```bash
npm install -g @imperiohub/cli
```

Or run without installing:

```bash
npx @imperiohub/cli
```

### Option 2: Clone Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/imperiohub-dev/sh-scripting.git
cd sh-scripting
```

### Option 1: Automatic (Recommended)

The launcher script will automatically make scripts executable when needed:

```bash
./run.sh
```

If you get a permission denied error on first run, make run.sh executable:

```bash
chmod +x run.sh
./run.sh
```

### Option 2: Manual Setup

Make all scripts executable at once:

```bash
chmod +x run.sh
chmod +x lib/*.sh
chmod +x scripts/**/*.sh
```

Or use find:

```bash
find . -name "*.sh" -type f -exec chmod +x {} \;
```

## 🎯 Main Launcher

The easiest way to use this toolkit is through the main launcher:

```bash
./run.sh              # Interactive mode (recommended)
./run.sh --list       # List all available scripts
./run.sh --help       # Show help
./run.sh --run <path> # Run a specific script directly
```

### Interactive Mode

When you run `./run.sh` without arguments, you'll see:

1. **Welcome banner** with branding
2. **Category selection** - Browse categories with arrow keys (↑/↓)
3. **Script selection** - Choose a script from the category
4. **Script execution** - The script runs and shows results
5. **Continue prompt** - Run another script or exit

### Features

- ✨ **Beautiful UI** with colors and emojis
- ⌨️ **Keyboard navigation** with arrow keys
- 📂 **Organized by categories** (Backend, Frontend, Database, etc.)
- 🔄 **Run multiple scripts** in one session
- 📋 **List all scripts** with descriptions
- 🎯 **Direct execution** of specific scripts

## 📚 Available Scripts

### Backend Scripts

- **Setup Backend Project** - Create a Node.js backend with Express
  - Supports TypeScript or JavaScript
  - Interactive configuration
  - **30+ Optional packages**:
    - **Security**: helmet, bcrypt, jsonwebtoken, passport
    - **Validation**: express-validator, zod, joi
    - **Database**: mongoose (MongoDB)
    - **Performance**: compression, express-rate-limit
    - **Utilities**: axios, uuid, multer, nodemailer, cookie-parser
    - **Logging**: morgan, winston
    - **Basics**: CORS, dotenv
  - Ready-to-use project structure with best practices
  - Automatic dependency installation
  - TypeScript support with types included

[View Backend Scripts Documentation](scripts/backend/README.md)

## 💡 Usage Examples

### Interactive Mode (Recommended)

```bash
./run.sh
```

Then use arrow keys to navigate:
```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║           🚀  Shell Scripting Utilities  🚀          ║
║                                                       ║
║         Your Swiss Army Knife for Dev Tasks          ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

? Choose a category
  ❯ Backend
    Frontend
    Database
    Exit
```

### List All Scripts

```bash
./run.sh --list
```

### Run Specific Script Directly

```bash
./run.sh --run scripts/backend/setup-backend.sh
```

Or run the script directly:

```bash
./scripts/backend/setup-backend.sh
```

## 📁 Project Structure

```
sh-scripting/
├── run.sh                 # ⭐ Main launcher (start here!)
├── CONTRIBUTING.md        # Guide for adding new scripts
├── lib/                   # Reusable libraries
│   ├── ui.sh             # UI functions (menus, prompts, colors)
│   ├── file-utils.sh     # File operations utilities
│   ├── package-manager.sh # Package manager detection and usage
│   └── validators.sh     # Input validation functions
├── scripts/              # Executable scripts organized by category
│   └── backend/         # Backend-related scripts
│       ├── setup-backend.sh
│       └── README.md
├── templates/           # File templates used by scripts
│   └── backend-ts/     # Backend templates
│       └── files/
└── README.md           # This file
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

Want to add a new script? It's easy!

**Quick steps:**
1. Create your script in `scripts/[category]/`
2. Add it to the registry in [run.sh](run.sh)
3. Done! It will appear in the interactive menu

**For detailed instructions**, see [CONTRIBUTING.md](CONTRIBUTING.md) which includes:
- How to structure your script
- Using the library functions
- Registering scripts in the launcher
- Best practices and examples
- Complete templates

## 📄 License

MIT

## 🔮 Future Scripts

Planned additions:
- Frontend setup scripts (React, Vue, Angular)
- Database setup scripts
- Docker configuration generators
- CI/CD pipeline generators
- Testing setup scripts
