---
name: worktree-workflow
description: >-
  Guides the agent in managing Git worktrees for safe, isolated feature development, bug fixes, and parallel agent execution. Use when creating worktrees, switching task contexts, preparing isolated test sandboxes, or safely cleaning up worktrees after pull requests.
---

# Git Worktree Workflow Skill

This skill teaches the agent how to safely manage Git worktrees to isolate tasks, protect the main branch, and allow parallel development without polluting working directories.

---

## Why Worktrees?

In autonomous multi-agent or multi-step engineering:
- **Clean Root**: The repository root stays clean on `main` or the default integration branch.
- **Zero Pollution**: Experimental branches, test output, or temporary files never contaminate the main working directory.
- **Fast Context Switching**: Multiple agents can work on distinct tasks simultaneously without stash or unstash conflicts.

---

## Worktree Lifecycle

### 1. Planning the Branch & Path
- Name branch following conventions:
  - `feat/<task-name>`
  - `fix/<issue-name>`
  - `chore/<task-name>`
  - `spike/<exploration-name>`
- Worktree directory path convention: `.worktrees/<sanitized-branch-name>`
  - Example: For branch `feat/user-auth`, path is `.worktrees/feat-user-auth`.

### 2. Creating the Worktree
Run the worktree creation command:
```bash
git worktree add .worktrees/<dir-name> -b <branch-name>
```

Or use the provided helper script:
- POSIX: `./skills/worktree-workflow/scripts/worktree-helper.sh create <branch-name>`
- Windows PowerShell: `.\skills\worktree-workflow\scripts\worktree-helper.ps1 -Action Create -Branch <branch-name>`

### 3. Setting Up Dependencies in the Worktree
Navigate to `.worktrees/<dir-name>` and install/link dependencies:
```bash
cd .worktrees/<dir-name>
npm install # or pnpm install
```

> [!TIP]
> If using `pnpm`, dependencies are automatically shared via the global store, making worktree setup nearly instantaneous and consuming minimal disk space.

### 4. Executing Work & Verifying
Perform all changes inside `.worktrees/<dir-name>`:
1. Write code, tests, and documentation.
2. Run validation inside the worktree:
   ```bash
   npm run lint
   npm run typecheck
   npm run test
   npm run build
   ```
3. Commit changes with semantic commit messages (`feat: add login form validation`).
4. Push branch to remote:
   ```bash
   git push -u origin <branch-name>
   ```

### 5. Creating PR & Cleanup
1. Use GitHub MCP or git CLI to open a pull request.
2. Once the PR is opened or merged, safely remove the worktree:
```bash
git worktree remove .worktrees/<dir-name>
```
3. Run `git worktree prune` to clean any stale metadata.
