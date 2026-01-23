# AI Gateway Content Restructuring Plan
## Persona-Based Reorganization

**Date:** January 21, 2026
**Purpose:** Restructure AI Gateway documentation to align with two primary personas (Admins and Builders) and their distinct user journeys.

---

## Executive Summary

The current AI Gateway documentation is comprehensive but doesn't clearly distinguish between Admin and Builder personas. This plan proposes:

1. **Restructure the navigation** to create clear persona-based paths
2. **Create new landing/discovery pages** for each persona
3. **Tag existing content** with appropriate personas
4. **Add missing content** to complete user journeys
5. **Reorganize the index** to guide users based on their role

---

## Personas Defined

### Admin Persona
- **Role:** Platform administrators with broad oversight
- **Responsibilities:**
  - Configure system-level parameters
  - Enable/disable LLM providers and models
  - Set up gateways with policies, routing, and budgets
  - Monitor usage across the organization
  - Manage access control and security
- **Key Questions:**
  - How do I set up and configure AI Gateway for my organization?
  - How do I control costs and enforce policies?
  - How do I monitor usage across all teams?

### Builder Persona
- **Role:** Developers/engineers building agents or AI applications
- **Responsibilities:**
  - Build agents and AI applications
  - Integrate agents with available gateways
  - Use MCP tools and services
  - Monitor their own usage and costs
- **Key Questions:**
  - Which gateways can I use?
  - How do I connect my agent to a gateway?
  - What tools/models are available to me?
  - How much am I spending?

---

## User Journey Mapping

### Admin User Journey
1. **Understand** → What is an AI gateway? (conceptual)
2. **Set Up** → Enable providers, enable models, create gateways
3. **Configure** → Set up networking, policies, routing, budgets
4. **Monitor** → Track usage, costs, and manage access
5. **Optimize** → Adjust policies, routing, and costs based on metrics

### Builder User Journey
1. **Discover** → Which gateways can I access?
2. **Connect** → How do I integrate my agent with a gateway?
3. **Build** → Use available models and MCP tools
4. **Test** → Validate my agent's integration
5. **Monitor** → Track my usage and costs

---

## Content Gap Analysis

### Missing Content
| Content Needed | Persona | Priority | Current Status |
|---------------|---------|----------|----------------|
| Gateway Discovery page | Builder | HIGH | Missing - critical for Builder journey |
| "What is AI Gateway" standalone page | Both | HIGH | Content exists in overview but needs extraction |
| Admin Setup Guide | Admin | HIGH | Scattered across quickstart - needs consolidation |
| Builder Integration Guide | Builder | HIGH | Exists partially in quickstart/integrations |
| Networking Configuration page | Admin | MEDIUM | Mentioned but not detailed |
| Access Management page | Admin | MEDIUM | Missing |

### Existing Content Gaps
1. **gateway-architecture.adoc** - Too dense, mixes Admin and Builder concerns
2. **gateway-quickstart.adoc (quickstart)** - Conflates Admin setup with Builder usage
3. **index.adoc** - Too minimal, provides no guidance
4. **No discovery mechanism** - Builders don't know which gateways they can use

---

## Recommended Content Structure

### New Navigation Structure

```
AI Gateway/
├── index.adoc (New: Persona-based landing page)
├── what-is-ai-gateway.adoc (New: Extracted from overview)
│
├── For Admins/
│   ├── admin-overview.adoc (New: Admin-focused overview)
│   ├── setup-guide.adoc (New: Complete admin setup)
│   │   ├── enable-providers.adoc (Extracted from quickstart)
│   │   ├── enable-models.adoc (Extracted from quickstart)
│   │   ├── create-gateways.adoc (Extracted from quickstart)
│   │   ├── networking-configuration.adoc (New/Expanded)
│   ├── configure-policies.adoc (Consolidated)
│   │   ├── routing-policies.adoc (Link to CEL cookbook)
│   │   ├── access-controls.adoc (New)
│   │   ├── budgets-and-limits.adoc (Consolidated from quickstart)
│   ├── manage-gateways.adoc (New: List, edit, delete)
│   ├── observability-admin.adoc (Link to metrics dashboard)
│   └── integrations/ (Admin versions)
│       ├── index.adoc
│       ├── claude-code-admin.adoc
│       ├── cursor-admin.adoc
│       └── ...
│
├── For Builders/
│   ├── builder-overview.adoc (New: Builder-focused overview)
│   ├── discover-gateways.adoc (NEW - CRITICAL)
│   ├── connect-your-agent.adoc (New: Integration guide)
│   ├── available-models.adoc (New: How to see what's available)
│   ├── use-mcp-tools.adoc (Link to MCP aggregation)
│   ├── test-your-integration.adoc (New: Validation)
│   ├── monitor-your-usage.adoc (Link to observability-logs)
│   └── integrations/ (Builder versions)
│       ├── index.adoc
│       ├── claude-code-user.adoc
│       ├── cursor-user.adoc
│       └── ...
│
├── Reference/
│   ├── gateway-architecture.adoc (Refactored: Technical deep-dive)
│   ├── cel-routing-cookbook.adoc (Existing)
│   ├── mcp-aggregation-guide.adoc (Existing)
│   ├── observability-logs.adoc (Existing)
│   ├── observability-metrics.adoc (Existing)
│   ├── migration-guide.adoc (Existing)
│   └── gateway-quickstart.adoc (Consolidated from ai-gateway.adoc and quickstart-enhanced.adoc)
```

