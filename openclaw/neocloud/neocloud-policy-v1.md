# NeoCloud Policy v1 (Owner + Agent Governance)

## Purpose
This policy defines how the assistant (agent) can act on behalf of the owner across cloud/services safely.

## Principals
- **Owner**: Controls billing, infrastructure, integrations, policy decisions.
- **Agent**: Separate principal with delegated, time-bound permissions.

## Core Rules
1. No long-lived raw credentials in prompts/chat.
2. All privileged actions require explicit capability grants.
3. Grants are scoped, time-limited, and revocable.
4. Every execution is audited with estimated and actual cost.
5. Fail closed on policy, budget, or approval uncertainty.

## Environments
- `dev` (default): agent can run approved low-risk tasks.
- `prod`: always stricter; requires explicit approvals for all write actions.

## Capability Catalog (initial)
- `compute.modal.run_job`
- `compute.modal.deploy_function`
- `cloud.digitalocean.vm.create`
- `email.send`
- `payments.stripe.charge`

Each capability must specify:
- scope/constraints
- max action count
- allowed targets (if applicable)
- grant TTL

## Risk Tiers
### Tier 0 (auto-allow)
Read-only and low-risk operations:
- list/read/status/reporting
- dry-run planning

### Tier 1 (approval required)
Potentially impactful actions:
- creating VMs
- deploying functions
- sending outbound emails

### Tier 2 (synchronous approval required)
High-risk/financial/destructive actions:
- charging payments
- deleting infrastructure/resources
- production data mutations

## Budgets
- Per-action cap: **$3** (default)
- Daily agent cap: **$20**
- Monthly workspace cap: **$200**

If any cap is exceeded: deny and request owner approval.

## Modal-Specific Guardrails
- Use dedicated Modal token scoped to this assistant.
- Start in `dev` workspace/project.
- Restrict secret access per job/function.
- Keep low concurrency initially.
- Require approval for deploy/update in `prod`.

## Grant Lifecycle
1. Agent requests missing capability with reason + estimate.
2. Owner approves/denies (with optional constraints).
3. System issues grant token with TTL and limits.
4. Agent executes.
5. Audit trail records all events.
6. Grant auto-expires; owner can revoke anytime.

## Required Audit Fields
- timestamp
- owner_id
- agent_id
- task_id
- capability
- grant_id
- decision (approved/denied/auto-allowed)
- estimate_cost_usd
- actual_cost_usd
- execution_result

## Safety Switches
- Global pause (stop all agent executions)
- Revoke all active grants
- Force approvals-only mode

## Operating Defaults
- Default to least privilege.
- Default to `dev`.
- Default to dry-run for new workflows.
- Escalate to owner when uncertain.
