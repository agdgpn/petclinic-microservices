#!/bin/bash
# Permet de générer des images pour le monitorint avec prometheus et graphana
# Usage ./build_monitoring_image NOM_IMAGE DOCKER_FILE
# Les dockerfiles se trouvent dans les dossiers docker/prometheus et docker/graphana

mon_app=$1
if [ $mon_app != prometheus ] && [ $mon_app != grafana ]
then
    echo "Exécution impossible - 'prometheus' ou 'grafana' sont les deux arguments acceptés! "
else
    if [ $mon_app = prometheus ]
    then
        echo "using context ./docker/prometheus"
        context=./docker/prometheus
    else
        echo "using context ./docker/grafana"
        context=./docker/grafana
    fi
    echo "Generation image docker pour le monitoring avec "$mon_app" ..."
    docker build $context -t agdgpn/$mon_app-image:latest
fi