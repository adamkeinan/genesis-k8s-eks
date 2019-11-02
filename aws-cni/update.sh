#!/bin/bash

kubectl patch daemonset aws-node \
-n kube-system \
-p '{"spec": {"template": {"spec": {"containers": [{"image": "602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon-k8s-cni:v1.5.4","name":"aws-node"}]}}}}'

echo "aws-cni version"
kubectl describe daemonset aws-node -n kube-system | grep Image | cut -d "/" -f 2

