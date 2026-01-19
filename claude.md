# Project Context for Claude Code

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
   claude.md                     # This file - Project context for Claude Code
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
   apps/
       api/                      # Main API application
           package.json          # Dependencies and scripts
           wrangler.jsonc        # Cloudflare Workers config
           tsconfig.json         # TypeScript configuration
           src/
               index.ts          # API entry point (Hono app)
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
- **Usage:** Enables Claude to interact with Supabase services

**2. Playwright MCP** (`playwright`)

- **Type:** stdio
- **Command:** `npx @playwright/mcp@latest`
- **Purpose:** Browser automation and testing
- **Usage:** Enables Claude to perform browser-based testing and automation

### MCP Configuration Location

MCP servers are configured in `.mcp.json` at the project root. This file is checked into version control so the entire team shares the same MCP setup.

**Note:** After any changes to `.mcp.json`, restart Claude Code for changes to take effect.

## Available Skills

### /dependencies

**Purpose:** Manage project dependencies

**Usage:**

- "Install dependencies"
- "Set up project packages"
- `/dependencies`

**What it does:**

- Navigates to `apps/api`
- Runs `bun install`
- Verifies installation success
- Cross-platform (Unix/Mac/Windows)

**Future:** Will support multiple apps, updates, audits, and adding/removing packages

### /check-envs

**Purpose:** Validate environment variables configuration

**Usage:**

- "Check environment variables"
- "Verify my .env file"
- "Are my environment variables set correctly?"
- `/check-envs`

**What it does:**

- Reads `.env` file from project root
- Checks all required Cloudflare variables (CLOUDFLARE_API, CLOUDFLARE_ACCOUNT_ID)
- Checks optional Supabase variables (SUPABASE_URL, SUPABASE_ANON_KEY, etc.)
- Detects placeholder values that need to be replaced
- Provides detailed status report with color-coded output
- Shows setup instructions for missing variables
- Cross-platform (Unix/Mac/Windows)

**When to use:**

- Before first deployment
- After updating .env file
- When troubleshooting deployment issues
- When onboarding new team members

**Output:**

- ✅ Green: Variable is properly set
- ⚠️ Yellow: Placeholder value detected
- ❌ Red: Variable is missing

**Future:** Format validation, configuration suggestions, multi-environment support

### /deployment

**Purpose:** Unified deployment to Cloudflare Workers and/or Supabase Edge Functions with branch-based environments

**Usage:**

- "Deploy the API"
- "Deploy to Cloudflare"
- "Deploy to Supabase"
- "Deploy to both platforms"
- `/deployment`

**What it does:**

- Detects current git branch (main/master = production, others = preview)
- Prompts for platform selection (Cloudflare / Supabase / Both)
- Verifies platform-specific environment variables
- Deploys to selected platform(s):
  - **Cloudflare**: Branch-specific worker names (`api` or `api-<branch-name>`)
  - **Supabase**: Creates/uses preview branches with isolated databases
- Reports deployment URLs and branch-specific credentials info
- Cross-platform (Unix/Mac/Windows)

**Deployment URLs:**

- **Cloudflare Production:** `https://api.<subdomain>.workers.dev`
- **Cloudflare Preview:** `https://api-<branch-name>.<subdomain>.workers.dev`
- **Supabase Production:** `https://<project-ref>.supabase.co/functions/v1/`
- **Supabase Preview:** `https://<branch-ref>.supabase.co/functions/v1/`

**Future:** Rollbacks, pre/post-deployment checks, secrets management

## Development Workflows

### Initial Setup

1. Install Bun: https://bun.sh
2. Clone the repository
3. Create `.env` file with Cloudflare and Supabase credentials (see Environment Configuration above)
4. Verify environment: `/check-envs`
5. Install dependencies: `/dependencies` or `cd apps/api && bun install`
6. Test locally: `cd apps/api && bun run dev`
7. Deploy: `/deployment` or `cd apps/api && bun run deploy`

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

```
/deployment
```

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
- **Solution:** Restart Claude Code after modifying `.mcp.json`

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
- **Claude Code Documentation:** https://docs.claude.com/en/docs/claude-code
- **MCP Documentation:** https://modelcontextprotocol.io

## Notes for AI Agents

- Always check for `.env` file before deployment operations
- Use `/check-envs` to verify environment configuration before deploying
- Use skills (`/dependencies`, `/check-envs`, `/deployment`) when available for better user experience
- The `/deployment` skill supports multi-platform deployment (Cloudflare + Supabase) with automatic branch detection
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

<!-- TRIGGER.DEV basic START -->

# Trigger.dev Basic Tasks (v4)

**MUST use `@trigger.dev/sdk`, NEVER `client.defineJob`**

## Basic Task

```ts
import { task } from '@trigger.dev/sdk';

export const processData = task({
  id: 'process-data',
  retry: {
    maxAttempts: 10,
    factor: 1.8,
    minTimeoutInMs: 500,
    maxTimeoutInMs: 30_000,
    randomize: false,
  },
  run: async (payload: { userId: string; data: any[] }) => {
    // Task logic - runs for long time, no timeouts
    console.log(`Processing ${payload.data.length} items for user ${payload.userId}`);
    return { processed: payload.data.length };
  },
});
```

