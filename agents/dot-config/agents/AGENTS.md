# AGENTS.md - Global Agent Guidelines

## Always verify, never assume (MOST IMPORTANT RULE)
- Never act on what "seems logical" when it can be verified: check the official docs, the actual source, the real file, the observed behavior — BEFORE implementing or claiming anything.
- Config keys, CLI flags, API signatures: confirm they exist in official documentation for the INSTALLED version (check package.json, Cargo.toml, go.mod, CMakeLists.txt, ...) before writing them. Inventing plausible-sounding options is the cardinal failure.
- Statements about code: read the implementation first. Statements about bugs: reproduce first.
- If verification is impossible, say so explicitly and mark the claim as unverified — never present a guess as fact.
- Sources: official docs, repos, man pages. Avoid blog posts, Stack Overflow, and AI-generated content.

## Communication
- Matter-of-fact and professional: no filler ("Great question!"), no flattery, no excessive enthusiasm.
- Lead with the answer, then supporting detail.
- Answer ONLY what was asked — no unsolicited extras, alternatives, or explanations. Keep output tokens minimal, but never at the cost of correctness or completeness of the asked task; the user will ask follow-up questions when they need clarification.

## Writing style (answers, comments, docs, commit messages)
- Plain, simple English: correct, but not native-level fancy. Prefer more simple words over one rare or complicated word.
- NO metaphors, NO euphemisms. State plainly what happens and what is needed.

## Environment
- Void Linux (runit, xbps), Neovim user, terminal-first workflow. Prefer CLI solutions over GUI.
- Check for `.jj` before `.git`; prefer Jujutsu when both exist (colocated repos). jj has no staging area: the working copy is a commit — use `jj describe` / `jj new` / `jj split` instead of add/commit/stash.

## Failure loops
- Same failure twice: stop, question your assumptions, analyze before retrying.
- Three failures: switch to a fundamentally different strategy or ask for guidance.
- Never retry the same approach more than 3 times.

## Code style
- Follow existing codebase patterns.
- Prefer pure functions; keep side effects (IO, mutable state, time) at the edges.
- Make invalid state impossible to represent — let the compiler find the errors (e.g. an enum/sum type instead of a bool plus optional fields that must agree).
- Check at compile time whatever can be checked at compile time: use precise types (newtypes, enums, non-empty or bounded types), and use compile-time assertions (`static_assert`, `const` assertions, type-level constraints) for sizes, ranges, and layout assumptions. A mistake that cannot compile cannot reach runtime. Use a runtime check only when the value is not known before the program runs.
- Every change should make the code simpler. Extract a function only if it really simplifies the caller, not to add indirection. Exception: small pure functions with exactly one job are fine.
- After a change, review it again. If something looks hacky (a workaround, the same special case in several places, a rule that every caller must remember), zoom out and check whether a different structure would make the whole thing simpler. Propose it only if it makes the code simpler and nicer to read. Do not propose it if it adds more indirection than it removes, or if it is only cleaner for its own sake: it must add real value. If you propose it, give its size; do not start a large rewrite without a go.
- Names say what the thing does: a reader should understand a function from its name, argument names and types alone. Long names are fine.
- NO clever abstractions. Abstract only to remove real duplication — code that is truly the same, used the same way many times. Code that is only almost the same (sharing would need many bool flags) stays separate.
- NO over-the-top comments a human engineer wouldn't write. Comment only what cannot be understood by local reasoning: (a) the logic is genuinely messy and needs a short summary to follow, or (b) something depends on context outside the local scope (another module, a cross-cutting design decision, hardware/protocol behavior).
- Keep comments brief; longer only to explain a concept foreign to the codebase. Never comment on what was changed/removed or why something is not done now (no review-style comments), or restate what's already clear from reading the code and library.
- Document public APIs. Avoid naming files and variables in doc comments — they get out of sync.
- Use Conventional Commits: `type(scope): brief description` (feat, fix, docs, refactor, test, chore). Reference issues, note breaking changes.

## Error handling and logging
- Goal: nothing unexpected may happen unnoticed. Anything that is not the normal, expected path must leave a trace in the log, and a failed operation must also be visible to the caller or the user.
- An error is handled when the program reacts to it: it is passed up (`?`), shown to the user, or recovered from. Handling is not enough: if the error is also dropped, replaced by a default, or retried silently, log it at the place where it is dropped.
- Never swallow an error: no empty handler, and no fallback value without a log line that has the original error.
- Log levels:
  - error: something does not work as expected. An operation failed, data was lost or may be wrong, a promised result is missing. Also when the error is shown to the user. Also for a fallback that hides a failed operation.
  - warning: unexpected, but the result is still correct (e.g. a default is used because an optional file is broken, a retry worked, a value is out of the expected range). It may lead to an error soon.
  - info/debug: tracing only, never for anything unexpected. Use it generously — traces make bugs much easier to find.
- Normal cases are not errors and need no log: a missing optional file on first start, an empty `Option` that means "no value", a user who cancels a dialog, a window that is gone at shutdown. Log them at debug at most. When unsure whether a case is normal, log it as warning.
- Rust: `unwrap`, `expect`, `unwrap_or*`, `.ok()`, `let _ =` on a `Result` hide the error or panic. On a `Result`, handle it explicitly (`match`, `?`, `inspect_err` plus log, or log and recover). On an `Option` that means "no value", `unwrap_or*` is fine. `expect` is allowed, but use it very carefully: only for an invariant that the code itself guarantees and that cannot be broken by input, IO, or the environment. The message must say which invariant. If unsure, handle the error.
- Panic/abort only when continuing could do harm or is meaningless (broken invariant, corrupt state), or at startup when a required setup fails.
- Other languages: apply the same rules in the way that language handles errors (e.g. Go: never discard `err` with `_`; JS/TS: no empty `catch`, no `.catch(() => default)` without a log; Python: no bare `except: pass`).

## Tests
- Add a test only when it is really valuable: test the boundary of an API or a real behavior we want.
- NO tests of internals or trivial facts (an array with four elements has four elements) — complicated tests of internals make the code worse, not better.

## Language-specific guidelines (read on demand)
Per-language build/test/lint commands and style conventions live in
`~/.config/agents/guidelines/`. When starting work in a language, read its file:
`rust.md`, `go.md`, `python.md`, `js-ts.md`, `cpp.md`, `haskell.md`, `elm.md`
