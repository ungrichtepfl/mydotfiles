# Haskell

## Commands
```bash
stack build / cabal build
stack test / cabal test
stack test --test-arguments="--match=specific test"     # single test
cabal test --test-options="--pattern=specific"
stack ghci / cabal repl
hlint src/
fourmolu / ormolu / stylish-haskell src/
```

## Style
- Explicit export lists; qualified imports for Text/Map etc.
- Type signatures on all top-level bindings; PascalCase types, camelCase functions.
- Domain error ADTs with `Either`/`ExceptT`/`MonadError` — avoid partial functions.
- Mind lazy evaluation (space leaks); pick appropriate container types.
