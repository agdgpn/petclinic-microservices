#!/bin/bash
# Create AMI image from a running instance.
# First arg = the  instance ID, Second arg = the AWS profile user
# Usage ./aws_create_image.sh INSTANCE-ID  SERVER-NAME AWS_PROFILE :
# Example ./aws_create_image.sh i-0dcf65cf09307baed jenkins-controller perso
# Prépare l environnment.

instance=$1         # example : i-0b09a25c58929de26
serverName=$2       # Example : jenkins-controller
profile=$3          # Example : perso (my personal AWS account)
suffix=$(date +'%Y%m%d%H%M%S')
aws ec2 create-image \
    --instance-id $instance \
    --name $serverName-$suffix \
    --no-reboot --profile $profile
