#!/bin/bash
# Usage ./setup_env.sh ENV_NAME - Exemple ./setup_env.sh testing
# Prépare l environnment
ENV_NAME=$1
ns_status=$(kubectl get ns $ENV_NAME -o json | jq .status.phase -r)
echo -e "$ns_status"
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

