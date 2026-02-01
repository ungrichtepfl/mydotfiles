# AGENTS.md - Universal Coding Guidelines for AI Agents

This document provides comprehensive guidelines for AI coding agents working across various repositories and technology stacks. Follow these guidelines to ensure consistent, high-quality code contributions.

## 💬 Communication Style

**Output should be detailed but concise:**
- Provide comprehensive technical information without unnecessary verbosity
- Get straight to the point - avoid filler phrases like "Great question!" or "I'd be happy to help!"
- No excessive enthusiasm or "simping" - maintain a professional, matter-of-fact tone
- Focus on actionable information and technical accuracy
- Use clear, direct language without unnecessary pleasantries

**Examples:**
- ❌ "Oh, that's a fantastic question! I'd absolutely love to help you implement this feature!"
- ✅ "Here's how to implement this feature using the repository's existing patterns:"
- ❌ "Great catch! You're absolutely right about this being a complex topic!"
- ✅ "This requires handling three components: authentication, validation, and persistence."

## 🔁 Preventing Doom Loops

**CRITICAL: Detect and break out of repetitive failure patterns immediately.**

A "doom loop" occurs when the agent repeatedly attempts the same failing operation without making progress. This wastes time and resources.

### Recognition Patterns
Watch for these signs of a doom loop:
- Running the same command multiple times with identical results
- Repeatedly attempting the same fix that continues to fail
- Making the same type of edit that keeps getting rejected
- Running tests that fail the same way more than 2-3 times
- Searching for the same information repeatedly without finding it

### Breaking the Loop
When caught in a doom loop, **STOP** and:

1. **Acknowledge the pattern**: "I've attempted this approach multiple times without success."
2. **Analyze what's different**: Identify what changed or why the approach isn't working
3. **Change strategy**: Try a fundamentally different approach, not minor variations
4. **Ask for help**: If stuck after 2-3 attempts, ask the user for guidance or clarification

### Prevention Guidelines
- **After 2 failures**: Analyze why the approach isn't working
- **After 3 failures**: Switch to a completely different strategy or ask the user
- **Never retry more than 3 times** without changing your approach significantly
- **Track your attempts**: Keep mental count of how many times you've tried similar solutions
- **Validate assumptions**: If something fails repeatedly, challenge your assumptions about what should work

### Examples

**Bad (Doom Loop):**
```
Attempt 1: Run tests → 5 failures
Fix attempt 1: Update type annotations
Attempt 2: Run tests → 5 failures  
Fix attempt 2: Update type annotations slightly differently
Attempt 3: Run tests → 5 failures
Fix attempt 3: Update type annotations with different syntax
[continues indefinitely...]
```

**Good (Breaking the Loop):**
```
Attempt 1: Run tests → 5 failures
Fix attempt 1: Update type annotations
Attempt 2: Run tests → 5 failures
Analysis: "The type annotations aren't the issue. Let me check if the test setup is correct."
Fix attempt 2: Investigate test configuration
[or ask user for clarification]
```

Remember: **3 strikes and you change approach or ask for help**. Persistence is good, but repetition without learning is a waste of everyone's time.

## 🛠️ User Environment

**Editor preference:** Neovim user - when suggesting editor-specific solutions or configurations, prioritize Neovim/Vim patterns and assume familiarity with modal editing, key bindings, and command-line workflows.

**Terminal-first workflow:** Prefer terminal-based solutions over GUI applications whenever possible. Assume familiarity with command-line tools, shell scripting, and text-based interfaces.

## 🔍 CRITICAL: Documentation and Research Requirements

**MANDATORY web search requirements:**
- **ALWAYS** perform web searches when configuring tools or using libraries
- **ALWAYS** verify that library/tool versions match current documentation
- **ALWAYS** check official documentation before implementing features
- **NEVER** do what seems logical without verification - always verify in official docs first

**The "seems logical" trap:**
When a user asks for a configuration change or feature implementation:
1. ❌ **WRONG**: "This seems logical, let me add it" → Make the change → Check docs later
2. ✅ **CORRECT**: Check official docs first → Verify it exists → Then make the change
3. **If unsure**: Search official documentation BEFORE suggesting or implementing anything

