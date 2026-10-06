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
- Every change should make the code simpler. Extract a function only if it really simplifies the caller, not to add indirection. Exception: small pure functions with exactly one job are fine.
- Names say what the thing does: a reader should understand a function from its name, argument names and types alone. Long names are fine.
- NO clever abstractions. Abstract only to remove real duplication — code that is truly the same, used the same way many times. Code that is only almost the same (sharing would need many bool flags) stays separate.
- NO over-the-top comments a human engineer wouldn't write. Comment only what cannot be understood by local reasoning: (a) the logic is genuinely messy and needs a short summary to follow, or (b) something depends on context outside the local scope (another module, a cross-cutting design decision, hardware/protocol behavior).
- Keep comments brief; longer only to explain a concept foreign to the codebase. Never comment on what was changed/removed or why something is not done now (no review-style comments), or restate what's already clear from reading the code and library.
- Document public APIs. Avoid naming files and variables in doc comments — they get out of sync.
- Use Conventional Commits: `type(scope): brief description` (feat, fix, docs, refactor, test, chore). Reference issues, note breaking changes.

## Tests
- Add a test only when it is really valuable: test the boundary of an API or a real behavior we want.
- NO tests of internals or trivial facts (an array with four elements has four elements) — complicated tests of internals make the code worse, not better.

## Language-specific guidelines (read on demand)
Per-language build/test/lint commands and style conventions live in
`~/.config/agents/guidelines/`. When starting work in a language, read its file:
`rust.md`, `go.md`, `python.md`, `js-ts.md`, `cpp.md`, `haskell.md`, `elm.md`
