## Project Overview

This is an AI-driven application development template designed to work seamlessly with AI coding agents like Claude Code and Cursor. The template provides a structured starting point for building applications with automated deployment, dependency management, and MCP (Model Context Protocol) integrations.

**Technology Stack:**

- **Runtime:** Bun (JavaScript runtime and package manager)
- **Framework:** Hono v4 (Lightweight web framework)
- **Deployment Platforms:**
  - Cloudflare Workers (API hosting)
  - Supabase Edge Functions (Serverless functions)
- **Deployment Tools:** Wrangler v4, Supabase CLI
- **Database:** Supabase (PostgreSQL with RLS)
- **AI Agents:** Claude Code, Cursor

## Project Structure

```
ai-driven-project-template/
   .env                          # Environment variables (not committed)
   .mcp.json                     # MCP server configurations
   package.json                  # Root package.json (Husky, lint-staged, commitlint, prettier)
   commitlint.config.js          # Commit message validation rules
   lint-staged.config.js         # Staged files linting configuration
   .prettierrc                   # Code formatting rules
   .prettierignore               # Files to exclude from formatting
   .husky/                       # Git hooks directory
       pre-commit               # Runs lint-staged on staged files
       commit-msg               # Validates commit messages
   agent.md                      # This file - Project context for Cursor
   claude.md                     # Project context for Claude Code
   plan.md                       # Feature planning template
   README.md                     # User-facing documentation
   .claude/                      # Claude Code configuration
      settings.local.json       # Permissions and settings
      skills/                   # Custom Claude Code skills
          dependencies/         # Dependency management skill
             SKILL.md
             scripts/
                 install.sh    # Unix/Mac install script
                 install.ps1   # Windows install script
          deployment/           # Deployment skill
              SKILL.md
              scripts/
                  deploy.sh     # Unix/Mac deploy script
                  deploy.ps1    # Windows deploy script
          check-envs/           # Environment check skill
              SKILL.md
              scripts/
                  check-envs.sh     # Unix/Mac check script
                  check-envs.ps1    # Windows check script
   .cursor/                      # Cursor configuration
      rules/                    # Cursor rule files (skills)
          dependencies.mdc      # Dependency management rule
          deployment.mdc        # Deployment rule
          check-envs.mdc        # Environment check rule
   apps/
       api/                      # Main API application
           package.json          # Dependencies and scripts
           wrangler.jsonc        # Cloudflare Workers config
           tsconfig.json         # TypeScript configuration
           src/
               index.ts          # API entry point (Hono app)
   supabase/
       functions/               # Supabase Edge Functions
           hello-world/         # Example function
               index.ts
       config.toml              # Supabase configuration
```

## Environment Configuration

### Required Environment Variables

Create a `.env` file in the project root with the following variables:

```bash
# Cloudflare Workers Configuration
CLOUDFLARE_API=<your_cloudflare_api_token>
CLOUDFLARE_ACCOUNT_ID=<your_cloudflare_account_id>

# Supabase Configuration
SUPABASE_URL=<your_supabase_project_url>
SUPABASE_ANON_KEY=<your_supabase_anon_key>
SUPABASE_SERVICE_ROLE_KEY=<your_supabase_service_role_key>
SUPABASE_PROJECT_REF=<your_supabase_project_ref>

# Resend Configuration (Email Service)
RESEND_KEY=<your_resend_api_key>
```

**How to Get Credentials:**

### Cloudflare

1. **Cloudflare Account ID:**
   - Dashboard: https://dash.cloudflare.com
   - Navigate to Workers & Pages
   - Copy Account ID from right sidebar

2. **Cloudflare API Token:**
   - API Tokens: https://dash.cloudflare.com/profile/api-tokens
   - Create token using "Edit Cloudflare Workers" template
   - Required permissions: Workers Scripts > Edit, Account Settings > Read

### Supabase

