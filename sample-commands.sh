
# Usage with REST
curl -X POST 'http://localhost:80/acquire?type=numeric-project&state=dirty&dest=busy&owner=christoph'

# Usage with boskosctl
boskosctl acquire --server-url http://localhost  --owner-name christoph --type manual-token --target-state used --state free

# Usage with kubectl
kubectl get resources -n boskos