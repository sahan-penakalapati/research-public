# Neo Cloud — Deep Research Strategy Memo (Draft v1)

_Date: 2026-03-24_

## 1-page Executive Summary

**Thesis:** A new category is emerging: **on-access cloud for autonomous agents**. Existing offerings solve parts of the stack (agent runtime, cloud execution, or payments), but do not yet provide an integrated control plane where agents can **discover capabilities, buy execution in real time, run safely, and prove settlement with receipts**.

**Why now:**
- Agent runtimes are becoming persistent and multi-channel (example: Hermes agent docs/repo).
- Cloud substrates can host agent workloads with elastic scaling and sandboxing (Cloud Run, Modal, Daytona).
- Stripe/Tempo’s **Machine Payments Protocol (MPP)** introduces a standard machine-payment flow over HTTP 402 and related SDK patterns.

**Gap:** No dominant product combines:
1. agent-native identity + spend policy,
2. machine-payment orchestration,
3. capability registry/marketplace,
4. safe execution fabric,
5. auditable receipts + governance.

**Definition (new concept):**
> **Neo Cloud** is the economic and execution layer for autonomous agents — a policy-governed, payment-native cloud where agents can access compute/tools/data on demand and settle usage programmatically.

**Recommended strategy:**
- Build a **hybrid architecture**: centralized policy/audit + federated execution providers.
- Start with one beachhead use case: **paid tool execution for coding/research agents**.
- GTM: PLG for developers + design partners for enterprise governance requirements.
- Partner motion: Stripe/MPP ecosystem, runtime/framework integrations (OpenClaw/Hermes class), execution partners (serverless/sandbox), observability partners.

---

## 1) Product Spec

### 1.1 Vision
Enable agents to transact for cloud resources and digital capabilities as naturally as APIs call APIs.

### 1.2 Problem Statement
Today, agent builders stitch together disparate systems:
- runtime orchestration,
- cloud provisioning,
- billing/payment handling,
- governance controls,
- audit logging.

This causes brittle integrations, poor cost governance, and weak trust/compliance in autonomous execution.

### 1.3 Jobs To Be Done (JTBD)
1. **As an agent builder**, I want my agent to pay for capabilities per action without manual checkout flows.
2. **As a platform team**, I want strict budget/policy controls for autonomous spending.
3. **As an enterprise security lead**, I need receipts, audit trails, and replayable events for every paid action.
4. **As a capability provider**, I want to monetize API/tool execution directly to agents with minimal integration work.

### 1.4 ICPs & Personas

| ICP | Primary Persona | Trigger | Buying Criteria |
|---|---|---|---|
| AI-native startups | Founding engineer | Need low-friction monetized agent infra | Fast integration, transparent pricing |
| Developer tool vendors | PM/Platform lead | Want to sell capabilities to agents | Distribution + payment rails |
| Mid-market/enterprise platforms | Platform architect + Security | Need governed autonomous workflows | Policy, audit, RBAC, compliance |

### 1.5 Core User Journeys
1. Agent requests paid capability.
2. Neo Cloud resolves endpoint + price/policy.
3. If payment required, challenge issued (MPP-style flow).
4. Agent wallet authorizes under policy constraints.
5. Execution occurs in approved runtime/sandbox.
6. Receipt returned, verified, persisted in audit ledger.
7. Memory/context updates for future decisions.

### 1.6 MVP vs V2 vs V3

**MVP (0–6 months)**
- Identity + wallet with spend caps
- MPP-compatible gateway
- Capability registry (curated)
- 2 execution backends (serverless + sandbox)
- Basic audit/receipts dashboard

**V2 (6–18 months)**
- Federated provider onboarding
- Marketplace listings + SLA metadata
- Fine-grained policy engine (org/user/agent scope)
- Cost optimization and routing

**V3 (18–36 months)**
- Cross-cloud settlement optimization
- Reputation graph for agents/providers
- Intent-level procurement (automatic provider selection)

### 1.7 Functional Requirements
- Capability discovery API
- Payment challenge/credential/receipt flow support
- Budget limits, approvals, allow/deny policies
- Execution orchestration across multiple providers
- Durable event + receipt logging
- Webhook/event stream for ops systems

### 1.8 Non-Functional Requirements
- p95 authz+routing latency < 200ms (pre-execution)
- 99.9% control plane availability (MVP target)
- Idempotent payment and execution semantics
- End-to-end traceability and tamper-evident logs
- Tenant isolation and key management

### 1.9 API Surface (Sketch)
- `POST /v1/capabilities/search`
- `POST /v1/intents` (agent intent + constraints)
- `POST /v1/payments/challenge`
- `POST /v1/payments/authorize`
- `POST /v1/executions`
- `GET /v1/receipts/{id}`
- `POST /v1/policies/evaluate`

