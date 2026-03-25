# Neo Cloud Deep Research (Half-Day)

Date: 2026-03-24  
Prepared for: Sahan  
Scope: New concept from scratch — product spec, architecture choice, GTM, and partner strategy  
Working concept: **Neo Cloud**

## 1) Executive Summary

Neo Cloud should be built and positioned as a **machine-payable cloud control plane for autonomous agents**, not as a generic serverless platform.

Core thesis:
- Agents need on-access compute, tools, and data.
- Current infrastructure platforms provide runtime primitives but not a unified machine-native payment + policy + settlement loop.
- Stripe’s Machine Payments Protocol (MPP) and adjacent standards make this timing favorable.

Recommended strategy:
- Build **control-plane first** (identity, policy, metering, payment orchestration, ledger).
- Use pluggable execution providers initially; selectively internalize runtimes later for margin/SLA/moat.
- Go to market via high-frequency, clearly metered workloads (browser sessions, sandboxes, paid APIs).

---

## 2) Research Basis and Signals

### 2.1 Stripe + MPP signal strength

Primary sources indicate MPP is now a concrete protocol direction for machine-to-machine payments:
- Stripe announcement: Introducing the Machine Payments Protocol (MPP), co-authored with Tempo.
- Stripe docs: machine payments in private preview with explicit MPP and x402 guides.
- Flow model: HTTP 402 payment-required challenge, client pays, retries with credential, service returns resource + receipt path.

References:
- https://stripe.com/blog/machine-payments-protocol
- https://docs.stripe.com/payments/machine
- https://docs.stripe.com/payments/machine/mpp
- https://docs.stripe.com/payments/machine/x402
- https://mpp.dev

### 2.2 Adjacent protocol landscape

- ACP (Agentic Commerce Protocol): oriented toward commerce/checkout coordination between buyer, agent, merchant.
- x402: open, internet-native payment challenge flow for HTTP resources.

References:
- https://www.agenticcommerce.dev
- https://x402.org

### 2.3 Runtime landscape snapshot

Current leaders are strong on execution, security isolation, and autoscaling but are generally weak on first-class machine-native payment orchestration as a product primitive:
- E2B (sandbox runtime)
- Daytona (fast sandboxes, stateful execution)
- Modal (serverless compute/GPU)
- Fly Machines (fast-launching VMs)
- Cloudflare Workers (global serverless runtime)

References:
- https://e2b.dev
- https://e2b.dev/pricing
- https://www.daytona.io
- https://www.daytona.io/pricing
- https://modal.com
- https://fly.io/docs/machines/
- https://developers.cloudflare.com/workers/

---

## 3) Problem Statement

### 3.1 Current failure mode for agents

Autonomous agents can plan and execute tasks, but paid resource access is fragmented:
- Compute in one place
- Tool/API access elsewhere
- Billing externalized
- Governance bolted on later

This causes:
- account/API-key friction for autonomous tasks
- weak spend governance
- poor microtransaction economics
- poor auditability and difficult settlement reconciliation

### 3.2 Neo Cloud opportunity

Create a unified machine-native loop:

**Request → Payment challenge → Pay → Execute → Receipt → Audit/Settlement**

If Neo owns this loop, it becomes infrastructure-critical to both agent platforms and paid service providers.

---

## 4) Product Spec (Neo Cloud v0.1)

### 4.1 Product definition

Neo Cloud is a machine-payable execution fabric where agents can discover, invoke, and pay for compute/tools/data on demand with policy-bound autonomy.

### 4.2 Personas

1. Agent platform teams (Hermes/OpenClaw-style builders)
2. API/tool/data providers monetizing agent traffic
3. Enterprise AI teams requiring auditability, budgets, and approval controls

### 4.3 Core jobs-to-be-done

1. Let agents run secure tasks on-demand without pre-negotiated human onboarding each time.
2. Let providers monetize per invocation/session with machine-verifiable receipts.
3. Let operators cap, monitor, and govern autonomous spend and actions.

### 4.4 v0.1 capabilities

1) Agent Identity + Access
- Agent keys and scoped credentials
- Budget envelopes and spend scopes
- Policy-aware routing

2) Payment Orchestration (MPP-first)
- 402 challenge issuance/handling
- Credential verification
- Retry orchestration
- Receipt binding to execution/job/session IDs

3) Execution Fabric
- Ephemeral sandbox tier
- Stateful workspace tier
- Optional special tiers (GPU/browser/network-heavy)

4) Metering + Settlement
- Fine-grained usage telemetry (CPU/GPU/time/network/tool calls)
- Charge policy engine (per-call/per-second/session)
- Reconciliation ledger + exports

5) Trust and Governance
- Policy DSL (allowed tools/domains/actions)
- Spend velocity/risk controls
- Approval workflows + kill switches

6) Developer Experience
- SDKs (Python/TS)
- API payment middleware
- Test harness with simulated payments/receipts

### 4.5 Non-goals (initial)

- Not a full hyperscaler replacement
- Not broad marketplace first
- Not trying to own all checkout commerce (ACP can complement later)

---

## 5) Architecture Choice

## Recommended: Control-plane-first + pluggable execution

### Why this choice

Pros:
- Fastest time to market
- Lowest capex risk
- Strongest immediate differentiation (payment-aware orchestration + governance)
- Lets Neo aggregate supply from multiple runtimes

Cons:
- Early dependency on third-party runtime suppliers
- Must build strong abstraction + observability

### 5.1 Logical architecture