---

## Detailed Content Recommendations

### 1. Create New index.adoc (HIGH PRIORITY)

**Current State:** Minimal landing page with just a description
**Proposed Change:** Transform into a persona-based router

**Content Structure:**
```asciidoc
= AI Gateway
:description: Unified access layer for LLM providers and AI tools
:page-layout: index

The Redpanda AI Gateway provides centralized routing, policy enforcement, cost management, and observability for all your AI traffic.

== Choose Your Path

[.persona-card]
=== I'm an Administrator
You manage AI Gateway infrastructure, configure providers, set policies, and monitor organizational usage.

* xref:ai-gateway/admin/admin-overview.adoc[Admin Overview]
* xref:ai-gateway/admin/setup-guide.adoc[Setup Guide]
* xref:ai-gateway/admin/manage-gateways.adoc[Manage Gateways]

[.persona-card]
=== I'm a Builder
You're building AI agents or applications and need to connect to available gateways.

* xref:ai-gateway/builders/builder-overview.adoc[Builder Overview]
* xref:ai-gateway/builders/discover-gateways.adoc[Discover Available Gateways]
* xref:ai-gateway/builders/connect-your-agent.adoc[Connect Your Agent]

== Learn More

* xref:ai-gateway/what-is-ai-gateway.adoc[What is an AI Gateway?]
* xref:ai-gateway/reference/gateway-architecture.adoc[Technical Architecture]
```

**Persona Tagging:** Both

---

### 2. Create what-is-ai-gateway.adoc (HIGH PRIORITY)

**Purpose:** Standalone conceptual page answering "What is an AI gateway?"
**Source:** Extract from gateway-architecture.adoc (lines 15-147)

**Content to Include:**
- The problem AI Gateway solves
- Core capabilities (unified access, routing, MCP aggregation, observability)
- Common gateway patterns
- High-level architecture diagram

**Remove from Overview:** Keep technical details in overview, move conceptual understanding here

**Persona Tagging:** Both (Admin and Builder)

---

### 3. Create discover-gateways.adoc (HIGH PRIORITY - NEW)

**Purpose:** Help Builders find which gateways they have access to
**This is CRITICAL and completely missing from current content**

**Content Structure:**
```asciidoc
= Discover Available Gateways
:description: Find which AI Gateways you can access and their configurations
:page-personas: app_developer

As a builder, you need to know which gateways are available to you before integrating your agent.

== List your accessible gateways

=== Using the Console

1. Navigate to AI Gateway → My Gateways
2. View all gateways you have access to:
   * Gateway Name
   * Gateway ID (for `rp-aigw-id` header)
   * Endpoint URL
   * Available Models
   * MCP Tools (if configured)

=== Using the API

[source,bash]
----
curl https://{CLUSTER}.cloud.redpanda.com/api/ai-gateway/v1/gateways \
  -H "Authorization: Bearer ${REDPANDA_CLOUD_TOKEN}"
----

== Understanding gateway information

Each gateway shows:

* **Gateway ID**: Use this in the `rp-aigw-id` header
* **Endpoint URL**: Base URL for API requests
* **Available Models**: Which models you can access (e.g., `openai/gpt-4o`, `anthropic/claude-sonnet-3.5`)
* **Rate Limits**: Your request limits
* **MCP Tools**: Available MCP servers and tools (if enabled)

== Check gateway availability

Before integrating, test gateway access:

[source,bash]
----
curl https://{GATEWAY_ENDPOINT}/v1/models \
  -H "Authorization: Bearer ${REDPANDA_CLOUD_TOKEN}" \
  -H "rp-aigw-id: ${GATEWAY_ID}"
----

Expected response: List of available models

== Next steps

* xref:ai-gateway/builders/connect-your-agent.adoc[Connect Your Agent]
* xref:ai-gateway/builders/available-models.adoc[View Available Models]
```

