<div align="center">

# H@H Server Container

**Run the Hentai@Home client as a set-and-forget Docker service: Java runtime included, your cache, credentials and downloads mounted from the host.**

[![CI](https://img.shields.io/github/actions/workflow/status/Delnegend/hath-server-container/ci.yml?branch=main&style=flat-square)](https://github.com/Delnegend/hath-server-container/actions)
[![Release](https://img.shields.io/github/v/release/Delnegend/hath-server-container?style=flat-square)](https://github.com/Delnegend/hath-server-container/releases)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

</div>

---

## Quick Start

```bash
# 1. Set your client ID and key in docker-compose.yml
#    (HATH_CLIENT_ID, HATH_CLIENT_KEY, plus TZ for your timezone)

# 2. Start it
docker compose up -d --build

# 3. Watch it come up
docker logs -f hath
```

## Highlights

- **No Java on the host**: The image ships the Semeru JRE and downloads the pinned client release into it.
- **State lives on your disk**: Cache, data, downloads, and logs are all bind mounts, so rebuilding the image never loses anything.
- **Fresh credentials every start**: The entry script rewrites `client_login` from the compose environment before launching.
- **Survives reboots**: `restart: unless-stopped` with Cloudflare DNS so the client resolves even on captive networks.

## Documentation

- **[Architecture](docs/architecture.md)**: Container runtime architecture, persistence volumes, and host mounts.
- **[Development](docs/development.md)**: Building images locally, shellcheck/actionlint checks, and release workflows.
- **[Deployment](docs/deployment.md)**: Deployment via Docker Compose or Podman, logging, and upgrades.

## License

[MIT](LICENSE)
