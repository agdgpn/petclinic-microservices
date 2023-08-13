#!/bin/bash
# En attente du message passe en argumen 1 dans le container passe en argument 2
grep -q "Started ConfigServerApplication in"<(docker logs --follow config-server)
echo "Message 'Started ConfigServerApplication in'  received from 'config-server' on `date`"
