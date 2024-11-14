# SysScope - Advanced System Diagnostics Tool

SysScope is a comprehensive system diagnostics and monitoring tool that provides detailed insights into system performance, Kubernetes clusters, and network connectivity.

## Features

- System resource monitoring (CPU, Memory, Disk)
- Process analysis and management
- Network diagnostics
- Kubernetes cluster health checks
- Log analysis capabilities
- Colorized output for better readability

## Requirements

- Bash 4.0+
- Core utilities (top, free, df, ps)
- Optional: kubectl for Kubernetes diagnostics
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
  -k, --k8s        Run Kubernetes diagnostics
  -n, --network    Run network diagnostics
  -a, --all        Run all diagnostics
  -h, --help       Show this help message
  -v, --version    Show version information
```

### Examples

1. Run all diagnostics:
```bash
./sysscope.sh --all
```

2. Check system resources only:
```bash
./sysscope.sh --system
```

3. Check network connectivity:
```bash
./sysscope.sh --network
```

4. Check Kubernetes cluster (if available):
```bash
./sysscope.sh --k8s
```

## Output

The tool provides color-coded output for better readability:
- ✓ Green: Success/Normal status
- ✗ Red: Error/Critical status
- ⚠ Yellow: Warning/Attention needed
- ℹ Cyan: Information
