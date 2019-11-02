#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml

# add node taint tolerations to deployed pods
kubectl patch deployment kubernetes-dashboard --namespace=kubernetes-dashboard --type=json --patch='[{"op": "add", "path": "/spec/template/spec/tolerations/0", "value": { "key" : "dirac.washington.edu/instance-name", "value" : "t3-medium", "operator" : "Equal", "effect" : "NoSchedule"}}]'
kubectl patch deployment dashboard-metrics-scraper --namespace=kubernetes-dashboard --type=json --patch='[{"op": "add", "path": "/spec/template/spec/tolerations/0", "value": { "key" : "dirac.washington.edu/instance-name", "value" : "t3-medium", "operator" : "Equal", "effect" : "NoSchedule"}}]'

# add nodeSelector
kubectl patch deployment kubernetes-dashboard --namespace=kubernetes-dashboard --type=json --patch='[{"op": "add", "path": "/spec/template/spec/nodeSelector", "value": { "dirac.washington.edu/instance-name" : "t3-medium"}}]'
kubectl patch deployment dashboard-metrics-scraper --namespace=kubernetes-dashboard --type=json --patch='[{"op": "add", "path": "/spec/template/spec/nodeSelector", "value": { "dirac.washington.edu/instance-name" : "t3-medium"}}]'