## Schema Task (with validation)

```ts
import { schemaTask } from '@trigger.dev/sdk';
import { z } from 'zod';

export const validatedTask = schemaTask({
  id: 'validated-task',
  schema: z.object({
    name: z.string(),
    age: z.number(),
    email: z.string().email(),
  }),
  run: async (payload) => {
    // Payload is automatically validated and typed
    return { message: `Hello ${payload.name}, age ${payload.age}` };
  },
});
```

## Triggering Tasks

### From Backend Code

```ts
import { tasks } from '@trigger.dev/sdk';
import type { processData } from './trigger/tasks';

// Single trigger
const handle = await tasks.trigger<typeof processData>('process-data', {
  userId: '123',
  data: [{ id: 1 }, { id: 2 }],
});

// Batch trigger (up to 1,000 items, 3MB per payload)
const batchHandle = await tasks.batchTrigger<typeof processData>('process-data', [
  { payload: { userId: '123', data: [{ id: 1 }] } },
  { payload: { userId: '456', data: [{ id: 2 }] } },
]);
```

### Debounced Triggering

Consolidate multiple triggers into a single execution:

```ts
// Multiple rapid triggers with same key = single execution
await myTask.trigger(
  { userId: '123' },
  {
    debounce: {
      key: 'user-123-update', // Unique key for debounce group
      delay: '5s', // Wait before executing
    },
  }
);

// Trailing mode: use payload from LAST trigger
await myTask.trigger(
  { data: 'latest-value' },
  {
    debounce: {
      key: 'trailing-example',
      delay: '10s',
      mode: 'trailing', // Default is "leading" (first payload)
    },
  }
);
```

**Debounce modes:**

- `leading` (default): Uses payload from first trigger, subsequent triggers only reschedule
- `trailing`: Uses payload from most recent trigger

### From Inside Tasks (with Result handling)

```ts
export const parentTask = task({
  id: 'parent-task',
  run: async (payload) => {
    // Trigger and continue
    const handle = await childTask.trigger({ data: 'value' });

    // Trigger and wait - returns Result object, NOT task output
    const result = await childTask.triggerAndWait({ data: 'value' });
    if (result.ok) {
      console.log('Task output:', result.output); // Actual task return value
    } else {
      console.error('Task failed:', result.error);
    }

    // Quick unwrap (throws on error)
    const output = await childTask.triggerAndWait({ data: 'value' }).unwrap();

    // Batch trigger and wait
    const results = await childTask.batchTriggerAndWait([
      { payload: { data: 'item1' } },
      { payload: { data: 'item2' } },
    ]);

    for (const run of results) {
      if (run.ok) {
        console.log('Success:', run.output);
      } else {
        console.log('Failed:', run.error);
      }
    }
  },
});

export const childTask = task({
  id: 'child-task',
  run: async (payload: { data: string }) => {
    return { processed: payload.data };
  },
});
```

> Never wrap triggerAndWait or batchTriggerAndWait calls in a Promise.all or Promise.allSettled as this is not supported in Trigger.dev tasks.

## Waits

```ts
import { task, wait } from '@trigger.dev/sdk';

export const taskWithWaits = task({
  id: 'task-with-waits',
  run: async (payload) => {
    console.log('Starting task');

    // Wait for specific duration
    await wait.for({ seconds: 30 });
    await wait.for({ minutes: 5 });
    await wait.for({ hours: 1 });
    await wait.for({ days: 1 });

    // Wait until specific date
    await wait.until({ date: new Date('2024-12-25') });

    // Wait for token (from external system)
    await wait.forToken({
      token: 'user-approval-token',
      timeoutInSeconds: 3600, // 1 hour timeout
    });

    console.log('All waits completed');
    return { status: 'completed' };
  },
});
```

> Never wrap wait calls in a Promise.all or Promise.allSettled as this is not supported in Trigger.dev tasks.

## Key Points

- **Result vs Output**: `triggerAndWait()` returns a `Result` object with `ok`, `output`, `error` properties - NOT the direct task output
- **Type safety**: Use `import type` for task references when triggering from backend
- **Waits > 5 seconds**: Automatically checkpointed, don't count toward compute usage
- **Debounce + idempotency**: Idempotency keys take precedence over debounce settings

## NEVER Use (v2 deprecated)

```ts
// BREAKS APPLICATION
client.defineJob({
  id: 'job-id',
  run: async (payload, io) => {
    /* ... */
  },
});
```

Use SDK (`@trigger.dev/sdk`), check `result.ok` before accessing `result.output`

<!-- TRIGGER.DEV basic END -->

<!-- TRIGGER.DEV advanced-tasks START -->

# Trigger.dev Advanced Tasks (v4)

**Advanced patterns and features for writing tasks**

## Tags & Organization