### 1.10 Pricing & Packaging
- **Developer:** usage-based + free monthly credits
- **Growth:** platform fee + usage pass-through + policy features
- **Enterprise:** annual contract + governance/compliance add-ons

Potential monetization layers:
1. take-rate on capability transactions,
2. orchestration fee,
3. enterprise governance SKU.

### 1.11 Success Metrics
- North-star: **Paid Agent Actions / Day (PAAD)**
- Gross payment volume through Neo Cloud
- Provider activation rate
- Failed payment/execution rate
- Policy violation prevention rate
- Enterprise expansion (seats/orgs/annual spend)

---

## 2) Architecture Choices

### 2.1 Options & Tradeoffs

| Option | Pros | Cons | Verdict |
|---|---|---|---|
| Fully centralized | Strong control/audit consistency | Vendor lock-in perception, scaling bottlenecks | Not ideal long-term |
| Fully federated | Open ecosystem, provider autonomy | Fragmented policy/audit UX | High complexity early |
| **Hybrid (recommended)** | Central trust/policy plane + federated execution | More integration work than centralized MVP | **Best balance** |

### 2.2 Recommended Architecture (Hybrid)

**Control Plane (centralized):**
- Identity & wallet service
- Policy engine
- Capability metadata index
- Payment orchestration and receipt verification
- Observability and audit ledger

**Execution Plane (federated):**
- Provider-specific executors (serverless, GPU, sandbox, data APIs)
- Standardized contract for request/response/receipt metadata

### 2.3 Core Components
1. **Identity/Wallet**: agent identities, budget scopes, delegated authorization.
2. **MPP Gateway**: challenge/credential/receipt mediation.
3. **Capability Registry**: pricing, SLA, geography, compliance tags.
4. **Execution Fabric**: adapters for runtime backends.
5. **Policy Engine**: spend, data, jurisdiction, risk rules.
6. **Audit/Observability**: immutable event stream, traces, receipts.
7. **Memory Plane**: contextual state (optional customer-managed mode).

### 2.4 Data Model (minimum)
- `Agent`, `Organization`, `Wallet`, `BudgetPolicy`
- `Capability`, `Provider`, `PriceQuote`
- `Intent`, `Execution`, `PaymentChallenge`, `PaymentReceipt`
- `AuditEvent`, `PolicyDecision`

### 2.5 Trust Model
- Signed challenges and receipts
- Idempotency keys for payment+execution coupling
- Least-privilege scoped credentials
- Human-in-the-loop thresholds for high-risk actions

### 2.6 Security & Abuse Controls
- Risk scoring for agent/payment patterns
- Velocity limits and dynamic spend clamps
- Provider reputation and quarantine modes
- Prompt/tool provenance logging for forensic analysis

### 2.7 Compliance/Governance
- SOC2-first architecture pathway
- Regional data residency controls
- Full receipt retention and export
- Enterprise RBAC and approval workflows

### 2.8 Build vs Buy Matrix

| Component | Build | Buy/Partner | Recommendation |
|---|---|---|---|
| Payment rails | No | Stripe/MPP ecosystem | Partner |
| Policy engine core | Yes | OPA-style optional | Build + integrate |
| Execution infra | Partial | Cloud/sandbox partners | Hybrid |
| Observability | Partial | Datadog/Honeycomb class | Buy + extend |
| Agent runtime | No | Integrate with existing runtimes | Partner |

---

## 3) GTM Strategy

### 3.1 Positioning
**Neo Cloud = Agent Commerce + Agent Execution Infrastructure**

Not “just another cloud” and not “just another framework.”

### 3.2 Messaging Pillars
1. **On-access everything** for agents.
2. **Policy-first autonomy**.
3. **Receipts and trust by default**.
4. **Multi-provider, no hard lock-in**.

### 3.3 Competitive Landscape (simplified)
- **Hyperscalers:** strong infra, weak agent commerce abstraction.
- **Agent frameworks:** strong orchestration, weak payment/governance layer.
- **GPUaaS/neoclouds:** strong compute economics, weak end-to-end agent lifecycle.

### 3.4 Beachhead Wedge
Start with **paid tools for coding/research agents**:
- clear ROI,
- measurable spend governance,
- high frequency transactions.

### 3.5 3-Phase GTM

**Phase 1 (0–6 months):**
- Dev-focused launch, SDK-first
- 10–20 lighthouse teams
- Publish reference integrations

