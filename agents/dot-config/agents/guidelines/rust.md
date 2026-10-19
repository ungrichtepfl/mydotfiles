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

## Async: cancellation safety
- A future can be dropped at any `.await` point (e.g. the losing branch of `select!`, a `timeout`, an aborted task). Everything after that point does not run, and state held only inside the future is lost.
- Before putting a future in `select!`, `timeout` or similar, check that it is cancel-safe. Check the docs of the method: tokio documents cancel safety per method (e.g. `mpsc::Receiver::recv` is cancel-safe, `AsyncReadExt::read_exact` is not).
- In a loop with `select!`, do not recreate a future that is not cancel-safe on each iteration. Create it once outside the loop, pin it, and poll it by `&mut`.
- Do not leave shared state half-updated across an `.await`. Finish the update before the `.await`, or make it so that a drop at that point leaves the state valid.
- Cleanup that must run (release a lock in another system, roll back, send a message) must not depend on code after an `.await`. Put it in a `Drop` guard or in a task that is not cancelled.
- Document in public async functions whether they are cancel-safe.