```ts
import { task, tags } from '@trigger.dev/sdk';

export const processUser = task({
  id: 'process-user',
  run: async (payload: { userId: string; orgId: string }, { ctx }) => {
    // Add tags during execution
    await tags.add(`user_${payload.userId}`);
    await tags.add(`org_${payload.orgId}`);

    return { processed: true };
  },
});

// Trigger with tags
await processUser.trigger(
  { userId: '123', orgId: 'abc' },
  { tags: ['priority', 'user_123', 'org_abc'] } // Max 10 tags per run
);

// Subscribe to tagged runs
for await (const run of runs.subscribeToRunsWithTag('user_123')) {
  console.log(`User task ${run.id}: ${run.status}`);
}
```

**Tag Best Practices:**

- Use prefixes: `user_123`, `org_abc`, `video:456`
- Max 10 tags per run, 1-64 characters each
- Tags don't propagate to child tasks automatically

## Batch Triggering v2

Enhanced batch triggering with larger payloads and streaming ingestion.

### Limits

- **Maximum batch size**: 1,000 items (increased from 500)
- **Payload per item**: 3MB each (increased from 1MB combined)
- Payloads > 512KB automatically offload to object storage

### Rate Limiting (per environment)

| Tier  | Bucket Size | Refill Rate     |
| ----- | ----------- | --------------- |
| Free  | 1,200 runs  | 100 runs/10 sec |
| Hobby | 5,000 runs  | 500 runs/5 sec  |
| Pro   | 5,000 runs  | 500 runs/5 sec  |

### Concurrent Batch Processing

| Tier  | Concurrent Batches |
| ----- | ------------------ |
| Free  | 1                  |
| Hobby | 10                 |
| Pro   | 10                 |

### Usage

```ts
import { myTask } from './trigger/myTask';

// Basic batch trigger (up to 1,000 items)
const runs = await myTask.batchTrigger([
  { payload: { userId: 'user-1' } },
  { payload: { userId: 'user-2' } },
  { payload: { userId: 'user-3' } },
]);

// Batch trigger with wait
const results = await myTask.batchTriggerAndWait([
  { payload: { userId: 'user-1' } },
  { payload: { userId: 'user-2' } },
]);

for (const result of results) {
  if (result.ok) {
    console.log('Result:', result.output);
  }
}

// With per-item options
const batchHandle = await myTask.batchTrigger([
  {
    payload: { userId: '123' },
    options: {
      idempotencyKey: 'user-123-batch',
      tags: ['priority'],
    },
  },
  {
    payload: { userId: '456' },
    options: {
      idempotencyKey: 'user-456-batch',
    },
  },
]);
```

## Debouncing

Consolidate multiple triggers into a single execution by debouncing task runs with a unique key and delay window.

### Use Cases

- **User activity updates**: Batch rapid user actions into a single run
- **Webhook deduplication**: Handle webhook bursts without redundant processing
- **Search indexing**: Combine document updates instead of processing individually
- **Notification batching**: Group notifications to prevent user spam

### Basic Usage

```ts
await myTask.trigger(
  { userId: '123' },
  {
    debounce: {
      key: 'user-123-update', // Unique identifier for debounce group
      delay: '5s', // Wait duration ("5s", "1m", or milliseconds)
    },
  }
);
```

### Execution Modes

**Leading Mode** (default): Uses payload/options from the first trigger; subsequent triggers only reschedule execution time.

```ts
// First trigger sets the payload
await myTask.trigger(
  { action: 'first' },
  {
    debounce: { key: 'my-key', delay: '10s' },
  }
);

// Second trigger only reschedules - payload remains "first"
await myTask.trigger(
  { action: 'second' },
  {
    debounce: { key: 'my-key', delay: '10s' },
  }
);
// Task executes with { action: "first" }
```

**Trailing Mode**: Uses payload/options from the most recent trigger.

```ts
await myTask.trigger(
  { data: 'latest-value' },
  {
    debounce: {
      key: 'trailing-example',
      delay: '10s',
      mode: 'trailing',
    },
  }
);
```

In trailing mode, these options update with each trigger:

- `payload` — task input data
- `metadata` — run metadata
- `tags` — run tags (replaces existing)
- `maxAttempts` — retry attempts
- `maxDuration` — maximum compute time
- `machine` — machine preset

### Important Notes

- Idempotency keys take precedence over debounce settings
- Compatible with `triggerAndWait()` — parent runs block correctly on debounced execution
- Debounce key is scoped to the task

## Concurrency & Queues

```ts
import { task, queue } from '@trigger.dev/sdk';

// Shared queue for related tasks
const emailQueue = queue({
  name: 'email-processing',
  concurrencyLimit: 5, // Max 5 emails processing simultaneously
});

// Task-level concurrency
export const oneAtATime = task({
  id: 'sequential-task',
  queue: { concurrencyLimit: 1 }, // Process one at a time
  run: async (payload) => {
    // Critical section - only one instance runs
  },
});

// Per-user concurrency
export const processUserData = task({
  id: 'process-user-data',
  run: async (payload: { userId: string }) => {
    // Override queue with user-specific concurrency
    await childTask.trigger(payload, {
      queue: {
        name: `user-${payload.userId}`,
        concurrencyLimit: 2,
      },
    });
  },
});

export const emailTask = task({
  id: 'send-email',
  queue: emailQueue, // Use shared queue
  run: async (payload: { to: string }) => {
    // Send email logic
  },
});
```

## Error Handling & Retries

