## Description
<!-- Provide a concise summary of the changes introduced in this PR. -->

## Associated Scope & Feature Spec
- **Feature Specification**: [e.g., `.project/features/user-auth.md` or `.project/SCOPE.md#milestone-1`]
- **Related Issue / Task**: [e.g., #12]

## Architectural & Data Contracts
- [ ] Domain interfaces updated in `src/types/`
- [ ] Mock API handlers updated in `src/services/mock/` (supports `VITE_USE_MOCKS=true`)
- [ ] No direct API endpoint coupling or leaky abstractions
- [ ] Reusable UI components placed under `src/components/ui/` without domain state

## Quality & Compliance Gates
- [ ] **Accessibility (a11y)**: WCAG 2.1 AA compliant, semantic markup, keyboard navigable
- [ ] **Core Web Vitals**: No layout shifts (CLS), lazy-loaded heavy components/images
- [ ] **Linting**: `npm run lint` executed with 0 errors
- [ ] **Type Safety**: `npm run typecheck` passes cleanly
- [ ] **Tests**: `npm test` passes with test coverage for new logic
- [ ] **Production Build**: `npm run build` passes

## Netlify Deploy Preview Verification
- **Preview URL**: [Netlify bot preview link]
- **Verification Notes**: [Brief notes on manual verification or visual regression check]
