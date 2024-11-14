#!/bin/bash

# Generate timestamp for report
get_timestamp() {
    date "+%Y-%m-%d_%H-%M-%S"
}

# Create report directory if it doesn't exist
init_report_dir() {
    local report_dir=$(read_config "report.output_dir" "reports")
    
    # First check if directory exists
    if [ ! -d "$report_dir" ]; then
        # Try to create directory with proper permissions
        mkdir -p "$report_dir" 2>/dev/null || {
            print_error "Failed to create reports directory: Permission denied"
            # Try in user's home directory as fallback
            report_dir="$HOME/sysscope_reports"
            print_warning "Attempting to create reports in home directory: $report_dir"
            mkdir -p "$report_dir" 2>/dev/null || {
                print_error "Failed to create reports directory in home directory"
                return 1
            }
        }
    fi

    # Verify write permissions
    if [ ! -w "$report_dir" ]; then
        print_error "No write permission for reports directory: $report_dir"
        return 1
    fi

    # Set proper permissions
    chmod 755 "$report_dir" 2>/dev/null || print_warning "Could not set directory permissions"
    
    echo "$report_dir"
}

# Generate HTML report
generate_html_report() {
    local timestamp=$(get_timestamp)
    local report_dir=$(init_report_dir)
    [ $? -ne 0 ] && return 1
    
    local report_file="${report_dir}/report_${timestamp}.html"
    local temp_file="${report_dir}/.temp_${timestamp}.html"

    # First write to a temporary file
    cat > "$temp_file" 2>/dev/null << EOL
<!DOCTYPE html>
<html>
<head>
    <title>SysScope Report - ${timestamp}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .section { margin: 20px 0; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
        .success { color: green; }
        .error { color: red; }
        .warning { color: orange; }
        .info { color: blue; }
        pre { background: #f5f5f5; padding: 10px; border-radius: 3px; overflow-x: auto; }
        h1, h2 { color: #333; }
    </style>
</head>
<body>
    <h1>SysScope System Report</h1>
    <p>Generated: $(date)</p>
    
    <div class="section" id="system">
        <h2>System Information</h2>
        <pre>$(get_system_info)</pre>
    </div>
    
    <div class="section" id="resources">
        <h2>Resource Usage</h2>
        <p><strong>CPU Usage:</strong> $(get_cpu_usage)</p>
        <p><strong>Memory Usage:</strong> $(get_memory_usage)</p>
        <p><strong>Disk Usage:</strong> $(get_disk_usage)</p>
        <p><strong>System Load:</strong> $(get_system_load)</p>
    </div>
    
    <div class="section" id="processes">
        <h2>Process Information</h2>
        <pre>$(get_process_list)</pre>
    </div>
    
    <div class="section" id="network">
        <h2>Network Information</h2>
        <pre>$(get_network_info)</pre>
    </div>
</body>
</html>
EOL

    if [ $? -ne 0 ]; then
        print_error "Failed to create temporary HTML report"
        rm -f "$temp_file" 2>/dev/null
        return 1
    fi

    # Move temporary file to final location
    mv "$temp_file" "$report_file" 2>/dev/null || {
        print_error "Failed to save HTML report"
        rm -f "$temp_file" 2>/dev/null
        return 1
    }

    # Set proper permissions
    chmod 644 "$report_file" 2>/dev/null || print_warning "Could not set file permissions"

    print_success "HTML report generated: $report_file"
    return 0
}

# Generate text report
generate_text_report() {
    local timestamp=$(get_timestamp)
    local report_dir=$(init_report_dir)
    [ $? -ne 0 ] && return 1
    
    local report_file="${report_dir}/report_${timestamp}.txt"
    local temp_file="${report_dir}/.temp_${timestamp}.txt"

    # First write to a temporary file
    {
        echo "SysScope System Report"
        echo "Generated: $(date)"
        echo "===================="
        echo
        echo "System Information"
        echo "-----------------"
        get_system_info
        echo
        echo "Resource Usage"
        echo "--------------"
        echo "CPU Usage: $(get_cpu_usage)"
        echo "Memory Usage: $(get_memory_usage)"
        echo "Disk Usage: $(get_disk_usage)"
        echo "System Load: $(get_system_load)"
        echo
        echo "Process Information"
        echo "------------------"
        get_process_list
        echo
        echo "Network Information"
        echo "------------------"
        get_network_info
    } > "$temp_file" 2>/dev/null

    if [ $? -ne 0 ]; then
        print_error "Failed to create temporary text report"
        rm -f "$temp_file" 2>/dev/null
        return 1
    fi

    # Move temporary file to final location
    mv "$temp_file" "$report_file" 2>/dev/null || {
        print_error "Failed to save text report"
        rm -f "$temp_file" 2>/dev/null
        return 1
    }

    # Set proper permissions
    chmod 644 "$report_file" 2>/dev/null || print_warning "Could not set file permissions"

    print_success "Text report generated: $report_file"
    return 0
}

# Get system information
get_system_info() {
    echo "OS: $(uname -a)"
    echo "Uptime: $(uptime)"
    echo "Kernel: $(uname -r)"
}

# Get network information
get_network_info() {
    echo "Network Interfaces:"
    ip addr show 2>/dev/null || ifconfig -a
    
    echo -e "\nOpen Ports:"
    local port_info=$(netstat -tuln 2>/dev/null || ss -tuln 2>/dev/null)
    if [ -n "$port_info" ]; then
        echo "$port_info"
    else
        echo "No port information available"
    fi
}

# Generate all reports
generate_reports() {
    print_header "Generating System Reports"
    
    # Check if reports are enabled in config
    local formats=($(read_config "report.formats" "text html"))
    
    local success=0
    for format in "${formats[@]}"; do
        case "$format" in
            "text")
                generate_text_report
                [ $? -eq 0 ] && ((success++))
                ;;
            "html")
                generate_html_report
                [ $? -eq 0 ] && ((success++))
                ;;
        esac
    done

    # Return success only if all enabled reports were generated
    [ $success -eq ${#formats[@]} ]
}

export -f generate_reports
export -f generate_html_report
export -f generate_text_report
export -f get_system_info
export -f get_network_info
export -f get_timestamp
export -f init_report_dir
