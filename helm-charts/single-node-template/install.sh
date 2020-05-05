#!/bin/bash


#checking if all necessary env variables setted
if [[ -z "${KEY_MNEMONIC}" ]]; then
    echo ERROR: you need to specific keys mnemonic phrase in KEY_MNEMONIC environment variable
    exit 1
else
    MNEMONIC=$(echo "${KEY_MNEMONIC}" | base64)
fi

if [[ -z "${KEY_SR25519}" ]]; then
    echo ERROR: you need to specific sr25519 public key in KEY_SR25519 environment variable
    exit 1
else
    SR25519=$(echo "${KEY_SR25519}" | base64)
fi

if [[ -z "${KEY_ED25519}" ]]; then
    echo ERROR: you need to specific ed25519 oublic key in KEY_ED25519 environment variable
    exit 1
else
    ED25519=$(echo "${KEY_ED25519}" | base64)
fi

# check if rpc argument address is provided. If no - set default value
if [[ -z "${1}" ]]; then
    APP_NAME=node
else
    APP_NAME="${1}"
fi


helm install "${APP_NAME}" --set \
  app="${APP_NAME}",validator.p2p="${KEY_P2P}",validator.mnemonic="${MNEMONIC}",validator.sr25519="${SR25519}",validator.ed25519="${ED25519}" \
./
