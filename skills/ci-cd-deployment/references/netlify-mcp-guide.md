# Netlify MCP Integration Guide

This guide details how to leverage Netlify Model Context Protocol (MCP) tools within this harness.

---

## 1. Authentication & Prerequisites
- Ensure `NETLIFY_PERSONAL_ACCESS_TOKEN` is set in the environment or user's Antigravity MCP configuration (`~/.gemini/config/mcp_config.json`).
- Netlify MCP runs via `npx -y @netlify/mcp`.

---

## 2. Common Operations

### Finding Connected Sites / Projects
- Tool: `netlify-project-services-reader`
- Purpose: Retrieve site ID, site name, default domain, and git repository link.

### Checking Deployment Status & Previews
- Tool: `netlify-deploy-services-reader`
- Purpose: Inspect the latest deployments, verify if deploy preview completed successfully, and extract the preview URL (e.g. `https://deploy-preview-12--site-name.netlify.app`).

### Managing Site Configuration & Environment Variables
- Tool: `netlify-project-services-updater` / `netlify-deploy-services-updater`
- Purpose: Set or update non-secret build environment variables and domain settings.

---

## 3. Deploy Preview Verification Checklist
Before approving or merging a feature pull request:
1. Verify Netlify build finished with state `ready`.
2. Open preview URL and verify key interactive flows.
3. Check browser console for runtime errors or broken asset paths.
4. Verify SPA client-side routes do not 404 on direct page refresh (validates `netlify.toml` redirect rules).