**Phase 2 (6–18 months):**
- Expand capability marketplace
- Introduce enterprise governance SKU
- Co-sell with strategic partners

**Phase 3 (18–36 months):**
- Vertical solutions (finops, support ops, research ops)
- International expansion + compliance footprints
- Ecosystem certification program

### 3.6 Sales Motion
- Start PLG: self-serve + credits + templates
- Layer enterprise sales for governance-heavy deals
- Land-and-expand by adding more paid capabilities/org policies

---

## 4) Partner Strategy

### 4.1 Ecosystem Map
1. **Payments:** Stripe/MPP ecosystem
2. **Execution:** serverless/GPU/sandbox vendors
3. **Runtime frameworks:** OpenClaw/Hermes class and others
4. **Model providers:** API inference partners
5. **Observability/security:** logging, SIEM, fraud/risk tools
6. **Data/API providers:** premium datasets/tools

### 4.2 Priority by Phase

| Phase | Partner Type | Why First |
|---|---|---|
| 0–6 mo | Payments + runtime | Prove core transaction loop |
| 6–18 mo | Execution + observability | Reliability + enterprise readiness |
| 18–36 mo | Vertical ISVs + global partners | Distribution + defensibility |

### 4.3 Integration Strategy
- Protocol: HTTP + MPP-compatible payment flow
- Agent interop: MCP-compatible tool interfaces where relevant
- SDKs: TypeScript first, Python next, then polyglot

### 4.4 Commercial Models
- Transaction rev-share for paid capabilities
- Referral fees for execution providers
- Co-sell agreements for enterprise bundles
- Marketplace take-rate with transparent pass-through

### 4.5 Risks & Mitigations
- **Protocol volatility**: adapter abstraction + versioned gateways
- **Partner concentration**: multi-provider by design
- **Fraud/abuse**: progressive trust tiers and spending controls
- **Unit economics drift**: dynamic routing + margin guardrails

---

## Evidence vs Interpretation

### Evidence (from external sources)
- MPP docs and quickstart indicate machine payment flows with HTTP 402 and preview Stripe integration paths.
- mpp.dev positions MPP as an open standard with SDK/docs for challenge-credential-receipt flows.
- Hermes materials describe persistent, cloud-portable agent operation.
- Cloud Run, Modal, Daytona materials indicate cloud execution and sandbox capabilities for agent-like workloads.

### Interpretation (this memo’s synthesis)
- The product gap is not raw compute, but integrated **economic control + safe execution for agents**.
- A hybrid architecture is likely optimal for trust + ecosystem scale.
- Beachhead should prioritize high-frequency paid tool calls with clear ROI.

---

## 90-Day Action Plan

### Days 0–30
- Finalize product requirements and trust model
- Build minimal control plane skeleton
- Implement one MPP-compatible payment loop
- Ship 2 execution adapters (serverless + sandbox)

### Days 31–60
- Launch private alpha with 5–10 design partners
- Add policy templates (budget, region, provider allowlist)
- Build receipts/audit dashboard v1
- Start partner pipeline for capability providers

### Days 61–90
- Ship developer SDK + docs + quickstarts
- Run pricing experiments (take-rate vs orchestration fee)
- Publish benchmark report (latency, failure modes, policy blocks)
- Prepare enterprise readiness checklist (SOC2 roadmap, RBAC, exports)

---

## Open Questions (Critical)
1. Is Neo Cloud positioned as a marketplace, control plane, or both from day one?
2. How much payment surface should be abstracted vs exposed to developers?
3. What default risk model determines autonomous spend limits?
4. What partner concessions are acceptable early to bootstrap liquidity?
5. Which vertical (coding/research/support/finops) provides fastest PMF signal?

---

## Source List (primary where possible)
- Stripe MPP docs: https://docs.stripe.com/payments/machine/mpp
- Stripe MPP quickstart: https://docs.stripe.com/payments/machine/mpp/quickstart
- MPP overview: https://mpp.dev/
- Hermes docs: https://hermes-agent.nousresearch.com/docs/
- Hermes repo: https://github.com/NousResearch/hermes-agent
- Google Cloud Run agents: https://docs.cloud.google.com/run/docs/ai-agents
- Modal cold starts: https://modal.com/docs/guide/cold-start
- Daytona overview: https://www.daytona.io/
- Neocloud context: https://www.voltagepark.com/blog/neoclouds-the-next-generation-of-ai-infrastructure
- Neocloud context: https://drivenets.com/resources/education-center/what-are-neocloud-providers/

---

_Notes:_ This is a draft strategy memo synthesized from available web-accessible sources. Some Stripe MPP materials appear in preview state and may change; design should account for protocol and API evolution.
