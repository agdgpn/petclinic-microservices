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
        echo "Modifying spring-petclinic-config-server/triggers.txt ..."
        echo "test `date`" >> spring-petclinic-config-server/triggers.txt
    fi
    if [[ $1 = visits ]]
    then
        echo "Modifying spring-petclinic-visits-service/triggers.txt ..."
        echo "test `date`" >> spring-petclinic-visits-service/triggers.txt
    fi
    if [[ $1 = vets ]]
    then
        echo "Modifying spring-petclinic-vets-service/triggers.txt ..."
        echo "test `date`" >> spring-petclinic-vets-service/triggers.txt
    fi
    if [[ $1 = discovery ]]
    then
        echo "Modifying spring-petclinic-discovery-server/triggers.txt ..."
        echo "test `date`" >> spring-petclinic-discovery-server/triggers.txt
    fi
    if [[ $1 = customers ]]
    then
        echo "Modifying spring-petclinic-customers-service/triggers.txt ..."
        echo "test `date`" >> spring-petclinic-customers-service/triggers.txt
    fi
    if [[ $1 = api-gateway ]]
    then
        echo "Modifying spring-petclinic-api-gateway/triggers.txt ..."
        echo "test `date`" >> spring-petclinic-api-gateway/triggers.txt
    fi
    if [[ $1 = admin ]]
    then
        echo "Modifying spring-petclinic-admin-server/triggers.txt ..."
        echo "test `date`" >> spring-petclinic-admin-server/triggers.txt
    fi
fi