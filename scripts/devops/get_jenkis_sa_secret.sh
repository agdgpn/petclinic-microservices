
#!/bin/bash
# Generate Jenkins secret to use in jenkins
# Usage : ./get_jenkis_sa_secret.sh NS
# NS = namespace where the secret is going to be used.

NS=$1
kubectl get secrets jenkins-admin-token  -o=jsonpath='{.data.token}' -n $NS | base64 -d