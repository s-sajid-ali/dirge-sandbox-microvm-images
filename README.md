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
dirge --sandbox microvm --microvm-image ghcr.io/<owner>/<repo>/<image>:latest-<arch>
```

Use the arch-suffixed tag (`-amd64` or `-arm64`) that matches your host,
not the plain `latest`/`sha-<sha>` tag. Those plain tags point at a
multi-arch OCI index, and `dirge`'s manifest-fetch (as of dirge-agent
0.21.11) sends an `Accept` header that doesn't include the OCI index /
Docker manifest-list media types, so registries refuse to serve it and
`dirge sandbox setup` fails with `no layers found in manifest`. This is an
upstream dirge bug in `oci.rs`'s `fetch_manifest`, not an issue with these
images — remove the arch suffix requirement once it's fixed upstream.

## Publishing

Each image has a matching workflow under
[`.github/workflows/`](.github/workflows) that builds a multi-arch
(`linux/amd64` + `linux/arm64`) OCI image and pushes it to GHCR on changes
to that image's directory on `main`, or via manual `workflow_dispatch`. It
pushes both the multi-arch manifest (plain tags, e.g. `latest`,
`sha-<sha>`) and single-platform arch-suffixed tags (e.g. `latest-amd64`,
`sha-<sha>-arm64`) — see [Usage](#usage) for why the latter are needed.
