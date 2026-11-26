<div align="center">

# H@H Server Container

**Run the Hentai@Home client as a set-and-forget Docker service: Java runtime included, your cache, credentials and downloads mounted from the host.**

[![CI](https://badgers.space/github/checks/Delnegend/hath-server-container/main?corner_radius=0&label=build)](https://github.com/Delnegend/hath-server-container/actions)
[![Release](https://badgers.space/github/release/Delnegend/hath-server-container?corner_radius=0&color=ea7233)](https://github.com/Delnegend/hath-server-container/releases)
[![License](https://badgers.space/badge/license/MIT/007ec6?corner_radius=0)](LICENSE)

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
