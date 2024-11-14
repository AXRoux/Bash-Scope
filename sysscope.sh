#!/bin/bash

# Import libraries
source lib/colors.sh
source lib/config.sh
source lib/core.sh
source lib/network.sh
source lib/report.sh

VERSION="1.0.0"

# Display content using less in a man-page style
display_help_content() {
    local content="$1"
    echo "$content" | less -R --quiet --no-init --prompt="Manual page - press 'q' to exit" --use-color
}

# Show command-specific help
show_command_help() {
    local command="$1"
    local help_content=""
    
    case "$command" in
        "system"|"-s"|"--system")
            help_content=$(cat << EOF
SYSTEM(1)                                    System Commands                                    SYSTEM(1)

NAME
    system - Perform comprehensive system diagnostics

SYNOPSIS
    $(basename "$0") --system

DESCRIPTION
    Performs comprehensive system diagnostics including CPU, memory, disk usage 
    analysis, and process monitoring.

OPTIONS
    None

OUTPUT
    CPU usage percentage
        Shows current CPU utilization across all cores
    
    Memory utilization
        Displays RAM usage and swap space status
    
    Disk space usage
        Reports storage utilization for mounted filesystems
    
    System load averages
        Shows 1, 5, and 15-minute load averages
    
    Top processes
        Lists processes consuming most system resources
    
    System logs
        Recent system log entries and important messages
    
    System health
        Overall health status based on configured thresholds

EXAMPLES
    1. Run system diagnostics:
       $ $(basename "$0") --system
    
    2. Run system diagnostics and generate report:
       $ $(basename "$0") --system --report

CONFIGURATION
    Thresholds can be configured in sysscope.yaml:
        thresholds:
            cpu: 90    # CPU usage threshold (percentage)
            memory: 90 # Memory usage threshold (percentage)
            disk: 90   # Disk usage threshold (percentage)

NOTES
    Some metrics may require root privileges for full access.

SEE ALSO
    network(1), report(1), all(1)
EOF
)
            ;;
        "network"|"-n"|"--network")
            help_content=$(cat << EOF
NETWORK(1)                                   Network Commands                                   NETWORK(1)

NAME
    network - Perform network connectivity tests and analysis

SYNOPSIS
    $(basename "$0") --network

DESCRIPTION
    Performs network connectivity tests, interface analysis, and port scanning.

OPTIONS
    None

OUTPUT
    Network interface status
        Status of all network interfaces and their configurations
    
    Active connections
        List of current network connections and their states
    
    Open ports
        Analysis of listening ports and associated services
    
    DNS resolution
        DNS server responsiveness and resolution tests
    
    Network performance
        Basic network performance metrics
    
    Connectivity tests
        Results of ping tests to configured targets

EXAMPLES
    1. Run network diagnostics:
       $ $(basename "$0") --network
    
    2. Combine with system diagnostics:
       $ $(basename "$0") --network --system

CONFIGURATION
    Network settings in sysscope.yaml:
        network:
            ping_target: "8.8.8.8"     # Default ping target
            ping_count: 3              # Number of pings
            dns_test_domain: "google.com"

SEE ALSO
    system(1), report(1), all(1)
EOF
)
            ;;
        "report"|"-r"|"--report")
            help_content=$(cat << EOF
REPORT(1)                                    Report Commands                                    REPORT(1)

NAME
    report - Generate detailed system reports

SYNOPSIS
    $(basename "$0") --report [--config <config_file>]

DESCRIPTION
    Generates detailed system reports in multiple formats with proper file permissions.

OPTIONS
    --config <config_file>
        Specify custom configuration file path

OUTPUT FORMATS
    HTML Report
        - Interactive web-based format
        - Color-coded status indicators
        - Collapsible sections
        - File permissions: 644
    
    Text Report
        - Plain text for easy parsing
        - Terminal-friendly format
        - File permissions: 644

CONFIGURATION
    Report settings in sysscope.yaml:
        report:
            formats: [text, html]
            output_dir: reports
            include_sections: [system, resources, processes, network]

EXAMPLES
    1. Generate default reports:
       $ $(basename "$0") --report
    
    2. Use custom configuration:
       $ $(basename "$0") --report --config custom_config.yaml

SEE ALSO
    system(1), network(1), all(1)
EOF
)
            ;;
        "all"|"-a"|"--all")
            help_content=$(cat << EOF
ALL(1)                                      General Commands                                      ALL(1)

NAME
    all - Execute complete system analysis

SYNOPSIS
    $(basename "$0") --all [--config <config_file>]

DESCRIPTION
    Executes complete system analysis including both system and network 
    diagnostics, followed by report generation.

OPTIONS
    --config <config_file>
        Specify custom configuration file path

COMPONENTS
    System Diagnostics
        - Resource usage analysis
        - Process monitoring
        - System health checks
    
    Network Diagnostics
        - Connectivity tests
        - Interface analysis
        - Port scanning
    
    Report Generation
        - HTML and text reports
        - Comprehensive results

EXAMPLES
    1. Run complete analysis:
       $ $(basename "$0") --all
    
    2. With custom configuration:
       $ $(basename "$0") --all --config custom_config.yaml

SEE ALSO
    system(1), network(1), report(1)
EOF
)
            ;;
        *)
            show_general_help
            return 1
            ;;
    esac
    
    display_help_content "$help_content"
}

