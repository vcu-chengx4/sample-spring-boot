#!/bin/bash
if ! kubectl get ns devopslab; then
    kubectl create ns devopslab
fi

if ! kubectl rollout status deployment sample-spring-boot -n devopslab; then
    kubectl apply -f kubernetes.yml
fi
