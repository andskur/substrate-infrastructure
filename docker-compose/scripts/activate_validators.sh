#!/bin/sh

# scripts fro autmaticaly insert all keys to validators

set -a
. ../keys/thrall/.env
set +a

./scripts/import_keys.sh

set -a
. ../keys/jaina/.env
set +a

./scripts/import_keys.sh http://localhost:9934

echo all validators nodes activated
