#!/bin/bash
# Cloudflare Workers Deployment Script (Unix/Mac/Linux)

set -e  # Exit on error

# Get the script's directory and navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

# Navigate to the API directory
cd "$PROJECT_ROOT/apps/api"

# Check if bun is installed
if ! command -v bun &> /dev/null; then
    echo "Error: bun is not installed or not in PATH"
    exit 1
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Error: node_modules not found. Run 'bun install' first."
    exit 1
fi

# Run deployment
echo "Deploying to Cloudflare Workers..."
bun run deploy

exit $?
