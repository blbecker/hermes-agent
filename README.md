# Hermes-Agent Custom Derivative

[![Build and Push Docker Image](https://github.com/blbecker/hermes-agent/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/blbecker/hermes-agent/actions/workflows/build-and-push.yml)

Custom derivative of `nousresearch/hermes-agent` with Rust toolchain pre-installed.

## Features
- Based on `nousresearch/hermes-agent:v2026.9.24`
- Rust toolchain (stable) installed via rustup
- Maintains upstream user and entrypoint
- Automatic versioning with GitVersion
- CI/CD pipeline with GitHub Actions
- Automatic updates via Renovate (manual review)

## Building Locally

### Build from latest
```bash
export docker_tag="hermes-agent:local-$(git rev-parse --short HEAD)"
docker build . -t "${docker_tag}"
```

### Build from specific base version
```bash
docker build --build-arg BASE_IMAGE_TAG=v2026.9.24 .
```

### Test Rust installation
```bash
docker run --rm "${docker_tag}" cargo --version
```

## Usage

The container inherits all functionality from the base hermes-agent image with Rust toolchain available.

```bash
# Run and access shell
docker run -it ghcr.io/blbecker/hermes-agent:latest

# Verify Rust installation
docker run --rm ghcr.io/blbecker/hermes-agent:latest cargo --version
```

## CI/CD

Automatically builds and pushes to GitHub Container Registry on:
- Push to main branch
- Manual trigger via workflow_dispatch

Images are tagged with:
- Semantic version (from GitVersion)
- Git SHA
- Major, minor tags for easier referencing

## Development

### Testing Changes
1. Make changes to Dockerfile
2. Build locally: `docker build . -t hermes-agent:test`
3. Test Rust: `docker run --rm hermes-agent:test cargo --version`

### Updating Base Image
Renovate will open PRs when new versions of `nousresearch/hermes-agent` are available. Review and merge manually.

## License
Same as base hermes-agent image.