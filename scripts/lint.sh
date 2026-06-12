#!/usr/bin/env bash
# Run all linting checks — mirrors the CI lint job.
set -euo pipefail

echo "▶ Ruff: linting..."
ruff check src/ tests/

echo "▶ Ruff: format check..."
ruff format --check src/ tests/

echo "▶ Mypy: type checking..."
mypy src/

echo "✅ All checks passed."