```ts
import { task, retry, AbortTaskRunError } from '@trigger.dev/sdk';

export const resilientTask = task({
  id: 'resilient-task',
  retry: {
    maxAttempts: 10,
    factor: 1.8, // Exponential backoff multiplier
    minTimeoutInMs: 500,
    maxTimeoutInMs: 30_000,
    randomize: false,
  },
  catchError: async ({ error, ctx }) => {
    // Custom error handling
    if (error.code === 'FATAL_ERROR') {
      throw new AbortTaskRunError('Cannot retry this error');
    }

    // Log error details
    console.error(`Task ${ctx.task.id} failed:`, error);

    // Allow retry by returning nothing
    return { retryAt: new Date(Date.now() + 60000) }; // Retry in 1 minute
  },
  run: async (payload) => {
    // Retry specific operations
    const result = await retry.onThrow(
      async () => {
        return await unstableApiCall(payload);
      },
      { maxAttempts: 3 }
    );

    // Conditional HTTP retries
    const response = await retry.fetch('https://api.example.com', {
      retry: {
        maxAttempts: 5,
        condition: (response, error) => {
          return response?.status === 429 || response?.status >= 500;
        },
      },
    });

    return result;
  },
});
```

## Machines & Performance

```ts
export const heavyTask = task({
  id: 'heavy-computation',
  machine: { preset: 'large-2x' }, // 8 vCPU, 16 GB RAM
  maxDuration: 1800, // 30 minutes timeout
  run: async (payload, { ctx }) => {
    // Resource-intensive computation
    if (ctx.machine.preset === 'large-2x') {
      // Use all available cores
      return await parallelProcessing(payload);
    }

    return await standardProcessing(payload);
  },
});

// Override machine when triggering
await heavyTask.trigger(payload, {
  machine: { preset: 'medium-1x' }, // Override for this run
});
```

**Machine Presets:**

- `micro`: 0.25 vCPU, 0.25 GB RAM
- `small-1x`: 0.5 vCPU, 0.5 GB RAM (default)
- `small-2x`: 1 vCPU, 1 GB RAM
- `medium-1x`: 1 vCPU, 2 GB RAM
- `medium-2x`: 2 vCPU, 4 GB RAM
- `large-1x`: 4 vCPU, 8 GB RAM
- `large-2x`: 8 vCPU, 16 GB RAM

## Idempotency

```ts
import { task, idempotencyKeys } from '@trigger.dev/sdk';

export const paymentTask = task({
  id: 'process-payment',
  retry: {
    maxAttempts: 3,
  },
  run: async (payload: { orderId: string; amount: number }) => {
    // Automatically scoped to this task run, so if the task is retried, the idempotency key will be the same
    const idempotencyKey = await idempotencyKeys.create(`payment-${payload.orderId}`);

    // Ensure payment is processed only once
    await chargeCustomer.trigger(payload, {
      idempotencyKey,
      idempotencyKeyTTL: '24h', // Key expires in 24 hours
    });
  },
});

// Payload-based idempotency
import { createHash } from 'node:crypto';

function createPayloadHash(payload: any): string {
  const hash = createHash('sha256');
  hash.update(JSON.stringify(payload));
  return hash.digest('hex');
}

export const deduplicatedTask = task({
  id: 'deduplicated-task',
  run: async (payload) => {
    const payloadHash = createPayloadHash(payload);
    const idempotencyKey = await idempotencyKeys.create(payloadHash);

    await processData.trigger(payload, { idempotencyKey });
  },
});
```

## Metadata & Progress Tracking

```ts
import { task, metadata } from '@trigger.dev/sdk';

export const batchProcessor = task({
  id: 'batch-processor',
  run: async (payload: { items: any[] }, { ctx }) => {
    const totalItems = payload.items.length;

    // Initialize progress metadata
    metadata
      .set('progress', 0)
      .set('totalItems', totalItems)
      .set('processedItems', 0)
      .set('status', 'starting');

    const results = [];

    for (let i = 0; i < payload.items.length; i++) {
      const item = payload.items[i];

      // Process item
      const result = await processItem(item);
      results.push(result);

      // Update progress
      const progress = ((i + 1) / totalItems) * 100;
      metadata
        .set('progress', progress)
        .increment('processedItems', 1)
        .append('logs', `Processed item ${i + 1}/${totalItems}`)
        .set('currentItem', item.id);
    }

    // Final status
    metadata.set('status', 'completed');

    return { results, totalProcessed: results.length };
  },
});

// Update parent metadata from child task
export const childTask = task({
  id: 'child-task',
  run: async (payload, { ctx }) => {
    // Update parent task metadata
    metadata.parent.set('childStatus', 'processing');
    metadata.root.increment('childrenCompleted', 1);

    return { processed: true };
  },
});
```

## Logging & Tracing

