# SysScope - System Diagnostics Tool

SysScope is a comprehensive system diagnostics and monitoring tool that provides detailed insights into system performance and network connectivity.

## Features

- System resource monitoring (CPU, Memory, Disk)
- Process analysis and management
- Network diagnostics
- Log analysis capabilities
- Colorized output for better readability
- Detailed HTML and text report generation

## Requirements

- Bash 4.0+
- Core utilities (top, free, df, ps)
- Optional: lsof for network port analysis

## Installation

1. Clone or download the repository
2. Make the script executable:
   ```bash
   chmod +x sysscope.sh
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

1. Run all diagnostics and generate reports:
```bash
./sysscope.sh --all
```

2. Check system resources only:
```bash
./sysscope.sh --system
```

3. Generate system report:
```bash
./sysscope.sh --report
```

4. Check network connectivity:
```bash
./sysscope.sh --network
```

## Reports

SysScope generates detailed reports in both text and HTML formats. Reports include:
- System information
- Resource usage statistics
- Process information
- Network configuration and status

Reports are stored in the `reports` directory with timestamps for easy reference.

## Output

The tool provides color-coded output for better readability:
- ✓ Green: Success/Normal status
- ✗ Red: Error/Critical status
- ⚠ Yellow: Warning/Attention needed
- ℹ Cyan: Information
