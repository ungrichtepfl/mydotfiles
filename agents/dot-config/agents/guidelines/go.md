# Go

## Commands
```bash
go mod download
go build ./...
go test ./...                               # all tests
go test -run TestSpecificFunction ./pkg/module   # single test
go fmt ./... && goimports -w .
golangci-lint run
```

## Style
- Imports grouped: stdlib, third-party, local. Exported identifiers capitalized.
- Short consistent receiver names; explicit error handling with wrapping:
  `fmt.Errorf("operation failed: %w", err)` — never ignore errors.
- Pass `context.Context` as first parameter through call chains.
- Use `sync.Pool` for object reuse in hot paths; mind goroutine lifecycles.
