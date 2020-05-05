#!/bin/bash

# function for generate payload for json rpc request
# function need to take arguments
# $1 - key type aura or gran
# $2 - sr25519 or ed25519 public key
generateRpcRequest()
{
    cat <<EOF
{
    "jsonrpc":"2.0",
    "id":1,
    "method":"author_insertKey",
    "params": [
        "$1",
        "$KEY_MNEMONIC",
        "$2"
    ]
}
EOF
}

sleep 20

#checking if all necessary env variables setted
if [[ -z "${KEY_MNEMONIC}" ]]; then
    echo ERROR: you need to specific keys mnemonic phrase in KEY_MNEMONIC environment variable
    exit 1
fi

if [[ -z "${KEY_SR25519}" ]]; then
    echo ERROR: you need to specific sr25519 public key in KEY_SR25519 environment variable
    exit 1
fi

if [[ -z "${KEY_ED25519}" ]]; then
    echo ERROR: you need to specific ed25519 oublic key in KEY_ED25519 environment variable
    exit 1
fi

# check if rpc argument address is provided. If no - set default value
if [[ -z "${1}" ]]; then
    NODE_RPC_ADR=http://localhost:9933
else
    NODE_RPC_ADR="${1}"
fi

echo $(generateRpcRequest aura "$KEY_SR25519")

# Submit a new aura sr25519 key via RPC
curl  "${NODE_RPC_ADR}" -H "Content-Type:application/json;charset=utf-8" --data "$(generateRpcRequest aura $KEY_SR25519)"
echo aura se25519 key successfully inserted to node via Json RPC on address "${NODE_RPC_ADR}"


echo $(generateRpcRequest gran $KEY_ED25519)

# Submit a new grandpa ed25519 key via RPC
curl  "${NODE_RPC_ADR}" -H "Content-Type:application/json;charset=utf-8" --data "$(generateRpcRequest gran $KEY_ED25519)"
echo granpa ed25519 key successfully inserted to node via Json RPC on address "${NODE_RPC_ADR}"
