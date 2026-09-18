# Project Agent Guidelines & Engineering Standards

Welcome! This repository is configured for autonomous and semi-autonomous AI engineering. All agents operating on this codebase must adhere to the patterns, specifications, and pipeline contracts defined below.

---

## 1. Single Source of Truth (`.project/`)

Before planning or executing any task in this codebase:
1. **Scope & Milestones**: Read [`.project/SCOPE.md`](file:///./.project/SCOPE.md) to verify feature boundaries and roadmap.
2. **Hard Constraints**: Read [`.project/CONSTRAINTS.md`](file:///./.project/CONSTRAINTS.md) for Core Web Vitals (LCP < 2.5s, INP < 200ms), accessibility standards (WCAG 2.1 AA), and bundle size budgets.
3. **Tech Stack & Conventions**: Read [`.project/TECH_STACK.md`](file:///./.project/TECH_STACK.md) for approved packages, styling rules, and directory standards.
4. **Architecture & Decisions**: Read [`.project/ARCHITECTURE.md`](file:///./.project/ARCHITECTURE.md) for data flow, state management, and ADRs.
5. **Feature Specs**: When implementing a specific feature, check [`.project/features/`](file:///./.project/features/) for the dedicated specification or create one using the feature template.

---

## 2. Directory Architecture & Component Hierarchy

Agents must respect the architectural boundaries of the codebase:

```text
src/
├── app/              # Routes, pages, and layout definitions
├── components/
│   ├── ui/           # Atomic, domain-agnostic UI primitives (Button, Input, Card, Modal)
│   └── domain/       # Feature-specific composite components
├── hooks/            # Reusable business logic & state hooks
├── lib/              # Pure utility functions, helpers, formatters
├── services/         # API clients, TanStack Query hooks, data fetching
│   ├── api/          # HTTP client, interceptors, and endpoints
│   ├── mock/         # Mock data generators and MSW handlers
│   └── schemas/      # Runtime Zod validation schemas
├── types/            # TypeScript domain interfaces and contracts
└── styles/           # Tailwind CSS tokens, theme variables, global CSS
```

### Component Rules:
- **Primitives in `src/components/ui/`**: Must remain completely domain-agnostic and reusable.
- **Accessibility Baseline**: Every interactive component must have semantic HTML, keyboard navigation, `:focus-visible` styling, and appropriate ARIA attributes.
- **Styling**: Use utility-first Tailwind CSS or CSS variables. Never introduce unencapsulated global CSS classes.

---

## 3. Contract-First API & Mock Data Discipline

To keep the frontend testable independently of the backend:
1. **Types First**: Define domain interfaces in `src/types/` and Zod schemas in `src/services/schemas/` matching backend contracts.
2. **Mock Data Layer**: When backend endpoints are in development, ensure mock handlers in `src/services/mock/` return realistic dummy data with loading and error states.
3. **Environment Switch**: Always read the API base from `VITE_API_BASE_URL` (or equivalent). Respect `VITE_USE_MOCKS=true/false` so the app seamlessly toggles between local dummy data and live backend services.

---

## 4. Development & CI/CD Pipeline Gates

Every pull request is automatically tested by GitHub Actions CI (`.github/workflows/ci.yml`) and receives a Netlify Deploy Preview.

Before committing or opening a pull request, the agent MUST run the local verification suite:
```bash
npm run lint          # Must pass with 0 warnings/errors
npm run typecheck     # Must pass with strict TypeScript checks
npm test              # Unit & component test suite
npm run build         # Production bundle verification
```

### Pull Request Discipline:
- Use isolated Git worktrees (`.worktrees/feat-<name>`) or task branches (`feat/*`, `fix/*`, `chore/*`).
- Follow `.github/pull_request_template.md`: link to the relevant `.project/` scope item, summarize changes, and list testing performed.
- Never push directly to `main`.
