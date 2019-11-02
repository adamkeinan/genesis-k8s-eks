#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Must pass name of user as first argument"
    exit 1
else
    echo ""
    echo "Finding tokens for users with name matching *$1*"
    user_name=$(kubectl -n kubernetes-dashboard get secret | grep $1 | awk '{print $1}')
    echo "Found user: $user_name"
    kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep $1 | awk '{print $1}') | grep 'token:' | awk '{print $2}'
    echo ""
fi
