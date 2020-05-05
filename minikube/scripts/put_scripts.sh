#!/bin/sh

# put import_keys.sh script to k8s configmap
kubectl create configmap import-script --from-file=../scripts/import_keys.sh