**Persona Tagging:** Builder (app_developer)

---

### 4. Refactor gateway-quickstart.adoc (quickstart)

**Current Problem:** Mixes Admin setup (Steps 1-3) with Builder usage (Steps 4-5, integrations)

**Proposed Split:**

#### Create admin/setup-guide.adoc (Admin path)
- Step 1: Enable providers
- Step 2: Enable models
- Step 3: Create gateways
- Step 4: Configure LLM routing (policies, pools, rate limits)
- Step 5: Configure MCP tools

#### Create builders/connect-your-agent.adoc (Builder path)
- Prerequisites: Gateway ID and endpoint (from discovery)
- Step 1: Get your gateway credentials
- Step 2: Configure your client SDK
- Step 3: Make your first request
- Step 4: Handle responses
- Step 5: Validate integration

**Content to Move:**
- Lines 17-89 (Admin steps) → admin/setup-guide.adoc
- Lines 160-337 (Integration examples) → builders/connect-your-agent.adoc
- Lines 106-118 (Observability) → Link to observability pages

---

### 5. Create admin/networking-configuration.adoc (MEDIUM PRIORITY)

**Purpose:** Dedicated page for networking setup
**Content:** Currently mentioned but not detailed

**Content Structure:**
```asciidoc
= Networking Configuration
:description: Configure networking for AI Gateway including endpoints, private networking, and connectivity
:page-personas: platform_admin

Configure network access and connectivity for your AI Gateway.

== Gateway endpoints

When you create a gateway, you receive:

* Public endpoint: `https://gw.ai.panda.com`
* Private endpoint (if enabled): `https://gw-internal.ai.panda.com`

== Public vs private endpoints

**Public endpoints:**
- Accessible from internet
- Use for external agents, testing
- Standard TLS encryption

**Private endpoints:**
- Accessible only within your VPC/network
- Use for production workloads
- Enhanced security

== Configure private networking

[PLACEHOLDER: Add private networking setup steps]

== Connectivity requirements

Outbound connections required:
- To LLM provider APIs (OpenAI, Anthropic, etc.)
- To configured MCP servers (if using MCP aggregation)

Inbound connections:
- From your agents/applications to gateway endpoint

== Firewall and security groups

[PLACEHOLDER: Add security group configuration]

== Next steps

