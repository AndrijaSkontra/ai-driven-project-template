# Cloudflare Workers Deployment Script (Windows PowerShell)

# Exit on error
$ErrorActionPreference = "Stop"

# Get the script's directory and navigate to project root
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "../../../..")

# Navigate to the API directory
$ApiDir = Join-Path $ProjectRoot "apps/api"
Set-Location $ApiDir

# Check if bun is installed
if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Error "Error: bun is not installed or not in PATH"
    exit 1
}

# Check if node_modules exists
if (-not (Test-Path "node_modules")) {
    Write-Error "Error: node_modules not found. Run 'bun install' first."
    exit 1
}

# Run deployment
Write-Host "Deploying to Cloudflare Workers..."
bun run deploy

exit $LASTEXITCODE
