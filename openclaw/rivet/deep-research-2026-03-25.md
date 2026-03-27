# Deep Research: Rivet (rivet.dev)

**Date:** 2026-03-25  
**Scope:** Product, technical architecture, ecosystem traction, competitive context, and implications for OpenClaw/NeoCloud positioning.

---

## Executive summary

Rivet has evolved into a **stateful compute primitive** play centered on “actors” (long-running processes with in-memory state + durable persistence + scheduling + queues + realtime events). Their positioning is closer to **Cloudflare Durable Objects + developer ergonomics + self-hostability**, with explicit AI-agent use cases but broader applicability (collaboration, workflows, per-tenant state, chat, etc.).

From an OpenClaw/NeoCloud angle:
- Rivet is **not primarily an access-control plane**.
- Rivet is a strong candidate for the **execution substrate** beneath agents.
- Their newer `sandbox-agent` project addresses coding-agent API fragmentation and could overlap with agent orchestration stacks.

Bottom line: Rivet looks like a credible infrastructure layer to partner/integrate with—not a direct replacement for a delegated capability + approval + budget governance product.

---

## 1) What Rivet is (current identity)

Rivet describes itself as:
- “The primitive for stateful workloads”
- “Rivet Actors are long-running, lightweight processes designed for stateful workloads”
- Applicable to AI agents, workflows, collaboration, chat, and more

Key primitives they emphasize:
- in-memory state + persistence
- queues
- scheduling
- workflows/retries
- websocket/realtime event streaming
- scale-to-zero / hibernation model

**Interpretation:** Their center of gravity is runtime infrastructure for stateful execution, not policy/governance.

---

## 2) Product surface and packaging

From repository/docs messaging, Rivet appears to have three modes:

1. **Library-first local dev** (`rivetkit`)  
   - Run actors in-process during local development.

2. **Self-hosted engine**  
   - Single Rust binary / Docker options.
   - Mentions support for Postgres, filesystem, or FoundationDB depending on component/runtime.

3. **Managed cloud offering**  
   - Hosted option with global edge positioning.

Other notable ecosystem signals:
- `rivetkit` SDKs listed for TypeScript, plus experimental Rust/Python client references.
- Inspector/debug tooling is a major part of their developer narrative.

---

## 3) Architecture clues (public claims)

Public materials (README + HN posts + org repos) indicate:
- actor model with durable state and evented execution
- Rust-heavy engine components (orchestration, routing, execution subsystems)
- strong messaging around observability/debuggability
- historical roots in multiplayer/realtime infra and now broader stateful workload framing

The HN post from the founder claims:
- production usage at significant scale in prior runtime context
- actor infrastructure inspired by Durable Objects but with self-host/open flexibility
- stack references including Rust, V8 isolates, FoundationDB

**Caveat:** Some benchmarking and architecture claims are self-published and should be treated as directional until independently validated.

---

## 4) Traction and momentum signals (GitHub/public)

Snapshot observed during this research:
- `rivet-dev/rivet`: **~5.3k stars**, active updates
- `rivet-dev/rivetkit`: **~1.2k stars**
- `rivet-dev/sandbox-agent`: **~1.1k stars**

Interpretation:
- strong early developer interest for a newer infra platform
- meaningful adjacent momentum in coding-agent tooling (`sandbox-agent`)
- likely still in rapid iteration phase rather than fully stabilized enterprise platform maturity

---

## 5) The `sandbox-agent` angle (important)

Rivet’s `sandbox-agent` project targets a real market pain: heterogeneous APIs for coding agents (Codex, Claude Code, OpenCode, Cursor, Amp, Pi), remote control from isolated sandboxes, and standardized event/session streaming.

Why this matters for OpenClaw/NeoCloud:
- potential overlap in “agent runtime plumbing” and session mediation
- potential complement if used as lower-layer execution + transcript/event normalization
- could accelerate multivendor coding-agent interoperability

