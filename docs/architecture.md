# Architecture

## Overview

`hath-server-container` packages the official Hentai@Home client into a containerized service. It bundles the Eclipse Semeru Java runtime and mounts cache, configuration, downloads, and logs from the host disk.

```mermaid
flowchart LR
    Host[Host Volumes] -->|Bind Mounts| Container[H@H Container]
    Container --> Client[Hentai@Home Client]
    Client -->|HTTPS| Upstream[H@H Network]
```

## Core Components

- **Runtime Image**: Built on Eclipse Semeru OpenJ9 JRE to provide minimal footprint and fast startup.
- **Entrypoint Script (`start.sh`)**: Sets umask permissions, writes `client_login` from environment variables, and launches the client jar.
- **Persistence Volumes**: Maps host directories for `data`, `download`, `cache`, and `log` to retain state across restarts and rebuilds.

## Invariants & Guarantees

- **Host Persistence**: All client state, cache, and downloads live exclusively on host bind mounts. Rebuilding the image never destroys cached data.
- **Dynamic Credentials**: Credentials from container environment variables populate `client_login` freshly on each boot.
- **Self-Healing Network**: Container restarts automatically with explicit DNS resolvers configured to survive host network changes.
