# python-dev microVM image

A [dirge](https://github.com/dirge-code/dirge) microVM guest image for Python
development, built on Debian bookworm-slim with
[uv](https://docs.astral.sh/uv/) preinstalled (including a pinned Python 3.13
toolchain), following the guest image requirements in
[`CUSTOM_IMAGES.md`](https://github.com/dirge-code/dirge/blob/main/docs/microvm/CUSTOM_IMAGES.md).

## Usage

Pull directly from GHCR — no local build or buildah required:

```bash
dirge --sandbox microvm --microvm-image ghcr.io/<owner>/<repo>/python-dev:latest
```

Replace `<owner>/<repo>` with this repository's GitHub path. Available tags:

- `latest` — most recent build from `main`
- `sha-<shortsha>` — pinned to a specific commit

## What's included

- OpenSSH server, configured per dirge's requirements (no root login, no
  password auth, `sandbox` user at UID 1000, `/workspace` mount point)
- `uv` and `uvx` (copied from `ghcr.io/astral-sh/uv`)
- Python 3.13, installed via `uv python install` at build time so the first
  `uv run` / `uv sync` in the guest works offline
- `git`, `build-essential`, `curl`, `vim-tiny`

`uv`'s Python installs, tool installs, and cache all live under
`/usr/local/share/uv`, and `/usr/local/bin` is on `PATH` for all users
(sshd sources `/etc/environment` via PAM), so `uv`/`uvx` work for the
`sandbox` user out of the box.

## Building locally

```bash
buildah bud --storage-driver vfs --tag python-dev -f Containerfile .
```

## Publishing

Pushing changes to `images/python-dev/**` on `main` triggers
[`.github/workflows/publish-python-dev.yml`](../../.github/workflows/publish-python-dev.yml),
which builds a multi-arch (`linux/amd64` + `linux/arm64`) OCI image and
pushes it to `ghcr.io/<owner>/<repo>/python-dev`. It can also be run manually
via `workflow_dispatch`.
