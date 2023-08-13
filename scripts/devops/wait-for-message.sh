#!/bin/bash
# En attente du message passe en argumen 1 dans le container passe en argument 2
grep -q "$1"<(docker logs --follow "$2")
echo "Message '$1'  received from '$2' on `date`"
