#!/bin/bash

# Import libraries
source lib/colors.sh
source lib/config.sh
source lib/core.sh
source lib/network.sh
source lib/report.sh

VERSION="1.0.0"

# Show command-specific help
show_command_help() {
    local command="$1"
    case "$command" in
        "system"|"-s"|"--system")
            cat << EOF
COMMAND: system (-s, --system)

DESCRIPTION
    Performs comprehensive system diagnostics including CPU, memory, disk usage 
    analysis, and process monitoring.

USAGE
    $(basename "$0") --system

OPTIONS
    None

OUTPUT
    - CPU usage percentage
    - Memory utilization
    - Disk space usage
    - System load averages
    - Top processes by resource usage
    - System logs analysis
    - Overall system health status

EXAMPLES
    1. Run system diagnostics:
       $ $(basename "$0") --system
    
    2. Run system diagnostics and generate report:
       $ $(basename "$0") --system --report

NOTES
    - Some metrics may require root privileges for full access
    - Thresholds can be configured in sysscope.yaml
EOF
            ;;
        "network"|"-n"|"--network")
            cat << EOF
COMMAND: network (-n, --network)

DESCRIPTION
    Performs network connectivity tests, interface analysis, and port scanning.

USAGE
    $(basename "$0") --network

OPTIONS
    None

OUTPUT
    - Network interface status
    - Active connections
    - Open ports analysis
    - DNS resolution status
    - Network performance metrics
    - Connectivity test results

EXAMPLES
    1. Run network diagnostics:
       $ $(basename "$0") --network
    
    2. Combine with system diagnostics:
       $ $(basename "$0") --network --system

CONFIGURATION
    Network settings in sysscope.yaml:
    - ping_target: Default ping test target
    - ping_count: Number of ping attempts
    - dns_test_domain: Domain for DNS checks
EOF
            ;;
        "report"|"-r"|"--report")
            cat << EOF
COMMAND: report (-r, --report)

DESCRIPTION
    Generates detailed system reports in multiple formats.

USAGE
    $(basename "$0") --report [--config <config_file>]

OPTIONS
    --config    Specify custom configuration file

OUTPUT FORMATS
    1. HTML Report
       - Interactive web-based format
       - Color-coded status indicators
       - Collapsible sections
    
    2. Text Report
       - Plain text for easy parsing
       - Terminal-friendly format

CONFIGURATION
    Report settings in sysscope.yaml:
    - formats: [text, html]
    - output_dir: Report output directory
    - include_sections: Sections to include

EXAMPLES
    1. Generate default reports:
       $ $(basename "$0") --report
    
    2. Use custom configuration:
       $ $(basename "$0") --report --config custom_config.yaml
EOF
            ;;
        "all"|"-a"|"--all")
            cat << EOF
COMMAND: all (-a, --all)

DESCRIPTION
    Executes complete system analysis including both system and network 
    diagnostics, followed by report generation.

USAGE
    $(basename "$0") --all [--config <config_file>]

OPTIONS
    --config    Specify custom configuration file

COMPONENTS
    1. System Diagnostics
       - Resource usage analysis
       - Process monitoring
       - System health checks
    
    2. Network Diagnostics
       - Connectivity tests
       - Interface analysis
       - Port scanning
    
    3. Report Generation
       - HTML and text reports
       - Comprehensive results

EXAMPLES
    1. Run complete analysis:
       $ $(basename "$0") --all
    
    2. With custom configuration:
       $ $(basename "$0") --all --config custom_config.yaml
EOF
            ;;
        *)
            show_general_help
            return 1
            ;;
    esac
}

# Show general help message
show_general_help() {
    cat << EOF
SysScope v${VERSION} - System Diagnostics Tool

DESCRIPTION
    A comprehensive system diagnostics and monitoring tool that performs system health 
    checks, network analysis, and generates detailed reports.

USAGE
    $(basename "$0") [options]
    $(basename "$0") --help <command>

OPTIONS
    -s, --system     Run system diagnostics
                     Performs CPU, memory, disk usage analysis, and process monitoring
    
    -n, --network    Run network diagnostics
                     Checks network interfaces, connectivity, open ports, and performance
    
    -a, --all        Run all diagnostics
                     Executes both system and network diagnostics, then generates reports
    
    -r, --report     Generate system report
                     Creates HTML and text reports in the configured output directory
    
    -c, --config     Specify custom config file
                     Override default config path (default: config/sysscope.yaml)
    
    -h, --help       Show this help message
                     Use --help <command> for detailed command help
    
    -v, --version    Show version information

COMMANDS WITH DETAILED HELP
    system    System diagnostics and monitoring
    network   Network analysis and testing
    report    Report generation and formatting
    all       Complete system analysis

For detailed help on any command, use:
    $(basename "$0") --help <command>

EXAMPLES
    1. Get detailed help on system command:
       $ $(basename "$0") --help system
    
    2. Get detailed help on report generation:
       $ $(basename "$0") --help report

For more information, visit: https://github.com/yourusername/sysscope
EOF
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
