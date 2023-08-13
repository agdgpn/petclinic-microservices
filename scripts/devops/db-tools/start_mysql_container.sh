#!/bin/bash
# Start mysql container named by argument 1 on the network given as a second argument.
# Arret de l'instance mysql-server du container mysql en cours d execution
#sudo docker stop mysql-server
# Attendre 5 secondes avant de relancer une nouvelle instance.
#sleep 5

# Lancement du container sans nom ni reseau (netword).
if [ ! $1 ]
then
    sudo docker run -d  --rm -e MYSQL_ROOT_PASSWORD=petclinic -e MYSQL_DATABASE=petclinic \
    -p 3306:3306 mysql:5.7.8
fi

# Lancement du container avec le nom donne comme unique argument du script.
if [ $1 ] && [ ! $2 ]
then
  sudo docker run -d  --rm -e MYSQL_ROOT_PASSWORD=petclinic -e MYSQL_DATABASE=petclinic \
  --name $1 -p 3306:3306 mysql:5.7.8
fi

# Lancement du container nomme avec le premier argument dans le reseau dont 
# le nom est fourni comme second argument du script.
if [ $1 ] && [ $2 ]
then
  sudo docker run -d  --rm -e MYSQL_ROOT_PASSWORD=petclinic -e MYSQL_DATABASE=petclinic \
  --name $1 --network $2 -p 3306:3306 mysql:5.7.8
fi

# Attendre 20 le temps que le container finit de se lancer.
#sleep 20
#./init_db.sh 
