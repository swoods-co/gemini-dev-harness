---
name: ci-cd-deployment
description: >-
  Guides the agent in configuring and managing continuous integration (GitHub Actions) and hosting/deployment (Netlify), using GitHub and Netlify MCP tools. Use when setting up netlify.toml, creating deployment pipelines, debugging build failures, or verifying PR deploy previews.
---

# CI/CD & Deployment Skill

This skill teaches the agent how to configure, automate, and verify continuous integration pipelines with GitHub Actions and hosting deployments on Netlify using GitHub and Netlify Model Context Protocol (MCP) integrations.

---

## When to Run This Skill

Run this skill when:
- Setting up a new project's CI/CD pipeline (`.github/workflows/ci.yml`).
- Configuring `netlify.toml` for hosting, redirects, and headers.
- Linking or creating a Netlify site via Netlify MCP.
- Verifying a Netlify deploy preview for an open pull request.
- Troubleshooting build or deployment failures in CI or Netlify.

---

## Procedure

### Step 1: Netlify Configuration Setup
1. Copy the harness template `templates/netlify/netlify.toml` into the project repository root.
2. Review and adapt build commands:
   - For Vite: `command = "npm run build"`, `publish = "dist"`
   - For Next.js: `command = "npm run build"`, `publish = ".next"` (with `@netlify/plugin-nextjs` if needed)
   - For Astro: `command = "npm run build"`, `publish = "dist"`
3. Verify client-side SPA routing redirects (`/* -> /index.html 200`) or SSR routing rules.
4. Ensure security headers (CSP, X-Frame-Options, HSTS, Referrer-Policy) are present.

### Step 2: GitHub Actions Workflow Setup
1. Create `.github/workflows/` in the host repository.
2. Copy `templates/github-actions/ci.yml` to `.github/workflows/ci.yml`.
3. Validate that package scripts in `package.json` match the CI commands:
   - `npm run lint`
   - `npm run typecheck`
   - `npm test`
   - `npm run build`

### Step 3: MCP Integrations & Verification

#### Netlify MCP
Refer to [references/netlify-mcp-guide.md](./references/netlify-mcp-guide.md) for available MCP actions:
- Query existing projects: Use `netlify-project-services-reader` to find or verify the connected site.
- Inspect deployments: Use `netlify-deploy-services-reader` to view build status and retrieve deploy preview URLs.
- Troubleshoot errors: Read deployment logs via Netlify MCP to locate failure causes.

#### GitHub MCP
Refer to [references/github-actions-guide.md](./references/github-actions-guide.md) for available MCP actions:
- PR creation: Use `create_pull_request` to open PRs against `main`.
- Issue & status checks: Use `list_pull_requests` or `get_commit` to inspect CI check-runs.

### Step 4: Deployment Documentation in `.project/`
1. Copy `templates/project-spec/DEPLOYMENT.md` to `.project/DEPLOYMENT.md` if not already present.
2. Record the Netlify Site ID, production URL, deploy preview naming pattern, and environment variables list.
