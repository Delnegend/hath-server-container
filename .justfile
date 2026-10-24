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

# Language-agnostic version contract for Delnegend/actions/resolve-release.
version action ver="":
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{action}}" in
      get)
        cat VERSION
        ;;
      set|bump)
        [ -n "{{ver}}" ] || { echo "usage: just version set X.Y.Z" >&2; exit 1; }
        NEW="{{ver}}"
        OLD="$(cat VERSION 2>/dev/null || true)"
        if [ "$NEW" = "$OLD" ]; then
          echo "error: set $NEW is a no-op (VERSION unchanged)" >&2
          exit 1
        fi
        printf '%s\n' "$NEW" > VERSION
        git diff -- VERSION
        ;;
      *) echo "usage: just version get|set X.Y.Z" >&2; exit 1 ;;
    esac
