# AI-Driven Project Template

A template for AI-driven application development.

## Supported AI Agents

This template currently supports the following AI agents:

- **Cursor** - AI-powered code editor
- **Claude Code** - Anthropic's official CLI for Claude

## Getting Started

### First Steps: Planning Your Features

Before diving into code, we recommend using the `plan.md` file to structure your feature development:

1. **Open `plan.md`** in the project root
2. **Copy the template** for your new feature
3. **Fill in the sections** with your requirements and approach
4. **Share with AI agents** (Claude Code, Cursor) for better assistance

The planning template helps you:
- Break down complex features into manageable tasks
- Document architecture decisions
- Maintain context across development sessions
- Get better AI assistance by providing clear context

**Example:** Tell Claude Code "Read plan.md and help me implement the authentication feature"

### Prerequisites

Before you begin, ensure you have the following installed:

- **[Bun](https://bun.sh)** - JavaScript runtime and package manager (required)
- **[Cloudflare Account](https://dash.cloudflare.com/sign-up)** - For deploying to Cloudflare Workers (required)
- **[Supabase Account](https://supabase.com)** - For database and edge functions (optional)
- **[Supabase CLI](https://supabase.com/docs/guides/cli)** - Required for deploying Edge Functions (optional, see installation instructions below)

### Cloudflare Setup

To deploy your API to Cloudflare Workers, you'll need to configure your Cloudflare credentials:

#### 1. Create a Cloudflare Account

If you don't have one already, sign up at [https://dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)

#### 2. Get Your Account ID

1. Log in to your [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Navigate to **Workers & Pages** in the left sidebar
3. Your **Account ID** will be displayed in the right sidebar
4. Copy this ID for the next step

#### 3. Generate an API Token

1. Go to [https://dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens)
2. Click **"Create Token"**
3. Use the **"Edit Cloudflare Workers"** template
4. Ensure the token has the following permissions:
   - Account > **Workers Scripts** > **Edit**
   - Account > **Account Settings** > **Read**
5. Click **"Continue to summary"** then **"Create Token"**
6. **Copy the token immediately** (you won't be able to see it again)

#### 4. Configure Environment Variables

Create a `.env` file in the project root directory with your Cloudflare credentials:

```bash
CLOUDFLARE_API=your_api_token_here
CLOUDFLARE_ACCOUNT_ID=your_account_id_here
```

**Important:** Never commit the `.env` file to version control. It's already included in `.gitignore`.

### Supabase Setup (Optional)

If you want to use Supabase for database and edge functions:

#### 1. Create a Supabase Project

1. Sign up or log in at [https://supabase.com](https://supabase.com)
2. Create a new project
3. Wait for the project to finish setting up

#### 2. Get Your Supabase Credentials

1. Go to your [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Navigate to **Settings** > **API**
4. Copy the following:
   - **Project URL** (e.g., `https://abcdefg.supabase.co`)
   - **Project Reference** (the short ID, e.g., `abcdefg`)
   - **anon public** key (safe for client-side use)
   - **service_role** key (server-only, keep secure!)

#### 3. Add to Environment Variables

Add the following to your `.env` file:

```bash
# Supabase Configuration
SUPABASE_URL=your_project_url_here
SUPABASE_PROJECT_REF=your_project_ref_here
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

**Security Note:** The service role key bypasses Row Level Security (RLS). Never expose it in client-side code.

#### 4. Install Supabase CLI (Required for Edge Functions Deployment)

**⚠️ Important:** The Supabase CLI is **required** if you want to deploy Supabase Edge Functions. Without it, you can still use Supabase database in your Cloudflare Workers API, but you won't be able to deploy the serverless functions.

**Installation Options:**

**macOS (Homebrew - Recommended):**
```bash
brew install supabase/tap/supabase
```

**Windows (Scoop):**
```bash
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase
```

**Cross-platform (npm/npx):**
```bash
# Install globally
npm install -g supabase

# Or use via npx (no installation required)
npx supabase [command]
```

**Linux:**
```bash
# Download the latest release
curl -L https://github.com/supabase/cli/releases/latest/download/supabase_linux_amd64.tar.gz -o supabase.tar.gz

# Extract and install
tar -xzf supabase.tar.gz
sudo mv supabase /usr/local/bin/supabase
```

**Verify Installation:**
```bash
supabase --version
```

#### 5. Authenticate with Supabase CLI

After installing the CLI, authenticate with your Supabase account:

```bash
supabase login
```

This will open a browser for authentication. Complete the login process to link your CLI with your Supabase account.

#### 6. Install Dependencies

```bash
cd apps/api
bun install
```

Or use the Claude Code dependencies skill:
```bash
/dependencies
```

#### 7. Verify Environment Configuration (Recommended)

Before deploying, verify that all environment variables are correctly configured:

```bash
/check-envs
```

This will check your `.env` file and report:
- ✅ Which variables are properly configured
- ⚠️  Which variables have placeholder values that need updating
- ❌ Which required variables are missing

**Example output:**
```
╔═══════════════════════════════════════════╗
║   Environment Variables Check             ║
╚═══════════════════════════════════════════╝

Cloudflare Workers (Required)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ CLOUDFLARE_API: Set
✅ CLOUDFLARE_ACCOUNT_ID: Set

Supabase (Optional)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SUPABASE_URL: Set
✅ SUPABASE_ANON_KEY: Set
✅ SUPABASE_SERVICE_ROLE_KEY: Set
✅ SUPABASE_PROJECT_REF: Set

Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Required variables: 2/2 configured
ℹ️  Optional variables: 4/4 configured

✅ Environment configuration is valid for deployment!
```

#### 8. Deploy Your Applications

##### Deploy to Cloudflare Workers

**Manual deployment:**
```bash
cd apps/api
bun run deploy
```

**Using Claude Code deployment skill:**
```bash
/deployment
```
Then select "Cloudflare Workers" from the menu.

Your API will be deployed to: `https://api.<your-subdomain>.workers.dev`

##### Deploy to Supabase Edge Functions (If Configured)

**⚠️ Prerequisites:**
- Supabase CLI must be installed (see step 4 above)
- You must be authenticated (`supabase login`)
- Environment variables must be configured in `.env`

**Manual deployment:**
```bash
supabase functions deploy
```

**Using Claude Code deployment skill:**
```bash
/deployment
```
Then select "Supabase Edge Functions" from the menu.

**Note:** If Supabase CLI is not installed, the deployment will skip Supabase and only deploy to Cloudflare Workers.

Your functions will be available at: `https://<your-ref>.supabase.co/functions/v1/`

##### Deploy to Both Platforms

The deployment skill supports deploying to both platforms simultaneously:
```bash
/deployment
```
Then select "Both platforms" from the menu.

### Monitoring and Logs

The API has observability logging enabled, which captures all console output and request details.

**View logs in Cloudflare Dashboard:**

Navigate to:
```
https://dash.cloudflare.com/{YOUR_ACCOUNT_ID}/workers/services/view/api/production/observability/logs?workers-observability-view=events
```

Replace `{YOUR_ACCOUNT_ID}` with your Cloudflare Account ID from the `.env` file.

**Or view logs from the command line:**

```bash
cd apps/api
wrangler tail
```

This will stream real-time logs including:
- Console output (`console.log`, `console.error`, etc.)
- Request/response details
- Errors and exceptions
- Timestamps

**Quick access:** After deployment, you can also find the logs by going to your Cloudflare Dashboard > Workers & Pages > api > Logs tab.

### Local Development

To run the API locally:

```bash
cd apps/api
bun run dev
```

The API will be available at `http://localhost:8787`

## MCP Server Configuration

This project uses [Model Context Protocol (MCP)](https://modelcontextprotocol.io) servers to enhance AI agent capabilities.

### Configured MCP Servers

The following MCP servers are pre-configured in `.mcp.json`:

#### 1. Supabase MCP
- **Purpose:** Database and backend services integration
- **Type:** HTTP server
- **URL:** `https://mcp.supabase.com/mcp`
- **Enables:** Claude to interact with Supabase services, manage databases, auth, and storage

#### 2. Playwright MCP
- **Purpose:** Browser automation and testing
- **Type:** stdio server (via npx)
- **Command:** `npx @playwright/mcp@latest`
- **Enables:** Claude to perform browser-based testing, automation, and web scraping

### Using MCP Servers

MCP servers are automatically available when using Claude Code. No additional setup is required beyond restarting Claude Code after any changes to `.mcp.json`.

**Note:** The first time you use the project, Claude Code will ask for permission to use these MCP servers. You'll need to approve them once.

### Adding More MCP Servers

To add additional MCP servers:

1. Edit `.mcp.json` in the project root
2. Add your server configuration under `mcpServers`
3. Restart Claude Code
4. Update this README and `claude.md` with the new server details

**Example:**
```json
{
  "mcpServers": {
    "your-server": {
      "url": "https://your-mcp-server.com/mcp"
    }
  }
}
```

For more information, see the [MCP documentation](https://modelcontextprotocol.io).

## Project Context for AI Agents

The `claude.md` file contains comprehensive project context for AI coding agents:

- Project structure and architecture
- Technology stack details
- Environment configuration
- Development workflows
- Available skills and commands
- Common issues and solutions

**For best results:** AI agents (Claude Code, Cursor) automatically read `claude.md` to understand your project. Keep it updated as your project evolves.

## Features

### Current Features

- **Multi-Platform Deployment** - Deploy to Cloudflare Workers and/or Supabase Edge Functions
- **Unified Deployment Skill** - One command to deploy to multiple platforms
- **Supabase Integration** - Database client for Cloudflare Workers API
- **Supabase Edge Functions** - Serverless functions running on Deno
- **Cloudflare Workers** - Production-ready API deployment to Cloudflare's edge network
- **Hono Framework** - Lightweight, ultrafast web framework designed for edge computing
- **Bun Runtime** - Fast JavaScript runtime and package manager
- **Claude Code Skills** - Custom skills for deployment, dependency management, and environment validation
- **MCP Integration** - Pre-configured Supabase and Playwright MCP servers
- **Cross-Platform Scripts** - Support for Unix/Mac/Linux and Windows
- **Environment Configuration** - Secure credential management with `.env`
- **TypeScript Support** - Full TypeScript configuration with strict mode
- **Development Planning** - Structured feature planning with `plan.md` template

### Available Skills

#### `/dependencies`
Manage project dependencies across all apps.
- Automatically runs `bun install` in the correct directories
- Verifies installation success
- Cross-platform support

#### `/check-envs`
Validate environment variables configuration.
- Checks all required and optional environment variables
- Detects placeholder values that need to be replaced
- Provides color-coded status report
- Shows setup instructions for missing variables
- Cross-platform support (Unix/Mac/Windows)

#### `/deployment`
Unified deployment to Cloudflare Workers and/or Supabase Edge Functions.
- Interactive platform selection (Cloudflare / Supabase / Both)
- Validates platform-specific environment variables
- Deploys to selected platform(s)
- Returns deployment URLs and status
- Cross-platform support (Unix/Mac/Windows)

### Coming Soon

- Authentication with Supabase Auth
- More API endpoints and database queries
- Testing framework setup
- CI/CD pipeline
- Multi-environment deployments (dev/staging/prod)
- More Claude Code skills
- Rollback functionality in deployment skill

## Contributing

(Coming soon)

## License

(Coming soon)
