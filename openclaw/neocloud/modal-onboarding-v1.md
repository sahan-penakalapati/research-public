# Modal Onboarding v1 for NeoCloud-Governed Agent Execution

## Goal
Set up Modal as a **compute substrate** under NeoCloud-style governance (grants, approvals, budgets, audits), without giving unrestricted autonomous infra control.

---

## 1) Workspace & environment layout

Create two Modal environments/projects:
- `neocloud-dev` (default)
- `neocloud-prod` (restricted)

Policy:
- Agent defaults to `neocloud-dev`
- Any `prod` write/deploy action requires explicit approval

---

## 2) Token & access model (least privilege)

### Recommended identities
- **Owner token**: full admin (you only)
- **Agent token (dev)**: limited to dev project operations
- **Agent token (prod)**: optional later, tightly constrained, approvals-only

### Minimum initial permissions for agent token
- Run existing jobs/functions in `neocloud-dev`
- Read logs/metrics for those runs
- Access only explicitly scoped secrets

Avoid initially:
- broad org-level admin
- unrestricted deploy permissions to prod
- cross-project secret read

---

## 3) Secret management

Use per-job/per-function secrets, not global shared secret bundles.

Rules:
- no raw keys in prompts/chat
- secrets injected only at execution time
- separate secret sets by environment (`DEV_*`, `PROD_*`)
- rotate leaked/posted credentials immediately

---

## 4) Budget guardrails (match NeoCloud policy)

Start with:
- per action cap: **$3**
- daily cap: **$20** (agent)
- monthly cap: **$200** (workspace)

Behavior:
- if estimate exceeds cap -> require approval
- if real spend exceeds cap -> stop + alert + require approval

---

## 5) Approval policy mapping

### Auto-allow (Tier 0)
- read/list/status/log retrieval
- dry-run plans

### Approval required (Tier 1)
- deploy/update function
- run compute job above low-cost threshold
- external side effects (email/webhook)

### Synchronous approval (Tier 2)
- destructive operations
- production writes
- payment-adjacent operations

---

## 6) First 3 safe pilot jobs on Modal

## Job A: `research_fetch_and_summarize`
Purpose:
- fetch specified sources
- summarize into markdown report

Constraints:
- output only to whitelisted workspace paths
- no external side effects
- time limit + retry limit

## Job B: `daily_market_scan`
Purpose:
- periodic market/news scan
- structured digest output

Constraints:
- scheduled in dev first
- fixed source allowlist
- bounded runtime and token usage

## Job C: `batch_doc_parse`
Purpose:
- parse PDFs/docs to structured JSON/markdown

Constraints:
- input path allowlist
- max file size/pages per run
- no outbound posting by default

---

## 7) Observability & audit requirements

Log these fields per run:
- `timestamp`
- `task_id`
- `agent_id`
- `environment`
- `capability`
- `approval_state`
- `estimate_cost_usd`
- `actual_cost_usd`
- `result_status`
- `artifact_path`

Keep immutable event logs for:
- request
- approval/denial
- execution start/end
- spend deltas

---

## 8) Rollout plan (practical)

### Phase 1 (Day 1)
- create dev project + limited token
- wire one pilot job (`research_fetch_and_summarize`)
- enforce budget + audit logging

### Phase 2 (Days 2–4)
- add 2 more jobs
- tune resource limits and retries
- validate cap enforcement and approval flow

### Phase 3 (Week 2)
- introduce restricted prod path
- keep approvals mandatory for prod writes/deploys
- define incident/rollback runbook

---

## 9) Incident controls

Must-have switches:
- global pause for all agent-triggered jobs
- revoke active grants/tokens
- approvals-only mode
- emergency secret rotation

---

## 10) Operator checklist (for you)

Before enabling agent write actions:
- [ ] Dev/prod separation enabled
- [ ] Limited agent token created
- [ ] Budget caps configured
- [ ] Approval workflow tested
- [ ] Audit log fields verified
- [ ] Kill switch tested

---

## 11) Clear boundary (important)

Modal handles: compute execution.

NeoCloud policy layer handles:
- who can do what
- under which approval and budget constraints
- with what audit guarantees

That boundary is your strategic advantage.
