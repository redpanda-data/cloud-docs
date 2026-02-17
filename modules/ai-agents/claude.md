# AI Agents Documentation Rules

## Scope of This File

This file provides **ai-agents module-specific guidance** for writing introduction paragraphs. It supplements—but does not replace—the general documentation standards provided by the docs-team-standards plugin.

**Use docs-team-standards plugin for:**
- General writing style, voice, and tone
- Page templates: `/plan`, skill templates (page-templates)
- Antora conventions: xrefs, partials, navigation (antora-conventions)
- Learning objectives: Bloom's taxonomy (learning-objectives)
- General documentation patterns: topic splitting, source verification, etc.

**Use this claude.md for:**
- ai-agents-specific requirement: outcome-focused, executive-friendly introductions
- Introduction paragraph patterns by topic type (concepts, how-to, overview, etc.)
- Module-specific examples from ai-agents pages

## Universal Principle: Outcome-Focused Introductions

**ALL ai-agents pages must focus on outcomes, not just features.** This module serves both evaluators (CIOs, VPs) and builders (developers, admins). Even technical pages should lead with value: what can you accomplish, what problems does this solve, what business value does it provide.

All introductions should:
- Lead with outcomes or value propositions
- Use plain language alternatives for jargon where possible
- Explain "why" before diving into "how"
- Focus on capabilities and results, not just mechanics

## Introduction Styles by Page Type

### Concepts Pages (4-5 sentences, ~100 words)

**Structure:** What-How-Coverage-Value-Foundation

1. State what Redpanda provides (capability)
2. Explain mechanism in accessible terms
3. Describe scope with specific examples
4. List concrete organizational outcomes
5. Reference technical standards/architecture

**Key principles:**
- Use plain language ("write-once record" not "immutable record")
- Include technical depth (OpenTelemetry, Raft, 100% sampling)
- Lead with value, not implementation
- Address all personas: evaluators, developers, admins, engineers

**Example (concepts.adoc):**
> Redpanda provides complete observability and governance for AI agents through automated transcript capture. Every agent execution—from simple tool calls to complex multi-agent, multi-turn workflows—generates a permanent, write-once record stored on Redpanda's distributed log. This captures all agent reasoning, tool invocations, model interactions, and data flows with 100% sampling and no gaps. Organizations gain the ability to debug agent behavior, identify performance bottlenecks, meet regulatory compliance requirements, and maintain accountability for AI-driven decisions. Transcripts leverage OpenTelemetry standards and Raft-based consensus for correctness, establishing a trustworthy foundation for agent governance.

### How-To Pages (1-2 sentences, ~30-50 words)

**Structure:** What you can accomplish + Why you'd do it (NO implementation details)

**Key principles:**
- Action-oriented, inviting language ("Use X to..." or "You can...")
- Focus on capability and value only
- Avoid duplication with page body
- No steps, commands, or configuration

**Examples:**
- transcripts.adoc: "Use the Transcripts view to filter, inspect, and debug agent execution records. Filter by operation type, time range, or service to isolate specific executions, then drill into span hierarchies to trace request flow and identify where failures or performance bottlenecks occur." (40 words)
- ingest-custom-traces.adoc: "You can extend Redpanda's transcript observability to custom agents built with frameworks like LangChain or instrumented with OpenTelemetry SDKs. By ingesting traces from external applications into the `redpanda.otel_traces` topic, you gain unified visibility across all agent executions, from Redpanda's declarative agents, Remote MCP servers, to your own custom implementations." (52 words)

### Other Topic Types

