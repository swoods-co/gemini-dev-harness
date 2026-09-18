# Scoping & Constraints Discovery Questionnaire

When conducting a project scoping session, use these targeted questions to guide the conversation without overwhelming the user:

### 1. Vision & Target User
- What is the one-sentence mission of this application?
- Who will use it daily (internal teams, public consumers, B2B clients)?
- What is their primary device context (mobile on-the-go, desktop workstation, tablet)?

### 2. MVP User Journeys (Prioritization)
- What is the single most important user journey that must work on Day 1?
- What secondary journeys are needed to support it (e.g., authentication, settings, data exports)?
- What can be deferred to Milestone 2 or 3?

### 3. Constraints & Operational Realities
- **Performance**: Are there strict initial load requirements or offline support needs?
- **Accessibility**: Is WCAG 2.1 AA sufficient, or are there higher compliance targets (Section 508, European Accessibility Act)?
- **Devices**: Any legacy device requirements, or evergreen browsers only?
- **Security & Data**: Are there GDPR, HIPAA, or strict authentication requirements (OAuth, SAML, SSO)?

### 4. Backend Contracts & Existing Repositories
- **Existing Backend**: Does a backend repository (e.g. Go, PostgreSQL, Node, Python) already exist, or is one currently being built?
- **Repository Reference**: What is the GitHub repository name (e.g. `owner/backend-repo`) or local folder path so the agent can inspect Go structs, routes, or SQL schemas?
- **API Documentation**: Is there an OpenAPI / Swagger endpoint or file (`swagger.json`, `openapi.yaml`) available?
- *(If yes: Immediately run `backend-contract-sync` to generate types and mocks from real schemas).*

### 5. Non-Goals & Boundaries
- What features or integrations should we explicitly declare out of scope for this version?
- Are there third-party SDKs or legacy APIs that will be deferred to later milestones?
