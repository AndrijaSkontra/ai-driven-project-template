---
name: deployment
description: Deploy the API application to Cloudflare Workers using Wrangler. Use when deploying to production, publishing the API, or when user requests deployment.
allowed-tools:
  - Bash
  - Read
user-invocable: true
---

# Cloudflare Workers Deployment Skill

This skill handles deployment of the API to Cloudflare Workers using Wrangler.

## Pre-deployment Checklist

Before deploying, verify:
1. Environment variables are properly configured in .env
2. CLOUDFLARE_API_TOKEN is set
3. CLOUDFLARE_ACCOUNT_ID is set
4. wrangler.jsonc configuration is valid

## Deployment Process

### Step 1: Environment Verification
- Read the .env file from project root to verify credentials exist
- Check that both CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID are present

### Step 2: Execute Deployment Script

Choose the appropriate script based on the user's platform:

**For Unix/Mac/Linux:**
```bash
.claude/skills/deployment/scripts/deploy.sh
```

**For Windows PowerShell:**
```powershell
.claude/skills/deployment/scripts/deploy.ps1
```

The script will:
- Navigate to the apps/api directory
- Execute `bun run deploy`
- Return deployment results

### Step 3: Verify Deployment Success
- Check the output for success message
- Look for the deployment URL (should be in format: https://api.*.workers.dev)
- Report the Version ID if available
- Display any errors to the user

## Error Handling

Handle these common errors:

- **Missing .env file**: Prompt user to create environment file with required variables
- **Invalid API token**: Request user to check Cloudflare credentials at https://dash.cloudflare.com/profile/api-tokens
- **Wrangler errors**: Display full error message and suggest checking:
  - API token permissions (needs Workers Scripts Edit permission)
  - Account ID is correct
  - Network connectivity
- **Command not found**: Verify bun is installed and dependencies are installed in apps/api

## Safety Guidelines

- Always verify environment variables before deploying
- Show user what's being deployed
- Report deployment URL after successful deploy
- Keep .env file secure and never commit it

## Future Enhancements

This skill will be expanded to include:
- Multi-environment deployments (staging, production)
- Rollback functionality
- Pre-deployment tests
- Post-deployment verification
