# =============================================================================
# Makefile — common development tasks
# =============================================================================
.PHONY: help install install-dev lint format type-check test test-cov \
        build clean docker-build docker-run pre-commit-install docs

PYTHON  := python3
UV      := uv
SRC     := src
TESTS   := tests

# Default target — show help
help:
	@echo ""
	@echo "  Modern Python Project — available commands:"
	@echo ""
	@echo "  Setup"
	@echo "    make install          Install production dependencies"
	@echo "    make install-dev      Install all dev dependencies"
	@echo "    make pre-commit-install  Install pre-commit hooks"
	@echo ""
	@echo "  Quality"
	@echo "    make lint             Run Ruff linter"
	@echo "    make format           Run Ruff formatter"
	@echo "    make type-check       Run Mypy"
	@echo "    make check            Run lint + format check + type-check"
	@echo ""
	@echo "  Testing"
	@echo "    make test             Run tests"
	@echo "    make test-cov         Run tests with coverage report"
	@echo ""
	@echo "  Build"
	@echo "    make build            Build distribution packages"
	@echo "    make clean            Remove build artifacts"
	@echo ""
	@echo "  Docker"
	@echo "    make docker-build     Build Docker image"
	@echo "    make docker-run       Run Docker container"
	@echo ""

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------
install:
	$(UV) pip install -e .

install-dev:
	$(UV) venv .venv
	$(UV) pip install -e ".[dev]"

pre-commit-install:
	pre-commit install

# ---------------------------------------------------------------------------
# Quality
# ---------------------------------------------------------------------------
lint:
	ruff check $(SRC) $(TESTS)

format:
	ruff format $(SRC) $(TESTS)

format-check:
	ruff format --check $(SRC) $(TESTS)

type-check:
	mypy $(SRC)

check: lint format-check type-check

# ---------------------------------------------------------------------------
# Testing
# ---------------------------------------------------------------------------
test:
	pytest $(TESTS)

test-cov:
	pytest --cov=$(SRC) --cov-report=term-missing --cov-report=html $(TESTS)

# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------
build:
	$(PYTHON) -m build

clean:
	rm -rf dist/ build/ *.egg-info/ .pytest_cache/ .mypy_cache/ .ruff_cache/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf htmlcov/ .coverage coverage.xml

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
docker-build:
	docker build -t my-project:local .

docker-run:
	docker run --rm my-project:local

docker-compose-up:
	docker compose up --build

# ---------------------------------------------------------------------------
# Docs (MkDocs)
# ---------------------------------------------------------------------------
docs:
	@echo "Run: mkdocs serve"
	@echo "Install with: uv pip install mkdocs mkdocs-material"
