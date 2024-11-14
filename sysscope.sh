#!/bin/bash

# Import libraries
source lib/colors.sh
source lib/core.sh
source lib/kubernetes.sh
source lib/network.sh

VERSION="1.0.0"

# Show help message
show_help() {
    cat << EOF
SysScope v${VERSION} - Advanced System Diagnostics Tool

Usage: $(basename "$0") [options]

Options:
  -s, --system     Run system diagnostics
  -k, --k8s        Run Kubernetes diagnostics
  -n, --network    Run network diagnostics
  -a, --all        Run all diagnostics
  -h, --help       Show this help message
  -v, --version    Show version information
EOF
}

# Show version
show_version() {
    echo "SysScope v${VERSION}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_warning "Some features may require root privileges"
    fi
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

# Main Kubernetes diagnostics function
run_kubernetes_diagnostics() {
    print_header "Running Kubernetes Diagnostics"
    get_cluster_info
    get_node_status
    get_pod_status
    check_k8s_health
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
        show_help
        exit 1
    fi

    # Check system requirements first
    if ! check_requirements; then
        exit 1
    fi

    # Parse command line arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -s|--system)
                run_system_diagnostics
                ;;
            -k|--k8s)
                run_kubernetes_diagnostics
                ;;
            -n|--network)
                run_network_diagnostics
                ;;
            -a|--all)
                check_root
                run_system_diagnostics
                run_kubernetes_diagnostics
                run_network_diagnostics
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
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
