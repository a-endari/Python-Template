# =============================================================================
# Stage 1: builder
# =============================================================================
FROM python:3.13-slim AS builder

WORKDIR /app

# Install uv for fast dependency resolution
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy dependency files first (layer cache optimisation)
COPY pyproject.toml ./
COPY src/ ./src/

# Install only production dependencies into a virtual environment
RUN uv venv .venv \
    && uv pip install --python .venv/bin/python hatchling \
    && uv pip install --no-cache --python .venv/bin/python .

# =============================================================================
# Stage 2: runtime
# =============================================================================
FROM python:3.13-slim AS runtime

WORKDIR /app

# Create a non-root user for security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Copy the pre-built venv and application from builder
COPY --from=builder /app/.venv .venv
COPY --from=builder /app/src ./src

# Make sure the venv binaries are on PATH
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER appuser

CMD ["python", "-m", "my_project.main"]
