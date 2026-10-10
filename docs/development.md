# Development

## Checks

```bash
just check   # actionlint + shellcheck + yamllint (when installed) + Dockerfile dry-run
just build   # docker build -t hath --build-arg HATH_VERSION=<VERSION> .
just save    # docker save hath | gzip > hath.tar.gz
```

`just check` is the CI gate (`Check (just check)` in `.github/workflows/ci.yml`);
the three scan jobs (Gitleaks, Semgrep, Trivy) report without blocking.
The image is never built in CI — only by `just build` locally and by the
release workflow.

## Release procedure

Releases are cut by `.github/workflows/release.yml`, which takes a `target`:

| Target | What it does |
| --- | --- |
| `new-tag` *(default, and what the weekly cron uses)* | Gates on `just check`, derives the next version from Conventional Commits, bumps `VERSION` via `just bump`, pushes the commit and tag together, then builds and publishes |
| `tag` | Rebuilds an existing tag and publishes its release — the repair path |
| `commit` | Test-builds a commit: the image loads locally and `hath.tar.gz` lands in the Actions run, nothing is published |

```bash
gh workflow run release.yml -f target=commit   # test-build latest commit, publish nothing
gh workflow run release.yml -f target=tag -f ref=v1.2.3   # rebuild + publish an existing tag
```

The version is never typed by hand: it comes from the Conventional Commits
since the last tag (`feat:` → minor, `fix:` → patch, and so on). A week whose
commits are all `docs:`/`ci:`/`chore:` releases nothing, and the run ends
green. `prepare` pushes the tag **before** the build starts, so a build
failure leaves a tag with no release — repair it with `target: tag`, never
with `new-tag`, which would cut a second tag for the same version.

Two versions coexist, and they mean different things:

- The **release tag** (`v1.2.3`) names this repackaging — the Dockerfile,
  entrypoint, and compose wiring around the client.
- `VERSION` / `HATH_VERSION` (`1.6.4`) names the **upstream client blob**
  inside the image, pinned in `docker-compose.yml` and `Dockerfile`.

`just bump` writes only `VERSION`; moving the client itself means changing
`HATH_VERSION` in `docker-compose.yml` (and the `justfile` build recipe
default) in a normal commit, which the next `new-tag` run then releases.

Each release ships:

- `ghcr.io/delnegend/hath-server-container:<version>` and `:latest`
- `hath.tar.gz` — the same image as a portable tarball (`docker load < hath.tar.gz`)

A weekly run fires every Sunday at 00:00 UTC; the repository is in
maintenance mode, so dependency updates and client bumps are the only
expected changes.
