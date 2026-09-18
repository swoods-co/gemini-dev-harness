# Go Struct to TypeScript & Zod Mapping Reference

Use this reference when parsing Go backend source code (`models/*.go`, `handlers/*.go`, `types/*.go`) into TypeScript interfaces and runtime Zod validation schemas.

---

## 1. Primitive Type Mappings

| Go Type | TypeScript Type | Zod Schema | Notes |
| :--- | :--- | :--- | :--- |
| `string` | `string` | `z.string()` | Standard string |
| `int`, `int32`, `int64` | `number` | `z.number().int()` | Integer |
| `uint`, `uint32`, `uint64`| `number` | `z.number().int().nonnegative()` | Positive integer |
| `float32`, `float64` | `number` | `z.number()` | Floating point |
| `bool` | `boolean` | `z.boolean()` | Boolean flag |
| `byte` / `[]byte` | `string` | `z.string()` | Typically base64 encoded in JSON |
| `time.Time` | `string` | `z.string().datetime()` | Serialized as ISO 8601 string |
| `uuid.UUID` | `string` | `z.string().uuid()` | From `github.com/google/uuid` |
| `interface{}` / `any` | `unknown` | `z.unknown()` | Arbitrary payload |

---

## 2. Pointers, Optionals & Nullability

In Go, pointers (`*Type`) are used for optional or nullable fields:

```go
type UpdateUserRequest struct {
    Name  *string `json:"name,omitempty"`
    Bio   *string `json:"bio"`
}
```

- **`omitempty` present**: Field is optional in JSON: `name?: string | null;`
- **Pointer without `omitempty`**: Field is nullable in JSON: `bio: string | null;`
- **Value type (no pointer)**: Field is strictly required: `email: string;`

---

## 3. Collections & Slices

| Go Definition | TypeScript Equivalent | Zod Equivalent |
| :--- | :--- | :--- |
| `[]string` | `string[]` | `z.array(z.string())` |
| `[]User` | `User[]` | `z.array(UserSchema)` |
| `map[string]string` | `Record<string, string>` | `z.record(z.string())` |
| `map[string]interface{}` | `Record<string, unknown>` | `z.record(z.unknown())` |

---

## 4. Go Enums (`iota`) to TypeScript Unions

In Go:
```go
type UserRole string

const (
    RoleAdmin  UserRole = "admin"
    RoleMember UserRole = "member"
    RoleGuest  UserRole = "guest"
)
```

Becomes TypeScript:
```typescript
export type UserRole = 'admin' | 'member' | 'guest';

export const UserRole = {
  Admin: 'admin',
  Member: 'member',
  Guest: 'guest',
} as const;
```

---

## 5. JSON Tags Handling

Go structs use struct tags to define JSON serialization keys:
```go
type Account struct {
    AccountID   string `json:"account_id"`           // Use "account_id" in TS
    SecretKey   string `json:"-"`                    // Omit from TS entirely
    DisplayName string `json:"display_name,omitempty"`// Optional in TS
}
```

Rules:
1. Always use the key specified inside `json:"..."`, **not** the Go struct field name.
2. If `json:"-"`, do not include the field in frontend types.
3. If `omitempty` is present, mark the property with `?`.

---

## 6. Route & Handler Patterns in Common Go Frameworks

### Gin (`github.com/gin-gonic/gin`)
```go
v1 := r.Group("/api/v1")
{
    v1.GET("/users", handler.ListUsers)         // GET /api/v1/users
    v1.GET("/users/:id", handler.GetUser)       // GET /api/v1/users/{id}
    v1.POST("/users", handler.CreateUser)       // POST /api/v1/users (Inspect handler body binding)
}
```

### Chi (`github.com/go-chi/chi/v5`)
```go
r.Route("/api/v1", func(r chi.Router) {
    r.Get("/projects", ListProjects)
    r.Post("/projects", CreateProject)
    r.Route("/{id}", func(r chi.Router) {
        r.Get("/", GetProject)
        r.Delete("/", DeleteProject)
    })
})
```

### Echo (`github.com/labstack/echo/v4`)
```go
e.GET("/api/v1/items", getItems)
e.POST("/api/v1/items", createItem)
```
