# Writing Testable Acceptance Criteria

High quality acceptance criteria allow autonomous agents to verify their own implementations against clear boundaries.

---

## 1. Structure: Given-When-Then (Gherkin format)

For each user journey or story, write criteria using this pattern:

```markdown
- [ ] **Scenario**: Successful Form Submission
  - **Given**: A user is on the signup page with all required inputs filled validly.
  - **When**: The user clicks the "Create Account" button.
  - **Then**: A loading spinner appears on the button, an API POST request is dispatched to `/api/auth/register`, and upon 201 response, the user is redirected to `/dashboard` with a welcome toast.
```

---

## 2. Negative & Edge Case Criteria

Always include at least one negative or boundary condition per story:

```markdown
- [ ] **Scenario**: Validation Error on Missing Email
  - **Given**: A user enters a password but leaves the email field blank.
  - **When**: The user blurs the email field or attempts submission.
  - **Then**: An inline error message appears below the email input ("Email is required"), the input receives `aria-invalid="true"`, and the form does not submit.
```

---

## 3. Checklist for Complete Criteria
Every story in `.project/SCOPE.md` should answer:
- [ ] What is the happy path?
- [ ] What happens on network failure / offline?
- [ ] What are the responsive view adjustments (mobile vs desktop)?
- [ ] What are the keyboard and accessibility states (tab order, focus ring, announcements)?
