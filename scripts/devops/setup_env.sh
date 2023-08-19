#!/bin/bash
# Usage ./setup_env.sh ENV_NAME - Exemple ./setup_env.sh testing
# Prépare l environnment
ENV_NAME=$1
ns_status=$(kubectl get ns $ENV_NAME -o json | jq .status.phase -r)

if [[ $ns_status != "Active" ]]
then
    echo "Creating namespace $ENV_NAME ..."
    kubectl create ns ${ENV_NAME}
else
    echo "Namespace $ENV_NAME already exists"
fi
sed -i "s+namespace:.*+namespace: ${ENV_NAME}+g" pipeline/jenkins/agent/service-account.yaml
sed -i "s+namespace:.*+namespace: ${ENV_NAME}+g" pipeline/jenkins/agent/secret.yaml

kubectl apply -f pipeline/jenkins/agent/service-account.yaml
kubectl apply -f pipeline/jenkins/agent/secret.yaml
# 1. Verifie si traefik est installe
traefik_status=$(kubectl get ns traefik -o json | jq .status.phase -r)

if [[ $traefik_status != "Active" ]]
then
    echo "Installing traefik ingress controller ..."
    # Installation traefik dans le namespace dev avec helm
    # 1.a. Ajouter et mise a jour repo helm
    helm repo add traefik https://helm.traefik.io/traefik
    helm repo update
    # 1.b. Creation fichier values.yaml
    echo '# values.yaml' > values.yaml
    echo '---' >> values.yaml
    echo 'ingressClass:' >> values.yaml
    echo '  enabled: true' >> values.yaml
    echo '  isDefaultClass: true' >> values.yaml
    echo '  fallbackApiVersion: v1' >> values.yaml
    echo 'ingressRoute:' >> values.yaml
    echo '  dashboard:' >> values.yaml
    echo '    enabled: false' >> values.yaml
    echo 'service:' >> values.yaml
    echo '  annotations:' >> values.yaml
    echo '    service.beta.kubernetes.io/aws-load-balancer-type: nlb' >> values.yaml
    echo 'globalArguments:' >> values.yaml
    echo '- "--api.insecure=true"' >> values.yaml
    echo 'ports:' >> values.yaml
    echo '  websecure:' >> values.yaml
    echo '    tls:' >> values.yaml
    echo '      enabled: true' >> values.yaml
    # 1.c. Installation traefik dans le namespace traefik
    #helm uninstall traefik --namespace=traefik
    helm install traefik traefik/traefik --create-namespace --namespace=traefik --values=values.yaml
else
    echo "Traefik ingress controller is already installed"
fi
# Installation du middleware traefik
kubectl apply -f kubernetes/standard/middleware.yml -n traefik

# 2. Installation du fournisseur de cerificats
cert_status=$(kubectl get ns cert-manager -o json | jq .status.phase -r)
if [[ $cert_status != "Active" ]]
then
    echo "Installing cluster Cert-Manager ..."
    # 2.a - Ajout repo helm
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    # 2.b Installation de Cert-Manager au sein du cluster
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.10.1 --set installCRDs=true
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
    # 12.c  Ajout du plugin Kubectl
    curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-amd64.tar.gz
    tar xzf kubectl-cert-manager.tar.gz
    sudo mv kubectl-cert_manager /usr/local/bin
    # 2.d Création d un ClusterIssuer
    echo 'apiVersion: cert-manager.io/v1' > myClusterIssuer.yaml
    echo 'kind: ClusterIssuer' >> myClusterIssuer.yaml
    echo 'metadata:' >> myClusterIssuer.yaml
    echo '  name: letsencrypt-prod # nom de la ressource' >> myClusterIssuer.yaml
    echo 'spec:' >> myClusterIssuer.yaml
    echo '  acme:' >> myClusterIssuer.yaml
    echo '    # L URL du serveur ACME' >> myClusterIssuer.yaml
    echo '    server: https://acme-v02.api.letsencrypt.org/directory' >> myClusterIssuer.yaml
    echo '    # Adresse e-mail utilisée pour l enregistrement ACME' >> myClusterIssuer.yaml
    echo '    email: agdgpn@gmail.com' >> myClusterIssuer.yaml
    echo '    # Nom d un secret utilisé pour stocker la clé privée du compte ACME' >> myClusterIssuer.yaml
    echo '    privateKeySecretRef:' >> myClusterIssuer.yaml
    echo '      name: letsencrypt-prod' >> myClusterIssuer.yaml
    echo '    # Activer le fournisseur de challenge HTTP-01' >> myClusterIssuer.yaml
    echo '    solvers:' >> myClusterIssuer.yaml
    echo '    - http01:' >> myClusterIssuer.yaml
    echo '        ingress:' >> myClusterIssuer.yaml
    echo '          class: traefik' >> myClusterIssuer.yaml
    # 2.d  Ajout du ClusterIssuer a notre cluster
    kubectl create -f myClusterIssuer.yaml
else
    echo "Cluster Cert-Manager is already installed !"
    echo "Skip cluster Cert-Manager installation."
fi