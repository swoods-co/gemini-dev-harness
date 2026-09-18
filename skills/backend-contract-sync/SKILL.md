---
name: backend-contract-sync
description: >-
  Inspects, ingests, and synchronizes backend API schemas, Go structs, SQL models, and OpenAPI specifications from an existing backend repository (remote via GitHub MCP, local path, or URL). Generates strict TypeScript types, contract-bound mock handlers, and updates .project/contracts/ to eliminate technical debt and model drift. Use when connecting frontend to an existing backend repo, importing Go/Postgres schemas, or setting up API contracts.
---

# Backend Contract Synchronization Skill

Use this skill to connect the frontend project directly to an existing backend repository (such as Go, PostgreSQL, Node, or Python), ingest its API models, routes, and constraints, and generate 100% type-safe TypeScript interfaces and mock handlers.

---

## Why Use This Skill?

1. **Eliminate Technical Debt**: Build against actual backend structs, JSON tags, and endpoint paths from Day 1 rather than inventing temporary mock shapes that have to be rewritten later.
2. **Zero-Clone Remote Ingestion**: If the backend is on GitHub, inspect it directly using the **GitHub MCP Server** without bloating the frontend repository with backend code or Docker dependencies.
3. **Continuous Synchronization**: When your backend developer updates a Go struct or database migration, re-running this skill updates types and immediately reveals all UI components that need updating at compile time.

---

## Ingestion Modes

The agent supports three ingestion modes depending on where the backend code resides:

### Mode 1: Remote GitHub Repository (Via GitHub MCP — Recommended)
When given a repository name (e.g., `owner/backend-repo`):
1. Use `github-mcp-server` tools:
   - `search_code`: Search for Go structs (`type [A-Z].*struct`), router setups (`r.GET`, `r.POST`, `chi.Router`, `gin.Default`), or OpenAPI files (`swagger.json`, `openapi.yaml`).
   - `get_file_contents`: Retrieve models, handler signatures, and SQL migrations directly.
2. No local git clone or Docker setup required.

### Mode 2: Local Directory / Filesystem
When given a local path (e.g., `../backend` or `f:/Repos/my-backend`):
1. Inspect Go source files (`models/*.go`, `handlers/*.go`, `routes.go`, `migrations/*.sql`) using local file tools (`grep_search`, `view_file`).

### Mode 3: OpenAPI / Swagger URL or File
When given a live Swagger URL (e.g., `http://localhost:8080/swagger/doc.json`) or static file:
1. Fetch or read the JSON/YAML spec directly.
2. Save into `.project/contracts/openapi.yaml`.

---

## Step-by-Step Procedure

### Step 1: Discover API Endpoints & Data Models
1. **Locate Route Definitions**:
   - Gin: Look for `r.GET("/api/v1/...", ...)` or route groups `v1 := r.Group("/api/v1")`.
   - Chi: Look for `r.Route("/api", func(r chi.Router) { ... })`.
   - Echo: Look for `e.GET("/api/...", ...)` or `g := e.Group("/api")`.
   - Fiber: Look for `app.Get("/api/...", ...)`.
2. **Locate Data Transfer Objects (DTOs) & Database Models**:
   - Find Go `struct` definitions with `json:"..."` tags.
   - Example:
     ```go
     type UserProfile struct {
         ID        uuid.UUID  `json:"id"`
         Email     string     `json:"email"`
         FullName  string     `json:"full_name"`
         Role      string     `json:"role"`
         CreatedAt time.Time  `json:"created_at"`
         UpdatedAt *time.Time `json:"updated_at,omitempty"`
     }
     ```
3. Consult [references/go-struct-mapping.md](./references/go-struct-mapping.md) for exact Go-to-TypeScript type mapping rules.

### Step 2: Store Canonical Contracts in `.project/contracts/`
1. Ensure `.project/contracts/` directory exists.
2. Write canonical specifications:
   - If OpenAPI/Swagger was found: Save to `.project/contracts/openapi.yaml`.
   - If parsed from Go structs: Save extracted endpoints and JSON schemas to `.project/contracts/api-spec.json` and create a summary in `.project/contracts/README.md`.

### Step 3: Generate Strict TypeScript Interfaces
Generate or update `src/types/api.generated.ts` (or `src/types/api.ts`):
```typescript
export interface UserProfile {
  id: string;
  email: string;
  fullName?: string; // or full_name matching backend json tag
  role: 'admin' | 'member' | 'guest';
  createdAt: string; // ISO 8601 string
  updatedAt?: string | null;
}
```
If using OpenAPI, run the automated type generator:
```bash
npx openapi-typescript .project/contracts/openapi.yaml -o src/types/api.generated.ts
```

### Step 4: Scaffold Contract-Bound Mock Fixtures (`src/services/mock/`)
1. Create or update mock handlers in `src/services/mock/[domain].mock.ts`.
2. Ensure mock datasets strictly implement the generated TypeScript interfaces.
3. Include:
   - Happy path realistic records (1 typical item, 10+ items for list testing).
   - Empty list state (`[]`).
   - Error simulation (e.g., 400 Bad Request, 401 Unauthorized, 404 Not Found, 500 Server Error).

### Step 5: Configure Automated Codegen in `package.json`
Add the synchronization command to `package.json`:
```json
{
  "scripts": {
    "codegen:api": "openapi-typescript .project/contracts/openapi.yaml -o src/types/api.generated.ts"
  }
}
```
See [references/codegen-setup.md](./references/codegen-setup.md) for full setup instructions.

### Step 6: Update `.project/SCOPE.md` with Verified Backend Endpoints
Update the API contract section of `.project/SCOPE.md`:
- List verified endpoints, HTTP methods, and status codes.
- Flag endpoints that are ready in the backend vs. endpoints that require frontend mock emulation.
