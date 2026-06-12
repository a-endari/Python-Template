# 🐍 Modern Python Project Template

> A production-ready GitHub template for Python projects — built around `uv`, `ruff`, `mypy`, `pytest`, multi-platform Docker, GHCR publishing, VS Code Dev Containers, and GitHub Actions CI/CD.

[![CI](https://github.com/a-endari/python-template/actions/workflows/ci.yml/badge.svg)](https://github.com/a-endari/python-template/actions/workflows/ci.yml)
[![Docker](https://github.com/a-endari/python-template/actions/workflows/docker.yml/badge.svg)](https://github.com/a-endari/python-template/actions/workflows/docker.yml)
[![CodeQL](https://github.com/a-endari/python-template/actions/workflows/codeql.yml/badge.svg)](https://github.com/a-endari/python-template/actions/workflows/codeql.yml)
[![Python 3.12+](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)

---

## 📋 Table of Contents

- [Why This Template](#-why-this-template)
- [Quick Start (Using This Template)](#-quick-start-using-this-template)
- [Project Structure](#-project-structure)
- [File-by-File Reference](#-file-by-file-reference)
  - [Root Configuration Files](#root-configuration-files)
  - [Source Code](#source-code)
  - [GitHub Actions Workflows](#github-actions-workflows)
  - [Docker](#docker)
  - [Dev Container](#dev-container)
  - [Scripts](#scripts)
  - [VS Code](#vs-code)
  - [GitHub Configuration](#github-configuration)
- [What to Change Per Project](#-what-to-change-per-project)
- [What to Remove Per Project](#-what-to-remove-per-project)
- [Development Guide](#-development-guide)
- [Project README Template](#-project-readme-template)

---

## 🎯 Why This Template

Most Python project templates are either too minimal (just `pyproject.toml` and a `src/` folder) or too heavy (Sphinx, tox, complex CI matrices). This one hits the sweet spot for:

| Use Case | What You Get |
|---|---|
| **Personal projects** | Zero-friction setup, pre-commit guards against messy commits |
| **Open-source** | GHCR publishing, CodeQL security scanning, Dependabot, issue templates |
| **Portfolio / job applications** | Clean structure, type-safe code, proper CI — looks professional to German engineering teams |
| **Docker-first development** | Multi-platform builds (amd64 + arm64), multi-stage Dockerfile, non-root user |
| **GitHub-first workflow** | GHCR image publishing, artifact attestation, release automation |

**Toolchain choices explained:**

| Tool | Why | Instead of |
|---|---|---|
| `uv` | 10–100× faster than pip, built-in venv management, becoming the standard | Poetry, pip-tools |
| `ruff` | Linter + formatter in one binary, replaces 5+ tools | flake8 + isort + black + pyupgrade + bandit |
| `mypy --strict` | Catches entire classes of bugs before runtime | No type checking |
| `pytest` | De-facto standard, excellent plugin ecosystem | unittest |
| `hatchling` | Minimal, PEP 517 compliant, no magic | setuptools, flit |
| Multi-stage Dockerfile | Smaller final image, cleaner layer cache | Single-stage builds |

---

## ⚡ Quick Start (Using This Template)

### Option 1 — GitHub Template (recommended)

1. Click **"Use this template"** → **"Create a new repository"** on GitHub
2. Clone your new repo
3. Run the rename script:

```bash
# Replace all template placeholders with your project details
./scripts/rename.sh your-project-name "Your Name" "you@example.com" your-github-username
```

4. Set up your environment:

```bash
uv venv .venv
source .venv/bin/activate
uv pip install -e ".[dev]"
make pre-commit-install
```

### Option 2 — Clone directly

```bash
git clone https://github.com/a-endari/python-template.git your-project-name
cd your-project-name
rm -rf .git && git init
# then follow step 3 above
```

---

## 📁 Project Structure

```
python-template/
│
├── .github/                        # GitHub-specific configuration
│   ├── workflows/
│   │   ├── ci.yml                  # Lint + test on every push/PR
│   │   ├── docker.yml              # Build & push multi-platform image to GHCR
│   │   ├── release.yml             # Create release + build package on version tags
│   │   └── codeql.yml              # Security vulnerability scanning
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml          # Structured bug report form
│   │   └── feature_request.yml     # Structured feature request form
│   ├── dependabot.yml              # Automatic dependency update PRs
│   └── pull_request_template.md    # PR checklist shown on every new PR
│
├── .devcontainer/                  # VS Code Dev Container
│   ├── devcontainer.json           # Container config, extensions, post-create commands
│   └── Dockerfile                  # Dev image with Python, uv, Docker CLI, git
│
├── .vscode/                        # VS Code workspace settings (committed)
│   ├── settings.json               # format-on-save, interpreter path, pytest config
│   └── extensions.json             # Recommended extensions prompt for new contributors
│
├── docs/                           # Documentation (MkDocs ready, currently empty)
│
├── scripts/                        # Developer utility scripts
│   ├── lint.sh                     # Run all linting checks (mirrors CI)
│   ├── build.sh                    # Build wheel + sdist
│   └── release.sh                  # Bump version, tag, and push
│
├── src/
│   └── my_project/                 # Your application package (rename this)
│       ├── __init__.py             # Package version
│       └── main.py                 # Entry point
│
├── tests/
│   ├── __init__.py
│   └── test_main.py                # Example tests
│
├── .dockerignore                   # Files excluded from Docker build context
├── .env.example                    # Environment variable template (safe to commit)
├── .gitignore                      # Python + venv + IDE + OS ignores
├── .pre-commit-config.yaml         # Pre-commit hooks: ruff, mypy, file hygiene
├── CHANGELOG.md                    # Keep a Changelog format
├── docker-compose.yml              # Local Docker Compose setup
├── Dockerfile                      # Multi-stage production image
├── LICENSE                         # MIT License
├── Makefile                        # Common dev commands (make help to list all)
├── pyproject.toml                  # Single source of truth for the entire project
├── README.md                       # This file
├── requirements.txt                # Pinned production deps (generated by uv)
└── requirements-dev.txt            # Pinned dev deps (generated by uv)
```

---

## 📖 File-by-File Reference

### Root Configuration Files

---

#### `pyproject.toml`

**Purpose:** The single source of truth for everything. Replaces `setup.py`, `setup.cfg`, `tox.ini`, `.flake8`, `mypy.ini`, `pytest.ini`, and `.coveragerc`.

**Sections:**
| Section | What it configures |
|---|---|
| `[project]` | Package metadata, dependencies, Python version constraint |
| `[project.urls]` | Homepage, repo, issues, changelog links |
| `[project.scripts]` | CLI entry points (e.g. `my-project` → `my_project.main:main`) |
| `[tool.uv]` | Dev dependencies managed by uv |
| `[tool.ruff]` | Linting rules, line length, target Python version |
| `[tool.ruff.lint]` | Which rule sets to enable/ignore |
| `[tool.mypy]` | Strict type checking settings |
| `[tool.pytest.ini_options]` | Test discovery, markers, extra args |
| `[tool.coverage]` | Coverage source, reporting, minimum threshold (80%) |
| `[tool.hatch.build]` | Tell the build backend where the package lives |

**What to change:** `name`, `version`, `description`, `authors`, all `[project.urls]`, and the `[project.scripts]` entry point name.

---

#### `.gitignore`

**Purpose:** Keeps the repository clean. Based on GitHub's official Python template, extended with:
- `.env` / `.env.*` — never commit secrets
- `.venv/` — virtual environment
- `.vscode/` — personal IDE settings (the committed `.vscode/` folder only has workspace-level settings)
- `.DS_Store` — macOS metadata noise
- `dist/`, `build/`, `*.egg-info/` — build artifacts
- `.ruff_cache/`, `.mypy_cache/`, `.pytest_cache/` — tool caches

**What to change:** Nothing for most projects. Add entries for any project-specific files you want ignored.

---

#### `.env.example`

**Purpose:** Documents every environment variable the application uses, with placeholder values. Safe to commit — it contains no real secrets.

**Usage:**
```bash
cp .env.example .env
# edit .env with real values — this file is gitignored
```

**What to change:** Uncomment and populate the sections relevant to your project (database URL, API keys, etc.). Add new variables as your project grows. Delete sections that don't apply.

---

#### `.pre-commit-config.yaml`

**Purpose:** Runs quality checks automatically before every `git commit`. Catches issues locally before they hit CI.

**Hooks configured:**
| Hook | What it does |
|---|---|
| `ruff` | Lints and auto-fixes Python code |
| `ruff-format` | Formats Python code |
| `trailing-whitespace` | Removes trailing spaces |
| `end-of-file-fixer` | Ensures files end with a newline |
| `check-yaml` / `check-toml` / `check-json` | Validates config file syntax |
| `check-merge-conflict` | Catches leftover merge conflict markers |
| `check-added-large-files` | Blocks files > 500KB |
| `detect-private-key` | Blocks accidental secret commits |
| `mypy` | Type-checks the `src/` directory |

**What to change:** Nothing for most projects. Add hooks if you introduce new file types (e.g. `sqlfluff` for SQL, `prettier` for JS).

---

#### `Makefile`

**Purpose:** Muscle memory shortcuts for common tasks. Run `make help` to see all available commands.

**Key commands:**
```bash
make install-dev      # create .venv and install everything
make check            # ruff lint + format check + mypy (same as CI)
make test             # run pytest
make test-cov         # run pytest with HTML coverage report
make docker-build     # build local Docker image
make clean            # remove all build/cache artifacts
```

**What to change:** Update `IMAGE_NAME` if you want docker commands to use your project name. Nothing else needs changing.

---

#### `CHANGELOG.md`

**Purpose:** Human-readable history of changes between releases, following [Keep a Changelog](https://keepachangelog.com/) format. The `release.yml` workflow reads this file to populate GitHub Release notes.

**What to change:** Update the repo URL in the footer links. Add entries under `[Unreleased]` as you work. The release script promotes `[Unreleased]` to a versioned section.

---

#### `requirements.txt` and `requirements-dev.txt`

**Purpose:** Pinned dependency lock files for reproducible environments (especially in Docker). These are meant to be generated by uv, not edited by hand.

**Regenerate with:**
```bash
uv pip compile pyproject.toml -o requirements.txt
uv pip compile pyproject.toml --extra dev -o requirements-dev.txt
```

**What to change:** Don't edit manually. Re-generate whenever you add/remove dependencies in `pyproject.toml`.

---

### Source Code

---

#### `src/my_project/__init__.py`

**Purpose:** Makes `my_project` a proper Python package. Exposes `__version__` which is the single source of version truth at runtime.

**What to change:** Rename the `my_project/` directory to your actual package name (use underscores). Update the docstring.

---

#### `src/my_project/main.py`

**Purpose:** Application entry point. Contains a `main()` function wired up as the CLI script in `pyproject.toml`.

**What to change:** Replace the example `greet()` function and `main()` body with your actual application logic.

---

#### `tests/test_main.py`

**Purpose:** Example test file demonstrating pytest patterns — basic assertions, edge cases, and `capsys` for stdout capture.

**What to change:** Delete the example tests and write tests for your actual code. Keep the file naming convention: `test_<module>.py`.

---

### GitHub Actions Workflows

---

#### `.github/workflows/ci.yml`

**Purpose:** Runs on every push and PR. Enforces code quality before any merge.

**Pipeline:**
```
push / PR
    │
    ├── lint job
    │     ├── ruff check (linting)
    │     ├── ruff format --check (formatting)
    │     └── mypy (type checking)
    │
    └── test job (runs only if lint passes)
          ├── Python 3.12
          └── Python 3.13
                └── pytest --cov → upload to Codecov
```

**What to change:**
- Remove the Python 3.12 matrix entry if you only need 3.13
- Add/remove `CODECOV_TOKEN` secret if you use/don't use Codecov
- Adjust branch triggers if you use a different branching strategy

---

#### `.github/workflows/docker.yml`

**Purpose:** Builds a multi-platform Docker image and pushes it to GHCR (GitHub Container Registry) on every push to `main` and on version tags.

**Key features:**
- Builds for `linux/amd64` **and** `linux/arm64` (Apple Silicon, AWS Graviton, Raspberry Pi)
- Uses GitHub Actions cache (`type=gha`) for fast rebuilds
- On PRs: builds but does NOT push (safe for forks)
- On `main` push: pushes with `latest` tag + `sha-<hash>` tag
- On version tags (`v1.2.3`): pushes with semantic version tags
- Generates build provenance attestation for supply-chain security

**Image is published to:**
```
ghcr.io/a-endari/python-template:latest
ghcr.io/a-endari/python-template:1.2.3
ghcr.io/a-endari/python-template:sha-abc1234
```

**What to change:** Nothing — it reads the repo name automatically from `github.repository`.

---

#### `.github/workflows/release.yml`

**Purpose:** Triggered when you push a version tag (`v1.2.3`). Creates a GitHub Release, builds the Python package (wheel + sdist), and attaches the artifacts.

**Pipeline:**
```
git tag v1.2.3 && git push origin v1.2.3
    │
    ├── build wheel + sdist
    ├── extract release notes from CHANGELOG.md
    ├── create GitHub Release with notes
    └── upload .whl and .tar.gz as release assets
```

**What to change:** Uncomment the PyPI publish step when you're ready to publish to PyPI (requires setting up a trusted publisher on PyPI first).

---

#### `.github/workflows/codeql.yml`

**Purpose:** GitHub's static application security testing (SAST) tool. Scans for vulnerabilities like SQL injection, path traversal, and insecure deserialization.

**Runs:**
- On every push to `main`
- On every PR to `main`
- Every Monday at 08:00 UTC (scheduled scan)

**What to change:** Nothing. It works automatically. Results appear in the **Security** tab of your GitHub repo.

---

#### `.github/dependabot.yml`

**Purpose:** Opens automatic PRs when dependencies have updates, so you're not running six-month-old versions with known CVEs.

**Configured for:**
- Python packages (`pip` ecosystem) — weekly, Mondays
- GitHub Actions — weekly, Mondays
- Docker base images — weekly, Mondays

**Groups dev dependencies** (ruff, mypy, pytest) into a single PR to avoid noise.

**What to change:** Adjust `open-pull-requests-limit` if you want more or fewer concurrent update PRs. Change `interval` if weekly is too frequent.

---

### Docker

---

#### `Dockerfile`

**Purpose:** Multi-stage production image. Keeps the final image small and secure.

**Stages:**
```
Stage 1: builder
  └── python:3.13-slim
  └── install uv
  └── create .venv
  └── uv pip install . (production deps only)

Stage 2: runtime
  └── python:3.13-slim (fresh copy, no build tools)
  └── create non-root user (appuser)
  └── copy .venv and src/ from builder
  └── CMD ["python", "-m", "my_project.main"]
```

**Security notes:**
- Runs as non-root (`appuser`) — a container escape won't give root on the host
- `PYTHONDONTWRITEBYTECODE=1` and `PYTHONUNBUFFERED=1` are set as best practice
- Build tools are in the builder stage only — they don't land in the final image

**What to change:** Update the `CMD` if your entry point changes. If your app needs system packages (e.g. `libpq` for PostgreSQL), add an `apt-get` layer in the runtime stage.

---

#### `.dockerignore`

**Purpose:** Prevents unnecessary files from being sent to the Docker build daemon, which speeds up builds and avoids accidentally baking secrets into the image.

**Notable exclusions:** `.git/`, `tests/`, `.env`, `.env.*`, `docs/`, `.github/`, `.venv/`

**What to change:** Add any project-specific directories that should stay out of the image.

---

#### `docker-compose.yml`

**Purpose:** Local development and testing with Docker. Defines two services:
- `app` — runs the production image
- `test` — runs the test suite inside a container (use `docker compose --profile test up test`)

**What to change:** Add services for databases, caches, or other infrastructure your project needs (PostgreSQL, Redis, etc.). Update `image:` name to match your project.

---

### Dev Container

---

#### `.devcontainer/devcontainer.json`

**Purpose:** Defines a fully configured development environment for VS Code, Cursor, and Windsurf. When you open the repo in any of these editors, you're offered to "Reopen in Container" and get a ready-to-code environment on any machine.

**What's configured:**
- Python interpreter path → `.venv/bin/python`
- Ruff as the default formatter with format-on-save
- Mypy type checker extension wired to the venv
- Post-create command: creates venv, installs all deps, installs pre-commit hooks
- Runs as non-root `vscode` user

**What to change:** Add extensions relevant to your project (e.g. `ms-toolsai.jupyter` for data science). Add environment variables to `remoteEnv` if your app needs them at dev time.

---

#### `.devcontainer/Dockerfile`

**Purpose:** The base image for the dev container. Installs:
- Python 3.13 slim
- Git, curl, build-essential
- uv (copied from the official uv image)
- Docker CLI (for running Docker commands inside the container)
- A `vscode` non-root user matching UID 1000

**What to change:** Add system dependencies your project needs at development time (e.g. `libpq-dev` for PostgreSQL development headers).

---

### Scripts

---

#### `scripts/lint.sh`

**Purpose:** Runs all linting checks in sequence — mirrors exactly what the CI lint job does. Useful for a full check before pushing.

```bash
./scripts/lint.sh
```

**What to change:** Nothing.

---

#### `scripts/build.sh`

**Purpose:** Cleans previous build artifacts and builds a fresh wheel and sdist into `dist/`.

```bash
./scripts/build.sh
```

**What to change:** Nothing.

---

#### `scripts/release.sh`

**Purpose:** Automates the release process — bumps the version in `pyproject.toml` and `__init__.py`, commits, tags, and pushes. GitHub Actions handles everything after the tag push.

```bash
./scripts/release.sh 1.2.3
```

**What to change:** Update the `src/my_project/__init__.py` path if you rename your package directory.

---

### VS Code

---

#### `.vscode/settings.json`

**Purpose:** Workspace-level VS Code settings committed to the repo so every contributor gets the same experience. Sets Ruff as the formatter, enables format-on-save, configures pytest discovery.

**What to change:** Nothing — these are intentionally project-level defaults, not personal preferences.

---

#### `.vscode/extensions.json`

**Purpose:** When a new contributor opens the project in VS Code, they're prompted to install the recommended extensions. Not forced — just suggested.

**Includes:** Python, Mypy, Ruff, Debugpy, Docker, GitLens, GitHub Pull Requests, Even Better TOML, Dev Containers.

**What to change:** Add extensions specific to your project type.

---

### GitHub Configuration

---

#### `.github/pull_request_template.md`

**Purpose:** Pre-fills every new PR with a checklist — summary, type of change, testing confirmation, and a "Related Issues" section. Reduces back-and-forth in code review.

**What to change:** Adjust the checklist items to match your team's process.

---

#### `.github/ISSUE_TEMPLATE/bug_report.yml` and `feature_request.yml`

**Purpose:** Structured forms for reporting bugs and requesting features. Uses GitHub's new YAML-based issue forms, which are friendlier than raw markdown templates and easier to triage.

**What to change:** Add or remove fields based on what information you actually need from reporters.

---

## ✅ What to Change Per Project

When you create a new project from this template, go through this checklist:

### Required (every project)

- [ ] **`pyproject.toml`** — update `name`, `description`, `authors`, all URLs
- [ ] **`src/my_project/`** — rename the directory to your package name (e.g. `src/invoice_parser/`)
- [ ] **`src/my_project/__init__.py`** — update the module docstring
- [ ] **`src/my_project/main.py`** — replace example code with your application
- [ ] **`tests/test_main.py`** — replace example tests with real tests
- [ ] **`scripts/release.sh`** — update the `__init__.py` path (line 37–38) to match your renamed package
- [ ] **`CHANGELOG.md`** — update the footer URLs to point to your new repo
- [ ] **`LICENSE`** — already has your name; no change needed unless you want a different license
- [ ] **`.env.example`** — uncomment and add environment variables your app actually needs
- [ ] **`README.md`** — replace this template README with the Project README Template below

### Situational

- [ ] **`docker-compose.yml`** — add database, cache, or other service containers if needed
- [ ] **`Dockerfile`** — add system packages to the runtime stage if needed
- [ ] **`.devcontainer/Dockerfile`** — add dev-time system packages if needed
- [ ] **`pyproject.toml` `[project.dependencies]`** — add your actual runtime dependencies
- [ ] **`.pre-commit-config.yaml`** — add language-specific hooks if needed
- [ ] **`.github/workflows/ci.yml`** — remove Python 3.12 from matrix if you only need 3.13

---

## 🗑️ What to Remove Per Project

Not every project needs every file. Here's what's safe to drop:

| File / Directory | Remove when... |
|---|---|
| `docker-compose.yml` | The project is a pure library (no services to run) |
| `Dockerfile` + `.dockerignore` | The project is a pure library published to PyPI only |
| `.devcontainer/` | Your team doesn't use VS Code / Cursor / Windsurf |
| `docs/` | You don't plan to write documentation |
| `scripts/release.sh` | You prefer to handle releases manually or via another tool |
| `requirements.txt` / `requirements-dev.txt` | You use `uv.lock` exclusively and don't need pip-compatible lock files |
| `CHANGELOG.md` | Very early-stage projects — add it back before your first public release |

---

## 🛠️ Development Guide

### Initial Setup

```bash
# Install uv if you don't have it
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create virtual environment and install everything
uv venv .venv
source .venv/bin/activate   # or .venv\Scripts\activate on Windows
uv pip install -e ".[dev]"

# Install pre-commit hooks
make pre-commit-install
```

### Daily Workflow

```bash
make test          # run tests
make check         # lint + type check (same as CI)
make format        # auto-format code
make test-cov      # tests + open htmlcov/index.html for coverage
```

### Releasing a New Version

```bash
# Make sure CHANGELOG.md has entries under [Unreleased]
./scripts/release.sh 1.0.0
# GitHub Actions takes over from here
```

### Running with Docker

```bash
make docker-build              # build local image
make docker-run                # run container
docker compose up              # run via compose
```

### Opening in Dev Container

In VS Code: `Ctrl/Cmd+Shift+P` → **"Dev Containers: Reopen in Container"**

The container will automatically:
1. Create a `.venv` with all dependencies
2. Install pre-commit hooks
3. Configure Ruff and Mypy

---

---

---

# 📄 Project README Template

> **Instructions:** Copy everything below this line into your project's `README.md` and fill in the placeholders. Delete sections that don't apply. The goal is a README that answers: *what is it, how do I install it, how do I use it, how do I contribute.*

---

<!-- Replace the lines below with your project's actual content -->

# `project-name`

> One-line description of what this project does.

[![CI](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/ci.yml)
[![Docker](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/docker.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/docker.yml)
[![Python 3.12+](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Features

- Feature one
- Feature two
- Feature three

---

## Requirements

- Python 3.12+
- [uv](https://docs.astral.sh/uv/getting-started/installation/)

---

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

uv venv .venv
source .venv/bin/activate
uv pip install -e ".[dev]"
```

---

## Quick Start

```bash
# Basic usage example
python -m your_package
```

---

## Docker

```bash
# Pull from GHCR
docker pull ghcr.io/YOUR_USERNAME/YOUR_REPO:latest
docker run --rm ghcr.io/YOUR_USERNAME/YOUR_REPO:latest

# Or build locally
docker build -t your-project .
docker run --rm your-project
```

---

## Development

```bash
# Install pre-commit hooks (once)
make pre-commit-install

# Run quality checks
make check

# Format code
make format
```

---

## Testing

```bash
make test          # run all tests
make test-cov      # run with coverage report
```

---

## Configuration

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

| Variable | Default | Description |
|---|---|---|
| `APP_ENV` | `development` | Runtime environment |
| `APP_LOG_LEVEL` | `INFO` | Logging verbosity |
| `YOUR_VAR` | — | Description of your variable |

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Make your changes and run `make check`
4. Push and open a pull request

---

## License

[MIT](LICENSE) © 2026 [YOUR NAME](https://github.com/YOUR_USERNAME)
