# Elm

## Commands
```bash
elm make src/Main.elm
elm-test                                    # all tests
elm-test --fuzz=100 tests/SpecificTest.elm  # single test
elm reactor                                 # dev server
elm-format src/ --yes
elm-review / elm-analyse
```

## Style
- Explicit `exposing` lists; PascalCase types, camelCase functions with type annotations.
- Model errors as custom types (`UserNotFound Int | HttpError Http.Error`); chain with `Result.andThen`.
- Descriptive decoder/encoder names (`userDecoder`, `encodeCreateUserRequest`).
- Minimize model updates; `Html.Lazy` for expensive renders.
