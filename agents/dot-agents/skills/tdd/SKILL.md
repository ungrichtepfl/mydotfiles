---
name: tdd
description: Test-driven development with the RED-GREEN-REFACTOR loop. Use when implementing a new feature, function, or bug fix where tests exist or are requested — write the failing test before the implementation.
---

# Test-driven development

One behavior per cycle. Never write implementation code before a failing test exists.

## The loop
1. **RED** — Write ONE test for the next small behavior. Run it and WATCH IT FAIL with the expected failure (assertion, not a compile error from a typo). A test that passes immediately proves nothing — fix the test.
2. **GREEN** — Write the MINIMAL implementation that makes it pass. No speculative generality, no handling cases without a test. Run the test; it must pass, and the rest of the suite must stay green.
3. **REFACTOR** — With everything green, clean up: naming, duplication, structure. Re-run the suite after each refactor step. No behavior changes in this phase.
4. Repeat for the next behavior.

## Rules
- Bug fix = regression test first: reproduce the bug as a failing test, then fix.
- NEVER weaken, delete, or skip a test to make it pass — a red test means the code is wrong until proven otherwise.
- Test behavior through the public interface, not implementation details.
- If a test is hard to write, that's design feedback — consider restructuring before working around it.
