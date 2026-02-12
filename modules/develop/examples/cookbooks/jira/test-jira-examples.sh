#!/usr/bin/env bash
#
# Test script for Jira cookbook examples
#
# This script validates YAML syntax using `rpk connect lint`
#
# Usage:
#   ./test-jira-examples.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Testing Jira cookbook examples..."
echo ""

TOTAL=0
PASSED=0
FAILED=0

for file in *.yaml; do
    if [[ -f "$file" ]]; then
        TOTAL=$((TOTAL + 1))
        echo -n "  $file... "

        if output=$(rpk connect lint --skip-env-var-check "$file" 2>&1); then
            echo -e "${GREEN}PASSED${NC}"
            PASSED=$((PASSED + 1))
        else
            echo -e "${RED}FAILED${NC}"
            echo "$output" | sed 's/^/    /'
            FAILED=$((FAILED + 1))
        fi
    fi
done

echo ""
echo "Results: $PASSED/$TOTAL passed"

if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}Some tests failed${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed${NC}"
    exit 0
fi
