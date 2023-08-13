aws eks update-kubeconfig --name petclinic-cluster --region eu-west-3
kubectl apply -f aws-auth-cm.yaml
