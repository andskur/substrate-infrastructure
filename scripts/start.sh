#!/bin/sh

# up all composer services
docker-compose up -d

# wait all nodes running
sleep 3

# activate validator nodes
./scripts/activate_validators.sh

# restart validator nodes for start finalizing blocks
# (don't know why they don't do it automatically after key imports)
docker-compose restart thrall jaina