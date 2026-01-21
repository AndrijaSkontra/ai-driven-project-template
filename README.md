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

Before you begin, ensure you have the following installed and configured:

- **[Bun](https://bun.sh)** - JavaScript runtime and package manager (required)
- **[Cloudflare Account](https://dash.cloudflare.com/sign-up)** - For deploying to Cloudflare Workers (required)
- **[Supabase Account](https://supabase.com)** - For database and edge functions (optional)
- **[Supabase CLI](https://supabase.com/docs/guides/cli)** - Required for deploying Edge Functions (optional, see installation instructions below)

#### Trigger.dev Setup

If you plan to use the Trigger.dev jobs in this template, you must configure your Trigger.dev project ID:

1. Create or locate your project in the [Trigger.dev dashboard](https://trigger.dev)
2. Copy your **Project ID / project ref**
3. Open `trigger.config.ts` in the project root
4. Replace the placeholder value in the `project` field:

```ts
export default defineConfig({
  project: '<fill-with-project-id>', // ← replace this with your real Trigger.dev project ID
  // ...
});
```

Trigger.dev tasks will not work until this value is set correctly.

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

> **Important:** The Supabase CLI is **required** if you want to deploy Supabase Edge Functions.

**Installation Options:**

| Platform             | Command                                                                                            |
| -------------------- | -------------------------------------------------------------------------------------------------- |
| macOS (Homebrew)     | `brew install supabase/tap/supabase`                                                               |
| Windows (Scoop)      | `scoop bucket add supabase https://github.com/supabase/scoop-bucket.git && scoop install supabase` |
| npm (Cross-platform) | `npm install -g supabase`                                                                          |
| npx (No install)     | `npx supabase [command]`                                                                           |

**Verify Installation:**

```bash
supabase --version
```

#### 5. Authenticate with Supabase CLI

```bash
supabase login
```

This will open a browser for authentication.

### Resend Setup (Optional)

If you want to use Resend for sending transactional emails:

#### 1. Create a Resend Account

1. Sign up at [https://resend.com](https://resend.com)
2. Verify your email address

#### 2. Get Your API Key

1. Go to [https://resend.com/api-keys](https://resend.com/api-keys)
2. Click **"Create API Key"**
3. Give it a name (e.g., "My Project API Key")
4. Select the appropriate permissions (Full access for development)
5. Click **"Add"** and copy the API key immediately

#### 3. Add to Environment Variables

Add the following to your `.env` file:

```bash
# Resend Configuration
RESEND_KEY=re_your-api-key-here
```

#### 4. Domain Configuration (Production)

For production use, you need to verify a domain:

1. Go to [https://resend.com/domains](https://resend.com/domains)
2. Click **"Add Domain"**
3. Add your domain (e.g., `yourdomain.com`)
4. Add the DNS records Resend provides to your domain
5. Wait for verification (usually within a few minutes)

**Testing without a domain:** Use `onboarding@resend.dev` as the sender for development/testing.

### Quick Start

```bash
# 1. Install dependencies
cd apps/api && bun install
# Or use: /dependencies

# 2. Verify environment configuration
/check-envs

# 3. Run locally
bun run dev

# 4. Deploy
/deployment
```

### Local Development

```bash
cd apps/api
bun run dev
```

The API will be available at `http://localhost:8787`

## Documentation

| Topic                                | Description                                                                  |
| ------------------------------------ | ---------------------------------------------------------------------------- |
| [Skills](docs/skills.md)             | Available Claude Code skills (`/dependencies`, `/check-envs`, `/deployment`) |
| [Monitoring](docs/monitoring.md)     | Viewing logs in Cloudflare Dashboard and CLI                                 |
| [MCP Servers](docs/mcp.md)           | Model Context Protocol server configuration                                  |
| [Design System](docs/design.md)      | UI/UX foundations and ASCII wireframing workflow                             |
| [Code Quality](docs/code-quality.md) | Git hooks, commit conventions, and formatting                                |
