---
name: project-scoping
description: >-
  Guides the agent through scoping, requirements discovery, constraint definition, and architecture decisions for a new or evolving frontend project. Use when initializing a new project, establishing .project/ documentation, eliciting user journeys, or refining project constraints.
---

# Project Scoping & Constraints Discovery Skill

This skill teaches the agent how to run a structured discovery session to scope a frontend project, document technical/operational constraints, and create the foundational specifications under `.project/`.

---

## When to Run This Skill

Run this skill when:
- A new project repository is opened and `.project/` does not exist or lacks `SCOPE.md` / `CONSTRAINTS.md`.
- The user requests to "scope the project", "define requirements", or "set up project specifications".
- A major feature requires updating the project scope and non-functional constraints.

---

## Procedure

### Step 1: Check Existing Project State
1. Inspect the root of the repository:
   - Does `.project/` exist?
   - Does `package.json` exist?
   - What assets, docs, or wireframes already exist?
2. If `.project/` already exists, read `.project/SCOPE.md` and `.project/CONSTRAINTS.md` to identify gaps before asking questions.

### Step 2: Conduct Discovery / Scoping Interview
If key information is missing, use the questions in [references/questionnaire.md](./references/questionnaire.md) to ask the user targeted questions. Keep the interview concise:
1. **Core Problem & Persona**: What problem does this solve, and who are the primary users?
2. **Critical User Journeys (P0s)**: What are the 2-3 most essential flows needed for MVP?
3. **Hard Constraints**:
   - What are the performance and Core Web Vitals expectations?
   - Accessibility requirements (WCAG 2.1 AA baseline).
   - Target devices and browser support.
4. **Third-Party & Backend Dependencies**: What APIs, authentication providers, or backend services will be integrated?
5. **Non-Goals**: What is explicitly out of scope for this version?

### Step 3: Scaffold `.project/` Documentation
Copy and populate the templates from the harness:
- Copy `templates/project-spec/SCOPE.md` to `.project/SCOPE.md`.
- Copy `templates/project-spec/CONSTRAINTS.md` to `.project/CONSTRAINTS.md`.
- Copy `templates/project-spec/ARCHITECTURE.md` to `.project/ARCHITECTURE.md`.

Fill in the template placeholders with the agreed-upon details from Step 2. Formulate acceptance criteria using the Gherkin-style patterns described in [references/acceptance-criteria.md](./references/acceptance-criteria.md).

### Step 4: Verification & Sign-off
1. Present the completed `.project/SCOPE.md` and `.project/CONSTRAINTS.md` to the user for review.
2. Ensure explicit sign-off on the P0 user journeys and out-of-scope items before advancing to `tech-stack-config`.
