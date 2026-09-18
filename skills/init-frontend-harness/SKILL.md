---
name: init-frontend-harness
description: >-
  Attaches and initializes the universal frontend development harness (gemini-dev-harness) into any new or existing workspace as a git submodule, scaffolds the .project/ specification contracts, and transitions into project scoping. Use whenever the user asks to "set up the harness", "bootstrap this project", "initialize frontend project", or start a new web app using the team harness.
---

# Initialize Frontend Harness Skill

Use this skill to automatically bootstrap any workspace with the Universal Frontend Development Harness without requiring the user to run any manual terminal commands.

---

## When to Run This Skill

Run this skill when:
- The user opens an empty workspace or new project and says: *"Set up this project with my frontend harness"*, *"Bootstrap this project"*, or *"Initialize this repo with the dev harness"*.
- A workspace does not yet have `.agents/plugins/frontend-harness` attached.

---

## Automated Procedure for the Agent

### Step 1: Verify or Initialize Git
1. Check if the workspace is already inside a Git repository:
   ```bash
   git rev-parse --is-inside-work-tree
   ```
2. If not a git repo, initialize it on `main`:
   ```bash
   git init -b main
   ```

### Step 2: Attach the Harness as a Git Submodule
1. Create the plugin directory:
   ```bash
   mkdir -p .agents/plugins
   ```
2. Add the harness submodule:
   ```bash
   git submodule add https://github.com/swoods-co/gemini-dev-harness.git .agents/plugins/frontend-harness
   git submodule update --init --recursive
   ```

### Step 3: Scaffold Project Specification Contract & Living Agent Rules
1. Create `.project/features/` and `.github/workflows/` directories:
   ```bash
   mkdir -p .project/features .github/workflows
   ```
2. Copy the harness blueprint templates into `.project/`:
   - POSIX:
     ```bash
     cp .agents/plugins/frontend-harness/templates/project-spec/*.md .project/
     cp .agents/plugins/frontend-harness/templates/project-spec/features/*.md .project/features/
     ```
   - Windows PowerShell:
     ```powershell
     Copy-Item .agents/plugins/frontend-harness/templates/project-spec/*.md .project/
     Copy-Item .agents/plugins/frontend-harness/templates/project-spec/features/*.md .project/features/
     ```
3. Copy the host project's living agent guidelines (`AGENTS.md`):
   - This file ensures future agents working on features or PRs in this project adhere to component boundaries, contract-first mock data, and CI/CD gates.
   - POSIX: `cp .agents/plugins/frontend-harness/templates/project-root/AGENTS.md AGENTS.md`
   - Windows PowerShell: `Copy-Item .agents/plugins/frontend-harness/templates/project-root/AGENTS.md AGENTS.md`
4. Copy the GitHub PR template:
   - POSIX: `cp .agents/plugins/frontend-harness/templates/github/pull_request_template.md .github/pull_request_template.md`
   - Windows PowerShell: `Copy-Item .agents/plugins/frontend-harness/templates/github/pull_request_template.md .github/pull_request_template.md`

### Step 4: Configure `.gitignore`
Ensure `.worktrees/` is ignored:
- Check if `.gitignore` exists. If not, create it.
- Append `.worktrees/` to `.gitignore`.

### Step 5: Commit Initial Scaffolding
Commit the harness submodule and specification contract:
```bash
git add .gitmodules .agents/plugins/frontend-harness .project AGENTS.md .github .gitignore
git commit -m "chore: attach universal frontend dev harness plugin and scaffold agent guidelines"
```

### Step 6: Seamless Transition to Project Scoping
1. Announce to the user:
   > *"The frontend harness is installed and living agent guidelines are initialized! Let's begin scoping your application."*
2. Automatically activate the **`project-scoping`** skill and ask the first discovery questions from `references/questionnaire.md`.
