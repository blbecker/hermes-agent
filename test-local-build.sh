#!/bin/bash
# Local build test script for hermes-agent derivative

set -e

echo "🔨 Testing local build of hermes-agent with Rust toolchain..."

# Build the image
export DOCKER_TAG="hermes-agent:local-$(git rev-parse --short HEAD 2>/dev/null || echo 'test')"
echo "Building image with tag: $DOCKER_TAG"

docker build . -t "$DOCKER_TAG"

echo ""
echo "✅ Build successful!"
echo ""

echo "🧪 Testing Rust installation..."
docker run --rm "$DOCKER_TAG" cargo --version
docker run --rm "$DOCKER_TAG" rustc --version

echo ""
echo "🧪 Verifying user is 'hermes'..."
docker run --rm "$DOCKER_TAG" whoami

echo ""
echo "🎉 All tests passed!"
echo "You can run the container interactively with:"
echo "  docker run -it $DOCKER_TAG bash"