**Examples:**
- ❌ User: "Add doom_loop_threshold to config" → *adds fictional config option*
- ✅ User: "Add doom_loop_threshold to config" → *searches docs first* → *finds `doom_loop` permission* → *adds correct option*

**Web search guidelines:**
- ✅ Use official documentation, GitHub repos, API references, man pages
- ✅ Prioritize recent, authoritative sources
- ❌ **AVOID** AI-generated content, blog tutorials, Stack Overflow answers
- ❌ **AVOID** outdated documentation or deprecated approaches
- ❌ **AVOID** assuming logical solutions without verification
- ✅ Cross-reference multiple official sources when in doubt

**Version compatibility:**
- Check `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `stack.yaml`, `elm.json`, `CMakeLists.txt` etc. for current versions
- Verify API compatibility before suggesting code changes
- Document version requirements in commit messages when relevant

## 🛠️ Build, Test, and Lint Commands

### Discovery Process
Before working in any repository, identify the build system:

```bash
# Check for common build/package files
ls package.json Makefile pyproject.toml Cargo.toml go.mod pom.xml build.gradle composer.json cabal.project stack.yaml elm.json CMakeLists.txt

# Look for CI configuration
ls .github/workflows .gitlab-ci.yml .travis.yml azure-pipelines.yml

# Check for task runners
ls Taskfile.yml justfile scripts/
```

### Common Command Patterns

#### JavaScript/TypeScript
```bash
# Install dependencies
npm install / yarn install / pnpm install

# Build
npm run build / yarn build / pnpm build

# Test (single test)
npm test -- --testNamePattern="specific test"
npm test path/to/specific.test.js
npx jest specific.test.js

# Lint/Format
npm run lint / yarn lint
npm run format / prettier --write .
npx eslint src/
```

#### Python
```bash
# Setup environment
pip install -e . / pip install -r requirements.txt
poetry install / pipenv install

# Test (single test)
pytest tests/test_specific.py::test_function
python -m pytest tests/test_specific.py -k "test_name"
python -m unittest tests.test_specific.TestClass.test_method

# Lint/Format
black . / isort . / flake8 src/
mypy src/ / pylint src/
ruff check . / ruff format .
```

#### Go
```bash
# Build and test
go mod download
go build ./...
go test ./...

# Single test
go test -run TestSpecificFunction ./pkg/module
go test -v ./internal/service -run TestServiceMethod

# Lint/Format
go fmt ./...
goimports -w .
golangci-lint run
```

#### Rust
```bash
# Build and test
cargo build / cargo build --release
cargo test
cargo clippy

# Single test
cargo test test_function_name
cargo test --package crate_name --test test_file -- test_function

# Format
cargo fmt
```

#### Java/Kotlin
```bash
# Maven
mvn clean install
mvn test -Dtest=SpecificTest

# Gradle
./gradlew build
./gradlew test --tests SpecificTest
./gradlew ktlintCheck / ./gradlew ktlintFormat
```

#### C/C++
```bash
# Build and test with CMake
mkdir build && cd build
cmake ..
make / ninja

# Single test (with Google Test)
./test_executable --gtest_filter="TestSuite.TestName"
ctest -R specific_test

# Build with Make
make all
make test

