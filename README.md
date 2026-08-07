# dirge-sandbox-microvm-images

Custom guest images for [dirge](https://github.com/dirge-code/dirge)'s
microVM sandbox, built per the requirements in
[`docs/microvm/CUSTOM_IMAGES.md`](https://github.com/dirge-code/dirge/blob/main/docs/microvm/CUSTOM_IMAGES.md)
and published as OCI images to GHCR so they can be pulled directly — no
local `buildah` build required.

## Images

| Image | Path | Description |
| --- | --- | --- |
| `python-dev` | [`images/python-dev`](images/python-dev) | Debian bookworm-slim + [uv](https://docs.astral.sh/uv/) with a pinned Python 3.13 toolchain |

Each image directory has its own README with usage and build details.

## Usage

```bash
dirge --sandbox microvm --microvm-image ghcr.io/<owner>/<repo>/<image>:latest
```

## Publishing

Each image has a matching workflow under
[`.github/workflows/`](.github/workflows) that builds a multi-arch
(`linux/amd64` + `linux/arm64`) OCI image and pushes it to GHCR on changes
to that image's directory on `main`, or via manual `workflow_dispatch`.
