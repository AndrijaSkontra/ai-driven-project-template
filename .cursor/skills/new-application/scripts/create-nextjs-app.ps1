param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$AppName
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($AppName)) {
  Write-Host "Usage: .\create-nextjs-app.ps1 <app-name>" -ForegroundColor Red
  exit 1
}

npx create-next-app@latest $AppName --ts --eslint --tailwind --app --src-dir --import-alias "@/*" --use-bun --react-compiler

