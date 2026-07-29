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

## Environment
- Void Linux (runit, xbps), Neovim user, terminal-first workflow. Prefer CLI solutions over GUI.
- Check for `.jj` before `.git`; prefer Jujutsu when both exist (colocated repos). jj has no staging area: the working copy is a commit — use `jj describe` / `jj new` / `jj split` instead of add/commit/stash.

## Failure loops
- Same failure twice: stop, question your assumptions, analyze before retrying.
- Three failures: switch to a fundamentally different strategy or ask for guidance.
- Never retry the same approach more than 3 times.

## Code style
- Follow existing codebase patterns.
- NO review comments: never comment why something was removed/changed, or restate what is clear to an engineer who reads code and knows the library. Comment ONLY "magic" values/config and logic that needs knowledge not available from the surrounding context. Document public APIs.
- Use Conventional Commits: `type(scope): brief description` (feat, fix, docs, refactor, test, chore). Reference issues, note breaking changes.

## Language-specific guidelines (read on demand)
Per-language build/test/lint commands and style conventions live in
`~/.config/agents/guidelines/`. When starting work in a language, read its file:
`rust.md`, `go.md`, `python.md`, `js-ts.md`, `cpp.md`, `haskell.md`, `elm.md`
