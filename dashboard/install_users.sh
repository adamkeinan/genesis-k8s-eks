#!/bin/bash

for user in users/*.yaml; do
    cmd="kubectl apply -f $user"
    echo $cmd
    $cmd
done
