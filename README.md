# SysScope - System Diagnostics Tool

SysScope is a comprehensive system diagnostics and monitoring tool written in Bash that performs system health checks, network analysis, and generates detailed reports. The tool processes system metrics and produces automated reports in both HTML and text formats, with proper file permission management.

## Features

### System Monitoring
- Real-time CPU, Memory, and Disk usage monitoring
- Process analysis and management
- System load tracking
- Configurable resource usage thresholds
- Detailed system information gathering

### Network Diagnostics
- Network interface analysis
- Connectivity testing
- Port scanning and analysis
- Network performance metrics
- DNS resolution checking

### Report Generation
- Multi-format reporting (HTML and Text)
- Permission-managed output (755 for directories, 644 for files)
- Timestamp-based report naming
- Customizable report sections
- System resource usage summaries

### Configuration Management
- YAML-based configuration
- Customizable thresholds and settings
- Flexible output directory configuration
- Configurable logging options

## Requirements

### System Requirements
- Bash 4.0 or higher
- Python 3.x (for YAML configuration parsing)
- Core system utilities:
  - top
  - free
  - df
  - ps
  - awk
  - sed
  - grep

### Optional Dependencies
- lsof (for network port analysis)
- netstat or ss (for network statistics)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/sysscope.git
   cd sysscope
   ```

2. Make the scripts executable:
   ```bash
   chmod +x sysscope.sh
   chmod +x lib/*.sh
   ```

3. Verify the installation:
   ```bash
   ./sysscope.sh --version
   ```

## Configuration

SysScope uses a YAML configuration file located at `config/sysscope.yaml`. You can customize various aspects of the tool:

```yaml
# System monitoring thresholds
thresholds:
  cpu: 90    # CPU usage threshold (percentage)
  memory: 90 # Memory usage threshold (percentage)
  disk: 90   # Disk usage threshold (percentage)

# Network monitoring settings
network:
  ping_target: "8.8.8.8"     # Default ping target
  ping_count: 3              # Number of pings
  dns_test_domain: "google.com"

# Report settings
report:
  formats:
    - text
    - html
  output_dir: "reports"
```

## Usage

```bash
./sysscope.sh [options]

Options:
  -s, --system     Run system diagnostics
  -n, --network    Run network diagnostics
  -a, --all        Run all diagnostics
  -r, --report     Generate system report
  -c, --config     Specify custom config file
  -h, --help       Show this help message
  -v, --version    Show version information
```

### Examples

1. Run complete system diagnostics and generate reports:
   ```bash
   ./sysscope.sh --all
   ```

2. Check system resources only:
   ```bash
   ./sysscope.sh --system
   ```

3. Generate reports with custom config:
   ```bash
   ./sysscope.sh --report --config /path/to/custom-config.yaml
   ```

4. Check network connectivity:
   ```bash
   ./sysscope.sh --network
   ```

## Report Types

### Text Reports
- Plain text format for easy reading and parsing
- Contains all system metrics and diagnostics
- Stored in `reports/report_TIMESTAMP.txt`
- File permissions: 644

### HTML Reports
- Rich formatted reports with CSS styling
- Interactive sections for better readability
- Color-coded status indicators
- Stored in `reports/report_TIMESTAMP.html`
- File permissions: 644

## Output Format

The tool provides color-coded output for better readability:
- ✓ Green: Success/Normal status
- ✗ Red: Error/Critical status
- ⚠ Yellow: Warning/Attention needed
- ℹ Cyan: Information

## Troubleshooting

### Common Issues

1. Permission Denied
   ```bash
   sudo chmod +x sysscope.sh lib/*.sh
   ```

2. Configuration File Not Found
   - Verify config file exists at `config/sysscope.yaml`
   - Use absolute path with --config option

3. Python Not Found
   - Install Python 3.x
   - Verify PyYAML is installed

### Report Generation Issues

1. Report Directory Permission
   - Default permissions: 755 for directories
   - Fallback to user's home directory if needed

2. File Permission Issues
   - Default permissions: 644 for files
   - Check directory write permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

Please ensure your code follows the existing style and includes appropriate tests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Authors

Initial version created as a system diagnostics and monitoring tool.

## Acknowledgments

- Bash community for scripting best practices
- YAML for configuration management
- Open source monitoring tools that inspired this project
