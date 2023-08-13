#!/bin/bash

#1. Installation de docker
if [ -x "$(command -v docker)" ]; then
    echo "Docker is already installed"
else
    echo "Installing docker ..."
    # Docker installation commands
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl gnupg -y

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                          "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
fi

# 2. Add jenkins user to docker group
sudo apt install docker-compose
echo "Adding user $USER in docker group ..."
sudo usermod -aG docker $USER # Add jenkins user to docker group
newgrp docker

# 3. Install mysql client for database tests
if [ -x "$(command -v mysql)" ]; then
    echo "Mysql client is already installed!"
else
    echo "Installing mysql-client ..."
    sudo apt install mysql-client -y
fi

# 4. Install aws cli with jenkins user
if [ -x "$(command -v aws)" ]; then
    echo "aws cli is already installed"
else
    # AWS CLI command installation
    echo "Installing aws ..."
    curl -X GET "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt install unzip
    sudo unzip awscliv2.zip
    sudo ./aws/install
    # aws configure
fi

# 5. Install k3s
if [ -x "$(command -v kubectl)" ]; then
    echo "kubectl cli is already installed"
else
    echo "Installing kubectl ..."
    # KUBECTL command installation
    curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
fi

# 6. Install helm
if [ -x "$(command -v helm)" ]; then
    echo "helm is already installed"
else
    echo "Installing helm ..."
    # HELM command installation
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
fi

# 7. Install and setup eksctl
if [ -x "$(command -v eksctl)" ]; then
    echo "eksctl is already installed"
else
    echo "Installing kubectl ..."
    # EKSCTL command installation
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
fi
# 8. Install docker-compose  for healthy tests
if [ -x "$(command -v docker-compose)" ]; then
    echo "docker-compose is already installed!"
else
    echo "Installing docker-compose ..."
    sudo apt install docker-compose -y
fi
export KUBECONFIG=/var/lib/jenkins/.kube/config
# 9. Mise a jour config eks
aws eks update-kubeconfig --region eu-west-3 --name petclinic-cluster

# 10. Installation traefik dans le namespace dev avec helm
# 10.a - Ajouter et mise a jour repo helm
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
# 10.b - Creation fichier values.yaml
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
helm uninstall traefik --namespace=traefik
helm install traefik traefik/traefik --create-namespace --namespace=traefik --values=values.yaml
# 11 - Installation traefik dans le namespace kube-system (pour la prod)
helm uninstall traefik --namespace=kube-system
helm install traefik traefik/traefik --create-namespace --namespace=kube-system --values=values.yaml

# 12 - Installation de Cert-Manager
# 12.a - Ajout repo helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
# 12.b Installation de Cert-Manager au sein du cluster
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.10.1 --set installCRDs=true
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
# 12.c  Ajout du plugin Kubectl
curl -L -o kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
sudo mv kubectl-cert_manager /usr/local/bin
# 12.d Création d un ClusterIssuer
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

# 12.d  Ajout du ClusterIssuer a notre cluster
kubectl create -f myClusterIssuer.yaml