# UPDATE ME when new version is out !!!!
ARG BVER=0.6.3-hotfix
ARG CLIVER=0.6.3
FROM ubuntu:18.04 as builder

# Dockerfile for running Binance node from binary packages under docker
# https://docs.binance.org/fullnode.html#run-full-node-to-join-binance-chain
# MIT license
LABEL Maintainer = "Evgeny Varnavskiy <varnavruz@gmail.com>"
LABEL Description="Docker image for Binance full and light nodes"
LABEL License="MIT License"

ARG DEBIAN_FRONTEND=noninteractive

ARG BVER
ARG CLIVER
ARG NODETYPE=quicksync
#ARG NODETYPE=lightnode

RUN apt-get update && apt-get install -y --no-install-recommends upx ca-certificates wget git git-lfs binutils
RUN	git lfs clone --depth 1 https://github.com/binance-chain/node-binary.git

# RUN upx /node-binary/cli/testnet/${CLIVER}/linux/tbnbcli \
# && upx /node-binary/cli/prod/${CLIVER}/linux/bnbcli \
# && upx /node-binary/${NODETYPE}/testnet/${BVER}/linux/bnbchaind \
# && upx /node-binary/${NODETYPE}/prod/${BVER}/linux/bnbchaind

# Final stage

FROM ubuntu:18.04

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

ARG BVER
ARG CLIVER
ENV BVER=$BVER
ENV CLIVER=$CLIVER
ARG NODETYPE=quicksync
ENV BNET=prod
ENV BNCHOME=/opt/bnbchaind

COPY --from=builder /node-binary/cli/${BNET}/${CLIVER}/linux/bnbcli /node-binary/cli/${BNET}/${BVER}/linux/
COPY --from=builder /node-binary/${NODETYPE}/bnbchaind /node-binary/${NODETYPE}/linux/
COPY ./bin/*.sh /usr/local/bin/

RUN set -ex \
&& chmod +x /usr/local/bin/*.sh \
&& mkdir -p "$BNCHOME" \
&& groupadd --gid "$HOST_USER_GID" bnbchaind \
&& useradd --uid "$HOST_USER_UID" --gid "$HOST_USER_GID" --shell /bin/bash --no-create-home bnbchaind \
&& chown -R bnbchaind:bnbchaind "$BNCHOME"

VOLUME ${BNCHOME}

# RPC service listen on port 27147 and P2P service listens on port 27146 by default.
# Prometheus is enabled on port 26660 by default, and the endpoint is /metrics.

EXPOSE 27146 27147 26660

ENTRYPOINT ["entrypoint.sh"]
