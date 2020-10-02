# Docker-Regen

Dockerized Regen Node

---

[![MicroBadger Version](https://images.microbadger.com/badges/version/ryanhendricks/docker-regen.svg)](https://microbadger.com/images/ryanhendricks/docker-regen)
[![CircleCI (all branches)](https://img.shields.io/circleci/project/github/RyanHendricks/docker-regen.svg?label=build&logo=circleci&logoColor=white)](https://circleci.com/gh/RyanHendricks/docker-regen)
[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-regen.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-regen)

[![MicroBadger Layers (latest)](https://img.shields.io/microbadger/layers/ryanhendricks/docker-regen/latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-regen)
[![MicroBadger Image-Size (latest)](https://img.shields.io/microbadger/image-size/ryanhendricks/docker-regen:latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-regen)

[![Codacy grade](https://img.shields.io/codacy/grade/c35da045d95b4f07b09948d19bacaa47.svg?logo=codacy)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RyanHendricks/docker-regen&amp;utm_campaign=Badge_Grade)

---

## Prerequisites

- Docker
- Docker-Compose (optional)

## Quick Start

The image can be run without any configuration and defaults to the *latest testnet*

```bash
docker run --rm -d -p 1317:1317/tcp -p 26656:26656/tcp -p 26657:26657/tcp -p 26658:26658/tcp ryanhendricks/docker-regen:latest
```

## Configuration

### Config.toml Parameters

- The config.toml is created dynamically when starting the container.
- All parameters specified in the standard config.toml file can be set using environmental variables with the same as the config parameter but in all caps.
- If left unset the default values will be used.
- Parameters can be set directly by modifying the config.toml portion of ./scripts/entrypoint.sh if you are cloning and building the image yourself.

### Environment Variables

You can set the following env variables either in a docker-compose file or in the docker run command if running the container directly. If left unchanged they will default to the values listed below.

- MONIKER
  - defaults to "regen-node"
- CHAIN_ID
  - defaults to regen-test-1001
- GENESIS_URL
  - defaults to regen-test-1001 github [genesis file url](https://raw.githubusercontent.com/regen-network/testnets/master/regen-test-1001/genesis.json)

```bash
# Example ENV variable from config.toml
MONIKER=regen-node
# The following variables (and their defaults) are set in the container creation entrypoint script and not set in config.toml:
CHAIN_ID=regen-test-1001
GENESIS_URL=https://raw.githubusercontent.com/regen-network/testnets/master/regen-test-1001/genesis.json
```

## Build

The following command will build the image.

```bash
docker build --rm -f Dockerfile -t docker-regen:latest .
```

## Supervisor

The image uses Supervisor to run both xrnd and xrncli simultaneously at container runtime. Supervisor also restarts either process should it fail for some reason.

### Additional Info

After starting the container you can check the status here: [http://127.0.0.1:26657/status](http://127.0.0.1:26657/status).

or from the terminal

```bash
# Node
curl -X GET \
  http://127.0.0.1:26657/status? \
  -H 'cache-control: no-cache'
```

```bash
# Rest Server
curl -X GET \
  http://127.0.0.1:1317/blocks/latest \
  -H 'cache-control: no-cache'
```

## Contributing

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?)](http://makeapullrequest.com)

### Contributors

[![Keybase PGP](https://img.shields.io/keybase/pgp/ryanhendricks.svg?label=keybase&logo=keybase&logoColor=white)](https://keybase.io/ryanhendricks)
<!-- 
## License

![GitHub](https://img.shields.io/github/license/ryanhendricks/docker-regen.svg)
 -->
