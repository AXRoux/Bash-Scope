#!/bin/bash

# Check if kubectl is installed
check_kubectl() {
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl not found"
        return 1
    fi
    return 0
}

# Get Kubernetes cluster info
get_cluster_info() {
    print_header "Kubernetes Cluster Info"
    if ! check_kubectl; then
        return 1
    fi

    kubectl cluster-info
}

# Get node status
get_node_status() {
    print_header "Kubernetes Node Status"
    if ! check_kubectl; then
        return 1
    fi

    kubectl get nodes -o wide
}

# Get pod status
get_pod_status() {
    print_header "Kubernetes Pod Status"
    if ! check_kubectl; then
        return 1
    fi

    kubectl get pods --all-namespaces
}

# Check pod logs
check_pod_logs() {
    local namespace="$1"
    local pod="$2"

    print_header "Pod Logs: $pod"
    if ! check_kubectl; then
        return 1
    fi

    if [ -z "$namespace" ] || [ -z "$pod" ]; then
        print_error "Namespace and pod name required"
        return 1
    fi

    kubectl logs -n "$namespace" "$pod" --tail=50
}

# Full Kubernetes health check
check_k8s_health() {
    print_header "Kubernetes Health Check"
    if ! check_kubectl; then
        return 1
    fi

    # Check API server
    if kubectl get --raw='/healthz' &>/dev/null; then
        print_success "API Server is healthy"
    else
        print_error "API Server is not responding"
    fi

    # Check nodes
    local unhealthy_nodes=$(kubectl get nodes | grep -v "Ready" | wc -l)
    if [ "$unhealthy_nodes" -eq 0 ]; then
        print_success "All nodes are healthy"
    else
        print_error "$unhealthy_nodes nodes are not ready"
    fi

    # Check pods
    local crashed_pods=$(kubectl get pods --all-namespaces | grep -v "Running\|Completed" | wc -l)
    if [ "$crashed_pods" -eq 0 ]; then
        print_success "All pods are healthy"
    else
        print_error "$crashed_pods pods are not running"
    fi
}
