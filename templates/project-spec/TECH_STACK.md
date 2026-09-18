# Tech Stack & Tooling Architecture

This document records the exact technology stack, tool configurations, and directory conventions selected for this project.

---

## 1. Core Framework & Runtime
- **Framework**: [e.g., Vite + React 19 / Next.js 15 App Router / Astro 5]
- **Language**: TypeScript (strict mode)
- **Node Version**: `>= 20.x LTS` (defined in `.nvmrc` and `package.json` engines)
- **Package Manager**: [pnpm / npm / yarn / bun] (pinned via `packageManager` field)

---

## 2. Styling & UI Components
- **Styling Solution**: [e.g., Tailwind CSS v4 / CSS Modules]
- **Component Primitives**: [e.g., Radix UI / shadcn/ui primitives / Headless UI]
- **Icon Library**: [e.g., Lucide React / Tabler Icons]
- **Animation / Motion**: [e.g., CSS View Transitions / Motion (Framer Motion)]

---

## 3. State Management & Data Fetching
- **Server Cache & Async Data**: [e.g., TanStack Query v5 / SWR / Native fetch with cache tags]
- **Client State**: [e.g., Zustand / React Context / URL Search Params (nuqs)]
- **Form Handling & Validation**: [e.g., React Hook Form + Zod]

---

## 4. Code Hygiene & Quality Tools
- **Linter & Formatter**: [e.g., Biome / ESLint (flat config) + Prettier]
- **Git Hooks**: [e.g., simple-git-hooks / husky] with `lint-staged`
- **Type Checking**: `tsc --noEmit`

---

## 5. Testing Suite
- **Unit & Component Testing**: Vitest + React Testing Library (or Testing Library appropriate to framework)
- **E2E Testing**: Playwright
- **Coverage Tool**: @vitest/coverage-v8

---

## 6. Directory Structure Convention
```text
src/
├── app/              # Application routes and pages
├── components/       # Reusable UI components
│   ├── ui/           # Atomic, domain-agnostic primitives (buttons, dialogs, inputs)
│   └── domain/       # Feature-specific composite components
├── hooks/            # Custom hooks
├── lib/              # Utility functions, API clients, helpers
├── services/         # Third-party integrations and backend API abstractions
├── types/            # Shared TypeScript domain interfaces and schemas
└── styles/           # Global styles and Tailwind tokens
```

---

## 7. Scripts Matrix (`package.json`)
```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "lint": "eslint . --max-warnings 0",
    "format": "prettier --write .",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:e2e": "playwright test"
  }
}
```
