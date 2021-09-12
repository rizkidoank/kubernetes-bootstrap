# install cni - calico
kubectl apply -f manifests/calico.yaml

# install argocd
helm repo add argo https://argoproj.github.io/argo-helm
kubectl apply -f manifests/namespaces/argocd.yaml
helm upgrade --install argocd argo/argo-cd -f releases/argocd/values.yaml -n argocd

# install argo apps
kubectl apply -f manifests/applications/application-cluster-bootstrap.yaml
