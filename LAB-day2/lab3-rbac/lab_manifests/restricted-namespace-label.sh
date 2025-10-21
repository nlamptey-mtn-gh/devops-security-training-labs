#!/bin/bash
kubectl create namespace dev
kubectl label namespace dev pod-security.kubernetes.io/enforce=restricted
echo "Namespace 'dev' labeled with restricted Pod Security Standard."
