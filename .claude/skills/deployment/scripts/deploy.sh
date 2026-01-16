#!/bin/bash
# Unified Deployment Script - Cloudflare Workers & Supabase Edge Functions
# Supports: Unix/Mac/Linux

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the script's directory and navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

# Load environment variables from .env
if [ -f "$PROJECT_ROOT/.env" ]; then
    export $(cat "$PROJECT_ROOT/.env" | grep -v '^#' | xargs)
else
    echo -e "${RED}Error: .env file not found in project root${NC}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to deploy to Cloudflare Workers
deploy_cloudflare() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Deploying to Cloudflare Workers${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    # Check if bun is installed
    if ! command_exists bun; then
        echo -e "${RED}Error: bun is not installed or not in PATH${NC}"
        echo -e "${YELLOW}Install from: https://bun.sh${NC}"
        return 1
    fi

    # Navigate to API directory
    cd "$PROJECT_ROOT/apps/api"

    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo -e "${RED}Error: node_modules not found. Run 'bun install' first.${NC}"
        return 1
    fi

    # Check required environment variables
    if [ -z "$CLOUDFLARE_API" ] || [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
        echo -e "${RED}Error: Missing required environment variables${NC}"
        echo -e "${YELLOW}Required: CLOUDFLARE_API, CLOUDFLARE_ACCOUNT_ID${NC}"
        return 1
    fi

    # Run deployment
    echo -e "${GREEN}Starting Cloudflare deployment...${NC}"
    bun run deploy

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✓ Cloudflare Workers deployment successful!${NC}"
        return 0
    else
        echo -e "\n${RED}✗ Cloudflare Workers deployment failed${NC}"
        return 1
    fi
}

# Function to deploy to Supabase Edge Functions
deploy_supabase() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Deploying to Supabase Edge Functions${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    # Check if supabase CLI is installed
    if ! command_exists supabase; then
        echo -e "${RED}Error: Supabase CLI is not installed or not in PATH${NC}"
        echo -e "${YELLOW}Install from: https://supabase.com/docs/guides/cli${NC}"
        echo -e "${YELLOW}  npm install -g supabase${NC}"
        echo -e "${YELLOW}  or: brew install supabase/tap/supabase${NC}"
        return 1
    fi

    # Navigate to project root
    cd "$PROJECT_ROOT"

    # Check if supabase directory exists
    if [ ! -d "supabase/functions" ]; then
        echo -e "${RED}Error: supabase/functions directory not found${NC}"
        return 1
    fi

    # Check required environment variables
    if [ -z "$SUPABASE_PROJECT_REF" ]; then
        echo -e "${RED}Error: Missing SUPABASE_PROJECT_REF environment variable${NC}"
        echo -e "${YELLOW}Add to .env: SUPABASE_PROJECT_REF=your-project-ref${NC}"
        return 1
    fi

    # Check if project is linked
    if [ ! -f "supabase/.temp/project-ref" ]; then
        echo -e "${YELLOW}Project not linked. Linking now...${NC}"
        supabase link --project-ref "$SUPABASE_PROJECT_REF"
        if [ $? -ne 0 ]; then
            echo -e "${RED}✗ Failed to link Supabase project${NC}"
            echo -e "${YELLOW}Run manually: supabase login && supabase link${NC}"
            return 1
        fi
    fi

    # Deploy all functions
    echo -e "${GREEN}Starting Supabase Edge Functions deployment...${NC}"
    supabase functions deploy

    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}✓ Supabase Edge Functions deployment successful!${NC}"
        echo -e "${BLUE}Functions available at: https://$SUPABASE_PROJECT_REF.supabase.co/functions/v1/${NC}"
        return 0
    else
        echo -e "\n${RED}✗ Supabase Edge Functions deployment failed${NC}"
        return 1
    fi
}

# Main script logic
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║   Unified Deployment - Select Platform   ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"

    # Check if DEPLOY_TARGET is set (for automated deployments)
    if [ ! -z "$DEPLOY_TARGET" ]; then
        PLATFORM_CHOICE="$DEPLOY_TARGET"
        echo -e "${BLUE}Using automated target: $DEPLOY_TARGET${NC}"
    else
        # Interactive platform selection
        echo "Select deployment platform:"
        echo "  1) Cloudflare Workers"
        echo "  2) Supabase Edge Functions"
        echo "  3) Both platforms"
        echo ""
        read -p "Enter choice [1-3]: " choice

        case $choice in
            1) PLATFORM_CHOICE="cloudflare" ;;
            2) PLATFORM_CHOICE="supabase" ;;
            3) PLATFORM_CHOICE="both" ;;
            *)
                echo -e "${RED}Invalid choice. Exiting.${NC}"
                exit 1
                ;;
        esac
    fi

    # Track deployment results
    CF_SUCCESS=0
    SB_SUCCESS=0

    # Deploy based on selection
    case $PLATFORM_CHOICE in
        cloudflare)
            deploy_cloudflare
            CF_SUCCESS=$?
            ;;
        supabase)
            deploy_supabase
            SB_SUCCESS=$?
            ;;
        both)
            deploy_cloudflare
            CF_SUCCESS=$?
            deploy_supabase
            SB_SUCCESS=$?
            ;;
    esac

    # Summary
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Deployment Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ "$PLATFORM_CHOICE" = "cloudflare" ] || [ "$PLATFORM_CHOICE" = "both" ]; then
        if [ $CF_SUCCESS -eq 0 ]; then
            echo -e "${GREEN}✓ Cloudflare Workers: SUCCESS${NC}"
        else
            echo -e "${RED}✗ Cloudflare Workers: FAILED${NC}"
        fi
    fi

    if [ "$PLATFORM_CHOICE" = "supabase" ] || [ "$PLATFORM_CHOICE" = "both" ]; then
        if [ $SB_SUCCESS -eq 0 ]; then
            echo -e "${GREEN}✓ Supabase Edge Functions: SUCCESS${NC}"
        else
            echo -e "${RED}✗ Supabase Edge Functions: FAILED${NC}"
        fi
    fi

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    # Exit with error if any deployment failed
    if [ $CF_SUCCESS -ne 0 ] || [ $SB_SUCCESS -ne 0 ]; then
        exit 1
    fi

    exit 0
}

# Run main function
main
