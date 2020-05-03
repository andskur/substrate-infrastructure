#!/bin/sh

docker-compose up -d
./scripts/activate_validators.sh
