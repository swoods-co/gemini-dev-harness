# Technical & Operational Constraints

Document the technical, performance, compliance, and architectural constraints that bound all implementation decisions in this project.

---

## 1. Performance Budgets (Core Web Vitals)
All pull requests must be validated against these performance thresholds:
- **Largest Contentful Paint (LCP)**: ≤ 2.5s (good)
- **Interaction to Next Paint (INP)**: ≤ 200ms (good)
- **Cumulative Layout Shift (CLS)**: ≤ 0.1
- **First Contentful Paint (FCP)**: ≤ 1.8s
- **Initial JS Bundle Size Budget**: ≤ 150 KB (gzipped) for initial route payload.
- **Route Chunk Budget**: ≤ 50 KB (gzipped) per lazy-loaded route chunk.

---

## 2. Accessibility & Usability (WCAG 2.1 AA)
- **Standards Compliance**: WCAG 2.1 Level AA compliant across all views.
- **Keyboard Navigation**: 100% navigable without mouse input. Visible focus rings must never be stripped (`:focus-visible`).
- **Color Contrast**: Minimum contrast ratio of 4.5:1 for normal text, 3:1 for large text and UI components.
- **Form Controls**: All inputs must have associated `<label>` or `aria-label`, with programmatic error descriptions (`aria-describedby`).
- **Screen Reader Testing**: Validated against NVDA, VoiceOver, or automated a11y tooling (axe-core / Lighthouse).

---

## 3. Browser & Platform Compatibility
- **Desktop**: Evergreen browsers (Chrome, Edge, Firefox, Safari) latest 2 major versions.
- **Mobile**: Safari on iOS (latest 2 major versions), Chrome on Android.
- **Minimum Resolution**: 320px width without horizontal scrollbars or clipping.

---

## 4. Security & Compliance
- **Authentication / Authorization**: [e.g., JWT in HttpOnly cookies, Auth0, Supabase, Firebase].
- **Content Security Policy (CSP)**: Enforced via headers in `netlify.toml`.
- **Secrets Management**: Zero secrets in source code. All runtime/build variables loaded via environment variables and declared in `.env.example`.
- **Data Privacy**: [e.g., GDPR compliant, cookie consent banner if tracking cookies are used, zero PII logging in client diagnostics].

---

## 5. Architectural & Code Constraints
- **TypeScript**: Strict mode enabled (`strict: true`, `noImplicitAny: true`).
- **Module Format**: Pure ESM (`"type": "module"`).
- **Styling Architecture**: Utility-first (Tailwind CSS) or scoped CSS Modules. No unencapsulated global style pollution.
- **State Management**: Prefer server state libraries (TanStack Query / SWR) and URL state over monolithic client-side global stores. Keep client state minimal (Zustand or React Context).
- **Dependencies**: New external dependencies must be evaluated for bundle size impact (via bundlephobia.com or equivalent) before introduction.
