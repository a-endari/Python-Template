"""Tests for my_project.main."""

import pytest

from my_project.main import greet, main


def test_greet_returns_hello_world() -> None:
    """greet should return a proper greeting."""
    assert greet("World") == "Hello, World!"


def test_greet_returns_custom_name() -> None:
    """greet should include the provided name."""
    result = greet("Python")
    assert "Python" in result


def test_greet_empty_string() -> None:
    """greet should handle an empty string."""
    result = greet("")
    assert isinstance(result, str)


def test_main_runs_without_error(capsys: pytest.CaptureFixture[str]) -> None:
    """main() should print without raising."""
    main()
    captured = capsys.readouterr()
    assert "Hello" in captured.out
