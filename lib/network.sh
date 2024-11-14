#!/bin/bash

# Check network connectivity
check_connectivity() {
    print_header "Network Connectivity"
    
    # Test internet connectivity
    if ping -c 1 8.8.8.8 &> /dev/null; then
        print_success "Internet connection is working"
    else
        print_error "No internet connection"
    fi

    # Test DNS resolution
    if host google.com &> /dev/null; then
        print_success "DNS resolution is working"
    else
        print_error "DNS resolution failed"
    fi
}

# Get network interfaces
get_network_interfaces() {
    print_header "Network Interfaces"
    if command -v ip &> /dev/null; then
        ip addr show | grep -E '^[0-9]+: ' | awk -F': ' '{print $2}'
    else
        print_warning "ip command not available, using ifconfig"
        ifconfig -a | grep -E '^[a-zA-Z0-9]+:' | cut -d: -f1
    fi
}

# Get open ports
get_open_ports() {
    print_header "Open Ports"
    if command -v lsof &> /dev/null; then
        print_info "Using lsof to check open ports"
        lsof -i -P -n | grep LISTEN
    else
        print_warning "No port checking tools available"
    fi
}

# Check network performance
check_network_performance() {
    print_header "Network Performance"
    
    # Check latency to Google DNS
    local latency=$(ping -c 3 8.8.8.8 2>/dev/null | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
    if [ ! -z "$latency" ]; then
        print_info "Average latency to 8.8.8.8: ${latency}ms"
    else
        print_error "Could not measure latency"
    fi
}
