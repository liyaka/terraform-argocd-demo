# Terraform ArgoCD demo

# Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.0/manifests/install.yaml

argocd app create infra --repo https://github.com/liyaka/terraform-argocd-demo --path argocd/infra --dest-server https://kubernetes.default.svc 
```