1. **Supabase Project URL & Keys:**
   - Dashboard: https://supabase.com/dashboard
   - Select your project
   - Navigate to Settings > API
   - Copy:
     - **Project URL** (SUPABASE_URL)
     - **Project Reference** (short ID from URL, e.g., "abcdefg" from https://abcdefg.supabase.co)
     - **anon public** key (SUPABASE_ANON_KEY) - Safe for client-side use with RLS
     - **service_role** key (SUPABASE_SERVICE_ROLE_KEY) - Server-only, bypasses RLS

### Resend

1. **Resend API Key:**
   - Dashboard: https://resend.com/api-keys
   - Click "Create API Key"
   - Copy the key (starts with `re_`)

2. **Domain Verification (Production):**
   - Domains: https://resend.com/domains
   - Add and verify your domain for production emails
   - For testing, use `onboarding@resend.dev` as the sender

**Security:**

- The `.env` file is in `.gitignore` and should never be committed
- `SUPABASE_SERVICE_ROLE_KEY` bypasses Row Level Security - NEVER expose publicly
- `SUPABASE_ANON_KEY` is safe for client-side use as it respects RLS policies

## MCP Server Configuration

This project uses Model Context Protocol (MCP) servers for enhanced AI capabilities.

### Configured MCP Servers

**1. Supabase MCP** (`supabase`)

- **Type:** HTTP
- **URL:** https://mcp.supabase.com/mcp
- **Purpose:** Database and backend services integration
- **Usage:** Enables AI to interact with Supabase services

**2. Playwright MCP** (`playwright`)

- **Type:** stdio
- **Command:** `npx @playwright/mcp@latest`
- **Purpose:** Browser automation and testing
- **Usage:** Enables AI to perform browser-based testing and automation

### MCP Configuration Location

MCP servers are configured in `.mcp.json` at the project root. This file is checked into version control so the entire team shares the same MCP setup.

**Note:** After any changes to `.mcp.json`, restart Cursor for changes to take effect.

## Available Skills

### dependencies

**Purpose:** Manage project dependencies

**Usage:**

- "Install dependencies"
- "Set up project packages"

**What it does:**

- Navigates to `apps/api`
- Runs `bun install`
- Verifies installation success
- Cross-platform (Unix/Mac/Windows)

**Script locations:**

- Unix/Mac: `.claude/skills/dependencies/scripts/install.sh`
- Windows: `.claude/skills/dependencies/scripts/install.ps1`

### check-envs

**Purpose:** Validate environment variables configuration

**Usage:**

- "Check environment variables"
- "Verify my .env file"
- "Are my environment variables set correctly?"

**What it does:**

- Reads `.env` file from project root
- Checks all required Cloudflare variables (CLOUDFLARE_API, CLOUDFLARE_ACCOUNT_ID)
- Checks optional Supabase variables (SUPABASE_URL, SUPABASE_ANON_KEY, etc.)
- Detects placeholder values that need to be replaced
- Provides detailed status report with color-coded output
- Shows setup instructions for missing variables
- Cross-platform (Unix/Mac/Windows)

**Script locations:**

- Unix/Mac: `.claude/skills/check-envs/scripts/check-envs.sh`
- Windows: `.claude/skills/check-envs/scripts/check-envs.ps1`

**Output:**

- ✅ Green: Variable is properly set
- ⚠️ Yellow: Placeholder value detected
- ❌ Red: Variable is missing

### deployment

**Purpose:** Unified deployment to Cloudflare Workers and/or Supabase Edge Functions with branch-based environments

**Usage:**

- "Deploy the API"
- "Deploy to Cloudflare"
- "Deploy to Supabase"
- "Deploy to both platforms"

**What it does:**

- Detects current git branch (main/master = production, others = preview)
- Prompts for platform selection (Cloudflare / Supabase / Both)
- Verifies platform-specific environment variables
- Deploys to selected platform(s):
  - **Cloudflare**: Branch-specific worker names (`api` or `api-<branch-name>`)
  - **Supabase**: Creates/uses preview branches with isolated databases
- Reports deployment URLs and branch-specific credentials info
- Cross-platform (Unix/Mac/Windows)

**Script locations:**

- Unix/Mac: `.claude/skills/deployment/scripts/deploy.sh`
- Windows: `.claude/skills/deployment/scripts/deploy.ps1`

**Deployment URLs:**

- **Cloudflare Production:** `https://api.<subdomain>.workers.dev`
- **Cloudflare Preview:** `https://api-<branch-name>.<subdomain>.workers.dev`
- **Supabase Production:** `https://<project-ref>.supabase.co/functions/v1/`
- **Supabase Preview:** `https://<branch-ref>.supabase.co/functions/v1/`

## Development Workflows

### Initial Setup

1. Install Bun: https://bun.sh
2. Clone the repository
3. Create `.env` file with Cloudflare and Supabase credentials (see Environment Configuration above)
4. Verify environment: Run check-envs skill
5. Install dependencies: Run dependencies skill or `cd apps/api && bun install`
6. Test locally: `cd apps/api && bun run dev`
7. Deploy: Run deployment skill or `cd apps/api && bun run deploy`

### Local Development

**Start dev server:**

```bash
cd apps/api
bun run dev
```

**Access:** http://localhost:8787

**Hot reload:** Enabled by default with Wrangler

### Deployment Process

**Manual deployment:**

```bash
cd apps/api
bun run deploy
```

**Using skill:**
Ask to "deploy the API" or "deploy to Cloudflare/Supabase"

**What happens:**

1. Environment variables loaded from `.env`
2. `CLOUDFLARE_API` mapped to `CLOUDFLARE_API_TOKEN`
3. Wrangler deploys with minification
4. Returns deployment URL and version ID

### Branch-Based Deployments

The deployment skill automatically detects your git branch and deploys to environment-specific resources:

**Branch Detection:**
| Branch | Environment |
|--------|-------------|
| `main` / `master` | Production |
| Any other branch | Preview |

**Cloudflare Workers:**

- Production: `https://api.*.workers.dev`
- Feature branch: `https://api-<branch-name>.*.workers.dev`
- Example: `feature/user-auth` → `api-feature-user-auth`

**Supabase Edge Functions:**

- Production: Deploys to main project
- Feature branch: Creates/uses Supabase preview branch with isolated database

### How Cloudflare Branching Works

Cloudflare Workers doesn't have native git branch support like some platforms. This project implements a **naming convention pattern** to simulate branch-based deployments.

**The Pattern:**
Each git branch deploys to a separate, independent Cloudflare Worker with a branch-derived name:

| Git Branch        | Worker Name         | URL                                                 |
| ----------------- | ------------------- | --------------------------------------------------- |
| `main` / `master` | `api`               | `https://api.<subdomain>.workers.dev`               |
| `test`            | `api-test`          | `https://api-test.<subdomain>.workers.dev`          |
| `feature/login`   | `api-feature-login` | `https://api-feature-login.<subdomain>.workers.dev` |
| `fix/bug-123`     | `api-fix-bug-123`   | `https://api-fix-bug-123.<subdomain>.workers.dev`   |

**Naming Rules:**

- Max 63 characters (DNS limit)
- Only lowercase alphanumeric and hyphens allowed
- Slashes (`/`) and underscores (`_`) converted to hyphens (`-`)
- Leading/trailing hyphens removed

**Key Characteristics:**

- **Completely independent**: Each worker is a separate deployment with its own URL, logs, and metrics
- **No automatic merging**: Deploying to `main` doesn't affect preview workers and vice versa
- **Manual cleanup required**: Preview workers persist until explicitly deleted
- **Separate configuration**: Each worker needs its own secrets/environment variables if different from production
- **Independent billing**: Each worker counts toward usage limits separately

### Finding Deployments in Cloudflare Console

**Workers & Pages Dashboard:**

```
https://dash.cloudflare.com/<ACCOUNT_ID>/workers-and-pages
```

**Direct link to specific worker:**

```
https://dash.cloudflare.com/<ACCOUNT_ID>/workers/services/view/<WORKER_NAME>
```

Examples:

- Production: `https://dash.cloudflare.com/<ACCOUNT_ID>/workers/services/view/api`
- Preview (test branch): `https://dash.cloudflare.com/<ACCOUNT_ID>/workers/services/view/api-test`

**Navigation Steps:**

1. Go to https://dash.cloudflare.com
2. Select your account
3. Click **Workers & Pages** in the left sidebar
4. All deployed workers are listed here (both production and preview)
5. Click on a worker name to view:
   - **Deployments**: Version history and rollback options
   - **Metrics**: Request counts, CPU time, errors
   - **Logs**: Real-time and historical logs
   - **Settings**: Environment variables, triggers, bindings

**Logs for specific worker:**

```
https://dash.cloudflare.com/<ACCOUNT_ID>/workers/services/view/<WORKER_NAME>/production/observability/logs
```

Replace `<ACCOUNT_ID>` with your `CLOUDFLARE_ACCOUNT_ID` from `.env`.

**Important - Supabase Branch Credentials:**
Supabase preview branches have their own API keys. When deploying to a feature branch:

1. The script prompts to create a Supabase preview branch if needed
2. After deployment, run: `supabase branches get <branch-name> --project-ref $SUPABASE_PROJECT_REF`
3. If your Cloudflare Worker connects to Supabase, update its secrets with branch credentials

**Cleanup:**

```bash
# Delete Cloudflare preview worker
wrangler delete --name api-feature-user-auth

# Delete Supabase preview branch
supabase branches delete feature-user-auth --project-ref $SUPABASE_PROJECT_REF
```

### Common Commands

```bash
# Install dependencies
bun install

# Run locally
bun run dev

# Deploy to Cloudflare
bun run deploy

# Generate Cloudflare type definitions
bun run cf-typegen

# Tail logs in real-time
wrangler tail
```

### Monitoring and Logs

The API has observability logging enabled via `wrangler.jsonc` configuration:

```json
"observability": {
  "logs": {
    "enabled": true,
    "invocation_logs": true
  }
}
```

**View logs in Cloudflare Dashboard:**
https://dash.cloudflare.com/{CLOUDFLARE_ACCOUNT_ID}/workers/services/view/api/production/observability/logs?workers-observability-view=events

Replace `{CLOUDFLARE_ACCOUNT_ID}` with your account ID from `.env`.

**View logs from CLI:**

```bash
cd apps/api
wrangler tail
```

This streams real-time logs including:

- Console output (`console.log`, `console.error`, etc.)
- Request details and response status codes
- Errors and exceptions
- Invocation timestamps

All `console.log()` statements in your worker code will appear in these logs.

## API Application (apps/api)

### Framework: Hono

The API uses Hono, a lightweight and ultrafast web framework designed for edge computing.

**Current endpoints:**

- `GET /` - Health check, returns "AI start!"
- `GET /db-test` - Tests Supabase connection and configuration

### Supabase Integration

The API includes Supabase client integration for database operations:

**Client Setup:** `apps/api/src/lib/supabase.ts`

- `createSupabaseClient()` - Creates client with anon key (respects RLS)
- `createSupabaseAdminClient()` - Creates client with service role key (bypasses RLS)

**Usage:**

```typescript
import { createSupabaseClient } from './lib/supabase';

app.get('/data', async (c) => {
  const supabase = createSupabaseClient(c.env);
  const { data, error } = await supabase.from('table').select('*');
  return c.json({ data, error });
});
```

**Environment Variables:**
The Cloudflare Worker expects these variables as bindings (set in .env, loaded during deployment):

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY` (optional, for admin operations)

### Resend Integration (Email)

The API includes Resend integration for sending transactional emails:

**Client Setup:** `apps/api/src/lib/resend.ts`

- `createResendClient()` - Creates a Resend client instance
- `sendEmail()` - Helper function to send emails with simplified options

**Usage:**

```typescript
import { createResendClient, sendEmail } from './lib/resend';

// Option 1: Using the client directly
app.post('/send-welcome', async (c) => {
  const resend = createResendClient(c.env);
  const { data, error } = await resend.emails.send({
    from: 'onboarding@resend.dev', // Use your verified domain in production
    to: 'user@example.com',
    subject: 'Welcome!',
    html: '<p>Welcome to our app!</p>',
  });
  return c.json({ data, error });
});

// Option 2: Using the helper function
app.post('/contact', async (c) => {
  const { error } = await sendEmail(c.env, {
    from: 'noreply@yourdomain.com',
    to: 'admin@yourdomain.com',
    subject: 'New Contact Form Submission',
    html: '<p>Someone contacted you!</p>',
  });

  if (error) {
    return c.json({ error: error.message }, 500);
  }
  return c.json({ success: true });
});
```

**Email Options:**

- `from` - Sender email (must be verified domain or `onboarding@resend.dev` for testing)
- `to` - Recipient email(s) (string or array)
- `subject` - Email subject line
- `html` - HTML content
- `text` - Plain text content (optional)
- `cc`, `bcc`, `replyTo` - Additional recipients

**Environment Variables:**

- `RESEND_KEY` - Your Resend API key (required)

**Testing:**
Use `onboarding@resend.dev` as the sender for development. For production, verify your domain at https://resend.com/domains.

### Configuration Files

**wrangler.jsonc:**

- Worker name: "api"
- Entry point: "src/index.ts"
- Compatibility date: "2026-01-16"
- Account ID: Loaded from `CLOUDFLARE_ACCOUNT_ID` env var

**package.json scripts:**

- `dev` - Start local development server
- `deploy` - Deploy to Cloudflare with minification
- `cf-typegen` - Generate TypeScript types for Cloudflare bindings

**tsconfig.json:**

- Target: ESNext
- Module resolution: Bundler
- Strict mode: Enabled
- Hono JSX support: Configured

## Code Standards and Conventions

### Git Hooks & Code Quality

This project enforces code quality through automated Git hooks powered by [Husky](https://typicode.github.io/husky/).

**Automated Checks:**

| Hook         | When                        | What it does                                    |
| ------------ | --------------------------- | ----------------------------------------------- |
| `pre-commit` | Before each commit          | Runs Prettier via lint-staged on staged files   |
| `commit-msg` | When writing commit message | Validates commit message format with commitlint |

**Commit Message Format (Conventional Commits):**

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>
```

**Allowed types:**

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, semicolons, etc.)
- `refactor` - Code refactoring (no functional changes)
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `build` - Build system or external dependencies
- `ci` - CI/CD configuration
- `chore` - Maintenance tasks
- `revert` - Reverting previous commits

