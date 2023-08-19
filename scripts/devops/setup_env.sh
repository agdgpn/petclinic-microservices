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
# Verifie si traefik est installe
traefik_status=$(kubectl get ns traefik -o json | jq .status.phase -r)

if [[ $traefik_status != "Active" ]]
then
    echo "Installing traefik ingress controller ..."
    # Installation traefik dans le namespace dev avec helm
    # 1. Ajouter et mise a jour repo helm
    helm repo add traefik https://helm.traefik.io/traefik
    helm repo update
    # 2. Creation fichier values.yaml
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
    # 10.c - Installation traefik dans le namespace traefik
    #helm uninstall traefik --namespace=traefik
    helm install traefik traefik/traefik --create-namespace --namespace=traefik --values=values.yaml
else
    echo "Traefik ingress controller is already installed"
fi
# Installation du middleware traefik
kubectl apply -f kubernetes/standard/middleware.yml -n traefik

