---
name: tech-stack-config
description: >-
  Guides the agent in selecting, bootstrapping, and configuring the frontend framework, styling engine, TypeScript strictness, linting/formatting, and testing suite. Use when initializing tech stack, configuring framework tooling, setting up build scripts, or updating .project/TECH_STACK.md.
---

# Tech Stack Configuration Skill

This skill teaches the agent how to bootstrap and configure a modern frontend application stack based on the project's requirements and constraints in `.project/`.

---

## When to Run This Skill

Run this skill when:
- Project scoping is complete and `.project/SCOPE.md` & `.project/CONSTRAINTS.md` have been approved.
- A new project needs its initial code repository initialized (framework scaffolding, dependencies, tooling).
- The user asks to "configure the tech stack", "set up Vite/Next/Tailwind", or "configure testing and linting".

---

## Procedure

### Step 1: Stack Selection Against Constraints
1. Read `.project/SCOPE.md` and `.project/CONSTRAINTS.md`.
2. Cross-reference requirements against the stack matrix in [references/stack-matrix.md](./references/stack-matrix.md):
   - SPA / Dashboards / Client-heavy: Vite + React / Vue / Svelte with TypeScript.
   - SEO / SSR / Marketing-heavy: Next.js App Router or Astro.
   - Content-driven / Static: Astro.
3. Confirm selection with the user.

### Step 2: Framework Scaffolding
1. Initialize the framework using standard template generators:
   - For Vite: `npm create vite@latest . -- --template react-ts`
   - For Next.js: `npx create-next-app@latest . --typescript --tailwind --eslint --app`
   - For Astro: `npm create astro@latest . -- --template minimal --typescript strict`
2. Ensure `package.json` contains appropriate `"type": "module"` and pinned Node engine.

### Step 3: Styling & Design System Setup
1. Configure Tailwind CSS v4 or preferred styling tool:
   - Install dependencies.
   - Set up `@import "tailwindcss";` in the main stylesheet.
   - Set up design tokens (colors, font scales, spacing) in CSS variables.

### Step 4: Code Hygiene & Testing Suite
Configure tooling according to [references/tooling-standards.md](./references/tooling-standards.md):
1. **TypeScript**: Enable `strict: true`, `noUncheckedIndexedAccess: true` in `tsconfig.json`.
2. **Linting & Formatting**: Configure Biome or ESLint flat config + Prettier.
3. **Testing**: Install and configure Vitest, `@testing-library/react`, and jsdom.
4. **Package Scripts**: Add standard scripts (`dev`, `build`, `lint`, `typecheck`, `test`, `preview`).

### Step 5: Document in `.project/TECH_STACK.md`
1. Copy `templates/project-spec/TECH_STACK.md` to `.project/TECH_STACK.md` if not already present.
2. Record the exact framework versions, libraries, package manager, and directory layout.

### Step 6: Verification
1. Run `npm run typecheck` or equivalent: must exit with 0.
2. Run `npm run lint`: must exit with 0.
3. Run `npm run test`: sample smoke test must pass.
4. Run `npm run build`: production bundle must succeed and stay within bundle size constraints.
