FROM alpine:3 AS build

# renovate: datasource=repology depName=nix_unstable/dnsmasq versioning=semver-coerced
ARG VERSION="2.92"

# Add dnsmasq archive and signature
ADD https://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz /tmp/dnsmasq.tar.gz
ADD https://thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.gz.asc /tmp/dnsmasq.tar.gz.asc

# Install dependencies including GPG for signature verification
RUN apk add --no-cache gcc linux-headers make musl-dev curl gnupg

# Import Simon Kelley's public key from official source
RUN curl -s https://thekelleys.org.uk/srkgpg.txt | gpg --import

# Verify the GPG signature
RUN gpg --verify /tmp/dnsmasq.tar.gz.asc /tmp/dnsmasq.tar.gz

# Extract and build dnsmasq
RUN tar -C /tmp -xf /tmp/dnsmasq.tar.gz && \
    cd /tmp/dnsmasq-$VERSION && \
      make LDFLAGS="-static"

RUN mkdir -p /rootfs/bin && \
      cp /tmp/dnsmasq-$VERSION/src/dnsmasq /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
EXPOSE 1053/udp
ENTRYPOINT ["/bin/dnsmasq"]
CMD ["--keep-in-foreground", "--port=1053"]