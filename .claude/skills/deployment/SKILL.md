---
name: deployment
description: Deploy applications to Cloudflare Workers and/or Supabase Edge Functions. Supports unified multi-platform deployment. Use when deploying to production, publishing APIs/functions, or when user requests deployment.
allowed-tools:
  - Bash
  - Read
user-invocable: true
---

# Unified Deployment Skill

This skill handles deployment to multiple platforms:
- **Cloudflare Workers**: API application (Hono) deployment via Wrangler
- **Supabase Edge Functions**: Serverless functions (Deno) deployment via Supabase CLI
- **Both**: Deploy to both platforms simultaneously

## Pre-deployment Checklist

### For Cloudflare Workers
Before deploying to Cloudflare, verify:
1. Environment variables in .env:
   - `CLOUDFLARE_API` (API token)
   - `CLOUDFLARE_ACCOUNT_ID` (Account ID)
2. `wrangler.jsonc` configuration is valid
3. Dependencies installed in `apps/api` (`bun install`)
4. Bun is installed

### For Supabase Edge Functions
Before deploying to Supabase, verify:
1. Environment variables in .env:
   - `SUPABASE_URL` (Project URL)
   - `SUPABASE_PROJECT_REF` (Project reference ID)
2. Supabase CLI is installed (`npm install -g supabase` or `brew install supabase/tap/supabase`)
3. Logged into Supabase CLI (`supabase login`)
4. Project is linked (script will attempt to link automatically)
5. Functions exist in `supabase/functions/` directory

## Deployment Process

### Step 1: Environment Verification
- Read the .env file from project root to verify credentials exist
- Check platform-specific environment variables based on deployment target

### Step 2: Execute Deployment Script

The unified deployment script supports interactive platform selection.

Choose the appropriate script based on the user's platform:

**For Unix/Mac/Linux:**
```bash
.claude/skills/deployment/scripts/deploy.sh
```

**For Windows PowerShell:**
```powershell
.claude/skills/deployment/scripts/deploy.ps1
```

**Automated Deployment (Non-interactive):**
Set `DEPLOY_TARGET` environment variable to skip interactive prompt:
```bash
# Deploy to Cloudflare only
DEPLOY_TARGET=cloudflare .claude/skills/deployment/scripts/deploy.sh

# Deploy to Supabase only
DEPLOY_TARGET=supabase .claude/skills/deployment/scripts/deploy.sh

# Deploy to both platforms
DEPLOY_TARGET=both .claude/skills/deployment/scripts/deploy.sh
```

### Step 3: Platform Selection

If running interactively, the script will prompt:
```
Select deployment platform:
  1) Cloudflare Workers
  2) Supabase Edge Functions
  3) Both platforms

Enter choice [1-3]:
```

### Step 4: Deployment Execution

**Cloudflare Workers:**
- Navigate to `apps/api` directory
- Execute `bun run deploy`
- Deploy with Wrangler and minification
- Return deployment URL (format: `https://api.*.workers.dev`)

**Supabase Edge Functions:**
- Navigate to project root
- Link project if not already linked
- Execute `supabase functions deploy`
- Deploy all functions in `supabase/functions/`
- Return functions URL (format: `https://<ref>.supabase.co/functions/v1/`)

### Step 5: Verify Deployment Success
- Check the output for success messages
- Display deployment URLs for each platform
- Show deployment summary
- Report any errors encountered

## Error Handling

### Cloudflare Workers Errors

- **Missing .env file**: Prompt user to create `.env` with required Cloudflare variables
- **Invalid API token**: Direct user to https://dash.cloudflare.com/profile/api-tokens
  - Token needs "Workers Scripts > Edit" permission
- **Wrangler errors**: Display full error and check:
  - API token permissions
  - Account ID is correct
  - Network connectivity
- **Bun not found**: Install from https://bun.sh
- **node_modules missing**: Run `bun install` in `apps/api`

### Supabase Edge Functions Errors

- **Supabase CLI not installed**: Install via:
  - `npm install -g supabase`
  - `brew install supabase/tap/supabase` (Mac)
  - `scoop install supabase` (Windows with Scoop)
- **Not logged in**: Run `supabase login` to authenticate
- **Project not linked**: Script will attempt auto-linking with `SUPABASE_PROJECT_REF`
  - If fails, run manually: `supabase link --project-ref <ref>`
- **Missing SUPABASE_PROJECT_REF**: Add to .env file
- **Functions directory not found**: Ensure `supabase/functions/` exists with function subdirectories

## Environment Variables Reference

### Cloudflare Workers
```bash
CLOUDFLARE_API="your-api-token"
CLOUDFLARE_ACCOUNT_ID="your-account-id"
```

### Supabase Edge Functions
```bash
SUPABASE_URL="https://your-ref.supabase.co"
SUPABASE_PROJECT_REF="your-ref"
SUPABASE_ANON_KEY="your-anon-key"  # Optional, for API integration
SUPABASE_SERVICE_ROLE_KEY="your-service-key"  # Optional, for admin operations
```

## Safety Guidelines

- Always verify environment variables before deploying
- Show user what platform(s) will be deployed to
- Report deployment URLs after successful deploy
- Keep .env file secure and never commit it
- Supabase service role keys should NEVER be exposed publicly
- Test locally before deploying to production

## Available Endpoints After Deployment

### Cloudflare Workers API
- **Base URL**: `https://api.*.workers.dev`
- **Health Check**: `GET /`
- **Database Test**: `GET /db-test` (tests Supabase connection)

### Supabase Edge Functions
- **Base URL**: `https://<ref>.supabase.co/functions/v1`
- **Hello World**: `GET /hello-world` or `POST /hello-world`

## Future Enhancements

This skill will be expanded to include:
- Multi-environment deployments (development, staging, production)
- Environment-specific configurations
- Rollback functionality
- Pre-deployment tests
- Post-deployment verification and health checks
- Secrets management improvements
- CI/CD integration examples
