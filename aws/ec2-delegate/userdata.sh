#!/bin/bash -e

#note this is for amazon linux.  not tested as userdata yet, only manual commands

sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull harness/delegate:latest

ACCOUNT_ID='xxxx'
ACCOUNT_SECRET='xxxx'

sudo docker run -d --restart unless-stopped --hostname=$(hostname -f) \
-e ACCOUNT_ID="${ACCOUNT_ID}" \
-e ACCOUNT_SECRET="${ACCOUNT_SECRET}" \
-e MANAGER_HOST_AND_PORT=https://app.harness.io \
-e WATCHER_STORAGE_URL=https://app.harness.io/storage/wingswatchers \
-e WATCHER_CHECK_LOCATION=watcherprod.txt \
-e DELEGATE_STORAGE_URL=https://app.harness.io/storage/wingsdelegates \
-e DELEGATE_CHECK_LOCATION=delegateprod.txt \
-e DEPLOY_MODE=KUBERNETES \
-e PROXY_HOST= \
-e PROXY_PORT= \
-e PROXY_SCHEME= \
-e PROXY_USER= \
-e PROXY_PASSWORD= \
-e NO_PROXY= \
-e PROXY_MANAGER=true \
-e POLL_FOR_TASKS=false \
-e HELM_DESIRED_VERSION= \
-e MANAGER_TARGET=app.harness.io \
-e MANAGER_AUTHORITY=manager-grpc-app.harness.io \
harness/delegate:latest
