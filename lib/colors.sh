#!/bin/bash

# Color definitions for output formatting
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export MAGENTA='\033[0;35m'
export CYAN='\033[0;36m'
export RESET='\033[0m'

# Function to print colored headers
print_header() {
    echo -e "${BLUE}==== $1 ====${RESET}"
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
