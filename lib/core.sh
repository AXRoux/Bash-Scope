#!/bin/bash

# Check system requirements
check_requirements() {
    local missing_deps=()
    
    # Check bash version
    if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
        print_error "Bash 4.0 or higher is required"
        return 1
    fi

    # Check essential commands
    local required_commands=("top" "free" "df" "ps" "awk" "sed" "grep" "python3")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required commands: ${missing_deps[*]}"
        return 1
    fi

    print_success "All system requirements met"
    return 0
}

# Get CPU usage
get_cpu_usage() {
    print_header "CPU Usage"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}

# Get memory usage
get_memory_usage() {
    print_header "Memory Usage"
    free -m | awk 'NR==2{printf "%.2f%%\n", $3*100/$2 }'
}

# Get disk usage
get_disk_usage() {
    print_header "Disk Usage"
    df -h | awk '$NF=="/"{printf "%s\n", $5}'
}

# Get system load
get_system_load() {
    print_header "System Load"
    uptime | awk -F'load average:' '{ print $2 }' | tr ',' ' '
}

# Get process list
get_process_list() {
    print_header "Top Processes by CPU Usage"
    ps aux --sort=-%cpu | head -n 6
}

# Check system logs
check_system_logs() {
    print_header "Recent System Logs"
    local log_lines=$(read_config "logging.system_log_lines" "10")
    
    if [ -f /var/log/syslog ]; then
        tail -n "$log_lines" /var/log/syslog
    elif [ -f /var/log/messages ]; then
        tail -n "$log_lines" /var/log/messages
    else
        print_warning "No system log file found"
    fi
}

# System health check
check_system_health() {
    local cpu_threshold=$(read_config "thresholds.cpu" "90")
    local mem_threshold=$(read_config "thresholds.memory" "90")
    local disk_threshold=$(read_config "thresholds.disk" "90")

    print_header "System Health Check"

    # CPU Check
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$cpu_usage > $cpu_threshold" | bc -l) )); then
        print_error "High CPU usage: ${cpu_usage}%"
    else
        print_success "CPU usage normal: ${cpu_usage}%"
    fi

    # Memory Check
    local mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$mem_usage > $mem_threshold" | bc -l) )); then
        print_error "High memory usage: ${mem_usage}%"
    else
        print_success "Memory usage normal: ${mem_usage}%"
    fi

    # Disk Check
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    if [ "$disk_usage" -gt "$disk_threshold" ]; then
        print_error "High disk usage: ${disk_usage}%"
    else
        print_success "Disk usage normal: ${disk_usage}%"
    fi
}
