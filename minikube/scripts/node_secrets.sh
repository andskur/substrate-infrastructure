#!/bin/sh

# you need to provide node name
if [[ -z "${1}" ]]; then
    echo ERROR: you need provide node name
    exit 1
fi

# check if node keys  path argument is provided.
# If no - set default path based on node name.
if [[ -z "${2}" ]]; then
    KEYS_PATH=../keys/${1}
else
    KEYS_PATH="${1}"
fi

kubectl create secret generic "${1}"-p2p --from-file="${KEYS_PATH}"/node.key

set -a
. ./"${KEYS_PATH}"/.env
set +a

kubectl create secret generic "${1}"-authorities --from-literal=KEY_MNEMONIC="${KEY_MNEMONIC}" --from-literal=KEY_SR25519="${KEY_SR25519}" --from-literal=KEY_ED25519="${KEY_ED25519}"