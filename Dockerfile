FROM golang:1.15-alpine3.12 AS builder

ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev libusb-dev linux-headers ca-certificates build-base
ENV VERSION=v1.0.0

RUN set -eux; apk add --no-cache $PACKAGES;

# Set working directory for the build
WORKDIR /go/src/github.com/regen-network/

# Add source files
RUN git clone --recursive https://github.com/regen-network/regen-ledger
WORKDIR /go/src/github.com/regen-network/regen-ledger
RUN git checkout $VERSION

# See https://github.com/CosmWasm/wasmvm/releases
ADD https://github.com/CosmWasm/wasmvm/releases/download/v0.13.0/libwasmvm_muslc.a /lib/libwasmvm_muslc.a
RUN sha256sum /lib/libwasmvm_muslc.a | grep 39dc389cc6b556280cbeaebeda2b62cf884993137b83f90d1398ac47d09d3900

RUN LEDGER_ENABLED=false BUILD_TAGS=muslc make install

# ------------------------------------------------------------------ #

FROM alpine:edge

ENV REGEN_HOME=/.regen

# Install ca-certificates
RUN apk add --no-cache --update ca-certificates py3-setuptools supervisor wget lz4

# Temp directory for copying binaries
RUN mkdir -p /tmp/bin
WORKDIR /tmp/bin

COPY --from=builder /go/bin/regen /tmp/bin
RUN install -m 0755 -o root -g root -t /usr/local/bin regen

# Remove temp files
RUN rm -r /tmp/bin

# Add supervisor configuration files
RUN mkdir -p /etc/supervisor/conf.d/
COPY /supervisor/supervisord.conf /etc/supervisor/supervisord.conf 
COPY /supervisor/conf.d/* /etc/supervisor/conf.d/


WORKDIR $REGEN_HOME

# Expose ports
EXPOSE 26656 26657 26658
EXPOSE 1317

# Add entrypoint script
COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

STOPSIGNAL SIGHUP
