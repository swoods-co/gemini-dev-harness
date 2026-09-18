---
name: team-orchestration
description: >-
  Orchestrates autonomous, specialized subagents (UI/UX, DevOps, Accessibility, API/Security) in parallel isolated git branches right after project scoping. Use when starting feature development, delegating parallel milestones, or bootstrapping multiple architectural concerns simultaneously without roadblocks.
---

# Parallel Subagent Team Orchestration Skill

This skill teaches the Lead Agent how to decompose a scoped project into non-blocking, parallel subagent tasks using Antigravity's `invoke_subagent` tool with branch isolation (`Workspace: 'branch'`).

---

## Why Subagent Specialization?

Sequential development causes bottlenecks: waiting for CI/CD setup before building UI, or waiting for API schemas before addressing accessibility.

By dispatching specialized subagents concurrently into isolated branches:
- **Zero Roadblocks**: DevOps, Design System, and Accessibility work proceed simultaneously.
- **Isolated Worktrees**: Each subagent operates in an isolated workspace branch (`Workspace: 'branch'`), eliminating git lock and file write conflicts.
- **Clean Context Windows**: Each agent focuses 100% on its domain without token pollution from unrelated concerns.

---

## The Specialized Subagent Team

Once `.project/SCOPE.md`, `CONSTRAINTS.md`, and `TECH_STACK.md` are established, the Lead Agent dispatches the following roles:

### 1. 🚀 DevOps & CI/CD Specialist
- **Workspace**: `Workspace: "branch"` (branch: `chore/ci-cd-pipeline`)
- **Mission**:
  - Drops in `templates/netlify/netlify.toml` and configures caching headers, SPA rewrites, and CSP rules.
  - Drops in `templates/github-actions/ci.yml` and verifies lint/typecheck/test/build pipeline.
  - Uses **Netlify MCP** to verify site linking and environment variable templates.
  - Updates `.project/DEPLOYMENT.md`.

### 2. 🎨 UI/UX & Design System Specialist
- **Workspace**: `Workspace: "branch"` (branch: `feat/design-system-foundation`)
- **Mission**:
  - Configures Tailwind CSS design tokens (colors, semantic shades, typography scale, radius).
  - Builds foundational domain-agnostic UI primitives in `src/components/ui/` (Button, Input, Card, Modal/Dialog, Toast).
  - Implements theme switcher (light/dark mode with system-preference detection).
  - Verifies responsive breakpoints (320px to 2560px).

### 3. ♿ Accessibility & Performance Specialist
- **Workspace**: `Workspace: "branch"` (branch: `feat/a11y-cwv-baseline`)
- **Mission**:
  - Validates landmark structures (`<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>`).
  - Sets up skip-to-content links and accessible focus indicators (`:focus-visible`).
  - Implements automated accessibility checks (e.g. `axe-core` or `@axe-core/react`).
  - Verifies Core Web Vitals optimizations (font preloading, image sizing attributes to prevent CLS).

### 4. 🔒 API, Data Contracts & Security Specialist
- **Workspace**: `Workspace: "branch"` (branch: `feat/api-client-core`)
- **Mission**:
  - Ingests backend schemas/contracts (OpenAPI, Swagger, GraphQL, or JSON payloads) and generates TypeScript types and Zod validation schemas.
  - Builds a mock data layer (`VITE_USE_MOCKS=true`) providing realistic dummy data for MVP testing prior to backend readiness.
  - Builds resilient HTTP client wrapper (exponential backoff retry, timeout handling, error logging).
  - Sets up TanStack Query / SWR providers and query client defaults.
  - Ensures a zero-code-change flip to production via `VITE_API_BASE_URL`.
  - Validates `.env.example` and runtime secret sanitation.

---

## Execution Pattern via `invoke_subagent`

The Lead Agent executes this single parallel call:

```json
{
  "Subagents": [
    {
      "Role": "DevOps & CI/CD Engineer",
      "TypeName": "self",
      "Workspace": "branch",
      "Prompt": "You are the DevOps Specialist for this frontend project. Read .project/TECH_STACK.md and .project/DEPLOYMENT.md. Configure netlify.toml and .github/workflows/ci.yml using harness templates. Validate build commands and report back when CI/CD is passing."
    },
    {
      "Role": "Design System Engineer",
      "TypeName": "self",
      "Workspace": "branch",
      "Prompt": "You are the UI/UX Specialist. Read .project/SCOPE.md and .project/CONSTRAINTS.md. Configure Tailwind CSS design tokens and scaffold foundational UI primitives (Button, Input, Card, ThemeToggle) in src/components/ui/. Verify responsive states and report back."
    },
    {
      "Role": "Accessibility & Performance Engineer",
      "TypeName": "self",
      "Workspace": "branch",
      "Prompt": "You are the Accessibility & Performance Specialist. Read .project/CONSTRAINTS.md. Implement skip-to-content link, global focus-visible styles, semantic landmark layout, and setup axe-core a11y tests. Verify WCAG 2.1 AA compliance and report back."
    }
  ]
}
```

---

## Reconciliation & Merging Procedure

1. **Reactive Wakeup**: The system notifies the Lead Agent as each subagent concludes its task.
2. **Review & PR Creation**:
   - For each subagent branch, the Lead Agent runs `npm test` and `npm run build`.
   - Opens a PR via **GitHub MCP** (`create_pull_request`).
3. **Sequential Merge**:
   - Merge Foundation branches in order:
     1. DevOps (`chore/ci-cd-pipeline`)
     2. UI/UX (`feat/design-system-foundation`)
     3. Accessibility (`feat/a11y-cwv-baseline`)
     4. API Client (`feat/api-client-core`)
4. **Final Integration Smoke Test**: Run the full verification suite on `main`.