```ts
import { task, logger } from '@trigger.dev/sdk';

export const tracedTask = task({
  id: 'traced-task',
  run: async (payload, { ctx }) => {
    logger.info('Task started', { userId: payload.userId });

    // Custom trace with attributes
    const user = await logger.trace(
      'fetch-user',
      async (span) => {
        span.setAttribute('user.id', payload.userId);
        span.setAttribute('operation', 'database-fetch');

        const userData = await database.findUser(payload.userId);
        span.setAttribute('user.found', !!userData);

        return userData;
      },
      { userId: payload.userId }
    );

    logger.debug('User fetched', { user: user.id });

    try {
      const result = await processUser(user);
      logger.info('Processing completed', { result });
      return result;
    } catch (error) {
      logger.error('Processing failed', {
        error: error.message,
        userId: payload.userId,
      });
      throw error;
    }
  },
});
```

## Hidden Tasks

```ts
// Hidden task - not exported, only used internally
const internalProcessor = task({
  id: 'internal-processor',
  run: async (payload: { data: string }) => {
    return { processed: payload.data.toUpperCase() };
  },
});

// Public task that uses hidden task
export const publicWorkflow = task({
  id: 'public-workflow',
  run: async (payload: { input: string }) => {
    // Use hidden task internally
    const result = await internalProcessor.triggerAndWait({
      data: payload.input,
    });

    if (result.ok) {
      return { output: result.output.processed };
    }

    throw new Error('Internal processing failed');
  },
});
```

## Best Practices

- **Concurrency**: Use queues to prevent overwhelming external services
- **Retries**: Configure exponential backoff for transient failures
- **Idempotency**: Always use for payment/critical operations
- **Metadata**: Track progress for long-running tasks
- **Machines**: Match machine size to computational requirements
- **Tags**: Use consistent naming patterns for filtering
- **Debouncing**: Use for user activity, webhooks, and notification batching
- **Batch triggering**: Use for bulk operations up to 1,000 items
- **Error Handling**: Distinguish between retryable and fatal errors

Design tasks to be stateless, idempotent, and resilient to failures. Use metadata for state tracking and queues for resource management.

<!-- TRIGGER.DEV advanced-tasks END -->

<!-- TRIGGER.DEV config START -->

# Trigger.dev Configuration (v4)

**Complete guide to configuring `trigger.config.ts` with build extensions**

## Basic Configuration

```ts
import { defineConfig } from '@trigger.dev/sdk';

export default defineConfig({
  project: '<project-ref>', // Required: Your project reference
  dirs: ['./trigger'], // Task directories
  runtime: 'node', // "node", "node-22", or "bun"
  logLevel: 'info', // "debug", "info", "warn", "error"

  // Default retry settings
  retries: {
    enabledInDev: false,
    default: {
      maxAttempts: 3,
      minTimeoutInMs: 1000,
      maxTimeoutInMs: 10000,
      factor: 2,
      randomize: true,
    },
  },

  // Build configuration
  build: {
    autoDetectExternal: true,
    keepNames: true,
    minify: false,
    extensions: [], // Build extensions go here
  },

  // Global lifecycle hooks
  onStartAttempt: async ({ payload, ctx }) => {
    console.log('Global task start');
  },
  onSuccess: async ({ payload, output, ctx }) => {
    console.log('Global task success');
  },
  onFailure: async ({ payload, error, ctx }) => {
    console.log('Global task failure');
  },
});
```

## Build Extensions

### Database & ORM

#### Prisma

```ts
import { prismaExtension } from '@trigger.dev/build/extensions/prisma';

extensions: [
  prismaExtension({
    schema: 'prisma/schema.prisma',
    version: '5.19.0', // Optional: specify version
    migrate: true, // Run migrations during build
    directUrlEnvVarName: 'DIRECT_DATABASE_URL',
    typedSql: true, // Enable TypedSQL support
  }),
];
```

#### TypeScript Decorators (for TypeORM)

```ts
import { emitDecoratorMetadata } from '@trigger.dev/build/extensions/typescript';

extensions: [
  emitDecoratorMetadata(), // Enables decorator metadata
];
```

### Scripting Languages

#### Python

```ts
import { pythonExtension } from '@trigger.dev/build/extensions/python';

extensions: [
  pythonExtension({
    scripts: ['./python/**/*.py'], // Copy Python files
    requirementsFile: './requirements.txt', // Install packages
    devPythonBinaryPath: '.venv/bin/python', // Dev mode binary
  }),
];

// Usage in tasks
const result = await python.runInline(`print("Hello, world!")`);
const output = await python.runScript('./python/script.py', ['arg1']);
```

### Browser Automation

#### Playwright

```ts
import { playwright } from '@trigger.dev/build/extensions/playwright';

extensions: [
  playwright({
    browsers: ['chromium', 'firefox', 'webkit'], // Default: ["chromium"]
    headless: true, // Default: true
  }),
];
```

#### Puppeteer

```ts
import { puppeteer } from '@trigger.dev/build/extensions/puppeteer';

extensions: [puppeteer()];

// Environment variable needed:
// PUPPETEER_EXECUTABLE_PATH: "/usr/bin/google-chrome-stable"
```

#### Lightpanda

```ts
import { lightpanda } from '@trigger.dev/build/extensions/lightpanda';

extensions: [
  lightpanda({
    version: 'latest', // or "nightly"
    disableTelemetry: false,
  }),
];
```

### Media Processing

#### FFmpeg

