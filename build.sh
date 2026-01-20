#!/bin/sh

set -e

# defaults
TARGET_OS=linux
TARGET_ARCH=${1:-${GOARCH:-amd64}}

echo "Building for OS: $TARGET_OS, ARCH: $TARGET_ARCH"

GOOS=$TARGET_OS GOARCH=$TARGET_ARCH go build -o eternal ./cmd/eternal
GOOS=$TARGET_OS GOARCH=$TARGET_ARCH go build -o eternal-daemon ./cmd/eternal-daemon