# Automated API Code Generation & Typed Mocking

This guide details how to configure zero-drift TypeScript code generation and typed Mock Service Worker (MSW) handlers from backend contracts.

---

## 1. Setting Up `openapi-typescript`

`openapi-typescript` generates static TypeScript types from OpenAPI 3.0 / 3.1 YAML or JSON files without any heavy runtime dependencies.

### Installation
```bash
npm install -D openapi-typescript
```

### Configure in `package.json`
```json
{
  "scripts": {
    "codegen:api": "openapi-typescript .project/contracts/openapi.yaml -o src/types/api.generated.ts",
    "codegen:api:remote": "openapi-typescript http://localhost:8080/swagger/doc.json -o src/types/api.generated.ts"
  }
}
```

---

## 2. Using Generated Types in API Services

Once generated, reference types directly from the schema paths:

```typescript
import type { paths, components } from '@/types/api.generated';

// Extract component schemas
export type User = components['schemas']['User'];
export type CreateUserRequest = components['schemas']['CreateUserRequest'];

// Extract response types from specific routes
export type GetUsersResponse =
  paths['/api/v1/users']['get']['responses']['200']['content']['application/json'];
```

---

## 3. Typed Mocking with MSW (Mock Service Worker)

To guarantee that mock data never falls out of sync with real backend types:

```typescript
// src/services/mock/handlers.ts
import { http, HttpResponse } from 'msw';
import type { paths } from '@/types/api.generated';

type UserListResponse = paths['/api/v1/users']['get']['responses']['200']['content']['application/json'];

export const handlers = [
  http.get('/api/v1/users', () => {
    const mockUsers: UserListResponse = [
      {
        id: 'usr_123',
        email: 'developer@example.com',
        role: 'admin',
        created_at: new Date().toISOString(),
      },
    ];

    return HttpResponse.json(mockUsers);
  }),
];
```

### TypeScript Enforcement Benefit
If the Go backend developer renames `created_at` to `createdAt` or alters the enum for `role`, re-running `npm run codegen:api` will cause TypeScript compilation (`npm run typecheck`) to immediately fail on the mock file above until it is updated.
