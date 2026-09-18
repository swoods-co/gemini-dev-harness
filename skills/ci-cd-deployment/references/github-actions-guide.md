# GitHub MCP & CI/CD Actions Guide

This guide details best practices for GitHub integration within this harness.

---

## 1. Authentication & Prerequisites
- Ensure `GITHUB_PERSONAL_ACCESS_TOKEN` is set with repository read/write permissions (`repo`, `workflow`).
- Configured in plugin `mcp_config.json` or user configuration.

---

## 2. GitHub MCP Workflow Operations

### Creating Pull Requests
When ready to ship an isolated worktree branch:
1. Push branch to origin.
2. Call `create_pull_request`:
   - `title`: Semantic description (`feat: implement user auth dashboard`)
   - `base`: `main`
   - `head`: `feat/<branch-name>`
   - `body`: Structured markdown linking to `.project/SCOPE.md`, summary of changes, test results, and preview link.

### Checking CI Status Checks
- Before merging, check status checks via GitHub MCP (`list_pull_requests` or `get_commit`).
- Ensure all CI jobs (`validate` job in `ci.yml`) report `success`.

---

## 3. GitHub Actions Secret Management
- Do not store plain text tokens in `.env` files committed to git.
- For CI deployment jobs requiring tokens, configure them under GitHub Repository Settings -> Secrets and Variables -> Actions:
  - `NETLIFY_AUTH_TOKEN`
  - `NETLIFY_SITE_ID`
