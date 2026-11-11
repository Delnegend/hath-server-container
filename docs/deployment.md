# Deployment & Operations

## Run with Docker Compose

1. Clone or download `docker-compose.yml`.
2. Configure your client credentials in `docker-compose.yml` or a `.env` file:
   - `HATH_CLIENT_ID`: Your client ID from the H@H management page.
   - `HATH_CLIENT_KEY`: Your client key.
   - `TZ`: Host timezone (e.g. `UTC` or `America/New_York`).
3. Start the container:

```bash
docker compose up -d
```

## Run with Podman

```bash
podman run -d --name hath \
  --restart unless-stopped \
  -e HATH_CLIENT_ID="your_id" \
  -e HATH_CLIENT_KEY="your_key" \
  -e TZ="UTC" \
  -v ./data:/hath/data:Z \
  -v ./download:/hath/download:Z \
  -v ./cache:/hath/cache:Z \
  -v ./log:/hath/log:Z \
  ghcr.io/delnegend/hath-server-container:latest
```

## Logs & Monitoring

Inspect live logs to verify connection status:

```bash
docker compose logs -f
```

## Upgrades

Pull the latest image and recreate the service without losing data:

```bash
docker compose pull
docker compose up -d
```
