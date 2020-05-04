#!/bin/sh

# check if chainspec file path argument is provided. If no - set default path
if [[ -z "${1}" ]]; then
    CHAIN_SPEC_PATH=./chainSpec/minikubeLocalSpecRaw.json
else
    CHAIN_SPEC_PATH="${1}"
fi

kubectl create configmap chainspec --from-file="${CHAIN_SPEC_PATH}"