```ts
import { ffmpeg } from '@trigger.dev/build/extensions/core';

extensions: [
  ffmpeg({ version: '7' }), // Static build, or omit for Debian version
];

// Automatically sets FFMPEG_PATH and FFPROBE_PATH
// Add fluent-ffmpeg to external packages if using
```

#### Audio Waveform

```ts
import { audioWaveform } from '@trigger.dev/build/extensions/audioWaveform';

extensions: [
  audioWaveform(), // Installs Audio Waveform 1.1.0
];
```

### System & Package Management

#### System Packages (apt-get)

```ts
import { aptGet } from '@trigger.dev/build/extensions/core';

extensions: [
  aptGet({
    packages: ['ffmpeg', 'imagemagick', 'curl=7.68.0-1'], // Can specify versions
  }),
];
```

#### Additional NPM Packages

Only use this for installing CLI tools, NOT packages you import in your code.

```ts
import { additionalPackages } from '@trigger.dev/build/extensions/core';

extensions: [
  additionalPackages({
    packages: ['wrangler'], // CLI tools and specific versions
  }),
];
```

#### Additional Files

```ts
import { additionalFiles } from '@trigger.dev/build/extensions/core';

extensions: [
  additionalFiles({
    files: ['wrangler.toml', './assets/**', './fonts/**'], // Glob patterns supported
  }),
];
```

### Environment & Build Tools

#### Environment Variable Sync

```ts
import { syncEnvVars } from '@trigger.dev/build/extensions/core';

extensions: [
  syncEnvVars(async (ctx) => {
    // ctx contains: environment, projectRef, env
    return [
      { name: 'SECRET_KEY', value: await getSecret(ctx.environment) },
      { name: 'API_URL', value: ctx.environment === 'prod' ? 'api.prod.com' : 'api.dev.com' },
    ];
  }),
];
```

#### ESBuild Plugins

```ts
import { esbuildPlugin } from '@trigger.dev/build/extensions';
import { sentryEsbuildPlugin } from '@sentry/esbuild-plugin';

extensions: [
  esbuildPlugin(
    sentryEsbuildPlugin({
      org: process.env.SENTRY_ORG,
      project: process.env.SENTRY_PROJECT,
      authToken: process.env.SENTRY_AUTH_TOKEN,
    }),
    { placement: 'last', target: 'deploy' } // Optional config
  ),
];
```

## Custom Build Extensions

```ts
import { defineConfig } from '@trigger.dev/sdk';

const customExtension = {
  name: 'my-custom-extension',

  externalsForTarget: (target) => {
    return ['some-native-module']; // Add external dependencies
  },

  onBuildStart: async (context) => {
    console.log(`Build starting for ${context.target}`);
    // Register esbuild plugins, modify build context
  },

  onBuildComplete: async (context, manifest) => {
    console.log('Build complete, adding layers');
    // Add build layers, modify deployment
    context.addLayer({
      id: 'my-layer',
      files: [{ source: './custom-file', destination: '/app/custom' }],
      commands: ['chmod +x /app/custom'],
    });
  },
};

export default defineConfig({
  project: 'my-project',
  build: {
    extensions: [customExtension],
  },
});
```

## Advanced Configuration

### Telemetry

```ts
import { PrismaInstrumentation } from '@prisma/instrumentation';
import { OpenAIInstrumentation } from '@langfuse/openai';

export default defineConfig({
  // ... other config
  telemetry: {
    instrumentations: [new PrismaInstrumentation(), new OpenAIInstrumentation()],
    exporters: [customExporter], // Optional custom exporters
  },
});
```

### Machine & Performance

```ts
export default defineConfig({
  // ... other config
  defaultMachine: 'large-1x', // Default machine for all tasks
  maxDuration: 300, // Default max duration (seconds)
  enableConsoleLogging: true, // Console logging in development
});
```

## Common Extension Combinations

### Full-Stack Web App

```ts
extensions: [
  prismaExtension({ schema: 'prisma/schema.prisma', migrate: true }),
  additionalFiles({ files: ['./public/**', './assets/**'] }),
  syncEnvVars(async (ctx) => [...envVars]),
];
```

### AI/ML Processing

```ts
extensions: [
  pythonExtension({
    scripts: ['./ai/**/*.py'],
    requirementsFile: './requirements.txt',
  }),
  ffmpeg({ version: '7' }),
  additionalPackages({ packages: ['wrangler'] }),
];
```

### Web Scraping

```ts
extensions: [
  playwright({ browsers: ['chromium'] }),
  puppeteer(),
  additionalFiles({ files: ['./selectors.json', './proxies.txt'] }),
];
```

## Best Practices

- **Use specific versions**: Pin extension versions for reproducible builds
- **External packages**: Add modules with native addons to the `build.external` array
- **Environment sync**: Use `syncEnvVars` for dynamic secrets
- **File paths**: Use glob patterns for flexible file inclusion
- **Debug builds**: Use `--log-level debug --dry-run` for troubleshooting

Extensions only affect deployment, not local development. Use `external` array for packages that shouldn't be bundled.

<!-- TRIGGER.DEV config END -->

<!-- TRIGGER.DEV scheduled-tasks START -->

# Scheduled tasks (cron)

Recurring tasks using cron. For one-off future runs, use the **delay** option.

