_default:
	just --choose

build:
    docker build -t hath --build-arg HATH_VERSION=1.6.4 .

save:
    docker save hath | gzip > hath.tar.gz

# The CI gate: lint the workflow YAML and the shell entrypoint. The image
# itself is built by `just build` and by the release workflow, never here,
# so this stays fast and build-free on CI.
check:
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v actionlint >/dev/null 2>&1; then
        actionlint .github/workflows/*.yml
    else
        echo "check: actionlint not installed, skipping workflow lint"
    fi
    shellcheck start.sh

# Bump the maintainer-owned release version. The client blob itself is frozen
# (HATH_VERSION in docker-compose.yml); VERSION is what `new-tag` moves.
bump version:
    #!/usr/bin/env bash
    set -euo pipefail
    NEW="{{version}}"
    # No-op signal is worktree content, not `git diff` (which ignores untracked
    # files) and not porcelain (which never shows untracked as unchanged).
    OLD="$(cat VERSION 2>/dev/null || true)"
    if [ "$NEW" = "$OLD" ]; then
        echo "error: bump $NEW is a no-op (VERSION unchanged)" >&2
        exit 1
    fi
    printf '%s\n' "$NEW" > VERSION
    git diff -- VERSION