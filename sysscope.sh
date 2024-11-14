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
    echo "$content" | less -R --quiet --no-init --prompt="Press 'q' to exit" --use-color
}

# Show command-specific help
show_command_help() {
    local command="$1"
    local help_content=""
    
    case "$command" in
        "system"|"-s"|"--system")
            help_content=$(cat << EOF
${BLUE}${BOLD}sysscope system${RESET} - System diagnostics and monitoring

${CYAN}Usage:${RESET}
  sysscope --system [options]

${CYAN}Description:${RESET}
  Performs comprehensive system diagnostics including CPU, memory,
  disk usage analysis, and process monitoring.

${CYAN}Options:${RESET}
  ${MAGENTA}None${RESET}

${CYAN}Output:${RESET}
  ${BOLD}• CPU Usage${RESET}
    Shows current CPU utilization across all cores
  
  ${BOLD}• Memory Usage${RESET}
    Displays RAM usage and swap space status
  
  ${BOLD}• Disk Usage${RESET}
    Reports storage utilization for mounted filesystems
  
  ${BOLD}• System Load${RESET}
    Shows 1, 5, and 15-minute load averages
  
  ${BOLD}• Process List${RESET}
    Lists processes consuming most system resources

${CYAN}Examples:${RESET}
  ${GREEN}$ sysscope --system${RESET}
    Run system diagnostics
  
  ${GREEN}$ sysscope --system --report${RESET}
    Run diagnostics and generate report

${CYAN}Configuration:${RESET}
  In sysscope.yaml:
  ${GREEN}thresholds:
    cpu: 90     # CPU usage threshold (%)
    memory: 90  # Memory usage threshold (%)
    disk: 90    # Disk usage threshold (%)${RESET}

${YELLOW}Note: Some metrics may require root privileges${RESET}

${GRAY}See also: network, report, all${RESET}
EOF
)
            ;;
        "network"|"-n"|"--network")
            help_content=$(cat << EOF
${BLUE}${BOLD}sysscope network${RESET} - Network analysis and connectivity testing

${CYAN}Usage:${RESET}
  sysscope --network [options]

${CYAN}Description:${RESET}
  Performs network connectivity tests, interface analysis,
  and port scanning operations.

${CYAN}Options:${RESET}
  ${MAGENTA}None${RESET}

${CYAN}Features:${RESET}
  ${BOLD}• Network Interfaces${RESET}
    Status and configuration of all interfaces
  
  ${BOLD}• Connectivity${RESET}
    Active connections and network status
  
  ${BOLD}• Port Analysis${RESET}
    Open ports and associated services
  
  ${BOLD}• DNS Resolution${RESET}
    DNS server response testing
  
  ${BOLD}• Performance${RESET}
    Basic network performance metrics

${CYAN}Examples:${RESET}
  ${GREEN}$ sysscope --network${RESET}
    Run network diagnostics
  
  ${GREEN}$ sysscope --network --system${RESET}
    Run network and system checks

${CYAN}Configuration:${RESET}
  In sysscope.yaml:
  ${GREEN}network:
    ping_target: "8.8.8.8"
    ping_count: 3
    dns_test_domain: "google.com"${RESET}

${GRAY}See also: system, report, all${RESET}
EOF
)
            ;;
        "report"|"-r"|"--report")
            help_content=$(cat << EOF
${BLUE}${BOLD}sysscope report${RESET} - Report generation and formatting

${CYAN}Usage:${RESET}
  sysscope --report [--config <file>]

${CYAN}Description:${RESET}
  Generates detailed system reports in multiple formats with
  proper file permissions (644 for files, 755 for directories).

${CYAN}Options:${RESET}
  ${MAGENTA}--config <file>${RESET}  Specify custom configuration file

${CYAN}Report Types:${RESET}
  ${BOLD}• HTML Report${RESET}
    - Interactive web-based format
    - Color-coded status indicators
    - Collapsible sections
  
  ${BOLD}• Text Report${RESET}
    - Plain text for easy parsing
    - Terminal-friendly output

${CYAN}Examples:${RESET}
  ${GREEN}$ sysscope --report${RESET}
    Generate default reports
  
  ${GREEN}$ sysscope --report --config custom.yaml${RESET}
    Use custom configuration

${CYAN}Configuration:${RESET}
  In sysscope.yaml:
  ${GREEN}report:
    formats: [text, html]
    output_dir: reports
    include_sections: [system, network]${RESET}

${GRAY}See also: system, network, all${RESET}
EOF
)
            ;;
        "all"|"-a"|"--all")
            help_content=$(cat << EOF
${BLUE}${BOLD}sysscope all${RESET} - Complete system analysis

${CYAN}Usage:${RESET}
  sysscope --all [--config <file>]

${CYAN}Description:${RESET}
  Executes complete system analysis including system diagnostics,
  network tests, and report generation.

${CYAN}Components:${RESET}
  ${BOLD}• System Analysis${RESET}
    - Resource usage monitoring
    - Process analysis
    - Health checks
  
  ${BOLD}• Network Analysis${RESET}
    - Connectivity testing
    - Interface analysis
    - Port scanning
  
  ${BOLD}• Reporting${RESET}
    - HTML and text formats
    - Comprehensive results

${CYAN}Examples:${RESET}
  ${GREEN}$ sysscope --all${RESET}
    Run complete analysis
  
  ${GREEN}$ sysscope --all --config custom.yaml${RESET}
    Use custom configuration

${GRAY}See also: system, network, report${RESET}
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
${BLUE}${BOLD}sysscope v${VERSION}${RESET} - System diagnostics and monitoring tool

${CYAN}Usage:${RESET}
  sysscope [command] [options]
  sysscope --help <command>

${CYAN}Description:${RESET}
  A comprehensive system diagnostics tool that performs health checks,
  network analysis, and generates detailed reports.

${CYAN}Commands:${RESET}
  ${BOLD}system${RESET}    Run system diagnostics
  ${BOLD}network${RESET}   Perform network analysis
  ${BOLD}report${RESET}    Generate system reports
  ${BOLD}all${RESET}       Run complete analysis

${CYAN}Options:${RESET}
  System:
    ${MAGENTA}-s, --system${RESET}     Run system diagnostics
    ${MAGENTA}-n, --network${RESET}    Run network diagnostics
    ${MAGENTA}-a, --all${RESET}        Run all diagnostics
  
  Output:
    ${MAGENTA}-r, --report${RESET}     Generate system report
    ${MAGENTA}-c, --config${RESET}     Specify config file
  
  Help:
    ${MAGENTA}-h, --help${RESET}       Show this help
    ${MAGENTA}-v, --version${RESET}    Show version

${CYAN}Examples:${RESET}
  ${GREEN}$ sysscope --system${RESET}
    Run system diagnostics
  
  ${GREEN}$ sysscope --help system${RESET}
    Show system command help
  
  ${GREEN}$ sysscope --all --config custom.yaml${RESET}
    Run all diagnostics with custom config

${CYAN}Files:${RESET}
  ${BOLD}config/sysscope.yaml${RESET}  Main configuration
  ${BOLD}reports/${RESET}              Generated reports

${YELLOW}Report bugs: https://github.com/yourusername/sysscope/issues${RESET}
${GRAY}This is free software: you are free to change and redistribute it.${RESET}
EOF
)
    display_help_content "$help_content"
}

# Show version
show_version() {
    echo -e "${BLUE}SysScope${RESET} ${GREEN}v${VERSION}${RESET}"
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