## Define a scheduled task

```ts
import { schedules } from '@trigger.dev/sdk';

export const task = schedules.task({
  id: 'first-scheduled-task',
  run: async (payload) => {
    payload.timestamp; // Date (scheduled time, UTC)
    payload.lastTimestamp; // Date | undefined
    payload.timezone; // IANA, e.g. "America/New_York" (default "UTC")
    payload.scheduleId; // string
    payload.externalId; // string | undefined
    payload.upcoming; // Date[]

    payload.timestamp.toLocaleString('en-US', { timeZone: payload.timezone });
  },
});
```

> Scheduled tasks need at least one schedule attached to run.

## Attach schedules

**Declarative (sync on dev/deploy):**

```ts
schedules.task({
  id: 'every-2h',
  cron: '0 */2 * * *', // UTC
  run: async () => {},
});

schedules.task({
  id: 'tokyo-5am',
  cron: { pattern: '0 5 * * *', timezone: 'Asia/Tokyo', environments: ['PRODUCTION', 'STAGING'] },
  run: async () => {},
});
```

**Imperative (SDK or dashboard):**

```ts
await schedules.create({
  task: task.id,
  cron: '0 0 * * *',
  timezone: 'America/New_York', // DST-aware
  externalId: 'user_123',
  deduplicationKey: 'user_123-daily', // updates if reused
});
```

### Dynamic / multi-tenant example

```ts
// /trigger/reminder.ts
export const reminderTask = schedules.task({
  id: 'todo-reminder',
  run: async (p) => {
    if (!p.externalId) throw new Error('externalId is required');
    const user = await db.getUser(p.externalId);
    await sendReminderEmail(user);
  },
});
```

```ts
// app/reminders/route.ts
export async function POST(req: Request) {
  const data = await req.json();
  return Response.json(
    await schedules.create({
      task: reminderTask.id,
      cron: '0 8 * * *',
      timezone: data.timezone,
      externalId: data.userId,
      deduplicationKey: `${data.userId}-reminder`,
    })
  );
}
```

## Cron syntax (no seconds)

```
* * * * *
| | | | └ day of week (0–7 or 1L–7L; 0/7=Sun; L=last)
| | | └── month (1–12)
| | └──── day of month (1–31 or L)
| └────── hour (0–23)
└──────── minute (0–59)
```

## When schedules won't trigger

- **Dev:** only when the dev CLI is running.
- **Staging/Production:** only for tasks in the **latest deployment**.

## SDK management (quick refs)

```ts
await schedules.retrieve(id);
await schedules.list();
await schedules.update(id, { cron: '0 0 1 * *', externalId: 'ext', deduplicationKey: 'key' });
await schedules.deactivate(id);
await schedules.activate(id);
await schedules.del(id);
await schedules.timezones(); // list of IANA timezones
```

## Dashboard

Create/attach schedules visually (Task, Cron pattern, Timezone, Optional: External ID, Dedup key, Environments). Test scheduled tasks from the **Test** page.

<!-- TRIGGER.DEV scheduled-tasks END -->

<!-- TRIGGER.DEV realtime START -->

# Trigger.dev Realtime (v4)

**Real-time monitoring and updates for runs**

## Core Concepts

Realtime allows you to:

- Subscribe to run status changes, metadata updates, and streams
- Build real-time dashboards and UI updates
- Monitor task progress from frontend and backend

## Authentication

### Public Access Tokens

```ts
import { auth } from '@trigger.dev/sdk';

// Read-only token for specific runs
const publicToken = await auth.createPublicToken({
  scopes: {
    read: {
      runs: ['run_123', 'run_456'],
      tasks: ['my-task-1', 'my-task-2'],
    },
  },
  expirationTime: '1h', // Default: 15 minutes
});
```

### Trigger Tokens (Frontend only)

```ts
// Single-use token for triggering tasks
const triggerToken = await auth.createTriggerPublicToken('my-task', {
  expirationTime: '30m',
});
```

## Backend Usage

### Subscribe to Runs

```ts
import { runs, tasks } from '@trigger.dev/sdk';

// Trigger and subscribe
const handle = await tasks.trigger('my-task', { data: 'value' });

// Subscribe to specific run
for await (const run of runs.subscribeToRun<typeof myTask>(handle.id)) {
  console.log(`Status: ${run.status}, Progress: ${run.metadata?.progress}`);
  if (run.status === 'COMPLETED') break;
}

// Subscribe to runs with tag
for await (const run of runs.subscribeToRunsWithTag('user-123')) {
  console.log(`Tagged run ${run.id}: ${run.status}`);
}

// Subscribe to batch
for await (const run of runs.subscribeToBatch(batchId)) {
  console.log(`Batch run ${run.id}: ${run.status}`);
}
```

### Realtime Streams v2 (Recommended)

