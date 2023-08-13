#!/bin/bash
# En attente du message passe en argumen 1 dans le container passe en argument 2
grep -q "Started DiscoveryServerApplication in"<(docker logs --follow discovery-server)
echo "Message 'Started DiscoveryServerApplication in'  received from 'discovery-server' on `date`"
