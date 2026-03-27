# NeoCloud Config Pack for Hermes (Delegated Agent Mode)

Date: 2026-03-25
Owner: Sahan

## Goal
Run Hermes in a delegated, policy-first mode aligned with NeoCloud:
- least privilege
- explicit approvals for risky actions
- budget guardrails
- auditable execution

## 1) Operating Profile
Default behavior:
- Read/plan by default
- Ask before write/execute on external systems
- Never expose raw credentials in prompts/responses
- Prefer smallest execution surface that satisfies task

Execution surface preference order:
1. local read-only analysis
2. short-lived coderun/sandbox
3. VM only when persistence/network/process longevity is required

## 2) Capability Tiers
Tier A — auto-allow (low risk)
- search/read/analyze files
- web research and summarization
- dry-run commands that do not mutate external systems
- metrics/log inspection

Tier B — async approval required
- create VM/sandbox resources
- send external email/messages
- deploy non-destructive preview/staging actions
- write operations to third-party APIs (non-monetary)

Tier C — synchronous approval mandatory
- payments (charge/refund/settlement impact)
- destructive infra changes (delete/terminate/drop)
- privilege escalation / key rotation / policy bypass
- public endpoint exposure with sensitive data paths

## 3) Budget Guardrails
Required controls per task:
- max_runtime_minutes
- max_estimated_cost_usd
- hard_stop_on_budget_exceed=true

Workspace controls:
- daily_budget_usd (owner-defined)
- per-action soft warning at 70%
- hard stop at 100%

Report fields on completion:
- estimated_cost_usd
- actual_cost_usd (if available)
- runtime_minutes
- actions_executed_count

## 4) Approval Contract (Message Template)
When approval is needed, agent should return:
- action(s) requested
- risk class
- budget impact estimate
- rollback path (if any)
- approval token/link/code

Template:
"I need approval for:
- <action_1>
- <action_2>
Risk class: <B|C>
Estimated impact: <$X, Y mins>
Rollback: <how>
Approve to continue: <link/code>"

## 5) Modal Usage Policy
Default Modal policy:
- CPU only
- no GPU unless explicitly requested
- timeout per run (10–20 min baseline)
- no long-lived workers unless explicitly requested
- no public endpoint deployment unless approved

Modal run report must include:
- image/env used
- command executed
- runtime
- estimated cost
- output artifact locations

## 6) Audit Log Contract
Every non-trivial action should capture:
- timestamp
- requester
- agent identity
- capability used
- approval status
- budget before/after
- result status
- relevant artifact links

## 7) Phase-1 Done Criteria (Operational)
- delegated registration works
- capability discovery works
- missing-access request works
- browser approval works
- temporary grant issuance works
- budget enforcement works
- audit logs complete and queryable

## 8) Practical Notes for Current Hermes Runtime
Current Hermes doesn’t natively enforce full NeoCloud policy objects at platform level.
So this pack should be treated as the active operating contract the agent follows during execution.

Recommended next implementation step:
- add a lightweight policy middleware/tool that intercepts tool calls and enforces Tier A/B/C + budget before execution.
