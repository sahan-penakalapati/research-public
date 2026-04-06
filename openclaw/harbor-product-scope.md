# Harbor Product Scope

## The Hook
**"Control panel for AI agents"** — one dashboard, one CLI, everything your agents need to build, deploy, and operate.

---

## Market Context

### The Opportunity
- Claude Code hit $2.5B ARR by Feb 2026; 41% of professional devs use it
- 75% of small companies adopted Claude Code (higher than enterprise)
- Only 23% of devs use AI agents regularly — massive gap between tools and agents
- 81% concerned about security/privacy with agents

### The Gap
Current landscape is fragmented:
- **Connectors**: Composio, Merge, Nango — 100-500+ app integrations, MCP support
- **Observability**: Langfuse, LangSmith, Braintrust, Helicone — tracing, cost tracking
- **Deployment**: Manual per-platform (Vercel, Modal, DO, etc.)
- **Guardrails**: Ad-hoc or non-existent

**No one owns the full stack.** Developers juggle 3-5 tools just to let agents do basic infra work.

---

## Product Vision

### What Harbor Does
A unified CLI + dashboard that gives agents:
1. **Infrastructure access** — Modal, DigitalOcean, E2B, etc. through one interface
2. **App connectors** — Composio-style integrations (GitHub, Slack, Linear, etc.)
3. **Search & retrieval** — Parallel, EXA, web search built-in
4. **Observability** — every call logged, cost tracked, anomalies flagged
5. **Guardrails** — budgets, approval flows, rate limits, rollback

### Who It's For
Primary: **Individual developers using Claude Code, Cursor, or similar agents**
- Indie hackers building side projects
- Early-stage startup founders shipping fast
- Developers who want agents to handle infra grunt work

Secondary: Small teams (2-10 engineers) adopting agent workflows

### Who It's NOT For
- Enterprises (initially) — too much procurement friction
- Platforms embedding it as infrastructure — Harbor is developer-installed
- Non-technical users — this is a dev tool

---

## Competitive Positioning

| Competitor | What They Do | What They Miss |
|------------|--------------|----------------|
| Composio | 500+ app connectors, MCP | No infra, no observability, no guardrails |
| Langfuse/LangSmith | Tracing, cost tracking | No connectors, no infra, no CLI for agents |
| Modal/DO direct | Compute/sandbox | Per-platform auth, no unified control |
| Vercel/Railway | Deployment | No agent-native interface, no guardrails |
| Zapier/n8n | Automation | Not agent-first, not dev-tool vibes |

**Harbor's wedge**: Be the ONE thing a developer installs to give their agent full infra + connector + observability access with guardrails.

---

## Core Features (MVP)

### Tier 1: Must Have
1. **CLI for agent tool access**
   - `harbor deploy` — auto-detect techstack, pick platform, deploy
   - `harbor run <script>` — execute in sandbox (Modal/DO/E2B)
   - `harbor search <query>` — Parallel/EXA/web search
   - `harbor connect <service>` — OAuth to GitHub, Slack, Linear, etc.

2. **Dashboard for connections**
   - Add API keys for Modal, DO, etc.
   - OAuth flows for SaaS connectors
   - One place to revoke, rotate, audit

3. **Observability basics**
   - Every CLI call logged
   - Cost per call (tokens, compute, API fees)
   - Session-level spend tracking
   - Simple anomaly alerts (e.g., "agent spent $50 in 10 min")

4. **Basic guardrails**
   - Daily/weekly budget caps
   - Rate limits per connector
   - Kill switch (disable agent access instantly)

### Tier 2: Should Have
5. **CI/CD integration**
   - `harbor ci deploy` — deploy on PR merge
   - Auto-detect framework (Next.js, FastAPI, etc.)
   - Platform abstraction (write once, deploy anywhere)

6. **Approval workflows**
   - High-spend actions require confirmation
   - Destructive ops (delete DB, etc.) blocked by default
   - Slack/Discord notifications for approvals

7. **Agent self-fixing**
   - Monitor deployed services
   - Trigger agent on errors/health check failures
   - Auto-rollback on repeated failures

### Tier 3: Nice to Have
8. **Team features**
   - Shared connections
   - Team budgets
   - Audit logs

