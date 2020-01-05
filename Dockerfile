FROM golang:1.13.2-alpine AS build-env


ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev
ENV VERSION=v0.5.0

# Set up dependencies
RUN apk add --no-cache $PACKAGES

# Set working directory for the build
WORKDIR /go/src/github.com/regen-network/

# Add source files
RUN git clone -b $VERSION https://github.com/regen-network/regen-ledger
WORKDIR /go/src/github.com/regen-network/regen-ledger

# Install minimum necessary dependencies, build Cosmos SDK, remove packages
RUN make


# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --no-cache --update ca-certificates supervisor wget lz4

# Temp directory for copying binaries
RUN mkdir -p /tmp/bin
WORKDIR /tmp/bin

# Copy over binaries from the build-env
COPY --from=build-env /go/bin/xrnd /tmp/bin
COPY --from=build-env /go/bin/xrncli /tmp/bin
RUN install -m 0755 -o root -g root -t /usr/local/bin xrnd
RUN install -m 0755 -o root -g root -t /usr/local/bin xrncli

# Remove temp files
RUN rm -r /tmp/bin

# Add supervisor configuration files
RUN mkdir -p /etc/supervisor/conf.d/
COPY /supervisor/supervisord.conf /etc/supervisor/supervisord.conf 
COPY /supervisor/conf.d/* /etc/supervisor/conf.d/

ENV REGEN_HOME=/.regen
WORKDIR $REGEN_HOME

# Expose ports for gaiad and gaiacli rest-server
EXPOSE 26656 26657 26658
EXPOSE 1317

# Add entrypoint script
COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

STOPSIGNAL SIGHUP