**Commit Message Rules:**

- Type must be lowercase
- Subject must be lowercase
- Subject must not end with a period
- Header max length: 100 characters
- Body line max length: 100 characters

**Examples:**

```bash
# ✅ Good
git commit -m "feat: add user authentication"
git commit -m "fix(api): resolve database connection timeout"
git commit -m "docs: update README with deployment instructions"

# ❌ Bad (will be rejected)
git commit -m "fixed stuff"
git commit -m "WIP"
git commit -m "Update file"
```

**Code Formatting:**

Prettier is used for consistent code formatting. Configuration is in `.prettierrc`.

```bash
# Format all files
bun run format

# Check formatting (CI/CD)
bun run format:check
```

**Supported file types:** TypeScript, JavaScript, JSON, YAML, Markdown, CSS, HTML

**Configuration Files:**

- `.husky/pre-commit` - Pre-commit hook script
- `.husky/commit-msg` - Commit message validation hook
- `commitlint.config.js` - Commit message rules
- `lint-staged.config.js` - Staged files linting configuration
- `.prettierrc` - Prettier formatting rules
- `.prettierignore` - Files to exclude from formatting

**Bypassing Hooks (Emergency Only):**

```bash
git commit --no-verify -m "feat: emergency fix"
# or
HUSKY=0 git commit -m "feat: emergency fix"
```

