# AI-Driven Project Template

A template for AI-driven application development.

## Supported AI Agents

This template currently supports the following AI agents:

- **Cursor** - AI-powered code editor
- **Claude Code** - Anthropic's official CLI for Claude

## Getting Started

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

### Local Development

To run the API locally:

```bash
cd apps/api
bun run dev
```

The API will be available at `http://localhost:8787`

## Features

(Coming soon)

## Contributing

(Coming soon)

## License

(Coming soon)
