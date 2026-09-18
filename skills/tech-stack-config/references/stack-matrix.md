# Frontend Technology Selection Matrix

Use this matrix to guide architecture decisions during tech stack configuration:

| Need / Constraint | Recommended Stack | Rationale | Alternatives |
| :--- | :--- | :--- | :--- |
| **Interactive Web App / Dashboard** | **Vite + React (TypeScript) + Tailwind CSS** | Blazing fast HMR, lightweight build, no SSR complexity, low latency on Netlify CDN. | Vue 3 / Vite, SvelteKit (SPA mode) |
| **Public SEO / E-commerce / SSR** | **Next.js (App Router) + TypeScript + Tailwind** | Server Components, hybrid rendering, built-in image optimization, OpenGraph generation. | Remix / React Router v7, Astro |
| **Content-Heavy / Documentation / Marketing** | **Astro + TypeScript + Tailwind** | Islands architecture, zero JS by default, outstanding Lighthouse scores out of the box. | 11ty, Next.js SSG |
| **Lightweight Widget / Embed** | **Vite + Web Components / Preact** | Ultra-minimal bundle footprint (<10KB runtime). | Lit, Vanilla TypeScript |

---

## State Management Decision Guide
- **Server Data Caching**: Prefer TanStack Query (React Query) or SWR. Eliminates manual `useEffect` fetching and standardizes background refresh.
- **Form State**: React Hook Form + Zod for schema validation.
- **Client Global State**: Zustand for simple stores; Avoid Redux unless existing legacy constraints require it.
- **URL Query State**: `nuqs` (type-safe search params) for filterable tables, search bars, and pagination.
