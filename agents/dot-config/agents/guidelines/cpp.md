# C / C++

## Commands
```bash
mkdir build && cd build && cmake .. && make    # or ninja
./test_executable --gtest_filter="TestSuite.TestName"   # single test (gtest)
ctest -R specific_test
clang-format -i src/*.cpp src/*.h
clang-tidy src/*.cpp
cppcheck src/
```

## Style
- Headers: system includes first, then project includes.
- Classes PascalCase; members with trailing underscore; be consistent within the codebase (snake_case or camelCase methods).
- RAII everywhere; smart pointers for ownership, raw pointers only non-owning; prefer stack allocation.
- Exceptions with meaningful types, or `std::optional`/`std::expected` for recoverable failures.
