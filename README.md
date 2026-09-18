# Universal Frontend Development Harness (Antigravity Plugin)

A universal, shareable **Antigravity Plugin** and development harness for modern frontend projects. Designed to be included across multiple frontend repositories as a **Git Submodule**, providing battle-tested agent workflows, project scoping, constraints management, framework scaffolding, git worktree isolation, and CI/CD pipelines with GitHub and Netlify MCPs.

- **GitHub Repository**: [https://github.com/swoods-co/gemini-dev-harness](https://github.com/swoods-co/gemini-dev-harness)

---

## Architecture Overview

```text
├── plugin.json                 # Antigravity plugin manifest
├── mcp_config.json             # GitHub & Netlify MCP server configurations
├── rules/
│   └── AGENTS.md               # Universal workspace rules (worktree rules, CI/CD, host contract)
├── skills/
│   ├── project-scoping/        # Inception, user journeys, constraints & acceptance criteria
│   ├── tech-stack-config/      # Framework selection, scaffolding, strict TS, linting & tests
│   ├── worktree-workflow/      # Safe parallel agent development in isolated .worktrees/
│   └── ci-cd-deployment/       # GitHub Actions CI & Netlify deploy previews via MCP
├── templates/                  # Ready-to-use blueprints injected into host projects
│   ├── project-spec/           # SCOPE.md, CONSTRAINTS.md, TECH_STACK.md, ARCHITECTURE.md, DEPLOYMENT.md
│   ├── github-actions/         # ci.yml, preview.yml
│   └── netlify/                # netlify.toml with security headers & caching
├── scripts/
│   ├── install-harness.sh      # POSIX installer to wire up the submodule in a project
│   └── install-harness.ps1     # PowerShell installer for Windows
└── README.md
```

---

## Clean Separation of Concerns

To allow this harness to be shared seamlessly across dozens of different projects:

| Layer | Responsibility | Location |
| :--- | :--- | :--- |
| **The Harness (Plugin)** | Universal workflows, agent rules, worktree isolation, CI/CD standards, GitHub & Netlify MCP tools. | `.agents/plugins/frontend-harness/` (Git Submodule) |
| **The Host Project** | Business domain, requirements, feature scope, framework decisions, and environment secrets. | `.project/` in host repository root |

### The Host Project Contract (`.project/`)
When Antigravity runs in a project equipped with this harness, agents read from and maintain `.project/`:
- `.project/SCOPE.md`: Functional scope, user stories, acceptance criteria, milestones.
- `.project/CONSTRAINTS.md`: Performance budgets (LCP, INP, CLS), accessibility (WCAG 2.1 AA), browser support, bundle size limits.
- `.project/TECH_STACK.md`: Confirmed frameworks, package managers, testing suites, folder architecture.
- `.project/DEPLOYMENT.md`: Netlify site ID, domains, secrets inventory.

---

## Quickstart: Adding to Any Frontend Repository

### Option A: Using the Installer Script (Recommended)

In your host repository root:

**Windows PowerShell:**
```powershell
git init -b main
.\.agents\plugins\frontend-harness\scripts\install-harness.ps1 -SubmoduleUrl "https://github.com/swoods-co/gemini-dev-harness.git"
```

**Linux / macOS:**
```bash
git init -b main
./.agents\plugins\frontend-harness\scripts\install-harness.sh "https://github.com/swoods-co/gemini-dev-harness.git"
```

---

### Option B: Manual Git Submodule Setup

1. Add the harness submodule inside `.agents/plugins/frontend-harness`:
   ```bash
   git submodule add https://github.com/swoods-co/gemini-dev-harness.git .agents/plugins/frontend-harness
   git submodule update --init --recursive
   ```

2. Initialize `.project/` by copying the spec templates:
   ```bash
   mkdir -p .project
   cp .agents/plugins/frontend-harness/templates/project-spec/*.md .project/
   ```

3. Ensure `.worktrees/` is added to your project's `.gitignore`:
   ```bash
   echo ".worktrees/" >> .gitignore
   ```

4. Commit the new submodule and `.project/` scaffolding:
   ```bash
   git add .gitmodules .agents/plugins/frontend-harness .project .gitignore
   git commit -m "chore: attach universal frontend dev harness plugin"
   ```

---

## How the Agent Works: Progressive Disclosure & Skill Activation

### Do I have to manually trigger skills?
**No.** You do **not** need to remember skill names or manually call them.

Antigravity operates on **Progressive Disclosure**:
1. When Antigravity opens your repository, it automatically reads `rules/AGENTS.md` and indexes the descriptions of all bundled skills.
2. When you start with **any natural prompt** (e.g. *"Let's build a real-time analytics dashboard"* or *"Help me start this new project"*), the agent reads `rules/AGENTS.md`.
3. The rule mandates that if `.project/` is uninitialized or missing requirements, the agent must **automatically activate `project-scoping`**.
4. The agent dynamically loads the full scoping skill, asks discovery questions, and populates `.project/`.
5. Once scoping is complete, it transitions automatically into `tech-stack-config` to bootstrap the code, and `ci-cd-deployment` to configure Netlify and GitHub Actions.

---

## The New Project Journey: Step-by-Step

```mermaid
flowchart TD
    A[You Type Any Natural Prompt] --> B[Agent Reads rules/AGENTS.md]
    B --> C{Is .project/ configured?}
    C -->|No / Incomplete| D[Auto-activates skill: project-scoping]
    D --> E[Conducts Discovery Interview]
    E --> F[Generates SCOPE.md, CONSTRAINTS.md, ARCHITECTURE.md]
    F --> G[Auto-activates skill: tech-stack-config]
    G --> H[Recommends Framework & Configures Tooling]
    H --> I[Auto-activates skill: ci-cd-deployment]
    I --> J[Sets up netlify.toml & GitHub Actions CI]
    J --> K[Feature Work Ready: Isolated Git Worktrees]
```

### 1. The Scoping Interview (`project-scoping`)
The agent asks targeted discovery questions:
- **Core User Journeys**: What 2-3 workflows are MVP blockers?
- **User Personas & Devices**: Who uses it daily, and on what devices?
- **Hard Constraints**: Core Web Vitals (LCP < 2.5s), WCAG 2.1 AA accessibility, browser support.
- **Explicit Non-Goals**: What is deferred or out of scope?

### 2. Specification Generation
The agent writes testable Given-When-Then (Gherkin) acceptance criteria into `.project/SCOPE.md` and records performance limits in `.project/CONSTRAINTS.md`.

### 3. Tech Stack Bootstrapping (`tech-stack-config`)
The agent selects and configures:
- **Framework**: Vite + React / Next.js / Astro based on your SEO and interactivity requirements.
- **Styling**: Tailwind CSS v4 with design tokens.
- **Hygiene & Strictness**: Strict TypeScript (`strict: true`), ESLint/Biome, and Vitest suite.
- **Documentation**: Records all decisions in `.project/TECH_STACK.md`.

### 4. CI/CD & Deployments (`ci-cd-deployment`)
The agent copies `netlify.toml` and `.github/workflows/ci.yml`, hooks up Netlify deploy previews, and tracks deployment configurations in `.project/DEPLOYMENT.md`.

### 5. Isolated Worktrees (`worktree-workflow`)
For subsequent feature development, the agent executes inside isolated git worktrees (`.worktrees/feat-<name>`), verifies builds and tests, pushes branches, and opens PRs using the **GitHub MCP**.

---

## Bundled Skills Reference

| Skill | Trigger / When it Activates | Deliverables |
| :--- | :--- | :--- |
| **`project-scoping`** | New project initialization, missing `.project/`, refining requirements. | `.project/SCOPE.md`, `.project/CONSTRAINTS.md`, `.project/ARCHITECTURE.md` |
| **`tech-stack-config`** | Post-scoping, configuring framework, styling, testing, or linting. | Scaffolding, `tsconfig.json`, `package.json`, `.project/TECH_STACK.md` |
| **`worktree-workflow`** | Feature additions, bug fixes, parallel agent tasks. | Isolated `.worktrees/<branch>`, safe merge & cleanup |
| **`ci-cd-deployment`** | Pipeline setup, Netlify preview verification, build troubleshooting. | `netlify.toml`, `.github/workflows/ci.yml`, `.project/DEPLOYMENT.md` |

---

## MCP Integrations (`mcp_config.json`)

The plugin bundles configurations for two core MCP servers:

1. **GitHub MCP Server (`github-mcp-server`)**:
   - Manages branches, creates pull requests, inspects commits, and queries CI status checks.
   - Requires: `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable.

2. **Netlify MCP Server (`netlify`)**:
   - Inspects sites, queries deployment statuses, retrieves deploy preview URLs, and reviews build logs.
   - Requires: `NETLIFY_PERSONAL_ACCESS_TOKEN` environment variable.

---

## Updating the Harness in Downstream Projects

To pull the latest harness skills, rules, and templates in any downstream project:
```bash
git submodule update --remote .agents/plugins/frontend-harness
git commit -am "chore: update frontend dev harness plugin"
```
