# EasyCloud v2 — Agent Capability Control Plane (NeoCloud Direction)

Date: 2026-03-25  
Author: Hermes (rewrite based on Easy cloud Notion draft + Neo Cloud research)

## 1) One-line thesis
EasyCloud should be built and positioned as a machine-payable capability control plane for AI agents, with remote compute as one capability class (not the core identity).

## 2) Problem statement
Current agent stacks are strong at reasoning but weak at safe execution.

The common failure mode:
- Agents hold overly broad credentials.
- Permissions are static rather than task-scoped.
- Sensitive actions are under-governed.
- Spend control is weak or reactive.
- Audits are fragmented across providers.

This creates operational and trust risk:
- Security risk (credential oversharing)
- Cost risk (runaway actions)
- Compliance risk (insufficient evidence trails)
- Reliability risk (tool sprawl and unclear control boundaries)

## 3) Product definition
EasyCloud is an agent-native delegated execution layer that gives each agent:
- its own identity
- temporary scoped grants
- policy-enforced approvals
- budget-aware execution
- complete audit trails

Core promise:
Request → policy check → (optional approval) → time-boxed grant → execution → metering → ledgered audit.

## 4) What EasyCloud is and is not
## What it is
- A capability control plane for agent actions
- A policy and grant system for delegated execution
- A governance layer for autonomous work across tools/providers

## What it is not
- Not just a remote compute launcher
- Not just an MCP gateway
- Not just a connector catalog
- Not a cloud reseller
- Not a generic OAuth broker

## 5) Mental model (canonical objects)
- Owner: controls policy, spend limits, approvals, and integrations
- Agent: independent principal that executes tasks
- Capability: narrow action scope (e.g., create_vm, send_email, call_openrouter)
- Grant: temporary permission bound to capability + constraints
- Approval: owner-mediated elevation for risky actions
- Budget: hard and soft spending controls
- Connector: provider integration implementation
- Audit Event: append-only execution and decision records

## 6) Trust and policy model
Default stance: deny-by-default, grant-by-need.

Policy dimensions:
- Action scope (what)
- Resource scope (where)
- Time scope (how long)
- Cost scope (how much)
- Risk class (what requires approval)

Approval classes:
1) Auto-allow (low-risk, in-policy, under budget)
2) Async approval (medium-risk, reversible actions)
3) Sync approval (high-risk, irreversible or monetary actions)

Examples:
- create temporary VM: async approval
- send external email: async/sync by policy
- charge Stripe card: sync approval mandatory

## 7) Execution surfaces (capability classes)
Execution is an implementation layer beneath the control plane:

- Coderun: short-lived tool execution
- Sandbox: interactive/dev/test workspace
- VM: long-lived, stateful machine semantics

Selection logic should be policy + task intent driven, not user guesswork.

### VM thesis (when VM is the right primitive)
Use VM when the task needs one or more of:
- long runtime
- stable host identity/IP
- persistent disk
- daemon/process longevity
- custom networking/proxies
- full SSH/server-like workflows

Public VM SKUs should stay simple:
- vm/small
- vm/standard
- vm/performance

Backend note:
- GCP is strong for suspend/stop semantics and heavy infra workflows.
- DigitalOcean is strong for simpler lease-style boxes and straightforward operation.

## 8) User flow (Phase 1 target)
1) Agent registers in delegated mode.
2) Agent discovers available capabilities.
3) Agent encounters missing permission.
4) Agent requests grant with machine-readable reason + constraints.
5) Owner reviews and approves in browser.
6) EasyCloud issues scoped temporary grant.
7) Agent executes action(s) under budget and policy.
8) All actions, approvals, and spend deltas are logged to ledger.

Example interaction:
User: “Create a temporary VM and email me details.”
Agent response (if missing permission):
- Needs approval for create_vm + send_email
- Provides approval link and short code
After approval: task continues without sharing raw provider credentials.

## 9) Ideal customer profile
Primary ICP:
- Teams already running agents in production-like workflows
- Builders using Hermes/OpenClaw/Codex/Claude-style loops
- Teams with permission and audit pain, not just compute pain

Early buyer signals:
- Existing incidents from over-privileged agents
- Compliance or SOC pressure around traceability
- Budget surprises from autonomous execution
- Manual approval bottlenecks slowing agent usage

## 10) Phase 1 scope and success criteria
Phase 1 is complete only if all are true:
1) Agent can register as delegated principal.
2) Agent can discover capabilities through EasyCloud.
3) Agent can request missing access.
4) Owner can approve in browser.
5) EasyCloud can issue active temporary grants.
6) Agent can execute OpenRouter calls under budget policy.
7) Agent can create one DigitalOcean VM after approval.
8) Agent can send one email after approval.
9) Agent cannot execute Stripe charge without synchronous approval.
10) Every action is captured in audit log.
11) Estimated and actual spend are both visible in ledger.
12) Flow works without exposing raw provider credentials to agent prompts.

## 11) Non-goals for Phase 1
- Full marketplace of all connectors
- Broad enterprise IAM replacement
- Multi-provider VM orchestration parity
- Advanced cost optimization engine
- Fully autonomous finance actions without human checkpoints

## 12) Metrics that matter (first operating dashboard)
Product integrity metrics:
- % actions executed with scoped grants
- % actions blocked by policy before execution
- % risky actions requiring approval

Trust metrics:
- approval turnaround time (p50/p95)
- irreversible-action incident count
- audit completeness rate

Economic metrics:
- estimated vs actual spend variance
- budget breach prevention rate
- cost per successful delegated task

Adoption metrics:
- active delegated agents per workspace
- capabilities used per agent per day
- repeated approvals converted into reusable policy rules

## 13) Competitive positioning
Positioning sentence:
EasyCloud is the delegated capability and payment-aware control plane for autonomous agents.

Against runtime-only tools (E2B/Daytona/Modal/Fly-style categories):
- They are execution-first.
- EasyCloud should be governance + delegated trust first, execution second.

Against cloud-control products (Clanker Cloud-style direction):
- EasyCloud focus should stay narrow and opinionated around agent delegation primitives:
  identity, grants, approval routing, budget constraints, auditable execution.

## 14) GTM wedge
Start with high-frequency, high-risk-enough actions where trust controls are visibly valuable:
- create ephemeral infra for tests
- invoke paid model/tool APIs under strict budget envelopes
- execute external communication or provider actions behind approval gates

Land with:
- one agent framework integration
- one VM provider integration
- one communication action (email)
- one monetary high-risk action with mandatory synchronous approval

Expand to:
- richer connector set
- policy templates by role/use-case
- tighter ledger + compliance exports

## 15) Final recommendation
Keep the EasyCloud message crisp:
- Primary: “safe delegated capability control plane for agents.”
- Secondary: “compute/tool execution surfaces behind that control plane.”

If messaging drifts toward generic remote compute, differentiation weakens.
If messaging stays anchored on delegated trust, policy, budget, and audit, EasyCloud can own a durable control-plane category in agent infrastructure.
