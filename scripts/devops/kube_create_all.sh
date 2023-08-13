#!/bin/bash
args=$#
kubectl -n kube-system  apply -f ../../kubernetes/middleware.yml 
if [ $args = 0 ] # Namespace par defaut
then
    kubectl apply -f ../../kubernetes/mysql-kube.yml \
                  -f ../../kubernetes/config-kube.yml \
                  -f ../../kubernetes/discovery-kube.yml \
                  -f ../../kubernetes/customers-kube.yml \
                  -f ../../kubernetes/vets-kube.yml \
                  -f ../../kubernetes/visits-kube.yml \
                  -f ../../kubernetes/admin-kube.yml \
                  -f ../../kubernetes/api-gateway-kube.yml
fi
if [ $args = 1 ] # Le namespace est passe en argument
then
    namespace=$1
    kubectl create namespace $namespace  
    kubectl -n $namespace  apply -f ../../kubernetes/mysql-kube.yml \
                                 -f ../../kubernetes/config-kube.yml \
                                 -f ../../kubernetes/discovery-kube.yml \
                                 -f ../../kubernetes/customers-kube.yml \
                                 -f ../../kubernetes/vets-kube.yml \
                                 -f ../../kubernetes/visits-kube.yml \
                                 -f ../../kubernetes/admin-kube.yml \
                                 -f ../../kubernetes/api-gateway-kube.yml

fi