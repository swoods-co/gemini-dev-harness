# Universal Frontend Development Harness (Antigravity Plugin)

A universal, shareable **Antigravity Plugin** and development harness for modern frontend projects. Designed to be included across multiple frontend repositories as a **Git Submodule**, providing battle-tested agent workflows, project scoping, constraints management, framework scaffolding, git worktree isolation, and CI/CD pipelines with GitHub and Netlify MCPs.

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

**Linux / macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/<your-org>/gemini-dev-harness/main/scripts/install-harness.sh | bash -s -- "https://github.com/<your-org>/gemini-dev-harness.git"
```
Or if you have already cloned/submoduled the repo locally:
```bash
./scripts/install-harness.sh "https://github.com/<your-org>/gemini-dev-harness.git"
```

**Windows PowerShell:**
```powershell
.\scripts\install-harness.ps1 -SubmoduleUrl "https://github.com/<your-org>/gemini-dev-harness.git"
```

---

### Option B: Manual Git Submodule Setup

1. Add the harness submodule inside `.agents/plugins/frontend-harness`:
   ```bash
   git submodule add https://github.com/<your-org>/gemini-dev-harness.git .agents/plugins/frontend-harness
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

## Bundled Skills

### 1. `project-scoping`
- **Purpose**: Runs a structured discovery session to define core personas, P0 user journeys, non-goals, and technical constraints.
- **Outputs**: Populates `.project/SCOPE.md` and `.project/CONSTRAINTS.md` with testable Gherkin acceptance criteria.

### 2. `tech-stack-config`
- **Purpose**: Bootstraps the framework (Vite, Next.js, Astro), configures Tailwind CSS, strict TypeScript, linting (ESLint/Biome), and testing (Vitest).
- **Outputs**: Populates `.project/TECH_STACK.md` and verifies the build.

### 3. `worktree-workflow`
- **Purpose**: Creates and manages isolated Git worktrees (`.worktrees/<branch-name>`) for parallel agent development and risk-free tasks.
- **Commands**:
  - `worktree-helper.sh create feat/user-auth`
  - `worktree-helper.sh remove feat/user-auth`

### 4. `ci-cd-deployment`
- **Purpose**: Sets up `netlify.toml`, GitHub Actions CI (`.github/workflows/ci.yml`), verifies deploy previews, and tracks deployment metadata in `.project/DEPLOYMENT.md`.

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
