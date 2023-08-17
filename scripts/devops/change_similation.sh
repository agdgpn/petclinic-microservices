#!/bin/bash
app=$1
if [[ $app = all ]]
then
    echo "Modifying */triggers.txt ..."
    echo "test `date`" >> spring-petclinic-admin-server/triggers.txt
    echo "test `date`" >> spring-petclinic-api-gateway/triggers.txt
    echo "test `date`" >> spring-petclinic-config-server/triggers.txt
    echo "test `date`" >> spring-petclinic-customers-service/triggers.txt
    echo "test `date`" >> spring-petclinic-discovery-server/triggers.txt
    echo "test `date`" >> spring-petclinic-vets-service/triggers.txt
    echo "test `date`" >> spring-petclinic-visits-service/triggers.txt
else
    if [[ $1 = config ]]
    then
        echo "test `date`" >> spring-petclinic-config-server/triggers.txt
        echo "Modifying spring-petclinic-config-server/triggers.txt ..."
    fi
fi