### File Organization

- Keep related functionality together
- Use descriptive file and folder names
- Separate concerns (routes, middleware, utilities)

### TypeScript

- Strict mode enabled
- Use proper type definitions
- Leverage Cloudflare type generation

## Supabase Edge Functions (supabase/functions/)

### Runtime: Deno

Supabase Edge Functions run on Deno, a secure runtime for JavaScript and TypeScript.

**Current functions:**

- `hello-world` - Example function that returns a greeting
  - Supports GET and POST requests
  - Query parameter: `?name=YourName`
  - POST body: `{ "name": "YourName" }`
  - Returns: `{ message, timestamp, function, runtime }`

### Function Structure

Each function is in its own directory:

```
supabase/functions/
  └── function-name/
      └── index.ts
```

### Local Development

```bash
# Start Supabase locally (requires Docker)
supabase start

# Serve functions locally
supabase functions serve

# Test function
curl http://localhost:54321/functions/v1/hello-world?name=Claude
```

### Deployment

Functions are deployed via the unified deployment skill or manually:

```bash
# Deploy all functions
supabase functions deploy

# Deploy specific function
supabase functions deploy hello-world
```

### Configuration

**supabase/config.toml:**

- Deno version: 1.38.5
- Edge runtime settings
- Local development ports

### API Design

