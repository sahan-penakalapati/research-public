# NeoCloud Enforcement Flow (Logs, Billing, Budgets)

## Objective
Enforce safe agent execution with hard budget controls, approval gating, and immutable audit trails.

## Core Principle
Agents never execute privileged compute actions directly with provider credentials.
All execution must pass through a policy/budget enforcement gateway.

## Request Lifecycle
1. Agent submits capability request with:
   - capability
   - scope
   - environment
   - reason
   - estimated cost
2. Policy engine validates capability and risk tier.
3. Approval engine checks if approval is required.
4. Budget ledger performs atomic pre-authorization (reservation).
5. Execution broker dispatches the job (e.g., Modal).
6. Runtime events stream into audit log.
7. Actual usage/cost is reconciled and posted to ledger.
8. Reservation is settled (capture/release delta).

## Enforcement States
- `REQUESTED`
- `POLICY_ALLOWED` / `POLICY_DENIED`
- `APPROVAL_REQUIRED`
- `APPROVED` / `DENIED`
- `BUDGET_RESERVED` / `BUDGET_BLOCKED`
- `EXECUTION_STARTED`
- `EXECUTION_FINISHED` / `EXECUTION_FAILED`
- `COST_RECONCILED`
- `SETTLED`

## Mandatory Guards
- Fail closed on:
  - unknown capability
  - missing approval where required
  - budget reserve failure
  - missing audit write
- No side effects before budget reservation.
- No provider call without grant + request_id correlation.

## Budget Model
Three hard caps:
- per action
- daily per agent
- monthly per workspace

Flow:
- Reserve estimated amount before execution.
- On completion, capture actual and release excess reserve.
- If actual > cap/tolerance, trigger alert + optional auto-pause.

## Billing Reconciliation
Two-step accounting:
1. `estimate` at request time
2. `actual` from provider usage API/logs

If provider usage is delayed:
- mark run `pending_reconciliation`
- keep conservative reserve until timeout policy
- retry reconciliation job

## Logging & Audit
Every transition emits append-only audit events.

Required event families:
- capability request/decision
- approval request/decision
- budget reserve/capture/release/block
- execution start/finish/fail
- cost estimate/actual/reconcile

## Safety Switches
- `GLOBAL_PAUSE` stops all new executions.
- `APPROVALS_ONLY_MODE` forces approvals for all writes.
- `REVOKE_ALL_GRANTS` invalidates active tokens/grants.
- `PROD_WRITE_LOCK` blocks production mutation actions.

## Alerting
Trigger alerts on:
- 50/80/100% budget thresholds
- any Tier-2 request
- missing reconciliation SLA
- failed audit write attempts
- repeated denied attempts for same capability

## Modal-Specific Enforcement
- Modal credentials live only in broker/gateway.
- Agent receives no raw provider token.
- Broker injects narrowly scoped runtime secrets.
- Broker tags every run with request_id/task_id for cost reconciliation.

## Recommended Initial Defaults
- per_action_usd: 3
- daily_agent_usd: 20
- monthly_workspace_usd: 200
- reconciliation_sla_minutes: 60
- default_grant_ttl_minutes: 60
