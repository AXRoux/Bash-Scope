#!/bin/bash

# Default config file location
CONFIG_FILE="config/sysscope.yaml"

# Function to check if Python and PyYAML are available
check_yaml_support() {
    if ! command -v python3 &> /dev/null; then
        print_error "Python3 is required for configuration support"
        return 1
    fi
    return 0
}

# Function to read configuration values
read_config() {
    local key="$1"
    local default_value="$2"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_warning "Configuration file not found, using default values"
        echo "$default_value"
        return
    fi

    if ! check_yaml_support; then
        echo "$default_value"
        return
    fi

    # Use Python to parse YAML and get the value
    value=$(python3 -c "
import yaml
try:
    with open('$CONFIG_FILE', 'r') as f:
        config = yaml.safe_load(f)
    keys = '$key'.split('.')
    result = config
    for k in keys:
        result = result[k]
    print(result)
except Exception as e:
    print('$default_value')
")
    echo "$value"
}

# Function to validate configuration file
validate_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        print_warning "Configuration file not found at $CONFIG_FILE"
        return 1
    fi

    if ! check_yaml_support; then
        return 1
    fi

    # Validate YAML syntax and required fields
    python3 -c "
import yaml
try:
    with open('$CONFIG_FILE', 'r') as f:
        config = yaml.safe_load(f)
    required_keys = ['thresholds', 'network', 'kubernetes', 'logging']
    for key in required_keys:
        if key not in config:
            raise KeyError(f'Missing required section: {key}')
    print('valid')
except Exception as e:
    print(f'invalid: {str(e)}')
    exit(1)
"
}