- RESTful conventions
- Clear endpoint naming
- Proper HTTP status codes
- Error handling middleware

## Common Issues and Solutions

### "wrangler: command not found"

- **Cause:** Dependencies not installed or wrangler not in PATH
- **Solution:** Run `bun install` in `apps/api` directory

### "Unable to authenticate request"

- **Cause:** Invalid or missing Cloudflare API token
- **Solution:** Verify `CLOUDFLARE_API` in `.env` is a valid API token with Workers Scripts > Edit permission

### "bun: command not found"

- **Cause:** Bun not installed
- **Solution:** Install from https://bun.sh

### MCP servers not available

- **Cause:** `.mcp.json` changes require restart
- **Solution:** Restart Cursor after modifying `.mcp.json`

### "supabase: command not found"

- **Cause:** Supabase CLI not installed
- **Solution:** Install via `npm install -g supabase` or `brew install supabase/tap/supabase`

### "Failed to link Supabase project"

- **Cause:** Not logged in or invalid project reference
- **Solution:**
  1. Run `supabase login` to authenticate
  2. Verify `SUPABASE_PROJECT_REF` in `.env` is correct
  3. Try manual linking: `supabase link --project-ref <your-ref>`

### Supabase connection fails in API

- **Cause:** Missing or incorrect environment variables
- **Solution:**
  1. Check `.env` has all Supabase variables
  2. For local dev, create `apps/api/.dev.vars` with Supabase credentials
  3. Test with `GET /db-test` endpoint

