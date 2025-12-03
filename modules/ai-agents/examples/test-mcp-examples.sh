#!/usr/bin/env bash
#
# Automated testing script for Redpanda Connect MCP examples (Cloud)
#
# Usage:
#   ./test-mcp-examples.sh                      # Test all examples
#   ./test-mcp-examples.sh weather_*.yaml       # Test specific pattern

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Counters
TOTAL=0
PASSED=0
FAILED=0
SKIPPED=0

echo "🧪 Redpanda Connect MCP Examples Test Suite (Cloud)"
echo "===================================================="
echo ""

# Determine what to test
PATTERN="${1:-*.yaml}"

# Function to lint a config file
lint_config() {
    local file=$1
    TOTAL=$((TOTAL + 1))

    echo -n "  Linting $(basename "$file")... "

    # Skip environment variable checks for MCP examples as they may use ${secrets.X}
    if rpk connect lint --skip-env-var-check "$file" 2>&1 | grep -q "error"; then
        echo -e "${RED}FAILED${NC}"
        rpk connect lint --skip-env-var-check "$file" 2>&1 | sed 's/^/    /'
        FAILED=$((FAILED + 1))
        return 1
    else
        echo -e "${GREEN}PASSED${NC}"
        PASSED=$((PASSED + 1))
        return 0
    fi
}

# Function to validate MCP metadata
validate_mcp_metadata() {
    local file=$1

    echo -n "  Validating MCP metadata... "

    # Check if file has MCP metadata
    if ! grep -q "meta:" "$file" || ! grep -q "mcp:" "$file"; then
        echo -e "${YELLOW}SKIPPED${NC} (no MCP metadata)"
        SKIPPED=$((SKIPPED + 1))
        return 0
    fi

    # Check for required MCP fields
    local has_enabled=$(grep -c "enabled: true" "$file" || echo 0)
    local has_description=$(grep -c "description:" "$file" || echo 0)

    if [[ $has_enabled -eq 0 ]]; then
        echo -e "${YELLOW}WARNING${NC} (mcp.enabled not set to true)"
        return 0
    fi

    if [[ $has_description -eq 0 ]]; then
        echo -e "${RED}FAILED${NC} (missing description)"
        return 1
    fi

    echo -e "${GREEN}PASSED${NC}"
    return 0
}

# Find and test all matching files
for file in $PATTERN; do
    if [[ -f "$file" ]]; then
        echo ""
        echo -e "${BLUE}📄 Testing: $file${NC}"

        # Lint the config
        if lint_config "$file"; then
            # Validate MCP metadata
            validate_mcp_metadata "$file" || true
        fi
    fi
done

# Summary
echo ""
echo "===================================================="
echo "📊 Test Summary"
echo "===================================================="
echo "Total configs tested: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
if [[ $SKIPPED -gt 0 ]]; then
    echo -e "Skipped: ${YELLOW}$SKIPPED${NC}"
fi
echo ""

if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
fi
