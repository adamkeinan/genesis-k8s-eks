#!/bin/bash

kubectl apply -f *.yaml

# add node taint tolerations to deployed pods
kubectl patch daemonset nvidia-device-plugin-daemonset --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/tolerations/0", "value": { "key" : "dirac.washington.edu/instance-name", "operator" : "Exists", "effect" : "NoSchedule"}}]'