## Planning Features with plan.md

The `plan.md` file helps structure feature development before implementation. See the file for template and instructions.

## External Resources

- **Hono Documentation:** https://hono.dev
- **Cloudflare Workers Docs:** https://developers.cloudflare.com/workers
- **Wrangler CLI Reference:** https://developers.cloudflare.com/workers/wrangler
- **Supabase Documentation:** https://supabase.com/docs
- **Supabase Edge Functions:** https://supabase.com/docs/guides/functions
- **Supabase CLI Reference:** https://supabase.com/docs/reference/cli
- **Supabase JavaScript Client:** https://supabase.com/docs/reference/javascript
- **Bun Documentation:** https://bun.sh/docs
- **Cursor Documentation:** https://docs.cursor.com
- **MCP Documentation:** https://modelcontextprotocol.io
- **Resend Documentation:** https://resend.com/docs
- **Resend Node.js SDK:** https://resend.com/docs/sdks/node

## Notes for AI Agents

- Always check for `.env` file before deployment operations
- Use check-envs skill to verify environment configuration before deploying
- Use available skills (dependencies, check-envs, deployment) when relevant for better user experience
- The deployment skill supports multi-platform deployment (Cloudflare + Supabase) with automatic branch detection
- **Branch deployments**: Feature branches deploy to isolated environments (separate Cloudflare workers, Supabase preview branches)
- **Supabase branch credentials**: When deploying to a feature branch, remind users that Supabase preview branches have their own API keys
- Cross-platform compatibility is important - scripts support Unix/Mac/Windows
- Environment variables are read from `.env` at project root, not in `apps/api`
- The `CLOUDFLARE_API` variable must be mapped to `CLOUDFLARE_API_TOKEN` for Wrangler
- Supabase Edge Functions use Deno runtime, not Node.js
- For Supabase deployments, check if CLI is installed and user is logged in
- `SUPABASE_SERVICE_ROLE_KEY` is sensitive and bypasses RLS - handle with care
- MCP servers enhance capabilities but require restart after configuration changes
- This is a template project - structure will expand as more apps/packages are added
- The API (`apps/api`) can connect to Supabase database using the client in `src/lib/supabase.ts`
- **Resend email integration**: Use `apps/api/src/lib/resend.ts` for sending emails
- For testing emails, use `onboarding@resend.dev` as the sender (works without domain verification)
- For production emails, remind users to verify their domain at https://resend.com/domains
- `RESEND_KEY` is required for email functionality - check with check-envs skill

### Git Hooks & Commit Guidelines

- **Commit messages MUST follow Conventional Commits format** - the commit-msg hook will reject non-compliant messages
- When making commits on behalf of the user, ALWAYS use the proper format: `<type>(<scope>): <subject>`
- Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
- Subject must be lowercase and not end with a period
- Header max length is 100 characters
- **Pre-commit hook runs Prettier automatically** - code will be formatted before commit
- If a commit fails due to formatting, the hook will fix it automatically; the user just needs to re-stage and commit
- To bypass hooks in emergencies: `git commit --no-verify -m "type: message"` (not recommended)
- Run `bun run format` to format all files manually
- Run `bun run format:check` to check formatting without changes (useful for CI)
