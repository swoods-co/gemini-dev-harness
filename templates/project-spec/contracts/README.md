# Backend API Contracts (`.project/contracts/`)

This directory houses the canonical API specifications, schema definitions, and contract snapshots ingested from the backend repository.

---

## What Lives Here:
- `openapi.yaml` or `swagger.json`: Exported or generated OpenAPI 3.x specifications from the backend.
- `api-spec.json`: Extracted JSON schema definitions parsed from Go structs, SQL migrations, or endpoints.
- `backend-reference.md`: Metadata linking to the backend source repository (e.g., GitHub repo URL, active branch, commit SHA, or local path).

---

## How to Synchronize:
1. **Agent Command**: Ask Antigravity:
   > *"Sync the latest backend contract from `owner/backend-repo`"*
2. **CLI Command**: If `openapi-typescript` is configured:
   ```bash
   npm run codegen:api
   ```
3. Run verification to ensure all frontend components and mocks adhere to updated contracts:
   ```bash
   npm run typecheck
   npm test
   ```
