# dnsmasq
Built-from-source container image for [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html). Based on archived https://github.com/ricardbejarano/dnsmasq

Published on [ghcr.io/stephanme/dnsmasq](https://github.com/stephanme/dnsmasq/pkgs/container/dnsmasq)

`docker pull ghcr.io/stephanme/dnsmasq`

## Features

* Compiled from source during build time
* Built `FROM scratch`, with zero bloat
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user
* Example HA deployment on k3s: [kube-system/dnsmasq](https://github.com/stephanme/pv-monitoring/tree/main/kube-system/dnsmasq)