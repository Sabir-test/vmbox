#!/bin/bash
set -e

WORKSPACE_ROOT="$HOME/dev"
TEMPLATE_PATH="$WORKSPACE_ROOT/vmbox/templates/devcontainer/devcontainer.template.json"
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

PROJECT_DIR="$WORKSPACE_ROOT/$PROJECT_NAME"

if [ -d "$PROJECT_DIR" ]; then
  echo "Error: Directory $PROJECT_DIR already exists."
  exit 1
fi

echo "Creating project $PROJECT_NAME..."
mkdir -p "$PROJECT_DIR/.devcontainer"

# Process template
sed "s/\${project_name}/$PROJECT_NAME/g" "$TEMPLATE_PATH" > "$PROJECT_DIR/.devcontainer/devcontainer.json"

# Create .envrc stub
echo "export PROJECT_NAME=$PROJECT_NAME" > "$PROJECT_DIR/.envrc"
echo "# Add project-specific env vars here" >> "$PROJECT_DIR/.envrc"

# Initialize git
cd "$PROJECT_DIR"
git init
echo ".envrc" >> .gitignore
echo ".env" >> .gitignore
echo "node_modules/" >> .gitignore
echo "__pycache__/" >> .gitignore
echo ".venv/" >> .gitignore

echo "Project $PROJECT_NAME created at $PROJECT_DIR"
echo "Run 'devpod up .' inside the directory to start."