What it does **not** appear to do by default:
- opinionated delegated approval governance, risk-tier policy, and budget ledger controls (your NeoCloud wedge)

---

## 6) Competitive map (high-level)

### A) Compared to Cloudflare Durable Objects
- Similarity: actor-style stateful compute pattern.
- Rivet differentiation claim: open-source, self-host flexibility, wider runtime/deployment control.
- Durable Objects advantage: massive edge footprint + ecosystem maturity.

### B) Compared to Temporal
- Temporal core: durable workflow orchestration semantics and replay-driven reliability.
- Rivet core: stateful actor runtime with realtime + co-located mutable state ergonomics.
- They overlap on “durable/stateful workflows,” but developer mental models differ.

### C) Compared to LangGraph
- LangGraph: agent orchestration framework/runtime focused on graphed agent workflows and human-in-loop patterns.
- Rivet: lower-level stateful runtime substrate for arbitrary workloads (including agents).
- Possible stack: LangGraph-like orchestration on top of Rivet-like stateful infra.

---

## 7) Implications for NeoCloud strategy

Your NeoCloud thesis (delegated capability control plane) remains differentiated if you stay explicit:

### Keep this boundary crisp
- **Rivet solves runtime/stateful execution.**
- **NeoCloud solves delegated permissions/governance/economic controls across tools and infra.**

### Integration opportunity
Position NeoCloud as the governance layer that can sit above multiple runtimes, including Rivet:
- per-agent identity and principal mapping
- capability grants (scoped/time-bounded)
- approval and escalation
- budget policy and spend ledger
- audit log normalization across heterogeneous runtimes/connectors

### Strategic risk to watch
If runtime vendors (Rivet or others) move upstack into policy + delegated approvals + cross-provider budget controls, overlap increases. Defensibility improves if NeoCloud is runtime-agnostic and connector-rich.

---

## 8) Due-diligence checklist before committing deeply

1. **Performance validation**
   - Reproduce startup/memory/latency claims in your own benchmark harness.

2. **Reliability semantics**
   - Failure modes, exactly-once/at-least-once behavior, replay/idempotency guidance.

3. **Data model and tenancy isolation**
   - Multi-tenant boundaries, encryption, secret handling, key management.

4. **Operational maturity**
   - Upgrade paths, backup/restore, observability export, incident response posture.

5. **License and lock-in profile**
   - OSS coverage vs managed-only features.

6. **Sandbox-agent production readiness**
   - Auth model hardening, event schema stability, audit export, compatibility drift across supported coding agents.

---

## 9) Recommended next move (for OpenClaw/NeoCloud)

Run a 2-track evaluation:

- **Track A: Technical fit spike (1–2 weeks)**
  - Build one realistic stateful agent workflow on Rivet.
  - Measure lifecycle, durability, stream quality, and debugging experience.

- **Track B: Governance overlay prototype**
  - Put NeoCloud-style grant/approval/budget/audit controls in front of that workflow.
  - Validate that your governance UX remains compelling regardless of runtime.

Success criterion: If runtime can be swapped while governance UX/value remains intact, your moat is healthy.

---

## Sources

Primary / official
1. https://rivet.dev  
2. https://github.com/rivet-dev/rivet  
3. https://github.com/rivet-dev/rivet/blob/main/README.md  
4. https://github.com/rivet-dev/sandbox-agent  
5. https://sandboxagent.dev/docs  

Community / external context
6. https://news.ycombinator.com/item?id=42472519  
7. https://news.ycombinator.com/item?id=37433218  

Comparative references
8. https://developers.cloudflare.com/durable-objects/  
9. https://docs.temporal.io/workflow-execution  
10. https://docs.langchain.com/oss/python/langgraph/overview

---

## Notes on confidence

- High confidence: Rivet’s current product framing, actor/runtime capabilities, and open-source footprint.
- Medium confidence: relative performance/comparative superiority claims (many are self-published).
- Medium confidence: long-term roadmap direction (subject to rapid product evolution).
