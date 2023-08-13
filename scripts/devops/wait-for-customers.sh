#!/bin/bash
# En attente du message passe en argumen 1 dans le container passe en argument 2
grep -q "customers-service:8081 with status UP"<(docker logs --follow discovery-server)
echo "Message 'customers-service:8081 with status UP'  received from 'discovery-server' on `date`"
