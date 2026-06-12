#!/usr/bin/env bash
# Tag and push a release. Usage: ./scripts/release.sh 1.2.3
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 1.2.3"
  exit 1
fi

VERSION="$1"
TAG="v${VERSION}"

# Validate semver format
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "❌ Invalid version format. Use semver: MAJOR.MINOR.PATCH"
  exit 1
fi

# Ensure we're on main and working tree is clean
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ]; then
  echo "❌ Must be on main branch to release. Current: $BRANCH"
  exit 1
fi

if ! git diff --quiet || ! git diff --staged --quiet; then
  echo "❌ Working tree is dirty. Commit or stash changes first."
  exit 1
fi

echo "▶ Bumping version in pyproject.toml to ${VERSION}..."
sed -i.bak "s/^version = \".*\"/version = \"${VERSION}\"/" pyproject.toml
rm -f pyproject.toml.bak

echo "▶ Updating __init__.py version..."
sed -i.bak "s/__version__ = \".*\"/__version__ = \"${VERSION}\"/" src/my_project/__init__.py
rm -f src/my_project/__init__.py.bak

echo "▶ Committing version bump..."
git add pyproject.toml src/my_project/__init__.py
git commit -m "chore: bump version to ${VERSION}"

echo "▶ Tagging release ${TAG}..."
git tag -a "${TAG}" -m "Release ${TAG}"

echo "▶ Pushing commit and tag..."
git push origin main
git push origin "${TAG}"

echo "✅ Released ${TAG}. GitHub Actions will handle the rest."
