# Feature Planning Template

## What is plan.md?

This file helps you plan and structure feature development before implementation. Use it to:

- Break down complex features into manageable tasks
- Document your approach and architecture decisions
- Share your plan with AI agents (Claude Code, Cursor) for better assistance
- Maintain context across development sessions
- Review and refine your approach before coding

## How to Use This Template

1. Copy the template below for each new feature
2. Fill in the sections with your specific requirements
3. Share with your AI agent to get implementation help
4. Update as you progress through development
5. Archive completed plans for reference

---

## Feature Plan Template

### Feature Name

[Brief, descriptive name of the feature]

### Overview

[1-2 sentences describing what this feature does and why it's needed]

### Goals

- [ ] Primary goal 1
- [ ] Primary goal 2
- [ ] Primary goal 3

### Non-Goals

[What this feature explicitly does NOT include]

### Technical Approach

#### Architecture Changes

[Describe any changes to the overall system architecture]

#### New Components/Files

- `path/to/file.ts` - Description of purpose
- `path/to/component.tsx` - Description of purpose

#### Modified Files

- `existing/file.ts` - What changes and why

#### Database/Storage Changes

[Any new tables, fields, or storage requirements]

#### API Changes

[New or modified endpoints]

```
POST /api/new-endpoint
Request: { ... }
Response: { ... }
```

#### External Dependencies

[Any new packages or services needed]

- `package-name` - Why it's needed
- MCP server needed: [Yes/No]

### Implementation Tasks

#### Phase 1: [Phase Name]

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

#### Phase 2: [Phase Name]

- [ ] Task 1
- [ ] Task 2

#### Phase 3: [Phase Name]

- [ ] Task 1
- [ ] Task 2

### Testing Strategy

- [ ] Unit tests for [components]
- [ ] Integration tests for [workflows]
- [ ] Manual testing checklist
- [ ] Performance testing (if applicable)

### Deployment Considerations

- Environment variables needed: [List]
- Database migrations: [Yes/No]
- Breaking changes: [Yes/No]
- Rollback plan: [Describe]

### Security Considerations

[Any authentication, authorization, or data protection concerns]

### Performance Considerations

[Expected load, caching strategy, optimization needs]

### Documentation Needed

- [ ] Update README.md
- [ ] Update claude.md
- [ ] API documentation
- [ ] User guide (if applicable)

### Questions/Unknowns

[Things you need to research or decide before implementation]

1. Question 1?
2. Question 2?

### Success Criteria

[How will you know this feature is complete and working correctly?]

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Timeline Estimate

[Rough estimate of implementation time]

---

## Example Plan

### Feature Name

User Authentication with Supabase

### Overview

Add user authentication to the API using Supabase Auth, allowing users to sign up, log in, and access protected endpoints.

### Goals

- [ ] Enable email/password authentication
- [ ] Protect API routes with JWT validation
- [ ] Store user profiles in Supabase

### Non-Goals

- OAuth providers (future enhancement)
- Multi-factor authentication (future enhancement)
- Password reset flow (include in separate plan)

### Technical Approach

#### Architecture Changes

- Add authentication middleware to Hono app
- Integrate Supabase client for auth operations
- Add protected route pattern

#### New Components/Files

- `apps/api/src/middleware/auth.ts` - JWT validation middleware
- `apps/api/src/routes/auth.ts` - Auth endpoints (signup, login, logout)
- `apps/api/src/lib/supabase.ts` - Supabase client initialization

#### Modified Files

- `apps/api/src/index.ts` - Register auth routes and middleware
- `apps/api/wrangler.jsonc` - Add Supabase environment variables

#### Database/Storage Changes

- Use Supabase's built-in auth.users table
- Add custom user profiles table in Supabase

#### API Changes

```
POST /auth/signup
Request: { email: string, password: string }
Response: { user: User, session: Session }

POST /auth/login
Request: { email: string, password: string }
Response: { user: User, session: Session }

POST /auth/logout
Headers: { Authorization: Bearer <token> }
Response: { success: boolean }

GET /auth/me
Headers: { Authorization: Bearer <token> }
Response: { user: User }
```

#### External Dependencies

- `@supabase/supabase-js` - Supabase client library
- MCP server needed: Yes (already configured)

### Implementation Tasks

#### Phase 1: Setup

- [ ] Install @supabase/supabase-js
- [ ] Add Supabase credentials to .env
- [ ] Initialize Supabase client
- [ ] Create user profiles table schema

#### Phase 2: Auth Endpoints

- [ ] Create signup endpoint
- [ ] Create login endpoint
- [ ] Create logout endpoint
- [ ] Create "get current user" endpoint

#### Phase 3: Middleware & Protection

- [ ] Implement JWT validation middleware
- [ ] Apply middleware to protected routes
- [ ] Add error handling for auth failures

### Testing Strategy

- [ ] Unit tests for auth middleware
- [ ] Integration tests for auth endpoints
- [ ] Manual testing with Postman/curl
- [ ] Test token expiration and refresh

### Deployment Considerations

- Environment variables needed: `SUPABASE_URL`, `SUPABASE_ANON_KEY`
- Database migrations: Create user profiles table in Supabase dashboard
- Breaking changes: No
- Rollback plan: Remove auth routes, middleware remains non-breaking

### Security Considerations

- Store Supabase credentials as Cloudflare secrets
- Use environment variables, not hardcoded values
- Validate JWT signatures properly
- Rate limit auth endpoints to prevent brute force
- Use HTTPS only (Cloudflare Workers enforces this)

### Performance Considerations

- Cache Supabase client instance
- Consider JWT validation caching for high-traffic routes
- Monitor auth endpoint response times

### Documentation Needed

- [ ] Update README.md with auth setup instructions
- [ ] Update claude.md with auth architecture
- [ ] Create API documentation for auth endpoints
- [ ] Add auth examples to user guide

### Questions/Unknowns

1. Should we implement refresh token rotation?
2. What's the desired JWT expiration time?
3. Do we need role-based access control now or later?

### Success Criteria

- [ ] Users can sign up with email/password
- [ ] Users can log in and receive JWT
- [ ] Protected routes reject requests without valid JWT
- [ ] Protected routes allow requests with valid JWT
- [ ] Auth state persists across requests

### Timeline Estimate

- Phase 1: 2 hours
- Phase 2: 3 hours
- Phase 3: 2 hours
- Testing & Documentation: 2 hours
- **Total: ~9 hours**

---

## Tips for Working with AI Agents

- **Be specific:** The more detail you provide, the better AI can help
- **Update as you go:** Keep the plan current as you learn more
- **Reference this file:** Tell Claude/Cursor "Read plan.md" to give context
- **Use checkboxes:** Track progress with `- [ ]` and `- [x]`
- **Ask for feedback:** AI agents can review and improve your plan
- **Break it down:** Large features should be split into multiple plans

## Planning Best Practices

1. **Start with why:** Explain the business value and user need
2. **Research first:** Investigate technical options before committing
3. **Think in phases:** Break work into shippable increments
4. **Consider risks:** Identify potential blockers early
5. **Plan for testing:** Don't treat testing as an afterthought
6. **Document decisions:** Future you will thank present you
7. **Get feedback:** Share plans with team members or AI agents
8. **Stay flexible:** Plans will change as you learn more
