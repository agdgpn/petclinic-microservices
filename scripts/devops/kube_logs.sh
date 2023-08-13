#!/bin/bash
args=$#
namespace="dev"
nbl=10 # Valeur par défaut.
app=$1
if [ $args = 0 ]
then
  echo "Exécution impossible: Le nom de l'appication est requis"
  echo "Choisir un nom dans la liste { config, discovery, customers, vets, visits, admin, api-gateway } comme argument du script."
  exit
fi
if [ $args -ge 1 ]
then
  if [ $app = mysql ] || [ $app = config ] || [ $app = admin ] || [ $app = discovery ]
  then
    app="$app-server"
  fi
  if [ $app = customers ] || [ $app = vets ] || [ $app = visits ]
  then
    app=$app-service
  fi
  if [ $args = 2 ]
  then
    namespace=$2
  fi
  if [ $args = 3 ]
  then
    nbl=$3
  fi
fi
# Execution de commande avec
#  - Si les arguments namespace et nombre de lingne sont omis, les valeus par défaut dev et 100 sont utilisées.
#  - Sinon les valeurs spécifiées en argument seront utilisées.
echo "Lancement commande : <kubectl logs -f -l app=$app --tail $nbl --all-containers=true -n $namespace> ..."
kubectl logs -f -l app=$app --tail $nbl --all-containers=true -n $namespace
