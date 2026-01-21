# Monitoring and Logs

The API has observability logging enabled, which captures all console output and request details.

## Cloudflare Dashboard

Navigate to your logs in the Cloudflare Dashboard:

```
https://dash.cloudflare.com/{YOUR_ACCOUNT_ID}/workers/services/view/api/production/observability/logs?workers-observability-view=events
```

> Replace `{YOUR_ACCOUNT_ID}` with your Cloudflare Account ID from the `.env` file.

**Quick access:** After deployment, you can also find the logs by going to:
Cloudflare Dashboard → Workers & Pages → api → Logs tab

## Command Line

Stream real-time logs from your terminal:

```bash
cd apps/api
wrangler tail
```

## What's Captured

- Console output (`console.log`, `console.error`, etc.)
- Request/response details
- Errors and exceptions
- Timestamps

## Configuration

Observability is configured in `apps/api/wrangler.jsonc`:

```json
{
  "observability": {
    "logs": {
      "enabled": true,
      "invocation_logs": true
    }
  }
}
```
