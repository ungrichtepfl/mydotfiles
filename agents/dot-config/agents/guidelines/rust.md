# Rust

## Commands
```bash
cargo build / cargo build --release
cargo test                                  # all tests
cargo test test_function_name               # single test
cargo test --package crate_name --test test_file -- test_function
cargo clippy
cargo fmt
```

## Style
- PascalCase types/enums, snake_case functions, organized `use` declarations (std, third-party, crate).
- Use `Result`/`Option` with `?` and `map_err` into domain error types — no `unwrap()` in library code.
- Derive `Debug`, `Clone`, `Serialize`/`Deserialize` where appropriate.
- Leverage zero-cost abstractions; understand borrowing before reaching for `clone()`/`Rc`.
