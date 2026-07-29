# Python

## Commands
```bash
pip install -e . / pip install -r requirements.txt / poetry install / uv sync
pytest tests/test_specific.py::test_function     # single test
python -m pytest tests/test_specific.py -k "test_name"
ruff check . / ruff format .                     # or black/isort/flake8
mypy src/
```

## Style
- Imports grouped: stdlib, third-party, local.
- Type hints on all function signatures; docstrings (Args/Returns/Raises) on public APIs.
- Catch specific exception types, log, then re-raise or handle — never bare `except`.
- Use generators for large datasets; NumPy for numeric work.
