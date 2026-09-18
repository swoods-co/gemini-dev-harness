# Frontend Tooling & Hygiene Standards

Universal configuration guidelines for frontend tooling in this harness.

---

## 1. TypeScript Strict Baseline
In `tsconfig.json`, always configure:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitOverride": true,
    "skipLibCheck": true,
    "isolatedModules": true
  }
}
```

---

## 2. Test Runner: Vitest
Vitest provides native ESM and Vite config sharing.

Sample `vitest.config.ts`:
```ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './src/test/setup.ts',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json-summary', 'html'],
    },
  },
});
```

Sample setup file `src/test/setup.ts`:
```ts
import '@testing-library/jest-dom/vitest';
import { cleanup } from '@testing-library/react';
import { afterEach } from 'vitest';

afterEach(() => {
  cleanup();
});
```

---

## 3. Package Management Conventions
- Prefer `pnpm` for fast, disk-efficient mono-repo and multi-worktree setups.
- If using `npm`, pin versions in `package-lock.json` and use `npm ci` in all CI environments.
