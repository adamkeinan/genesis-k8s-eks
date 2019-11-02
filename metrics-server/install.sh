#!/bin/bash

# https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html

echo "Finding latest metrics server release"
DOWNLOAD_URL=$(curl --silent ""https://api.github.com/repositories/92132038/releases/latest | jq -r .tarball_url)
DOWNLOAD_VERSION=$(grep -o '[^/v]*$' <<< $DOWNLOAD_URL)

echo "Downloading metrics server verion $DOWNLOAD_VERSION"
curl -Ls $DOWNLOAD_URL -o metrics-server-$DOWNLOAD_VERSION.tar.gz
mkdir metrics-server-$DOWNLOAD_VERSION
tar -xzf metrics-server-$DOWNLOAD_VERSION.tar.gz --directory metrics-server-$DOWNLOAD_VERSION --strip-components 1
rm -rf metrics-server-deploy/1.8+
mv metrics-server-$DOWNLOAD_VERSION/deploy/1.8+ metrics-server-deploy

echo "Deleting previous metrics server deployment"
kubectl delete -f metrics-server-deploy

echo "Applying metrics server deployment"
kubectl apply -f metrics-server-deploy

echo "Patching to add node tolerations and selectors"
# add node taint tolerations to deployed pods
kubectl patch deployment metrics-server --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/tolerations", "value": [{ "key" : "dirac.washington.edu/instance-name", "value" : "t3-medium", "operator" : "Equal", "effect" : "NoSchedule"}]}]'

# add nodeSelector
kubectl patch deployment metrics-server --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/nodeSelector", "value": { "dirac.washington.edu/instance-name" : "t3-medium"}}]'

echo "Cleaning up"
rm -rf metrics-server-$DOWNLOAD_VERSION
rm -rf metrics-server-$DOWNLOAD_VERSION.tar.gz