```ts
import { streams, InferStreamType } from '@trigger.dev/sdk';

// 1. Define streams (shared location)
export const aiStream = streams.define<string>({
  id: 'ai-output',
});

export type AIStreamPart = InferStreamType<typeof aiStream>;

// 2. Pipe from task
export const streamingTask = task({
  id: 'streaming-task',
  run: async (payload) => {
    const completion = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [{ role: 'user', content: payload.prompt }],
      stream: true,
    });

    const { waitUntilComplete } = aiStream.pipe(completion);
    await waitUntilComplete();
  },
});

// 3. Read from backend
const stream = await aiStream.read(runId, {
  timeoutInSeconds: 300,
  startIndex: 0, // Resume from specific chunk
});

for await (const chunk of stream) {
  console.log('Chunk:', chunk); // Fully typed
}
```

Enable v2 by upgrading to 4.1.0 or later.

## React Frontend Usage

### Installation

```bash
npm add @trigger.dev/react-hooks
```

### Triggering Tasks

```tsx
'use client';
import { useTaskTrigger, useRealtimeTaskTrigger } from '@trigger.dev/react-hooks';
import type { myTask } from '../trigger/tasks';

function TriggerComponent({ accessToken }: { accessToken: string }) {
  // Basic trigger
  const { submit, handle, isLoading } = useTaskTrigger<typeof myTask>('my-task', {
    accessToken,
  });

  // Trigger with realtime updates
  const {
    submit: realtimeSubmit,
    run,
    isLoading: isRealtimeLoading,
  } = useRealtimeTaskTrigger<typeof myTask>('my-task', { accessToken });

  return (
    <div>
      <button onClick={() => submit({ data: 'value' })} disabled={isLoading}>
        Trigger Task
      </button>

      <button onClick={() => realtimeSubmit({ data: 'realtime' })} disabled={isRealtimeLoading}>
        Trigger with Realtime
      </button>

      {run && <div>Status: {run.status}</div>}
    </div>
  );
}
```

### Subscribing to Runs

```tsx
'use client';
import { useRealtimeRun, useRealtimeRunsWithTag } from '@trigger.dev/react-hooks';
import type { myTask } from '../trigger/tasks';

function SubscribeComponent({ runId, accessToken }: { runId: string; accessToken: string }) {
  // Subscribe to specific run
  const { run, error } = useRealtimeRun<typeof myTask>(runId, {
    accessToken,
    onComplete: (run) => {
      console.log('Task completed:', run.output);
    },
  });

  // Subscribe to tagged runs
  const { runs } = useRealtimeRunsWithTag('user-123', { accessToken });

  if (error) return <div>Error: {error.message}</div>;
  if (!run) return <div>Loading...</div>;

  return (
    <div>
      <div>Status: {run.status}</div>
      <div>Progress: {run.metadata?.progress || 0}%</div>
      {run.output && <div>Result: {JSON.stringify(run.output)}</div>}

      <h3>Tagged Runs:</h3>
      {runs.map((r) => (
        <div key={r.id}>
          {r.id}: {r.status}
        </div>
      ))}
    </div>
  );
}
```

### Realtime Streams with React

```tsx
'use client';
import { useRealtimeStream } from '@trigger.dev/react-hooks';
import { aiStream } from '../trigger/streams';

function StreamComponent({ runId, accessToken }: { runId: string; accessToken: string }) {
  // Pass defined stream directly for type safety
  const { parts, error } = useRealtimeStream(aiStream, runId, {
    accessToken,
    timeoutInSeconds: 300,
    throttleInMs: 50, // Control re-render frequency
  });

  if (error) return <div>Error: {error.message}</div>;
  if (!parts) return <div>Loading...</div>;

  const text = parts.join(''); // parts is typed as AIStreamPart[]

  return <div>Streamed Text: {text}</div>;
}
```

### Wait Tokens

```tsx
'use client';
import { useWaitToken } from '@trigger.dev/react-hooks';

function WaitTokenComponent({ tokenId, accessToken }: { tokenId: string; accessToken: string }) {
  const { complete } = useWaitToken(tokenId, { accessToken });

  return <button onClick={() => complete({ approved: true })}>Approve Task</button>;
}
```

### SWR Hooks (Fetch Once)

```tsx
'use client';
import { useRun } from '@trigger.dev/react-hooks';
import type { myTask } from '../trigger/tasks';

function SWRComponent({ runId, accessToken }: { runId: string; accessToken: string }) {
  const { run, error, isLoading } = useRun<typeof myTask>(runId, {
    accessToken,
    refreshInterval: 0, // Disable polling (recommended)
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return <div>Run: {run?.status}</div>;
}
```

## Run Object Properties

Key properties available in run subscriptions:

- `id`: Unique run identifier
- `status`: `QUEUED`, `EXECUTING`, `COMPLETED`, `FAILED`, `CANCELED`, etc.
- `payload`: Task input data (typed)
- `output`: Task result (typed, when completed)
- `metadata`: Real-time updatable data
- `createdAt`, `updatedAt`: Timestamps
- `costInCents`: Execution cost

## Best Practices

- **Use Realtime over SWR**: Recommended for most use cases due to rate limits
- **Scope tokens properly**: Only grant necessary read/trigger permissions
- **Handle errors**: Always check for errors in hooks and subscriptions
- **Type safety**: Use task types for proper payload/output typing
- **Cleanup subscriptions**: Backend subscriptions auto-complete, frontend hooks auto-cleanup

<!-- TRIGGER.DEV realtime END -->
