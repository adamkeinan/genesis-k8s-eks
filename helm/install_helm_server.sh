#!/usr/bin/env bash

# create Tiller service account  
kubectl --namespace kube-system create serviceaccount tiller

# create clusterrolebinding for Tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

# patch to only listen on a certain port
kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

# add node taint tolerations to deployed Tiller pods
kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/tolerations", "value": [{ "key" : "dirac.washington.edu/instance-name", "value" : "t3-medium", "operator" : "Equal", "effect" : "NoSchedule"}]}]'

# add nodeSelector
kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/nodeSelector", "value": { "dirac.washington.edu/instance-name" : "t3-medium"}}]'

# wait for tiller to initialize
helm init --service-account tiller --wait

# verify client / server versions
helm version

