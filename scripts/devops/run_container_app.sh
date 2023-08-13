#!/bin/sh
args=$#
if [ $args = 0 ]
then
    ../mvnw spring-boot:run
else
    if [ $args = 1 ]
    then
        sleep $1
        ../mvnw spring-boot:run
    else
        if [ $args = 2 ]
        then
            if [ "$2" != "mysql" ] && [ "$2" != "docker" ] && [ "$2" != "mysql,docker" ] && [ "$2" != "docker,mysql" ]
            then
                echo "[$0] - Le profile '$2' est inconnu! - Les profiles connus sont : 'msql' 'docker' 'mysql,docker' 'docker mysql'"
                exit
            fi
            sleep $1
            ../mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=$2
        fi
    fi
fi