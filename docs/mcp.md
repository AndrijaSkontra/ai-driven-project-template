# MCP Server Configuration

This project uses [Model Context Protocol (MCP)](https://modelcontextprotocol.io) servers to enhance AI agent capabilities.

## Configured MCP Servers

The following MCP servers are pre-configured in `.mcp.json`:

### Supabase MCP

| Property    | Value                                                                          |
| ----------- | ------------------------------------------------------------------------------ |
| **Purpose** | Database and backend services integration                                      |
| **Type**    | HTTP server                                                                    |
| **URL**     | `https://mcp.supabase.com/mcp`                                                 |
| **Enables** | Claude to interact with Supabase services, manage databases, auth, and storage |

### Playwright MCP

| Property    | Value                                                                 |
| ----------- | --------------------------------------------------------------------- |
| **Purpose** | Browser automation and testing                                        |
| **Type**    | stdio server (via npx)                                                |
| **Command** | `npx @playwright/mcp@latest`                                          |
| **Enables** | Claude to perform browser-based testing, automation, and web scraping |

## Usage

MCP servers are automatically available when using Claude Code. No additional setup is required beyond restarting Claude Code after any changes to `.mcp.json`.

> **Note:** The first time you use the project, Claude Code will ask for permission to use these MCP servers. You'll need to approve them once.

## Adding More MCP Servers

1. Edit `.mcp.json` in the project root
2. Add your server configuration under `mcpServers`
3. Restart Claude Code
4. Update this documentation and `claude.md` with the new server details

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

## Resources

- [MCP Documentation](https://modelcontextprotocol.io)
- [MCP Server Directory](https://github.com/modelcontextprotocol/servers)
