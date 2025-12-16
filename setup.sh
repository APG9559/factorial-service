#!/usr/bin/env bash

# GitHub Template Setup Script
# This script replaces {{NAMESPACE}} placeholders with your actual namespace

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== GitHub Template Setup ===${NC}"
echo ""

# Prompt for namespace
if [ -z "$1" ]; then
    echo -e "${YELLOW}Enter your namespace (e.g., my.service or MyService):${NC}"
    read -r NAMESPACE
else
    NAMESPACE="$1"
fi

if [ -z "$NAMESPACE" ]; then
    echo -e "${RED}Error: Namespace cannot be empty${NC}"
    exit 1
fi

# Validate namespace (basic check - should be valid C# namespace)
if [[ ! "$NAMESPACE" =~ ^[a-zA-Z][a-zA-Z0-9._]*$ ]]; then
    echo -e "${RED}Error: Invalid namespace format. Use alphanumeric characters, dots, and underscores.${NC}"
    exit 1
fi

echo -e "${GREEN}Using namespace: ${NAMESPACE}${NC}"
echo ""

# Check if template folders exist
if [ ! -d "{{NAMESPACE}}" ] || [ ! -d "{{NAMESPACE}}.Tests" ]; then
    echo -e "${RED}Error: Template folders not found. Make sure you're running this from the repository root.${NC}"
    exit 1
fi

# Function to replace in file
replace_in_file() {
    local file="$1"
    if [ -f "$file" ]; then
        # Use sed with different syntax for macOS vs Linux
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/{{NAMESPACE}}/${NAMESPACE}/g" "$file"
        else
            sed -i "s/{{NAMESPACE}}/${NAMESPACE}/g" "$file"
        fi
    fi
}

# Function to replace in all files recursively
replace_in_all_files() {
    local dir="$1"
    find "$dir" -type f \( -name "*.cs" -o -name "*.csproj" -o -name "*.sh" -o -name "Dockerfile" -o -name "*.md" -o -name "*.yml" -o -name "*.yaml" \) -exec bash -c 'replace_in_file "$0"' {} \;
}

echo -e "${YELLOW}Replacing placeholders in files...${NC}"

# Replace in all files
replace_in_all_files "{{NAMESPACE}}"
replace_in_all_files "{{NAMESPACE}}.Tests"
replace_in_file "run.sh"
replace_in_file "README.md"
replace_in_file "setup.sh"

echo -e "${GREEN}✓ Placeholders replaced${NC}"

# Rename folders
echo -e "${YELLOW}Renaming folders...${NC}"

if [ -d "{{NAMESPACE}}" ]; then
    mv "{{NAMESPACE}}" "${NAMESPACE}"
    echo -e "${GREEN}✓ Renamed {{NAMESPACE}} to ${NAMESPACE}${NC}"
fi

if [ -d "{{NAMESPACE}}.Tests" ]; then
    mv "{{NAMESPACE}}.Tests" "${NAMESPACE}.Tests"
    echo -e "${GREEN}✓ Renamed {{NAMESPACE}}.Tests to ${NAMESPACE}.Tests${NC}"
fi

# Update run.sh to use correct path
if [ -f "run.sh" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/cd {{NAMESPACE}}/cd ${NAMESPACE}/g" "run.sh"
    else
        sed -i "s/cd {{NAMESPACE}}/cd ${NAMESPACE}/g" "run.sh"
    fi
fi

echo ""
echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo ""
echo -e "Your project has been configured with namespace: ${GREEN}${NAMESPACE}${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes"
echo "  2. Run 'dotnet restore' in both project folders"
echo "  3. Run 'dotnet build' to verify everything compiles"
echo "  4. Update README.md with your project-specific information"
echo ""

