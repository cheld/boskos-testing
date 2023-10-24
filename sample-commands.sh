
# Usage with REST
curl -X POST 'http://localhost:80/acquire?type=aws-account&state=dirty&dest=busy&owner=christoph'

# Usage with boskosctl
boskosctl acquire --server-url http://localhost  --owner-name christoph --type manual-token --target-state used --state free

# Acquire resource with autoscaling -> use timout flag
boskosctl acquire --server-url http://localhost  --owner-name christoph --type autoscaling-env --target-state used --state free --timeout 1m

# Usage with kubectl
kubectl get resources -n boskos