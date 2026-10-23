# Development

## Checks

```bash
just check   # actionlint + shellcheck
just build   # docker build -t hath --build-arg HATH_VERSION=<VERSION> .
just save    # docker save hath | gzip > hath.tar.gz
```

`just check` is the CI gate (`Check (just check)` in `.github/workflows/ci.yml`);
the three scan jobs (Gitleaks, Semgrep, Trivy) report without blocking.
The image is never built in CI — only by `just build` locally and by the
release workflow.

## Release procedure

Releases are cut by `.github/workflows/release.yml`, which takes an optional
`ref`: empty ships, a version tag rebuilds, and a commit SHA test-builds
without publishing ([dispatch modes](https://github.com/Delnegend/actions/blob/main/README.md)).

```bash
gh workflow run release.yml -f ref=<SHA>   # test-build a commit, publish nothing
gh workflow run release.yml -f ref=v1.2.3   # rebuild + publish an existing tag
```

The version is never typed by hand: it comes from the Conventional Commits
since the last tag (`feat:` → minor, `fix:` → patch, and so on). A week whose
commits are all `docs:`/`ci:`/`chore:` releases nothing, and the run ends
green.

Two versions coexist, and they mean different things:

- The **release tag** (`v1.2.3`) names this repackaging — the Dockerfile,
  entrypoint, and compose wiring around the client.
- `VERSION` / `HATH_VERSION` (`1.6.4`) names the **upstream client blob**
  inside the image, pinned in `docker-compose.yml` and the `build` recipe.

`just bump` writes only `VERSION`; moving the client itself means changing
`HATH_VERSION` in `docker-compose.yml` (and the `.justfile` build recipe
default) in a normal commit, which the next ship run then releases.

Each release ships `ghcr.io/delnegend/hath-server-container:<version>` and
`:latest`.

A weekly run fires every Sunday at 00:00 UTC; the repository is in
maintenance mode, so dependency updates and client bumps are the only
expected changes.