# Lint/Format
clang-format -i src/*.cpp src/*.h
cppcheck src/
clang-tidy src/*.cpp
```

#### Haskell
```bash
# Build and test with Stack
stack build
stack test
stack test --test-arguments="--match=specific test"

# Build with Cabal
cabal configure
cabal build
cabal test

# Single test with cabal
cabal test --test-options="--pattern=specific"

# REPL and formatting
stack ghci / cabal repl
hindent src/ / stylish-haskell src/
hlint src/
```

#### Elm
```bash
# Build and test
elm make src/Main.elm
elm-test

# Single test
elm-test --fuzz=100 tests/SpecificTest.elm

# Development
elm reactor
elm install package/name

# Format and review
elm-format src/ --yes
elm-review
elm-analyse
```

## 📝 Code Style Guidelines

### General Principles
- **Consistency**: Follow existing codebase patterns
- **Clarity**: Prefer readable code over clever code  
- **Documentation**: Document complex logic and public APIs
- **Error handling**: Handle errors explicitly, don't ignore them
- **Performance**: Optimize for readability first, performance second

### Language-Specific Style

#### JavaScript/TypeScript
```typescript
// Imports: ES6 modules, absolute imports preferred
import { Component } from '@/components/Component';
import { validateInput } from '@/utils/validation';

// Functions: Use arrow functions for short, function declarations for complex
const calculateTotal = (items: Item[]): number => items.reduce(sum, 0);

function processComplexData(data: RawData): ProcessedData {
    // Complex logic with proper error handling
    if (!data || !Array.isArray(data.items)) {
        throw new Error('Invalid data format');
    }
    // ... implementation
}

// Types: Explicit typing, avoid 'any'
interface UserPreferences {
    theme: 'light' | 'dark';
    language: string;
    notifications: boolean;
}
```

#### Python
```python
# Imports: Standard library, third-party, local
import os
import sys
from typing import Dict, List, Optional, Union

import requests
import pandas as pd

from .models import User
from .utils import validate_email

# Functions: Type hints, docstrings
def process_user_data(
    users: List[Dict[str, str]], 
    filter_active: bool = True
) -> List[User]:
    """Process raw user data into User objects.
    
    Args:
        users: List of user dictionaries
        filter_active: Whether to filter for active users only
        
    Returns:
        List of processed User objects
        
    Raises:
        ValueError: If user data is invalid
    """
    # Implementation with proper error handling
    if not users:
        raise ValueError("Users list cannot be empty")
```

#### Go
```go
// Package declaration and imports
package main

import (
    "context"
    "fmt"
    "log"
    
    "github.com/gin-gonic/gin"
    
    "myapp/internal/service"
    "myapp/pkg/database"
)

// Structs: Exported fields capitalized
type UserService struct {
    db     *database.DB
    logger *log.Logger
}

// Methods: Receiver names short and consistent
func (us *UserService) CreateUser(ctx context.Context, req CreateUserRequest) (*User, error) {
    if err := req.Validate(); err != nil {
        return nil, fmt.Errorf("invalid request: %w", err)
    }
    
    // Implementation with explicit error handling
    user, err := us.db.CreateUser(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("failed to create user: %w", err)
    }
    
    return user, nil
}
```

#### Rust
```rust
// Imports: Use declarations organized
use std::collections::HashMap;
use std::error::Error;
use std::fmt;

use serde::{Deserialize, Serialize};
use tokio::time::{sleep, Duration};

use crate::models::User;
use crate::database::Database;

// Structs and enums: PascalCase
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserPreferences {
    pub theme: Theme,
    pub language: String,
    pub notifications: bool,
}

#[derive(Debug)]
pub enum Theme {
    Light,
    Dark,
}

// Functions: snake_case with proper error handling
pub async fn process_user_data(
    db: &Database,
    user_id: u64,
) -> Result<UserPreferences, ProcessingError> {
    let user = db.get_user(user_id).await?;
    
    // Implementation with Result error handling
    match user {
        Some(u) => Ok(u.preferences),
        None => Err(ProcessingError::UserNotFound(user_id)),
    }
}
```

#### C/C++
```cpp
// Headers: System headers, then project headers
#include <iostream>
#include <memory>
#include <string>
#include <vector>

#include "user.h"
#include "database.h"

// Classes: PascalCase, members with trailing underscore
class UserService {
 public:
    explicit UserService(Database* db) : db_(db) {}
    
    // Methods: snake_case or camelCase (be consistent)
    std::unique_ptr<User> CreateUser(const CreateUserRequest& req) {
        if (!req.IsValid()) {
            throw std::invalid_argument("Invalid request");
        }
        
        // RAII and smart pointers
        auto user = std::make_unique<User>(req.name(), req.email());
        if (!db_->SaveUser(*user)) {
            throw std::runtime_error("Failed to save user");
        }
        
        return user;
    }
    
 private:
    Database* db_;  // Non-owning pointer
};

// Functions: snake_case
bool validate_email(const std::string& email) {
    return email.find('@') != std::string::npos;
}
```

#### Haskell
```haskell
-- Module declaration and imports
module User.Service 
    ( UserService
    , createUser
    , getUserById
    ) where

import Control.Monad.Except (ExceptT, throwError)
import Data.Text (Text)
import qualified Data.Text as T

import User.Types (User(..), UserId, CreateUserRequest(..))
import Database (Database, MonadDatabase)

-- Types: PascalCase, data constructors explicit
data UserService m = UserService
    { database :: Database m
    , logger   :: Logger m
    }

data UserError
    = UserNotFound UserId
    | InvalidUserData Text
    | DatabaseError Text
    deriving (Show, Eq)

-- Functions: camelCase with type signatures
createUser :: (MonadDatabase m, MonadError UserError m) 
           => UserService m 
           -> CreateUserRequest 
           -> m User
createUser service req = do
    validateRequest req
    user <- User <$> generateId <*> pure (reqName req) <*> pure (reqEmail req)
    database service `saveUser` user
  where
    validateRequest r = 
        when (T.null $ reqName r) $ 
            throwError $ InvalidUserData "Name cannot be empty"
```

#### Elm
```elm
-- Module declaration and imports
module User.Service exposing (UserService, createUser, getUserById)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Task exposing (Task)

-- Types: PascalCase
type alias User =
    { id : Int
    , name : String
    , email : String
    }

type alias CreateUserRequest =
    { name : String
    , email : String
    }

type UserError
    = UserNotFound Int
    | InvalidUserData String
    | HttpError Http.Error

-- Functions: camelCase with explicit types
createUser : CreateUserRequest -> Task UserError User
createUser request =
    if String.isEmpty request.name then
        Task.fail (InvalidUserData "Name cannot be empty")
    
    else
        Http.task
            { method = "POST"
            , headers = []
            , url = "/api/users"
            , body = Http.jsonBody (encodeCreateUserRequest request)
            , resolver = Http.stringResolver handleResponse
            , timeout = Nothing
            }

-- Decoders and encoders: descriptive names
userDecoder : Decoder User
userDecoder =
    Decode.map3 User
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "email" Decode.string)

encodeCreateUserRequest : CreateUserRequest -> Encode.Value
encodeCreateUserRequest request =
    Encode.object
        [ ( "name", Encode.string request.name )
        , ( "email", Encode.string request.email )
        ]
```

## 🏗️ Project Structure Patterns

### Repository Analysis
**CRITICAL: Before making any changes or providing analysis, ALWAYS read through ALL files in the relevant directory first.**

When starting work in any directory:
1. **Read ALL files** in the target directory before doing any analysis or making changes
2. Use the Read tool to examine each file's complete contents
3. Understand the full context of what exists before proposing solutions
4. Only after reading all files should you begin planning or implementing changes

Always analyze the project structure first:
```bash
# Look for configuration files
find . -name "*.config.*" -o -name ".*rc" -o -name "*.toml" -o -name "*.yaml"

# Understand the source layout
tree src/ app/ lib/ internal/ pkg/ (as appropriate)

# Check for documentation
ls README.md CONTRIBUTING.md CHANGELOG.md docs/
```

### Common Patterns
- `src/` - Source code
- `tests/` or `__tests__/` - Test files
- `docs/` - Documentation
- `examples/` - Usage examples
- `scripts/` - Build/utility scripts
- `config/` - Configuration files

## 🔧 Error Handling Patterns

### JavaScript/TypeScript
```typescript
// Use Result pattern or proper try/catch
try {
    const result = await riskyOperation();
    return { success: true, data: result };
} catch (error) {
    logger.error('Operation failed:', error);
    return { success: false, error: error.message };
}
```

### Python
```python
# Use specific exception types
try:
    result = risky_operation()
except ValueError as e:
    logger.error(f"Invalid input: {e}")
    raise
except ConnectionError as e:
    logger.error(f"Connection failed: {e}")
    return None
```

### Go
```go
// Explicit error handling
result, err := riskyOperation()
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}
```

### Rust
```rust
// Use Result and Option types
let result = risky_operation()
    .map_err(|e| ProcessingError::OperationFailed(e))?;
```

### C/C++
```cpp
// Use exceptions and RAII
try {
    auto resource = acquire_resource();
    auto result = risky_operation(resource);
    return result;
} catch (const std::exception& e) {
    logger.error("Operation failed: {}", e.what());
    throw;  // Re-throw or handle appropriately
}

// Or use error codes with optional/expected
std::optional<Result> safe_operation() {
    if (auto resource = try_acquire_resource()) {
        return process(*resource);
    }
    return std::nullopt;
}
```

### Haskell
```haskell
-- Use Maybe and Either for error handling
processData :: Text -> Either UserError User
processData input
    | T.null input = Left (InvalidInput "Input cannot be empty")
    | otherwise = case parseUser input of
        Nothing -> Left (ParseError "Failed to parse user data")
        Just user -> Right user

-- With monadic error handling
processUserM :: (MonadError UserError m) => Text -> m User
processUserM input = do
    when (T.null input) $ throwError (InvalidInput "Input cannot be empty")
    case parseUser input of
        Nothing -> throwError (ParseError "Failed to parse user data")
        Just user -> return user
```

### Elm
```elm
-- Use Result and Maybe types
processUser : String -> Result String User
processUser input =
    if String.isEmpty input then
        Err "Input cannot be empty"
    else
        case parseUser input of
            Nothing ->
                Err "Failed to parse user data"
            
            Just user ->
                Ok user

-- Chain operations with Result
validateAndProcess : CreateUserRequest -> Result UserError User
validateAndProcess request =
    request
        |> validateRequest
        |> Result.andThen processRequest
        |> Result.andThen saveUser
```

## 📚 Documentation Standards

### Code Comments
- **WHY** over **WHAT**: Explain reasoning, not obvious code
- **TODO**: Include descriptive context: `// TODO: Implement caching for performance`
- **FIXME**: Include context: `// FIXME: Race condition in concurrent access`

### Function Documentation
- **Purpose**: What the function does
- **Parameters**: What each parameter expects
- **Returns**: What the function returns
- **Errors**: What can go wrong
- **Examples**: Usage examples for complex APIs

### API Documentation
- Use language-appropriate tools: JSDoc, docstrings, rustdoc, godoc
- Include usage examples
- Document error conditions
- Keep documentation in sync with code

## 🔐 Security Guidelines

### Input Validation
- Validate all user inputs
- Sanitize data before database operations
- Use parameterized queries
- Validate file uploads and sizes

### Secrets Management
- Never commit secrets, API keys, passwords
- Use environment variables or secret management systems
- Rotate secrets regularly
- Use least-privilege access principles

### Dependencies
- Keep dependencies updated
- Audit dependencies for vulnerabilities
- Use lock files (package-lock.json, poetry.lock, go.sum)
- Minimize dependency count

## ⚡ Performance Guidelines

### General
- Profile before optimizing
- Optimize hot paths identified by profiling
- Consider memory usage patterns
- Use appropriate data structures

### Language-Specific
- **JavaScript**: Avoid memory leaks, use proper event cleanup
- **Python**: Use generators for large datasets, consider NumPy for math
- **Go**: Use sync.Pool for object reuse, consider goroutine lifecycle
- **Rust**: Leverage zero-cost abstractions, understand borrowing
- **C/C++**: Use RAII, prefer stack allocation, minimize dynamic allocation
- **Haskell**: Leverage lazy evaluation, use appropriate data structures
- **Elm**: Minimize model updates, use Html.Lazy for expensive renders

## 🧪 Testing Standards

### Test Structure
- **Arrange**: Set up test data
- **Act**: Execute the operation
- **Assert**: Verify the results

### Test Categories
- **Unit**: Test individual functions/methods
- **Integration**: Test component interactions
- **E2E**: Test complete user workflows

### Test Naming
```
test_should_return_error_when_input_invalid()
should_create_user_with_valid_data()
TestUserService_CreateUser_ReturnsErrorOnInvalidInput()
```

## 🔄 Git and Commit Guidelines

### Commit Messages
```
type(scope): brief description

Longer description if needed.

- Bullet points for multiple changes
- Reference issues: Fixes #123
- Breaking changes: BREAKING CHANGE: explanation
```

### Commit Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `refactor`: Code refactoring
- `test`: Tests
- `chore`: Maintenance

Remember: Always research documentation, verify versions, and avoid AI-generated content when implementing solutions!
