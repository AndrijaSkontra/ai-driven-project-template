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

- **[Bun](https://bun.sh)** - JavaScript runtime and package manager
- **[Cloudflare Account](https://dash.cloudflare.com/sign-up)** - For deploying to Cloudflare Workers

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

#### 5. Install Dependencies

```bash
cd apps/api
bun install
```

Or use the Claude Code dependencies skill:
```bash
/dependencies
```

#### 6. Deploy to Cloudflare

```bash
cd apps/api
bun run deploy
```

Or use the Claude Code deployment skill:
```bash
/deployment
```

Your API will be deployed to: `https://api.<your-subdomain>.workers.dev`

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

- **Cloudflare Workers Deployment** - Production-ready API deployment to Cloudflare's edge network
- **Hono Framework** - Lightweight, ultrafast web framework designed for edge computing
- **Bun Runtime** - Fast JavaScript runtime and package manager
- **Claude Code Skills** - Custom skills for deployment and dependency management
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

#### `/deployment`
Deploy the API to Cloudflare Workers with one command.
- Validates environment variables
- Deploys with minification
- Returns deployment URL and version
- Cross-platform support

### Coming Soon

- Authentication with Supabase
- Database integration
- Additional API endpoints
- Testing framework setup
- CI/CD pipeline
- Multi-environment deployments
- More Claude Code skills

## Contributing

(Coming soon)

## License

(Coming soon)
