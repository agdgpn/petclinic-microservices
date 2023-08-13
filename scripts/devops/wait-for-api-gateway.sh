#!/bin/bash
# En attente du message passe en argumen 1 dans le container passe en argument 2
grep -q "api-gateway:8080 with status UP"<(docker logs --follow "discovery-server")
echo "Message 'api-gateway:8080 with status UP'  received from 'discovery-server' on `date`"