9. **Hosted compute**
   - Bring your own keys OR use Harbor-hosted
   - Markup on underlying infra (Modal/DO)

10. **Marketplace**
    - Pre-built agent skills for common tasks
    - "One-click deploy a cron job that monitors X"

---

## Go-To-Market: Who First

### Primary Target: Claude Code Power Users
**Profile:**
- Individual devs or tiny teams (1-3 people)
- Already using Claude Code or Cursor daily
- Frustrated by managing multiple API keys
- Want agents to do more but worried about cost/control

**Where to find them:**
- r/ClaudeAI, r/LocalLLaMA, r/aiagents
- Claude Code Discord servers
- Hacker News (Show HN posts about agent tools)
- Twitter/X AI dev community

**Messaging:**
> "Stop juggling API keys. Give your Claude Code agent one CLI to deploy, search, and connect to everything — with cost tracking and guardrails built in."

### Secondary Target: Indie Hackers Building AI Products
**Profile:**
- Building AI-powered apps or agents
- Need compute (Modal/DO) + connectors (Composio-style)
- Cost-sensitive, want visibility

**Where to find them:**
- Indie Hackers forum
- YC community (W24, S24 batches)
- Product Hunt AI tools

**Messaging:**
> "Ship faster. Your agent can deploy to production, connect to 100+ tools, and self-monitor — all through Harbor."

### NOT the First Target: Enterprises
- Long sales cycles
- Security/compliance requirements
- Existing vendor relationships
- Too early for this segment

---

## Pricing Model (Directional)

**Individual (PLG wedge):**
- Free tier: 100 calls/day, 3 connectors, basic logs
- Pro: $20-29/mo — unlimited calls, 10+ connectors, full observability, guardrails

**Team (later):**
- $50-100/mo per seat
- Shared connections, team budgets, audit logs

**Hosted infra:**
- Pass-through cost + 10-20% markup
- Or bring your own keys (no markup)

**Principle:** Match Claude Code's pricing ($20/mo individual) — be an obvious add-on.

---

## Differentiation Strategy

### vs. Composio
- "Composio gives connectors. Harbor gives connectors + infra + observability + guardrails."

### vs. Langfuse/LangSmith
- "Langfuse tells you what happened. Harbor lets your agent DO things safely."

### vs. Platform CLIs (Vercel, DO, Modal)
- "Modal is great for Modal. Harbor is great for whichever platform you pick — and you can switch."

### vs. Zapier/n8n
- "Zapier connects apps. Harbor gives your agent hands to build and operate software."

---

## Key Risks

1. **Scope creep** — trying to do too much, MVP never ships
2. **Platform lock-in** — if Modal/DO change APIs, breakage risk
3. **Commoditization** — Composio adds observability, Langfuse adds connectors
4. **Agent adoption gap** — if only 23% use agents, is the market big enough?

### Mitigation
- Ship narrow MVP fast (connectors + observability + basic guardrails)
- Focus on Claude Code users specifically — they're already agent-native
- Build platform abstraction early but don't over-engineer
- Watch competitor moves; stay ahead on developer experience

---

## Success Metrics (First 6 Months)

1. **1,000 developers** installed CLI
2. **100 weekly active users** making 10+ calls/week
3. **50 paying customers** at $20-29/mo
4. **5 case studies** of devs shipping faster with Harbor
5. **Zero major security incidents**

---

## Next Steps

1. **Validate the wedge** — interview 10 Claude Code power users about pain points
2. **Scope MVP v1** — connectors (3-5 services) + observability + guardrails only
3. **Build "magic moment"** — 5-minute install to first agent deployment
4. **Ship to 20 beta users** — iterate fast
5. **Launch on HN/Reddit** with "Show HN: Harbor — control panel for Claude Code agents"

---

## Open Questions

1. Should hosted compute be day-1 or post-MVP?
2. Which 3-5 connectors are table stakes? (GitHub, Linear, Slack, ???)
3. Approval workflow: CLI-native or dashboard-first?
4. Agent awareness: does Claude Code need config changes, or auto-detect?
5. What's the viral loop? (Invite teammates? Share deployments?)

---

*Last updated: 2026-04-06*
*Next review: After first 10 user interviews*
