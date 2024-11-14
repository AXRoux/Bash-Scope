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
    if isinstance(result, list):
        print(' '.join(map(str, result)))
    else:
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
    
    # Required sections and their required fields
    required_structure = {
        'thresholds': ['cpu', 'memory', 'disk'],
        'network': ['ping_target', 'ping_count', 'dns_test_domain'],
        'logging': ['system_log_lines', 'enable_debug'],
        'report': {
            'formats': list,
            'output_dir': str,
            'include_sections': ['system', 'resources', 'processes', 'network']
        }
    }
    
    def validate_section(config_section, required_fields):
        if isinstance(required_fields, dict):
            for key, value in required_fields.items():
                if key not in config_section:
                    raise KeyError(f'Missing required field: {key}')
                if isinstance(value, list):
                    for field in value:
                        if field not in config_section[key]:
                            raise KeyError(f'Missing required field: {key}.{field}')
                elif isinstance(value, type):
                    if not isinstance(config_section[key], value):
                        raise TypeError(f'Invalid type for {key}')
        else:
            for field in required_fields:
                if field not in config_section:
                    raise KeyError(f'Missing required field: {field}')
    
    for section, fields in required_structure.items():
        if section not in config:
            raise KeyError(f'Missing required section: {section}')
        validate_section(config[section], fields)
    
    print('valid')
except Exception as e:
    print(f'invalid: {str(e)}')
    exit(1)
"
}
