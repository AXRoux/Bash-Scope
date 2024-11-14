#!/bin/bash

# Color definitions for output formatting (using subtle colors)
export RED='\033[38;5;167m'    # Soft red
export GREEN='\033[38;5;71m'   # Soft green
export YELLOW='\033[38;5;179m' # Soft yellow
export BLUE='\033[38;5;67m'    # Soft blue
export MAGENTA='\033[38;5;132m' # Soft magenta
export CYAN='\033[38;5;73m'    # Soft cyan
export GRAY='\033[38;5;246m'   # Soft gray for less important text
export BOLD='\033[1m'          # Bold text
export RESET='\033[0m'         # Reset formatting

# Function to print colored headers
print_header() {
    echo -e "${BLUE}${BOLD}$1${RESET}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${RESET}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${RESET}" >&2
}

# Function to print warnings
print_warning() {
    echo -e "${YELLOW}⚠ $1${RESET}"
}

# Function to print information
print_info() {
    echo -e "${CYAN}ℹ $1${RESET}"
}

# Function to print less important information
print_secondary() {
    echo -e "${GRAY}$1${RESET}"
}
