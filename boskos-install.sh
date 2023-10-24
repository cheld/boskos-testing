
#!/bin/bash

# Install boskosctl from sources
if ! which "boskosctl" >/dev/null 2>&1; then
    echo "boskosctl not installed. Downloading..."
    go install sigs.k8s.io/boskos/cmd/boskosctl@latest
fi

# Install kind
if [ ! -e "kind" ]; then
    echo "kind not installed. Downloading..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
fi

# Install local Kubernetes cluster
echo
echo "Installing kind cluster..."
if ./kind get clusters | grep -q "kind"; then
    echo "Kubernetes cluster already exists."
else
    ./kind create cluster --config kind-config.yaml
fi
kubectl wait --for=condition=Ready node/kind-control-plane --timeout=180s
echo
echo "Cluster status:"
kubectl cluster-info
echo
echo "Node status:"
kubectl get nodes

# Install Boskos Namespace
echo
echo "Installing Boskos Namespace..."
if kubectl get namespace boskos &> /dev/null; then
    echo "Namespace boskos already exists."
else
    echo "Namespace boskos does not exist. Creating..."
    kubectl create namespace boskos
fi

# Install Boskos rbac and crds
echo
echo "Installing RBAC and CRDs..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/crd.yaml
kubectl wait --for=condition=complete dynamicresourcelifecycles.boskos.k8s.io -n boskos --timeout=60s
kubectl wait --for=condition=complete resources.boskos.k8s.io -n boskos --timeout=60s
echo
echo "CRD status:"
kubectl get crd 

# Deploy Boskos
echo
echo "Installing Boskos..."
kubectl create configmap -n boskos boskos-resources --from-file=boskos-resources.yaml 
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/service.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/deployment.yaml
kubectl rollout status -w deployment/boskos -n boskos
echo
echo "Deployment status:"
kubectl get pods -n boskos

# Exposing Boskos
echo
echo "Configure ingress..."
kubectl patch service boskos -n boskos -p '{"spec": {"type": "NodePort", "ports": [{"port": '80', "nodePort": '32000'}]}}'
echo 
echo "Ingress status:"
kubectl get svc -n boskos

# Testing
echo
echo "----------------Testing------------------------"
kubectl get resources -n boskos
echo
echo "Installation finished."
