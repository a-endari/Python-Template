"""Entry point for my-project."""

from __future__ import annotations


def greet(name: str) -> str:
    """Return a greeting message.

    Args:
        name: The name to greet.

    Returns:
        A friendly greeting string.
    """
    return f"Hello, {name}!"


def main() -> None:
    """Run the application."""
    print(greet("World"))


if __name__ == "__main__":
    main()