# Show general help message
show_general_help() {
    local help_content=$(cat << EOF
SYSSCOPE(1)                                General Commands                                SYSSCOPE(1)

NAME
    sysscope - System diagnostics and monitoring tool

SYNOPSIS
    $(basename "$0") [options]
    $(basename "$0") --help <command>

DESCRIPTION
    A comprehensive system diagnostics and monitoring tool that performs system health 
    checks, network analysis, and generates detailed reports.

VERSION
    SysScope v${VERSION}

OPTIONS
    -s, --system
        Run system diagnostics
        Performs CPU, memory, disk usage analysis, and process monitoring
    
    -n, --network
        Run network diagnostics
        Checks network interfaces, connectivity, open ports, and performance
    
    -a, --all
        Run all diagnostics
        Executes both system and network diagnostics, then generates reports
    
    -r, --report
        Generate system report
        Creates HTML and text reports in the configured output directory
    
    -c, --config
        Specify custom config file
        Override default config path (default: config/sysscope.yaml)
    
    -h, --help
        Show this help message
        Use --help <command> for detailed command help
    
    -v, --version
        Show version information

COMMANDS
    system    System diagnostics and monitoring
    network   Network analysis and testing
    report    Report generation and formatting
    all       Complete system analysis

EXAMPLES
    1. Get detailed help on system command:
       $ $(basename "$0") --help system
    
    2. Get detailed help on report generation:
       $ $(basename "$0") --help report

FILES
    config/sysscope.yaml
        Main configuration file

    reports/
        Default directory for generated reports

AUTHOR
    Initial version created as a system diagnostics and monitoring tool.

REPORTING BUGS
    Report bugs to: https://github.com/yourusername/sysscope/issues

COPYRIGHT
    This is free software: you are free to change and redistribute it.

SEE ALSO
    system(1), network(1), report(1), all(1)
EOF
)
    display_help_content "$help_content"
}

# Show version
show_version() {
    echo "SysScope v${VERSION}"
}

# Main system diagnostics function
run_system_diagnostics() {
    print_header "Running System Diagnostics"
    get_cpu_usage
    get_memory_usage
    get_disk_usage
    get_system_load
    get_process_list
    check_system_logs
    check_system_health
}

# Main network diagnostics function
run_network_diagnostics() {
    print_header "Running Network Diagnostics"
    check_connectivity
    get_network_interfaces
    get_open_ports
    check_network_performance
}

# Main function
main() {
    # Check for no arguments
    if [ $# -eq 0 ]; then
        show_general_help
        exit 1
    fi

    # Check system requirements first
    if ! check_requirements; then
        exit 1
    fi

    # Handle help command first
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        if [ -n "$2" ]; then
            show_command_help "$2"
        else
            show_general_help
        fi
        exit 0
    fi

    # Validate configuration file
    if ! validate_config; then
        print_error "Invalid configuration file"
        exit 1
    fi

    # Parse command line arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -v|--version)
                show_version
                exit 0
                ;;
            -c|--config)
                if [ -n "$2" ]; then
                    CONFIG_FILE="$2"
                    shift
                else
                    print_error "Config file path required"
                    exit 1
                fi
                ;;
            -s|--system)
                run_system_diagnostics
                ;;
            -n|--network)
                run_network_diagnostics
                ;;
            -r|--report)
                generate_reports
                ;;
            -a|--all)
                run_system_diagnostics
                run_network_diagnostics
                generate_reports
                ;;
            *)
                print_error "Unknown option: $1"
                show_general_help
                exit 1
                ;;
        esac
        shift
    done
}

# Trap Ctrl+C and cleanup
trap 'echo -e "\n${RED}Interrupted by user${RESET}"; exit 1' INT

# Execute main function
main "$@"
