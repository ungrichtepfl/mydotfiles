# JavaScript / TypeScript

## Commands
```bash
npm install / yarn install / pnpm install
npm run build
npm test -- --testNamePattern="specific test"    # single test
npx jest specific.test.js
npm run lint / npx eslint src/
prettier --write .
```

## Style
- ES6 modules; absolute imports preferred (`@/...`).
- Arrow functions for short lambdas, function declarations for complex logic.
- Explicit typing, no `any`; model unions/interfaces for domain types.
- Result-pattern or try/catch with logged context; validate inputs at boundaries.
- Clean up event listeners/subscriptions to avoid leaks.
