# Deploy local substrate network via docker-compose
Repository contain substrate all necessary components for run local properly monitored private substrate network.

## Containers:
 - **thrall & jaina** - two substrate validators nodes
 - **kairn** - substrate node with no validator authorities
 - **ui-app** - polkadot frontend application for interacting with nodes
 - **telemetry-backend** - substrate telemetry metrics backend
 - **telemetry-frontend** - frontend app that show nodes telemetry metrics
 - **prometheus** - main metrics server
 - **grafana** - metrics visualisation
 - **node-esporter** - prometheus exporter for machine metrics
 - **cadvisor** - containers resources usage metrics
 
 ## Requirements
  - **[docker](https://www.docker.com)** - container runtime
  - **[docker-compose](https://docs.docker.com/compose/)** - containers orchestration
  - **[subkey](https://github.com/paritytech/substrate/tree/master/bin/utils/subkey)** - substrate key generation util
 
 
 ## Usage
*All command executed from project root directory*
 
 ### Generate Keys
 For first we need to generate nodes keys for libp2p networking and validators key pairs.
 
 #### Nodes networking keys
 For each validator node we need to generate libp2p networking keys
 for nodes we need use ``subkey`` command with output file as argument
 like ``subkey -e generate-node-key keys/{node_name}/node.key``.
 
 example:
 ```=bash
 $ subkey -e generate-node-key keys/thrall/node.key
 QmNya1J4fRYoa72GjAHIPaaW2tWhjXsDx8AVcP9LRwM2PA
 ```
 command save unencoded key to file and print peerID.
 We need to save it and add to chain spec bootnodes configuration.
 
 #### Nodes validator keys
 For each validator node we need to generate sr25519 and ed25519 for aura block and grandpa.
 
 *This step is some pain for this moment, but i'm working on automatic tool for generate keys and update chainspec.*
 
 ##### Aura sr25519
 Simple use ``subkey`` command for generate key - ``subkey --sr25519 generate > keys/{node_name}/sr25519``.
 
 example:
 ```=bash
 $ subkey --sr25519 generate > keys/thrall/sr25519
 ```
 
 ##### Grandpa ed25519
 We need use ``subkey`` command with mnnemonic seed from previos step
 (we can found it in generated key file) - 
 ``subkey --ed25519 inspect "{your 12 world mnemonic seed from previous step}" > keys/{node_name}/ed25519``.
 
  example:
 ```=bash
 $ subkey --ed25519 inspect "{your 12 world mnemonic seed from previous step}" > keys/{node_name}/ed25519
 ```
 #### create .env file
 Next we need yo create .env file for all validator nodes based on ``keys/.env.examle``
 file and values that we have recieved from previous step.
 
 ```=bash
 KEY_MNEMONIC={genereated mnemonic seed}
 KEY_SR25519={sr25519 public key}
 KEY_ED25519={ed25519 public key}
 ```
 
 once you have finished with values in .env file save it as ``keys/{node}/.env`` for each node.
 
 #### update chainspec
 Next we need update chainspec file by add generated keys to aura and granpa authorities:
 
```=json
  "genesis": {
    "runtime": {
      // --skip--
      "aura": {
        "authorities": [
          "{first validator node sr25519 address}",
          "{second validator node sr25519 address}"
        ]
      },
      "grandpa": {
        "authorities": [
          [
            "{first validator node ed25519 address}",
            1
          ],
          [
            "{second validator node ed25519 address}",
            1
          ]
        ]
      },
      // --skip--
      "sudo": {
        "key": "{first validator node sr25519 address}"
      }
    }
  }
```

### Start substrate network
For start network simple run start script - ``./scripts/start.sh``. 
It will up all containers and import validators keys to nodes.

example:
```=bash
$./scripts/start.sh
Creating network "substrate-infrastructure_panlog" with the default driver
Creating node-exporter      ... done
Creating telemetry-backend ... done
Creating ui-app            ... done
Creating cadvisor           ... done
Creating thrall             ... done
Creating telemetry-frontend ... done
Creating jaina              ... done
Creating kairn              ... done
Creating prometheus         ... done
Creating grafana            ... done
{"jsonrpc":"2.0","result":null,"id":1}
aura se25519 key successfully inserted to node via Json RPC on address http://localhost:9933
{"jsonrpc":"2.0","result":null,"id":1}
granpa ed25519 key successfully inserted to node via Json RPC on address http://localhost:9933
{"jsonrpc":"2.0","result":null,"id":1}
aura se25519 key successfully inserted to node via Json RPC on address http://localhost:9934
{"jsonrpc":"2.0","result":null,"id":1}
granpa ed25519 key successfully inserted to node via Json RPC on address http://localhost:9934
all validators nodes activated
Restarting jaina  ... done
Restarting thrall ... done
```

## Monitoring

### Telemetry
You can access to telemetry ui on [http://localhost:8080/]()

### Grafana
You can access grafana on [http://localhost:3001/]()

Defaul user and password - **admin**

## Authors

* **Andrey Skurlatov** - [andskur](https://github.com/andskur)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
