#!/usr/bin/env bash
# Build distribution packages (wheel + sdist).
set -euo pipefail

echo "▶ Cleaning previous builds..."
rm -rf dist/ build/ *.egg-info/

echo "▶ Building packages..."
python -m build

echo "✅ Build complete. Artifacts in dist/:"
ls -lh dist/
