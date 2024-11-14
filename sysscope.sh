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
    local separator="${BLUE}─────────────────────────────────────────────────────────────────────────────${RESET}"
    
    case "$command" in
        "system"|"-s"|"--system")
            help_content=$(cat << EOF
${BLUE}SYSTEM(1)                                    System Commands                                    SYSTEM(1)${RESET}

$separator

${BLUE}NAME${RESET}
    ${GREEN}system${RESET} - Perform comprehensive system diagnostics

${BLUE}SYNOPSIS${RESET}
    ${GREEN}$(basename "$0") --system${RESET}

${BLUE}DESCRIPTION${RESET}
    ${CYAN}Performs comprehensive system diagnostics including CPU, memory, disk usage 
    analysis, and process monitoring.${RESET}

$separator

${BLUE}OPTIONS${RESET}
    ${MAGENTA}None${RESET}

${BLUE}OUTPUT${RESET}
    ${MAGENTA}• CPU usage percentage${RESET}
        ${CYAN}Shows current CPU utilization across all cores${RESET}
    
    ${MAGENTA}• Memory utilization${RESET}
        ${CYAN}Displays RAM usage and swap space status${RESET}
    
    ${MAGENTA}• Disk space usage${RESET}
        ${CYAN}Reports storage utilization for mounted filesystems${RESET}
    
    ${MAGENTA}• System load averages${RESET}
        ${CYAN}Shows 1, 5, and 15-minute load averages${RESET}
    
    ${MAGENTA}• Top processes${RESET}
        ${CYAN}Lists processes consuming most system resources${RESET}
    
    ${MAGENTA}• System logs${RESET}
        ${CYAN}Recent system log entries and important messages${RESET}
    
    ${MAGENTA}• System health${RESET}
        ${CYAN}Overall health status based on configured thresholds${RESET}

$separator

${BLUE}EXAMPLES${RESET}
    ${CYAN}1. Run system diagnostics:${RESET}
       ${GREEN}$ $(basename "$0") --system${RESET}
    
    ${CYAN}2. Run system diagnostics and generate report:${RESET}
       ${GREEN}$ $(basename "$0") --system --report${RESET}

${BLUE}CONFIGURATION${RESET}
    ${CYAN}Thresholds can be configured in sysscope.yaml:${RESET}

    ${GREEN}thresholds:
        cpu: 90    # CPU usage threshold (percentage)
        memory: 90 # Memory usage threshold (percentage)
        disk: 90   # Disk usage threshold (percentage)${RESET}

${BLUE}NOTES${RESET}
    ${YELLOW}⚠ Some metrics may require root privileges for full access.${RESET}

$separator

${BLUE}SEE ALSO${RESET}
    ${CYAN}network(1), report(1), all(1)${RESET}
EOF
)
            ;;
        "network"|"-n"|"--network")
            help_content=$(cat << EOF
${BLUE}NETWORK(1)                                   Network Commands                                   NETWORK(1)${RESET}

$separator

${BLUE}NAME${RESET}
    ${GREEN}network${RESET} - Perform network connectivity tests and analysis

${BLUE}SYNOPSIS${RESET}
    ${GREEN}$(basename "$0") --network${RESET}

${BLUE}DESCRIPTION${RESET}
    ${CYAN}Performs network connectivity tests, interface analysis, and port scanning.${RESET}

$separator

${BLUE}OPTIONS${RESET}
    ${MAGENTA}None${RESET}

${BLUE}OUTPUT${RESET}
    ${MAGENTA}• Network interface status${RESET}
        ${CYAN}Status of all network interfaces and their configurations${RESET}
    
    ${MAGENTA}• Active connections${RESET}
        ${CYAN}List of current network connections and their states${RESET}
    
    ${MAGENTA}• Open ports${RESET}
        ${CYAN}Analysis of listening ports and associated services${RESET}
    
    ${MAGENTA}• DNS resolution${RESET}
        ${CYAN}DNS server responsiveness and resolution tests${RESET}
    
    ${MAGENTA}• Network performance${RESET}
        ${CYAN}Basic network performance metrics${RESET}
    
    ${MAGENTA}• Connectivity tests${RESET}
        ${CYAN}Results of ping tests to configured targets${RESET}

$separator

${BLUE}EXAMPLES${RESET}
    ${CYAN}1. Run network diagnostics:${RESET}
       ${GREEN}$ $(basename "$0") --network${RESET}
    
    ${CYAN}2. Combine with system diagnostics:${RESET}
       ${GREEN}$ $(basename "$0") --network --system${RESET}

${BLUE}CONFIGURATION${RESET}
    ${CYAN}Network settings in sysscope.yaml:${RESET}

    ${GREEN}network:
        ping_target: "8.8.8.8"     # Default ping target
        ping_count: 3              # Number of pings
        dns_test_domain: "google.com"${RESET}

$separator

${BLUE}SEE ALSO${RESET}
    ${CYAN}system(1), report(1), all(1)${RESET}
EOF
)
            ;;
        "report"|"-r"|"--report")
            help_content=$(cat << EOF
${BLUE}REPORT(1)                                    Report Commands                                    REPORT(1)${RESET}

$separator

${BLUE}NAME${RESET}
    ${GREEN}report${RESET} - Generate detailed system reports

${BLUE}SYNOPSIS${RESET}
    ${GREEN}$(basename "$0") --report [--config <config_file>]${RESET}

${BLUE}DESCRIPTION${RESET}
    ${CYAN}Generates detailed system reports in multiple formats with proper file permissions.${RESET}

$separator

${BLUE}OPTIONS${RESET}
    ${MAGENTA}--config <config_file>${RESET}
        ${CYAN}Specify custom configuration file path${RESET}

${BLUE}OUTPUT FORMATS${RESET}
    ${MAGENTA}• HTML Report${RESET}
        ${CYAN}• Interactive web-based format
        • Color-coded status indicators
        • Collapsible sections
        • File permissions: 644${RESET}
    
    ${MAGENTA}• Text Report${RESET}
        ${CYAN}• Plain text for easy parsing
        • Terminal-friendly format
        • File permissions: 644${RESET}

${BLUE}CONFIGURATION${RESET}
    ${CYAN}Report settings in sysscope.yaml:${RESET}

    ${GREEN}report:
        formats: [text, html]
        output_dir: reports
        include_sections: [system, resources, processes, network]${RESET}

$separator

${BLUE}EXAMPLES${RESET}
    ${CYAN}1. Generate default reports:${RESET}
       ${GREEN}$ $(basename "$0") --report${RESET}
    
    ${CYAN}2. Use custom configuration:${RESET}
       ${GREEN}$ $(basename "$0") --report --config custom_config.yaml${RESET}

$separator

${BLUE}SEE ALSO${RESET}
    ${CYAN}system(1), network(1), all(1)${RESET}
EOF
)
            ;;
        "all"|"-a"|"--all")
            help_content=$(cat << EOF
${BLUE}ALL(1)                                      General Commands                                      ALL(1)${RESET}

$separator

${BLUE}NAME${RESET}
    ${GREEN}all${RESET} - Execute complete system analysis

${BLUE}SYNOPSIS${RESET}
    ${GREEN}$(basename "$0") --all [--config <config_file>]${RESET}

${BLUE}DESCRIPTION${RESET}
    ${CYAN}Executes complete system analysis including both system and network 
    diagnostics, followed by report generation.${RESET}

$separator

${BLUE}OPTIONS${RESET}
    ${MAGENTA}--config <config_file>${RESET}
        ${CYAN}Specify custom configuration file path${RESET}

${BLUE}COMPONENTS${RESET}
    ${MAGENTA}• System Diagnostics${RESET}
        ${CYAN}• Resource usage analysis
        • Process monitoring
        • System health checks${RESET}
    
    ${MAGENTA}• Network Diagnostics${RESET}
        ${CYAN}• Connectivity tests
        • Interface analysis
        • Port scanning${RESET}
    
    ${MAGENTA}• Report Generation${RESET}
        ${CYAN}• HTML and text reports
        • Comprehensive results${RESET}

$separator

${BLUE}EXAMPLES${RESET}
    ${CYAN}1. Run complete analysis:${RESET}
       ${GREEN}$ $(basename "$0") --all${RESET}
    
    ${CYAN}2. With custom configuration:${RESET}
       ${GREEN}$ $(basename "$0") --all --config custom_config.yaml${RESET}

$separator

${BLUE}SEE ALSO${RESET}
    ${CYAN}system(1), network(1), report(1)${RESET}
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
    local separator="${BLUE}─────────────────────────────────────────────────────────────────────────────${RESET}"
    local help_content=$(cat << EOF
${BLUE}SYSSCOPE(1)                                General Commands                                SYSSCOPE(1)${RESET}

$separator

${BLUE}NAME${RESET}
    ${GREEN}sysscope${RESET} - System diagnostics and monitoring tool

${BLUE}SYNOPSIS${RESET}
    ${GREEN}$(basename "$0")${RESET} ${MAGENTA}[options]${RESET}
    ${GREEN}$(basename "$0")${RESET} ${MAGENTA}--help <command>${RESET}

${BLUE}DESCRIPTION${RESET}
    ${CYAN}A comprehensive system diagnostics and monitoring tool that performs system health 
    checks, network analysis, and generates detailed reports.${RESET}

${BLUE}VERSION${RESET}
    ${CYAN}SysScope v${VERSION}${RESET}

$separator

${BLUE}OPTIONS${RESET}
    ${MAGENTA}• -s, --system${RESET}
        ${CYAN}Run system diagnostics
        Performs CPU, memory, disk usage analysis, and process monitoring${RESET}
    
    ${MAGENTA}• -n, --network${RESET}
        ${CYAN}Run network diagnostics
        Checks network interfaces, connectivity, open ports, and performance${RESET}
    
    ${MAGENTA}• -a, --all${RESET}
        ${CYAN}Run all diagnostics
        Executes both system and network diagnostics, then generates reports${RESET}
    
    ${MAGENTA}• -r, --report${RESET}
        ${CYAN}Generate system report
        Creates HTML and text reports in the configured output directory${RESET}
    
    ${MAGENTA}• -c, --config${RESET}
        ${CYAN}Specify custom config file
        Override default config path (default: config/sysscope.yaml)${RESET}
    
    ${MAGENTA}• -h, --help${RESET}
        ${CYAN}Show this help message
        Use --help <command> for detailed command help${RESET}
    
    ${MAGENTA}• -v, --version${RESET}
        ${CYAN}Show version information${RESET}

$separator

${BLUE}COMMANDS${RESET}
    ${GREEN}• system${RESET}    ${CYAN}System diagnostics and monitoring${RESET}
    ${GREEN}• network${RESET}   ${CYAN}Network analysis and testing${RESET}
    ${GREEN}• report${RESET}    ${CYAN}Report generation and formatting${RESET}
    ${GREEN}• all${RESET}       ${CYAN}Complete system analysis${RESET}

${BLUE}EXAMPLES${RESET}
    ${CYAN}1. Get detailed help on system command:${RESET}
       ${GREEN}$ $(basename "$0") --help system${RESET}
    
    ${CYAN}2. Get detailed help on report generation:${RESET}
       ${GREEN}$ $(basename "$0") --help report${RESET}

$separator

${BLUE}FILES${RESET}
    ${CYAN}• config/sysscope.yaml${RESET}
        ${CYAN}Main configuration file${RESET}

    ${CYAN}• reports/${RESET}
        ${CYAN}Default directory for generated reports${RESET}

${BLUE}AUTHOR${RESET}
    ${CYAN}Initial version created as a system diagnostics and monitoring tool.${RESET}

${BLUE}REPORTING BUGS${RESET}
    ${CYAN}Report bugs to: https://github.com/yourusername/sysscope/issues${RESET}

${BLUE}COPYRIGHT${RESET}
    ${CYAN}This is free software: you are free to change and redistribute it.${RESET}

$separator

${BLUE}SEE ALSO${RESET}
    ${CYAN}system(1), network(1), report(1), all(1)${RESET}
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