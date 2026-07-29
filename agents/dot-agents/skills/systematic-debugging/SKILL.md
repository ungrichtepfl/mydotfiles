---
name: systematic-debugging
description: Root-cause a bug methodically instead of guessing at fixes. Use when investigating a bug, test failure, crash, or unexpected behavior — before proposing any fix.
---

# Systematic debugging

Find the root cause BEFORE writing any fix. A fix without a diagnosed cause is a guess.

## Procedure
1. **Reproduce.** Run the failing command/test and capture the exact error. If it can't be reproduced, that IS the first problem — don't theorize about unreproduced bugs.
2. **Read the actual code path.** Follow the real implementation from the error site backwards — not what the code "should" do, what it does. Read the failing function, its inputs, its callers.
3. **Form ONE hypothesis** stating cause → effect ("X is nil here because Y runs before Z"). It must be falsifiable.
4. **Test the hypothesis minimally**: a log line, a debugger breakpoint, a narrowed test — the smallest probe that confirms or kills it. Do not "test" a hypothesis by applying the fix.
5. **Wrong? Back to 2 with what you learned.** Two failed hypotheses: question a deeper assumption (is the input what you think? the version? the environment?).
6. **Confirmed? Fix the cause, not the symptom.** Then re-run the original reproduction to prove it, and check whether the same bug class exists elsewhere in the codebase.

## Forbidden
- Shotgun fixes: changing several things at once "to see if it helps".
- Fixing the symptom (swallowing the error, widening a type, adding a null check) while the cause is unknown.
- Declaring victory without re-running the original failing case.