1. Identity & Policy Gateway
- AuthN/AuthZ for agents and providers
- Policy evaluation, budget checks, risk checks

2. Payment Protocol Engine
- MPP adapter (primary)
- x402 adapter (secondary/fallback)
- Normalized internal payment event model

3. Metering Kernel
- Runtime usage ingest
- Deterministic charge computation
- Receipt linkage and validation

4. Execution Adapters
- Neo-managed pools (where differentiation is critical)
- Third-party adapter layer for elasticity

5. Ledger + Observability
- Append-only transaction/audit stream
- Cost-performance-risk dashboards
- Reconciliation and settlement operations

### 5.2 Build-vs-buy boundaries

Build in-house now:
- policy engine
- payment orchestration
- metering model
- ledger/reconciliation
- SDK/runtime adapter contracts

Buy/partner now:
- broad execution capacity and specialized infra where faster than in-house

Internalize later:
- high-margin/high-control runtime verticals (e.g., browser or secure code workloads)

---

## 6) Market Positioning and GTM

### 6.1 Positioning statement

"Neo Cloud is the machine-payable cloud control plane for autonomous agents."

Avoid positioning as:
- "cheaper serverless"
- "another sandbox provider"

### 6.2 Wedge use cases

1. Paid browser automation sessions
2. Secure code execution tasks
3. Premium data/API invocations

These have:
- high action frequency
- clear per-use value
- strong need for audit + spend controls

### 6.3 ICP (ideal customer profile)

- Agent product teams with meaningful daily autonomous action volume
- API/tool businesses seeing rising agent traffic and monetization pressure
- Enterprises piloting autonomous workflows but blocked by governance/compliance concerns

### 6.4 Commercial model

1. Infrastructure margin (compute pass-through + Neo premium)
2. Payment orchestration fee (bps or fixed per machine-payment event)
3. Governance/compliance tier (enterprise add-on)
4. Optional marketplace take-rate (post v1)

### 6.5 KPI framework

Adoption:
- active paying agents
- active paid endpoints/providers

Economics:
- machine payment volume (GMV-like)
- net revenue per 1k paid requests

Reliability:
- paid request success rate
- p95 end-to-end request latency
- reconciliation mismatch/error rate

Risk:
- prevented overspend incidents
- policy violation detection + response time

---

## 7) Partner Strategy

### 7.1 Partner tiers

Tier 1: Payment/protocol anchors
- Stripe machine payments ecosystem
- Tempo ecosystem where needed

Tier 2: Runtime supply partners
- E2B, Daytona, Modal, Fly/Workers-like infrastructure adapters

Tier 3: Demand/distribution
- Agent framework maintainers
- Agent IDE ecosystems

Tier 4: Trust/compliance/security
- Identity, KMS, SIEM/observability, approvals/governance tooling

### 7.2 Partner principles

1. Neo remains source of truth for policy/metering/settlement state.
2. Maintain multi-runtime + multi-protocol optionality (avoid lock-in).
3. Co-sell around monetization uplift and governance, not just compute cost.

### 7.3 First partner motion (90 days)

- 3 design partners on demand side (agent platforms)
- 3 supply partners (runtime/tool providers)
- 1 protocol/payment anchor integration narrative
- deliver public case studies with measurable conversion and settlement metrics

---

## 8) Key Risks and Mitigations

1) Protocol maturity risk (MPP early/private preview)
- Mitigation: protocol abstraction; support MPP first with x402 compatibility path.

2) Regulatory/geographic complexity
- Mitigation: region-aware payment policies and routing constraints.

3) Autonomous overspend/security incidents
- Mitigation: mandatory spend envelopes, anomaly controls, approval gates, kill switches.

4) Hyperscaler competition risk
- Mitigation: own machine-payment control plane + deep ecosystem integrations + governance moat.

5) Runtime dependency risk
- Mitigation: multi-provider adapters and selective first-party runtime verticalization.

---

## 9) 12-Month Roadmap

### Q1
- MPP-native end-to-end flow (challenge/pay/retry/receipt)
- Ephemeral sandbox + browser execution SKUs
- Policy and spend controls v1

### Q2
- Runtime adapter ecosystem expansion
- Ledger/reconciliation operator console
- Design partner proof points

### Q3
- Enterprise package (approval flows, audit APIs, tenancy options)
- x402 compatibility layer
- Early provider marketplace primitives

### Q4
- Intelligent routing (cost/latency/risk-aware)
- Anomaly/risk modeling improvements
- Verticalized GTM in 2–3 high-value domains

---

## 10) Recommended Decision

Proceed with Neo Cloud as a control-plane-first, machine-payable infrastructure product.

Sequence:
1. Win the protocol + policy + metering + settlement layer.
2. Prove high-frequency paid agent workloads in production.
3. Expand supply network and selectively internalize runtime for margin/control.

This approach maximizes speed, preserves strategic flexibility, and creates defensible moat in the agent economy.

---

## Appendix: Selected Source Links

- https://stripe.com/blog/machine-payments-protocol
- https://docs.stripe.com/payments/machine
- https://docs.stripe.com/payments/machine/mpp
- https://docs.stripe.com/payments/machine/x402
- https://mpp.dev
- https://docs.tempo.xyz
- https://www.agenticcommerce.dev
- https://x402.org
- https://e2b.dev
- https://e2b.dev/pricing
- https://www.daytona.io
- https://www.daytona.io/pricing
- https://modal.com
- https://fly.io/docs/machines/
- https://developers.cloudflare.com/workers/
