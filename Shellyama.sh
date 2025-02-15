#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display models
display_models() {
    echo -e "${BLUE}Currently installed Ollama models:${NC}\n"
    ollama list 2>/dev/null | tail -n +2 | nl -w2 -s') '
}

# Function to get model name by number
get_model_name() {
    local number=$1
    local model_name=$(ollama list 2>/dev/null | tail -n +2 | sed -n "${number}p" | awk '{print $1}')
    echo "$model_name"
}

# Function to validate number
is_number() {
    case $1 in
        ''|*[!0-9]*) return 1 ;;
        *) return 0 ;;
    esac
}

# Main script
clear
echo -e "${GREEN}=== Ollama Model Manager ===${NC}\n"

# Display initial model list
display_models

echo -e "\n${YELLOW}Enter the numbers of models to delete (space-separated) or 'q' to quit:${NC}"
read -r input

if [ "$input" = "q" ]; then
    echo -e "\n${GREEN}Exiting. Current models:${NC}\n"
    ollama list 2>/dev/null
    exit 0
fi

# Process each number entered
for number in $input; do
    if ! is_number "$number"; then
        echo -e "${RED}Invalid input: $number is not a number${NC}"
        continue
    fi

    model_name=$(get_model_name "$number")
    
    if [ -z "$model_name" ]; then
        echo -e "${RED}Invalid model number: $number${NC}"
        continue
    fi

    echo -e "${YELLOW}Deleting model: $model_name${NC}"
    ollama rm "$model_name" 2>/dev/null
done

echo -e "\n${GREEN}Operation completed. Current models:${NC}\n"
ollama list 2>/dev/null 