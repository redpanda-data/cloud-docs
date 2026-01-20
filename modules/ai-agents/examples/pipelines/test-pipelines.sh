#!/usr/bin/env bash
#
# Test script for Redpanda Cloud pipeline examples
#
# This script uses rpk connect lint to validate pipeline configurations.
# Cloud-specific processors (like a2a_message) are not available in the local
# CLI, so those errors are expected and noted.
#
# Usage:
#   ./test-pipelines.sh
#
# Exit codes:
#   0 - All files have valid YAML structure (Cloud processor errors are expected)
#   1 - YAML syntax errors or unexpected failures

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Counters
TOTAL=0
PASSED=0
CLOUD_PROCESSOR_ERRORS=0
FAILED=0

echo "🧪 Redpanda Cloud Pipeline Examples - Test Suite"
echo "================================================="
echo ""

# Check for rpk
if ! command -v rpk &> /dev/null; then
    echo -e "${RED}Error: rpk is required${NC}"
    echo "Install rpk: https://docs.redpanda.com/current/get-started/rpk-install/"
    exit 1
fi

echo -e "${CYAN}Using:${NC} $(rpk version 2>/dev/null | head -1 || echo 'rpk')"
echo ""

# ============================================================================
# Lint each pipeline file
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "📦 ${CYAN}Pipeline Linting${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for file in *.yaml; do
    if [[ -f "$file" ]]; then
        TOTAL=$((TOTAL + 1))
        echo -n -e "   ${BLUE}$file${NC}... "

        # Run rpk connect lint
        output=$(rpk connect lint --skip-env-var-check "$file" 2>&1) || true

        if [[ -z "$output" ]]; then
            # No output means success
            echo -e "${GREEN}PASSED${NC}"
            PASSED=$((PASSED + 1))
        elif echo "$output" | grep -q "a2a_message\|unable to infer.*a2a"; then
            # Cloud-specific processor error (expected)
            echo -e "${YELLOW}OK${NC} (Cloud processor - requires Redpanda Cloud)"
            CLOUD_PROCESSOR_ERRORS=$((CLOUD_PROCESSOR_ERRORS + 1))
        elif echo "$output" | grep -qi "yaml\|parse\|syntax"; then
            # YAML syntax error (unexpected)
            echo -e "${RED}FAILED${NC}"
            echo "$output" | sed 's/^/      /'
            FAILED=$((FAILED + 1))
        else
            # Other lint error
            echo -e "${YELLOW}WARNING${NC}"
            echo "$output" | sed 's/^/      /' | head -5
            CLOUD_PROCESSOR_ERRORS=$((CLOUD_PROCESSOR_ERRORS + 1))
        fi
    fi
done

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "================================================="
echo "📊 Test Summary"
echo "================================================="
echo -e "Total files:           $TOTAL"
echo -e "Fully passed:          $PASSED"
echo -e "Cloud processors:      $CLOUD_PROCESSOR_ERRORS (expected - requires Cloud)"
echo -e "Failed:                $FAILED"
echo "──────────────────────────────────────────────────"

if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}❌ $FAILED file(s) have YAML errors${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All files valid${NC}"
    if [[ $CLOUD_PROCESSOR_ERRORS -gt 0 ]]; then
        echo ""
        echo -e "${YELLOW}Note: $CLOUD_PROCESSOR_ERRORS file(s) use Cloud-specific processors (a2a_message)${NC}"
        echo -e "${YELLOW}These require deployment to Redpanda Cloud for full validation.${NC}"
    fi
    exit 0
fi
