
kind-0.11 create cluster
kubectl get nodes

# rbac and crds
kubectl create namespace boskos
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/crd.yaml
kubectl get crd 

# service
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/service.yaml

# deployment
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/boskos/master/deployments/base/deployment.yaml
kubectl get pods -n boskos

kubectl create configmap -n boskos boskos-resources --from-file=boskos-resources.yaml 
kubectl get resources -n boskos

# test
kubectl run curl --image=radial/busyboxplus:curl -i --tty
curl -X POST 'http://boskos.boskos.svc.cluster.local/acquire?type=numeric-project&state=dirty&dest=busy&owner=christoph'
kubectl get resources -n boskos