* xref:ai-gateway/admin/configure-policies.adoc[Configure Access Policies]
```

**Persona Tagging:** Admin (platform_admin)

---

### 6. Create admin/access-controls.adoc (MEDIUM PRIORITY)

**Purpose:** How Admins control who can access which gateways

**Content:**
- Gateway-level access control
- API key management
- RBAC configuration (if available)
- Audit logging

**Persona Tagging:** Admin (platform_admin)

---

### 7. Update Existing Files

#### gateway-architecture.adoc
**Changes:**
- Remove conceptual "What is" content (move to what-is-ai-gateway.adoc)
- Focus on technical architecture deep-dive
- Keep: Architecture details, request lifecycle, advanced patterns
- Update persona tag to: `platform_admin, app_developer` (both, but technical)

#### cel-routing-cookbook.adoc
**Changes:**
- Add note at top: "This is an advanced reference for Admins configuring routing policies"
- Update persona tag to: `platform_admin` (currently has both)
- No content changes needed

#### mcp-aggregation-guide.adoc
**Changes:**
- Add section for Builders: "Using MCP tools as a Builder"
- Currently too Admin-focused
- Add discovery section: How Builders see available MCP tools
- Keep persona tag: `app_developer` but clarify sections

#### observability-logs.adoc
**Changes:**
- Add intro section distinguishing Admin vs Builder use cases:
  - Admins: Monitor all traffic, all gateways, org-wide
  - Builders: Monitor their own agent's requests
- Update UI paths to reflect persona-based views
- Persona tag is currently correct: `platform_admin, app_developer`

#### observability-metrics.adoc
**Changes:**
- Similar to logs: Distinguish Admin (org-wide) vs Builder (my usage) views
- Add section: "View your agent's usage" (Builder perspective)
- Persona tag currently: `platform_admin` - should add `app_developer`

---

## Navigation (nav.adoc) Changes

**Current Structure:**
```
* AI Gateway
** Overview
** Quickstart
** CEL Routing
** MCP Aggregation
** Observability
** Integrations
```

**Proposed Structure:**
```
* xref:ai-agents:ai-gateway/index.adoc[AI Gateway]
** xref:ai-agents:ai-gateway/what-is-ai-gateway.adoc[What is AI Gateway?]
** For Admins
*** xref:ai-agents:ai-gateway/admin/admin-overview.adoc[Admin Overview]
*** xref:ai-agents:ai-gateway/admin/setup-guide.adoc[Setup Guide]
*** xref:ai-agents:ai-gateway/admin/manage-gateways.adoc[Manage Gateways]
*** xref:ai-agents:ai-gateway/admin/networking-configuration.adoc[Networking Configuration]
*** xref:ai-agents:ai-gateway/admin/configure-policies.adoc[Configure Policies]
*** xref:ai-agents:ai-gateway/admin/access-controls.adoc[Access Controls]
*** xref:ai-agents:ai-gateway/admin/observability-admin.adoc[Monitor Usage]
*** xref:ai-agents:ai-gateway/admin/integrations/index.adoc[Integrations (Admin)]
** For Builders
*** xref:ai-agents:ai-gateway/builders/builder-overview.adoc[Builder Overview]
*** xref:ai-agents:ai-gateway/builders/discover-gateways.adoc[Discover Gateways]
*** xref:ai-agents:ai-gateway/builders/connect-your-agent.adoc[Connect Your Agent]
*** xref:ai-agents:ai-gateway/builders/available-models.adoc[Available Models]
*** xref:ai-agents:ai-gateway/builders/use-mcp-tools.adoc[Use MCP Tools]
*** xref:ai-agents:ai-gateway/builders/monitor-your-usage.adoc[Monitor Your Usage]
*** xref:ai-agents:ai-gateway/builders/integrations/index.adoc[Integrations (Builder)]
** Reference
*** xref:ai-agents:ai-gateway/reference/gateway-architecture.adoc[Architecture Deep Dive]
*** xref:ai-agents:ai-gateway/reference/cel-routing-cookbook.adoc[CEL Routing Cookbook]
*** xref:ai-agents:ai-gateway/reference/mcp-aggregation-guide.adoc[MCP Aggregation Guide]
*** xref:ai-agents:ai-gateway/reference/observability-logs.adoc[Request Logs]
*** xref:ai-agents:ai-gateway/reference/observability-metrics.adoc[Metrics and Analytics]
```

---

## Implementation Priority

### Phase 1: Critical Path (Do First)
1. **Create index.adoc** - Persona router (HIGH)
2. **Create discover-gateways.adoc** - Critical Builder need (HIGH)
3. **Create what-is-ai-gateway.adoc** - Entry point (HIGH)
4. **Split quickstart** into admin/setup-guide.adoc and builders/connect-your-agent.adoc (HIGH)

### Phase 2: Complete User Journeys
1. Create admin/manage-gateways.adoc (MEDIUM)
2. Create builders/available-models.adoc (MEDIUM)
3. Create admin/networking-configuration.adoc (MEDIUM)
4. Create admin/access-controls.adoc (MEDIUM)
5. Update observability pages with persona distinctions (MEDIUM)

### Phase 3: Polish and Optimize
1. Refactor gateway-architecture.adoc (MEDIUM)
2. Update mcp-aggregation-guide.adoc with Builder sections (LOW)
3. Create admin/builder overview pages (LOW)
4. Reorganize integrations folders (LOW)
5. Update all cross-references (LOW)

---

## Mapping to User Journey

### Admin Journey → Content
| Journey Step | Content |
|--------------|---------|
| What is an AI gateway? | what-is-ai-gateway.adoc |
| How do I create, list, and manage gateways? | admin/setup-guide.adoc, admin/manage-gateways.adoc |
| Networking configuration & Gateway creation | admin/networking-configuration.adoc |
| Configure which models are accessible | admin/setup-guide.adoc (enable models section) |
| Configure access and routing policies | admin/configure-policies.adoc, cel-routing-cookbook.adoc |
| Track usage and configure budgeting | admin/setup-guide.adoc (budgets), observability-metrics.adoc |

### Builder Journey → Content
| Journey Step | Content |
|--------------|---------|
| What is an AI gateway? | what-is-ai-gateway.adoc |
| Discover which AI gateways my agents have access to | **builders/discover-gateways.adoc (NEW)** |
| How do I integrate my agent? | builders/connect-your-agent.adoc |
| What models/tools are available? | builders/available-models.adoc, builders/use-mcp-tools.adoc |
| Test my integration | builders/connect-your-agent.adoc (validation section) |
| Track my usage | builders/monitor-your-usage.adoc → observability-logs.adoc |

---

## Key Principles

1. **Persona First:** Content should clearly identify which persona it serves
2. **Progressive Disclosure:** Start simple, link to advanced topics
3. **Minimize Duplication:** Use xrefs to avoid maintaining same content twice
4. **Clear Entry Points:** Index page must route users effectively
5. **Discovery is Critical:** Builders MUST be able to find available gateways

---

## Success Metrics

After implementation, evaluate:
- Can a Builder discover available gateways in <2 minutes?
- Can an Admin complete setup in <15 minutes?
- Do users report clearer distinction between Admin vs Builder tasks?
- Reduced support tickets about "I can't find which gateway to use"

---

## Open Questions

1. **API for Gateway Discovery:** Does the API support listing accessible gateways per user?
2. **RBAC Model:** How granular is access control (workspace, gateway, model level)?
3. **Private Networking:** What's the detailed setup for private endpoints?
4. **Budgets and Limits:** Can Builders see their own usage/limits, or only Admins?
5. **Integration Folders:** Should we physically split integration files into admin/ and builders/ subdirectories?

---

## Next Steps

1. **Review this plan** with product and docs team
2. **Validate API capabilities** for gateway discovery
3. **Create Phase 1 content** (index, discover-gateways, what-is, split quickstart)
4. **Test with users** from each persona
5. **Iterate based on feedback**

---

## Appendix: File Operations Summary

### New Files to Create
- `ai-gateway/index.adoc` (replace existing minimal one)
- `ai-gateway/what-is-ai-gateway.adoc`
- `ai-gateway/admin/admin-overview.adoc`
- `ai-gateway/admin/setup-guide.adoc`
- `ai-gateway/admin/manage-gateways.adoc`
- `ai-gateway/admin/networking-configuration.adoc`
- `ai-gateway/admin/configure-policies.adoc`
- `ai-gateway/admin/access-controls.adoc`
- `ai-gateway/builders/builder-overview.adoc`
- `ai-gateway/builders/discover-gateways.adoc` ⭐ CRITICAL
- `ai-gateway/builders/connect-your-agent.adoc`
- `ai-gateway/builders/available-models.adoc`
- `ai-gateway/builders/use-mcp-tools.adoc`
- `ai-gateway/builders/monitor-your-usage.adoc`

### Files to Move
- `ai-gateway/gateway-architecture.adoc` → `ai-gateway/reference/gateway-architecture.adoc`
- `ai-gateway/cel-routing-cookbook.adoc` → `ai-gateway/reference/cel-routing-cookbook.adoc`
- `ai-gateway/mcp-aggregation-guide.adoc` → `ai-gateway/reference/mcp-aggregation-guide.adoc`
- `ai-gateway/observability-*.adoc` → `ai-gateway/reference/observability-*.adoc`

### Files to Refactor
- `ai-gateway/gateway-quickstart.adoc` (quickstart) - split content between admin and builder paths
- `ai-gateway/gateway-architecture.adoc` - extract conceptual content to what-is page
- `ai-gateway/observability-logs.adoc` - add persona-specific sections
- `ai-gateway/observability-metrics.adoc` - add builder usage section

### Files to Keep As-Is (Minimal Changes)
- `ai-gateway/integrations/*-admin.adoc`
- `ai-gateway/integrations/*-user.adoc`
- `ai-gateway/migration-guide.adoc`
- `ai-gateway/gateway-quickstart.adoc` (consolidated)
