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
    echo -e "$content" | less -R --quiet --no-init --prompt="$(echo -e "${GRAY}Press 'q' to exit${RESET}")"
}

# Show command-specific help
show_command_help() {
    local command="$1"
    local help_content=""
    
    case "$command" in
        "system"|"-s"|"--system")
            help_content="$(printf '%s\n' \
                "${BLUE}${BOLD}SysScope System Command${RESET}" \
                "${CYAN}System diagnostics and monitoring tool${RESET}" \
                "" \
                "${BLUE}${BOLD}Usage:${RESET}" \
                "  ${GREEN}sysscope --system${RESET} [options]" \
                "" \
                "${BLUE}${BOLD}Description:${RESET}" \
                "  Performs comprehensive system diagnostics including CPU, memory," \
                "  disk usage analysis, and process monitoring." \
                "" \
                "${BLUE}${BOLD}Output:${RESET}" \
                "  ${CYAN}• CPU Usage${RESET}" \
                "    Shows current CPU utilization across all cores" \
                "" \
                "  ${CYAN}• Memory Usage${RESET}" \
                "    Displays RAM usage and swap space status" \
                "" \
                "  ${CYAN}• Disk Usage${RESET}" \
                "    Reports storage utilization for mounted filesystems" \
                "" \
                "  ${CYAN}• Process List${RESET}" \
                "    Lists processes consuming most system resources" \
                "" \
                "${BLUE}${BOLD}Examples:${RESET}" \
                "  ${GREEN}sysscope --system${RESET}" \
                "    Run system diagnostics" \
                "" \
                "  ${GREEN}sysscope --system --report${RESET}" \
                "    Run diagnostics and generate report" \
                "" \
                "${BLUE}${BOLD}Configuration:${RESET}" \
                "  In sysscope.yaml:" \
                "  ${CYAN}thresholds:${RESET}" \
                "    cpu: 90     # CPU usage threshold (%)" \
                "    memory: 90  # Memory usage threshold (%)" \
                "    disk: 90    # Disk usage threshold (%)" \
                "" \
                "${YELLOW}Note: Some metrics may require root privileges${RESET}" \
                "" \
                "${GRAY}See also: network, report, all${RESET}"
            )"
            ;;
        "network"|"-n"|"--network")
            help_content="$(printf '%s\n' \
                "${BLUE}${BOLD}SysScope Network Command${RESET}" \
                "${CYAN}Network analysis and connectivity testing${RESET}" \
                "" \
                "${BLUE}${BOLD}Usage:${RESET}" \
                "  ${GREEN}sysscope --network${RESET} [options]" \
                "" \
                "${BLUE}${BOLD}Description:${RESET}" \
                "  Performs network connectivity tests, interface analysis," \
                "  and port scanning operations." \
                "" \
                "${BLUE}${BOLD}Features:${RESET}" \
                "  ${CYAN}• Network Interfaces${RESET}" \
                "    Status and configuration of all interfaces" \
                "" \
                "  ${CYAN}• Connectivity${RESET}" \
                "    Active connections and network status" \
                "" \
                "  ${CYAN}• Port Analysis${RESET}" \
                "    Open ports and associated services" \
                "" \
                "${BLUE}${BOLD}Examples:${RESET}" \
                "  ${GREEN}sysscope --network${RESET}" \
                "    Run network diagnostics" \
                "" \
                "  ${GREEN}sysscope --network --system${RESET}" \
                "    Run network and system checks" \
                "" \
                "${BLUE}${BOLD}Configuration:${RESET}" \
                "  In sysscope.yaml:" \
                "  ${CYAN}network:${RESET}" \
                "    ping_target: \"8.8.8.8\"" \
                "    ping_count: 3" \
                "    dns_test_domain: \"google.com\"" \
                "" \
                "${GRAY}See also: system, report, all${RESET}"
            )"
            ;;
        "report"|"-r"|"--report")
            help_content="$(printf '%s\n' \
                "${BLUE}${BOLD}SysScope Report Command${RESET}" \
                "${CYAN}Report generation and formatting${RESET}" \
                "" \
                "${BLUE}${BOLD}Usage:${RESET}" \
                "  ${GREEN}sysscope --report${RESET} [--config <file>]" \
                "" \
                "${BLUE}${BOLD}Description:${RESET}" \
                "  Generates detailed system reports in multiple formats" \
                "  with proper file permissions." \
                "" \
                "${BLUE}${BOLD}Options:${RESET}" \
                "  ${CYAN}--config <file>${RESET}  Specify custom configuration file" \
                "" \
                "${BLUE}${BOLD}Report Types:${RESET}" \
                "  ${CYAN}• HTML Report${RESET}" \
                "    - Interactive web-based format" \
                "    - Color-coded status indicators" \
                "    - Collapsible sections" \
                "" \
                "  ${CYAN}• Text Report${RESET}" \
                "    - Plain text for easy parsing" \
                "    - Terminal-friendly output" \
                "" \
                "${BLUE}${BOLD}Examples:${RESET}" \
                "  ${GREEN}sysscope --report${RESET}" \
                "    Generate default reports" \
                "" \
                "  ${GREEN}sysscope --report --config custom.yaml${RESET}" \
                "    Use custom configuration" \
                "" \
                "${GRAY}See also: system, network, all${RESET}"
            )"
            ;;
        "all"|"-a"|"--all")
            help_content="$(printf '%s\n' \
                "${BLUE}${BOLD}SysScope All Command${RESET}" \
                "${CYAN}Complete system analysis${RESET}" \
                "" \
                "${BLUE}${BOLD}Usage:${RESET}" \
                "  ${GREEN}sysscope --all${RESET} [--config <file>]" \
                "" \
                "${BLUE}${BOLD}Description:${RESET}" \
                "  Executes complete system analysis including system" \
                "  diagnostics, network tests, and report generation." \
                "" \
                "${BLUE}${BOLD}Components:${RESET}" \
                "  ${CYAN}• System Analysis${RESET}" \
                "    - Resource usage monitoring" \
                "    - Process analysis" \
                "    - Health checks" \
                "" \
                "  ${CYAN}• Network Analysis${RESET}" \
                "    - Connectivity testing" \
                "    - Interface analysis" \
                "    - Port scanning" \
                "" \
                "  ${CYAN}• Reporting${RESET}" \
                "    - HTML and text formats" \
                "    - Comprehensive results" \
                "" \
                "${BLUE}${BOLD}Examples:${RESET}" \
                "  ${GREEN}sysscope --all${RESET}" \
                "    Run complete analysis" \
                "" \
                "  ${GREEN}sysscope --all --config custom.yaml${RESET}" \
                "    Use custom configuration" \
                "" \
                "${GRAY}See also: system, network, report${RESET}"
            )"
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
    local help_content="$(printf '%s\n' \
        "${BLUE}${BOLD}SysScope v${VERSION}${RESET}" \
        "${CYAN}System diagnostics and monitoring tool${RESET}" \
        "" \
        "${BLUE}${BOLD}Usage:${RESET}" \
        "  ${GREEN}sysscope${RESET} [command] [options]" \
        "  ${GREEN}sysscope --help${RESET} <command>" \
        "" \
        "${BLUE}${BOLD}Commands:${RESET}" \
        "  ${CYAN}system${RESET}    Run system diagnostics" \
        "  ${CYAN}network${RESET}   Perform network analysis" \
        "  ${CYAN}report${RESET}    Generate system reports" \
        "  ${CYAN}all${RESET}       Run complete analysis" \
        "" \
        "${BLUE}${BOLD}Options:${RESET}" \
        "  System:" \
        "    ${CYAN}-s, --system${RESET}     Run system diagnostics" \
        "    ${CYAN}-n, --network${RESET}    Run network diagnostics" \
        "    ${CYAN}-a, --all${RESET}        Run all diagnostics" \
        "" \
        "  Output:" \
        "    ${CYAN}-r, --report${RESET}     Generate system report" \
        "    ${CYAN}-c, --config${RESET}     Specify config file" \
        "" \
        "  Help:" \
        "    ${CYAN}-h, --help${RESET}       Show this help" \
        "    ${CYAN}-v, --version${RESET}    Show version" \
        "" \
        "${BLUE}${BOLD}Examples:${RESET}" \
        "  ${GREEN}sysscope --system${RESET}" \
        "    Run system diagnostics" \
        "" \
        "  ${GREEN}sysscope --help system${RESET}" \
        "    Show system command help" \
        "" \
        "${BLUE}${BOLD}Files:${RESET}" \
        "  ${CYAN}config/sysscope.yaml${RESET}  Main configuration" \
        "  ${CYAN}reports/${RESET}             Generated reports" \
        "" \
        "${YELLOW}Report bugs: https://github.com/yourusername/sysscope/issues${RESET}" \
        "${GRAY}This is free software: you are free to change and redistribute it.${RESET}"
    )"
    
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
