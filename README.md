<div align="center">

# H@H Docker

**Run the Hentai@Home client as a set-and-forget Docker service: Java runtime included, your cache, credentials and downloads mounted from the host.**

[![CI](https://img.shields.io/github/actions/workflow/status/Delnegend/hath-server-container/ci.yml?branch=main&style=flat-square)](https://github.com/Delnegend/hath-server-container/actions)
[![License](https://img.shields.io/github/license/Delnegend/hath-server-container?style=flat-square)](LICENSE)

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

- **No Java on the host** — the image ships the Semeru JRE and downloads the pinned client release into it.
- **State lives on your disk** — cache, data, downloads and logs are all bind mounts, so rebuilding the image never loses anything.
- **Fresh credentials every start** — the entry script rewrites `client_login` from the compose environment before launching.
- **Survives reboots** — `restart: unless-stopped` with Cloudflare DNS so the client resolves even on captive networks.

## Files

| File | Purpose |
|---|---|
| `docker-compose.yml` | Service, volumes, ports, DNS, credentials |
| `Dockerfile` | Two-stage build: fetch + unzip the client, then a JRE image |
| `start.sh` | Entrypoint: applies umask, writes `client_login`, runs the client |

`just build` builds `hath` locally; `just save` exports it to `hath.tar.gz`.

## License

[MIT](LICENSE)
