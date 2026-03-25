# EasyCloud / NeoCloud — Product Thesis & Phase 1 Plan

## One-line positioning
EasyCloud is the delegated access control plane for AI agents: identity-bound, time-limited, budgeted permissions across cloud and SaaS, with human approvals and full audit trails.

## Problem
Teams want agents to perform real actions (provision infra, call APIs, send emails, trigger workflows), but current options force bad tradeoffs:
- long-lived shared credentials
- weak traceability
- poor budget control
- no consistent approval path for risky actions

This blocks safe production deployment of agent workflows.

## What EasyCloud is
An **agent-native gateway + delegated capability control plane** that gives:
- per-agent identity
- scoped, temporary, revocable grants
- approval/escalation for high-risk actions
- unified policy + budget enforcement
- end-to-end auditability
- one branded interface (`easy` / EasyCloud), instead of raw provider keys

## What EasyCloud is not
- not just remote compute
- not just an MCP gateway
- not just a connector catalog
- not a cloud reseller
- not a generic OAuth broker

## Mental model
- **Owner**: controls infrastructure, integrations, policy, and spend
- **Agent**: separate principal that requests and uses capabilities
- **Capability**: narrow action (e.g., `digitalocean.vm.create`)
- **Grant**: temporary scoped permission given to an agent
- **Approval**: explicit owner confirmation for elevated actions
- **Budget**: cost and usage constraints for action execution
- **Connector**: provider-specific adapter implementation
- **Audit record**: immutable event trail for each request/decision/action

## ICP (Phase 1)
### Primary customer
Technical teams already running agents in real workflows:
- OpenClaw / Hermes users
- Codex / Claude Code / Pi power users
- founders and engineering teams building multi-agent systems

### Strong fit signals
- already using multiple agents/sessions
- touching real systems (infra + SaaS)
- clear pain around permissions, budgets, and traceability

### Anti-ICP (for now)
- hobby users with no real-world actions
- teams that only need a local sandbox
- orgs seeking enterprise procurement features before core workflow validation

## Canonical user flow (delegated mode)
1. Agent registers with EasyCloud in delegated mode.
2. Agent discovers available capabilities.
3. Agent receives task requiring missing permissions.
4. Agent requests specific capabilities (scoped + duration + estimated cost).
5. Owner approves in browser via approval URL + one-time code.
6. EasyCloud issues active grant(s) with policy and budget limits.
7. Agent executes actions through EasyCloud connectors.
8. Every step is logged (request, approval/denial, execution, spend).

Example approval prompt:
> I need approval for:
> - DigitalOcean VM create
> - email send
>
> Open: https://app.easycloud.dev/approve
> Code: 731044

## Phase 1 scope (must all be true)
- Agent can register in delegated mode
- Agent can discover capabilities
- Agent can request missing access
- Owner can approve from browser
- EasyCloud can issue active grants
- Agent can execute OpenRouter calls under budget
- Agent can create **one** DigitalOcean VM after approval
- Agent can send **one** email after approval
- Stripe charge requires synchronous owner approval
- Every action is present in audit log
- Ledger shows estimated vs actual spend
- End-to-end flow uses EasyCloud interface only (no raw provider creds)

## Phase 1 non-goals
- enterprise SSO / SCIM
- multi-tenant org hierarchy with advanced RBAC
- full marketplace of connectors
- generalized policy DSL beyond required controls
- autonomous high-risk financial actions without human approval

## Success metrics
- **Activation**: % of registered agents completing first approved delegated action
- **Time to first approval**: request → owner approved
- **Time to first successful task**: from setup to successful end-to-end action
- **Safety**: denied high-risk actions executed without approval (target: 0)
- **Governance**: % actions with complete audit records (target: 100%)
- **Cost control**: budget violations per 100 tasks

## Why now
- Agent capabilities are rising faster than governance primitives.
- Teams are moving from demo agents to production workflows.
- Existing stacks are fragmented across cloud creds, tool connectors, and ad hoc policy.

EasyCloud’s wedge is simple: make delegated agent action safe by default.

## Open questions
- What is the exact default grant duration and revocation model?
- Should approvals be per-task, per-capability, or policy-template based?
- Which connector trio should be first-class after DO + email + OpenRouter?
- What minimum audit schema is enough for trust without slowing velocity?
