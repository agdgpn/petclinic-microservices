#!/bin/bash
# Usage ./push_image NOM application. Exemple ./push_image config
app=$1
tag='latest'       # Valeur par défaut
docker_id='agdgpn' # Valeur par défaut
if [ $2 ]
then
  docker_id=$2
fi
if [ $3 ]
then
  tag=$3
fi
# Le repertoire de base des fichiers docker (HOME_DIR/petclinic-microservices-devop/docker/devops)
apps="config discovery customers vets visits admin api-gateway"
if [ $app = all ]
then
  echo "Push de toutes les images docker les applications vers le repository de <$docker_id> ..."
  for iApp in $apps
  do
    echo "  - Push de l'image $docker_id/$iApp-image:$tag"
    docker push $docker_id/$iApp-image:$tag
  done
else
  echo "Push de l'images $docker_id/$app-image:$tag"
  docker push $docker_id/$app-image:$tag
fi