| Type | Length | Structure | Example |
|------|--------|-----------|---------|
| **overview** | 2 paragraphs, ~80-100 words | Problem framing (use rhetorical questions) + Solution (how it solves problems, key capabilities) | "As AI agents evolve from experimental prototypes to business-critical systems, companies face new challenges. How do you ensure reliability? How do you maintain control over costs and compliance?<br><br>Redpanda ADP solves these problems by bringing together key capabilities: a solid data foundation, over 300 proven connectors, and a declarative approach..." |
| **tutorial/quickstart** | 1-2 sentences, ~25-40 words | What you'll build/learn. Meta-language okay ("This quickstart helps you...") | "This quickstart helps you build your first AI agent in Redpanda Cloud. You'll create an agent that understands natural language requests and uses MCP tools to generate and publish event data." |
| **best-practices** | 1-2 sentences, ~15-30 words | Imperative tone, outcome-focused | "Write system prompts that produce reliable, predictable agent behavior. Good prompts define scope, specify constraints, and guide tool usage." |
| **troubleshooting** | 1 sentence, ~15-25 words | Direct problem scope. Meta-language okay | "This page helps you diagnose and fix common issues when building and running Remote MCP servers." |
| **cookbook** | 1 sentence + xrefs, ~20-30 words | Context + navigation to related content | "When building tools, use these patterns as starting points for common scenarios. For step-by-step instructions, see xref:[]. For design guidelines, see xref:[]." |
| **guide** | Same as overview | Problem-solution framing, 2 paragraphs, executive-friendly | Use overview principles |
| **reference** | 1 sentence, ~10-20 words | What the reference covers, extremely brief | Focus on scope of reference material |

## Quick Reference Table

| Page Type | Length | Key Characteristics |
|-----------|--------|---------------------|
| `concepts` / `concept` | 4-5 sentences, ~100+ words | What-How-Coverage-Value-Foundation, executive-friendly |
| `overview` | 2 paragraphs, ~80-100 words | Problem + solution, rhetorical questions, business outcomes |
| `how-to` | 1-2 sentences, ~30-50 words | Action-oriented, no implementation details |
| `tutorial` / `quickstart` | 1-2 sentences, ~25-40 words | What you'll build/learn, meta-language okay |
| `best-practices` | 1-2 sentences, ~15-30 words | Imperative, outcome-focused |
| `troubleshooting` | 1 sentence, ~15-25 words | Problem-solving scope, meta-language okay |
| `cookbook` | 1 sentence + xrefs, ~20-30 words | Context + related content links |
| `guide` | 2 paragraphs, ~80-100 words | Same as overview |
| `reference` | 1 sentence, ~10-20 words | Scope of reference |

**All types must be outcome-focused and executive-friendly per the universal principle.**

## Anti-Patterns to Avoid

### Universal (All Page Types)

- ✗ Vague timeframes: "operations lasting minutes to days"
- ✓ Specific examples: "from simple single-turn requests to complex multi-day workflows"

- ✗ Buried value: "Redpanda stores data in a log. This provides benefits."
- ✓ Value-first: "Redpanda provides [benefit] by storing data in a log."

- ✗ Implementation-first: "Using OpenTelemetry, Redpanda captures..."
- ✓ Outcome-first: "Redpanda captures... leveraging OpenTelemetry standards"

- ✗ Features without outcomes: "Transcripts include reasoning, tool calls, and model interactions."
- ✓ Features with outcomes: "This captures all agent reasoning, tool invocations, and model interactions, enabling debugging and accountability."

### How-To Specific

- ✗ Implementation steps in intro: "First, deploy a Connect pipeline. Then configure your agent..."
- ✗ Duplicating body content: Explaining same config details that appear in first section
- ✗ Meta-language: "This guide shows you how to...", "This page explains..." (Exception: tutorials/troubleshooting)
- ✗ Conceptual background: Save for concepts pages, link instead
- ✗ Too long: 3+ sentences with implementation details

## Writing Principles

These principles are **specific to ai-agents introductions**. For general writing guidance, see docs-team-standards skills.

**Plain language with technical depth:**
- "write-once record" not "immutable record"
- "permanent record" not "durable storage"
- But DO include: OpenTelemetry, Raft, A2A, MCP, 100% sampling

**Be specific, not vague:**
- ✓ "simple tool calls to complex multi-agent, multi-turn workflows"
- ✗ "operations that may last from minutes to days"

**Lead with value:**
- Answer: What can you accomplish? What problems does this solve?
- Then explain: How it works, technical foundations
