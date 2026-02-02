#!/usr/bin/env bash
#
# Test script for Redpanda Cloud MCP examples
#
# This script tests:
# 1. MCP tool definitions using `rpk connect mcp-server lint`
# 2. MCP metadata validation (enabled, description, properties)
#
# Usage:
#   ./test-mcp-tools.sh              # Run all tests
#   ./test-mcp-tools.sh --lint-only  # Only lint, skip metadata validation
#
# Unlike rp-connect-docs, Cloud MCP tools cannot be tested with
# `rpk connect run` because they are standalone tool definitions, not
# full pipelines. End-to-end testing requires the Cloud Console.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get script directory (script lives inside mcp-tools/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Component type directories
COMPONENT_DIRS=("inputs" "outputs" "processors" "caches")

# Counters
TOTAL_TOOLS=0
PASSED_LINT=0
PASSED_METADATA=0
FAILED_LINT=0
FAILED_METADATA=0
SKIPPED=0

echo "🧪 Redpanda Cloud MCP Examples - Test Suite"
echo "============================================"
echo ""

# Parse arguments
RUN_METADATA=true

if [[ $# -gt 0 ]]; then
    case "$1" in
        --lint-only)
            RUN_METADATA=false
            ;;
    esac
fi

# ============================================================================
# SECTION 1: MCP Tool Linting
# Validates YAML syntax and component schemas
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "📦 ${CYAN}SECTION 1: MCP Tool Linting${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for dir in "${COMPONENT_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        file_count=$(find "$dir" -maxdepth 1 -name "*.yaml" | wc -l | tr -d ' ')
        if [[ $file_count -gt 0 ]]; then
            TOTAL_TOOLS=$((TOTAL_TOOLS + file_count))
            echo -n -e "${BLUE}📁 $dir/${NC} ($file_count files)... "

            if output=$(rpk connect mcp-server lint --skip-env-var-check "$dir" 2>&1); then
                echo -e "${GREEN}✓ PASSED${NC}"
                PASSED_LINT=$((PASSED_LINT + file_count))
            else
                echo -e "${RED}✗ FAILED${NC}"
                echo "$output" | sed 's/^/   /' | head -20
                FAILED_LINT=$((FAILED_LINT + file_count))
            fi
        fi
    fi
done

# ============================================================================
# SECTION 2: MCP Metadata Validation
# Validates tool metadata (enabled, description, properties)
# ============================================================================

if $RUN_METADATA; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "📝 ${CYAN}SECTION 2: MCP Metadata Validation${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Determine which YAML parser to use
    use_yq=true
    if ! command -v yq &> /dev/null; then
        use_yq=false
        if ! command -v python3 &> /dev/null; then
            echo -e "${YELLOW}⚠ Neither yq nor python3 available - skipping metadata validation${NC}"
            RUN_METADATA=false
        fi
    fi

    if $RUN_METADATA; then
        for dir in "${COMPONENT_DIRS[@]}"; do
            if [[ -d "$dir" ]]; then
                for file in "$dir"/*.yaml; do
                    if [[ -f "$file" ]]; then
                        echo -n -e "   ${BLUE}$file${NC}... "

                        # Check if .meta.mcp exists
                        if $use_yq; then
                            mcp_exists=$(yq eval '.meta.mcp' "$file" 2>/dev/null)
                            enabled=$(yq eval '.meta.mcp.enabled' "$file" 2>/dev/null)
                            description=$(yq eval '.meta.mcp.description' "$file" 2>/dev/null)
                        else
                            mcp_exists=$(python3 -c "
import yaml
try:
    with open('$file') as f:
        doc = yaml.safe_load(f)
    meta = doc.get('meta', {}) if doc else {}
    mcp = meta.get('mcp')
    print('null' if mcp is None else 'exists')
except:
    print('null')
" 2>/dev/null)
                            enabled=$(python3 -c "
import yaml
try:
    with open('$file') as f:
        doc = yaml.safe_load(f)
    enabled = doc.get('meta', {}).get('mcp', {}).get('enabled')
    print('null' if enabled is None else str(enabled).lower())
except:
    print('null')
" 2>/dev/null)
                            description=$(python3 -c "
import yaml
try:
    with open('$file') as f:
        doc = yaml.safe_load(f)
    desc = doc.get('meta', {}).get('mcp', {}).get('description')
    print('null' if desc is None or desc == '' else str(desc))
except:
    print('null')
" 2>/dev/null)
                        fi

                        # Validate
                        if [[ "$mcp_exists" == "null" || -z "$mcp_exists" ]]; then
                            echo -e "${YELLOW}SKIPPED${NC} (no MCP metadata)"
                            SKIPPED=$((SKIPPED + 1))
                        elif [[ "$enabled" != "true" ]]; then
                            echo -e "${YELLOW}WARNING${NC} (mcp.enabled not true)"
                            SKIPPED=$((SKIPPED + 1))
                        elif [[ "$description" == "null" || -z "$description" ]]; then
                            echo -e "${RED}FAILED${NC} (missing description)"
                            FAILED_METADATA=$((FAILED_METADATA + 1))
                        else
                            echo -e "${GREEN}PASSED${NC}"
                            PASSED_METADATA=$((PASSED_METADATA + 1))
                        fi
                    fi
                done
            fi
        done
    fi
fi

# ============================================================================
# SECTION 3: Cloud-Specific Validation
# Validates secrets use Cloud format (${secrets.X})
# ============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "☁️  ${CYAN}SECTION 3: Cloud Secrets Format${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

secrets_issues=0
for dir in "${COMPONENT_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        for file in "$dir"/*.yaml; do
            if [[ -f "$file" ]]; then
                # Check for non-Cloud secrets patterns (${VAR} without secrets. prefix)
                # Exclude:
                #   - ${! ... } which is Bloblang interpolation
                #   - ${REDPANDA_BROKERS} which is platform-injected
                if grep -E '\$\{[A-Z_]+\}' "$file" | grep -v '\${secrets\.' | grep -v '\${!' | grep -v '\${REDPANDA_BROKERS}' > /dev/null 2>&1; then
                    echo -e "   ${BLUE}$file${NC}... ${YELLOW}WARNING${NC} (uses env vars instead of \${secrets.X})"
                    secrets_issues=$((secrets_issues + 1))
                fi
            fi
        done
    fi
done

if [[ $secrets_issues -eq 0 ]]; then
    echo -e "   ${GREEN}✓ All files use Cloud secrets format${NC}"
fi

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "============================================"
echo "📊 Test Summary"
echo "============================================"

echo -e "Lint:       ${PASSED_LINT}/${TOTAL_TOOLS} passed"
if $RUN_METADATA; then
    METADATA_TOTAL=$((PASSED_METADATA + FAILED_METADATA + SKIPPED))
    echo -e "Metadata:   ${PASSED_METADATA}/${METADATA_TOTAL} passed (${SKIPPED} skipped)"
fi
if [[ $secrets_issues -gt 0 ]]; then
    echo -e "Secrets:    ${YELLOW}${secrets_issues} warnings${NC}"
fi
echo "──────────────────────────────────────────────────"

TOTAL_FAILED=$((FAILED_LINT + FAILED_METADATA))

if [[ $TOTAL_FAILED -gt 0 ]]; then
    echo -e "${RED}❌ Some tests failed ($TOTAL_FAILED failures)${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
fi
