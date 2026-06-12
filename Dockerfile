# =============================================================================
# Stage 1: builder — installs dependencies into an isolated venv
# =============================================================================
FROM python:3.13-slim AS builder

WORKDIR /app

# Copy uv binary from the official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Create a virtual environment and put it on PATH for all subsequent steps
RUN uv venv .venv
ENV PATH="/app/.venv/bin:$PATH"

# Copy dependency manifest — this layer is cached until pyproject.toml changes
COPY pyproject.toml ./

# Install hatchling (the build backend declared in pyproject.toml)
# uv needs it to build the project wheel from source
RUN uv pip install --no-cache hatchling

# Copy source and install the project (production deps only — no [dev] extras)
COPY src/ ./src/
RUN uv pip install --no-cache .

# =============================================================================
# Stage 2: runtime — lean final image, no build tools
# =============================================================================
FROM python:3.13-slim AS runtime

WORKDIR /app

# Create a non-root user — running as root inside a container is a bad idea
RUN addgroup --system appgroup \
    && adduser --system --ingroup appgroup appuser

# Copy only what we need from builder: the venv and the source
COPY --from=builder /app/.venv .venv
COPY --from=builder /app/src ./src

# Activate the venv
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER appuser

CMD ["python", "-m", "my_project.main"]
