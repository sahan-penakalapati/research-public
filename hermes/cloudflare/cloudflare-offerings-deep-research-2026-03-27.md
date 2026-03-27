# Cloudflare Offerings Deep Research (2026)

Date: 2026-03-27  
Prepared for: Sahan Penakalapati  
Scope: Cloudflare product landscape, with deep focus on Containers, Sandbox SDK, and Dynamic Workers

## 1) Executive summary

Cloudflare has evolved from a CDN/WAF company into a full-stack edge cloud: network + security + zero trust + developer compute + data + AI.

The most important shift for AI-native builders is that Cloudflare now offers three distinct isolation/compute primitives:

1. Workers (isolate-first serverless)
2. Dynamic Workers (runtime-created isolates for untrusted/generated code)
3. Containers / Sandbox SDK (VM-isolated Linux runtime for heavier workloads)

Practical interpretation:
- Dynamic Workers = fastest “sandboxed code execution” primitive when code can stay in Worker-compatible runtime.
- Containers = heavier, Linux-native runtime for binaries, filesystem-heavy tools, and broader runtime compatibility.
- Sandbox SDK = productized “secure code execution platform” built on Containers + Durable Objects + Workers.

For an AI-agent stack, these are complementary, not competing:
- Use Dynamic Workers for cheap/fast generated code paths.
- Use Sandbox SDK/Containers for high-isolation Linux tasks, package managers, complex tooling, and interactive dev environments.

---

## 2) Cloudflare offering map (portfolio view)

## 2.1 Network and application delivery

Core:
- CDN / Cache
- DNS and authoritative DNS infrastructure
- Argo/Smart Routing
- Load Balancing
- Spectrum / L4+ services
- Image/video/media delivery products

Positioning:
- Cloudflare remains strongest where global network proximity + traffic steering + integrated security are required.

Representative docs/pages:
- https://www.cloudflare.com/network-services/
- https://developers.cloudflare.com/cache/
- https://developers.cloudflare.com/dns/
- https://developers.cloudflare.com/load-balancing/
- https://developers.cloudflare.com/argo-smart-routing/
- https://developers.cloudflare.com/spectrum/

## 2.2 Application security

Core:
- WAF and rules engine
- DDoS protection
- Bot management
- API Shield
- Rate limiting and security policy orchestration

Representative docs/pages:
- https://www.cloudflare.com/application-services/
- https://developers.cloudflare.com/waf/
- https://developers.cloudflare.com/ddos-protection/
- https://developers.cloudflare.com/bots/
- https://developers.cloudflare.com/api-shield/

## 2.3 Zero Trust / SASE (Cloudflare One)

Core:
- Access (ZTNA)
- Secure Web Gateway
- CASB / remote browser isolation patterns
- Gateway policies + identity integrations
- Tunnel/WARP-based private network access

Representative docs/pages:
- https://www.cloudflare.com/zero-trust/
- https://developers.cloudflare.com/cloudflare-one/
- https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
- https://developers.cloudflare.com/cloudflare-one/policies/

## 2.4 Developer platform (compute + orchestration)

Core:
- Workers (serverless edge compute)
- Pages
- Durable Objects
- Workflows
- Queues
- Browser Rendering
- Dynamic Workers (runtime spin-up of Workers)
- Containers (beta)
- Sandbox SDK (beta)

Representative docs:
- https://developers.cloudflare.com/workers/
- https://developers.cloudflare.com/pages/
- https://developers.cloudflare.com/durable-objects/
- https://developers.cloudflare.com/workflows/
- https://developers.cloudflare.com/queues/
- https://developers.cloudflare.com/browser-rendering/
- https://developers.cloudflare.com/dynamic-workers/
- https://developers.cloudflare.com/containers/
- https://developers.cloudflare.com/sandbox/

## 2.5 Data and storage services

Core:
- R2 (object storage)
- D1 (serverless SQL)
- KV (key-value)
- Durable Objects storage (stateful coordination + storage)
- Hyperdrive (DB acceleration)
- Vectorize (vector DB)

Representative docs:
- https://developers.cloudflare.com/r2/
- https://developers.cloudflare.com/d1/
- https://developers.cloudflare.com/kv/
- https://developers.cloudflare.com/durable-objects/
- https://developers.cloudflare.com/hyperdrive/
- https://developers.cloudflare.com/vectorize/

## 2.6 AI stack

Core:
- Workers AI (serverless inference)
- AI Gateway (routing, observability, controls)
- Vectorize + R2 + D1 patterns for retrieval and memory
- Agents ecosystem (rapidly emerging)

Representative docs:
- https://developers.cloudflare.com/workers-ai/
- https://developers.cloudflare.com/ai-gateway/
- https://developers.cloudflare.com/vectorize/

---

## 3) Deep dive: Cloudflare Containers (Beta)

Definition:
- Containers let you run containerized Linux workloads from Workers, with lifecycle mediated by Durable Objects and Cloudflare’s container runtime.

What it is best for:
- Runtime/tooling that does not fit native Workers constraints
- Existing containerized workloads
- Resource-intensive tasks requiring more memory/CPU/disk profile
- Session/stateful process patterns (with app-managed semantics)

Important architecture traits (from docs):
- Containers are integrated with Workers + Durable Objects.
- Images are pushed via Wrangler to Cloudflare’s registry and distributed globally.
- Startup uses pre-fetched images across regions for faster cold starts.
- Each container instance runs in its own VM (strong isolation).
- Disk is currently ephemeral (state reset after sleep/restart).

Key beta caveats:
- No released autoscaling/latency-aware LB yet (manual scaling patterns with unique IDs/getRandom stopgap).
- Some rollout and placement behavior still evolving.
- Durable Objects and container co-location not guaranteed in all cases yet.

Pricing signals (beta docs):
- Workers Paid plan requirement
- Billing dimensions: vCPU, memory, disk, egress
- Included usage + per-unit overages
- Example rates shown in docs:
  - memory overage +$0.0000025/GiB-second
  - CPU overage +$0.000020/vCPU-second
  - disk overage +$0.00000007/GB-second
  - egress by region pricing tier

References:
- https://developers.cloudflare.com/containers/
- https://developers.cloudflare.com/containers/get-started/
- https://developers.cloudflare.com/containers/platform-details/architecture/
- https://developers.cloudflare.com/containers/platform-details/limits/
- https://developers.cloudflare.com/containers/platform-details/scaling-and-routing/
- https://developers.cloudflare.com/containers/pricing/
- https://developers.cloudflare.com/containers/beta-info/

---

## 4) Deep dive: Sandbox SDK (Beta)

Definition:
- Sandbox SDK is a developer-facing SDK for secure code execution, built on top of Containers.
- It provides high-level APIs: command execution, file ops, process mgmt, terminal/ws, and service exposure.

What it is best for:
- AI agent code execution environments
- browser IDE / cloud dev environments
- CI-like isolated task execution
- data science/compute workflows that need Linux userland tools

Architecture (explicit in docs):
- Worker app layer
- Durable Object layer (identity/routing/lifecycle)
- Container runtime layer (isolated Linux execution)
- Can use HTTP or WebSocket transport between control plane and runtime

Security model highlights:
- Isolation boundary is per sandbox VM/container
- Within one sandbox, processes/files are shared
- Strong recommendation: separate sandbox per user/session/task for isolation
- SDK docs explicitly emphasize application-level authz/input validation still required

Lifecycle semantics:
- Sandbox ID identifies instance
- Idle timeout defaults to 10 minutes (configurable)
- KeepAlive mode available
- Ephemeral container state on restart unless app persists externally

Why this matters strategically:
- Sandbox SDK is effectively Cloudflare’s higher-level “managed code execution substrate,” reducing boilerplate vs raw Containers.
- For product teams, this can significantly reduce time-to-market for agentic “code mode” features.

References:
- https://developers.cloudflare.com/sandbox/
- https://developers.cloudflare.com/sandbox/get-started/
- https://developers.cloudflare.com/sandbox/concepts/architecture/
- https://developers.cloudflare.com/sandbox/concepts/security/
- https://developers.cloudflare.com/sandbox/concepts/sandboxes/
- https://developers.cloudflare.com/sandbox/concepts/containers/

---

## 5) Deep dive: Dynamic Workers

Definition:
- Dynamic Workers let a Worker load/spawn Workers at runtime and execute arbitrary code in secure Worker isolates.

Core API model:
- `load(code)` for one-off execution (fresh worker each call)
- `get(id, callback)` for cacheable/warm reuse by stable ID
- Worker Loader binding (`worker_loaders`) required in wrangler config

Why it is differentiated:
- Lowest-level primitive for runtime-created Worker isolates
- Fine-grained controls for bindings, network egress (`globalOutbound`), and code packaging
- Strong fit for AI “code mode” and generated micro-tools

Cost/performance implications:
- Reuses Workers request/CPU billing model
- Additional pricing dimension documented for “unique Dynamic Workers created daily” (published ahead of full activation)
- Docs explicitly recommend stable IDs with `.get()` to avoid unnecessary new worker creation costs

Where it beats Containers:
- Lower overhead startup in Worker runtime contexts
- Better for short-lived generated logic that does not require full Linux/container semantics

Where Containers/Sandbox beat it:
- OS-level tooling, package manager-heavy workflows, binary/runtime dependencies, long-running Linux process semantics

References:
- https://developers.cloudflare.com/dynamic-workers/
- https://developers.cloudflare.com/dynamic-workers/getting-started/
- https://developers.cloudflare.com/dynamic-workers/api-reference/
- https://developers.cloudflare.com/dynamic-workers/pricing/

---

## 6) Containers vs Sandbox SDK vs Dynamic Workers

| Dimension | Dynamic Workers | Containers | Sandbox SDK |
|---|---|---|---|
| Isolation primitive | Worker isolate | Container in VM | Container in VM (via SDK abstraction) |
| Runtime environment | Worker-compatible JS/Python modules | Full containerized Linux workload | Full containerized Linux workload + high-level APIs |
| Primary control plane | Worker Loader API | Worker + Durable Object + container package | SDK + Durable Object + container |
| Startup model | `load()` or `get(id)` | Container start; may incur cold start seconds | Same as containers, abstracted behind SDK |
| State persistence | isolate cache by ID, non-guaranteed warm | Ephemeral disk unless externally persisted | Ephemeral unless persisted externally |
| Best use case | fast generated code execution | custom runtimes / heavy compute / existing images | secure code execution product features |
| Operational complexity | lower | medium-high | medium (lower than raw containers) |
| Maturity signal | emerging but productized docs/API | beta with known roadmap gaps | beta (built atop containers) |

Decision heuristic:
- If your task can run in Worker runtime and needs fast spin-up: start with Dynamic Workers.
- If you need Linux/runtime flexibility: use Containers.
- If you need a turnkey product API for safe code execution workflows: use Sandbox SDK.

---

## 7) Cloudflare offering landscape for builders (practical stack recipes)

## 7.1 AI app baseline on Cloudflare

Common stack:
- Compute: Workers
- Inference: Workers AI
- LLM routing/controls: AI Gateway
- Retrieval memory: Vectorize + R2/D1
- Stateful coordination: Durable Objects
- Async orchestration: Queues + Workflows
- Optional secure code execution: Dynamic Workers or Sandbox SDK

## 7.2 Agent platform pattern (multi-tenant)

Control plane:
- API layer in Workers
- tenant/session routing via Durable Objects

Execution plane options:
- Dynamic Workers for lightweight user-generated code paths
- Sandbox SDK for stronger isolation and Linux-native tools

Data plane:
- D1 for metadata
- R2 for artifacts
- Vectorize for semantic context

Security and ingress:
- Cloudflare Access/WAF/Bot controls at edge

## 7.3 Enterprise deployment posture

- Network + app security + zero trust from same vendor simplifies policy stack.
- Key risk remains beta dependence if Containers/Sandbox are core path.
- Mitigate by defining fallback execution tier (Dynamic Workers or external container backend) until GA confidence is high.

---

## 8) Commercial and technical watchpoints

1. Beta risk concentration
- Containers and Sandbox SDK are both beta; roadmap gaps (autoscaling, placement guarantees, etc.) are documented.

2. Cost architecture
- Dynamic Workers economics depend strongly on ID reuse and invocation model.
- Containers economics depend on instance sizing and active runtime windows.

3. State model pitfalls
- All three execution modes require explicit state architecture decisions.
- Treat runtime state as ephemeral and externalize durable state to D1/R2/KV/DO storage.

4. Placement and latency behavior
- For globally distributed users, explicit session/region strategy is required to avoid accidental latency regressions.

---

## 9) Strategic conclusion

Cloudflare is no longer just “edge CDN + Workers.” It now has a credible layered cloud model:
- Traffic/network/security edge
- unified app + zero trust controls
- composable serverless + state primitives
- emerging AI-native execution surfaces (Dynamic Workers, Containers, Sandbox SDK)

For teams building agentic products, the key opportunity is architectural optionality under one platform:
- isolate-first execution (Dynamic Workers)
- VM/container execution (Containers/Sandbox)
- integrated data + inference + security around both.

If Cloudflare executes on Containers/Sandbox GA maturity (especially autoscaling/routing and operational ergonomics), it can become a default platform for production-grade agent execution systems.

---

## 10) Sources

Core portfolio and category pages:
- https://www.cloudflare.com/network-services/
- https://www.cloudflare.com/application-services/
- https://www.cloudflare.com/zero-trust/

Developer platform docs:
- https://developers.cloudflare.com/workers/
- https://developers.cloudflare.com/workers/platform/pricing/
- https://developers.cloudflare.com/durable-objects/
- https://developers.cloudflare.com/workers-ai/
- https://developers.cloudflare.com/queues/
- https://developers.cloudflare.com/workflows/
- https://developers.cloudflare.com/vectorize/
- https://developers.cloudflare.com/r2/
- https://developers.cloudflare.com/d1/
- https://developers.cloudflare.com/kv/
- https://developers.cloudflare.com/hyperdrive/

Containers:
- https://developers.cloudflare.com/containers/
- https://developers.cloudflare.com/containers/get-started/
- https://developers.cloudflare.com/containers/platform-details/architecture/
- https://developers.cloudflare.com/containers/platform-details/limits/
- https://developers.cloudflare.com/containers/platform-details/scaling-and-routing/
- https://developers.cloudflare.com/containers/pricing/
- https://developers.cloudflare.com/containers/faq/
- https://developers.cloudflare.com/containers/beta-info/

Sandbox SDK:
- https://developers.cloudflare.com/sandbox/
- https://developers.cloudflare.com/sandbox/get-started/
- https://developers.cloudflare.com/sandbox/concepts/architecture/
- https://developers.cloudflare.com/sandbox/concepts/security/
- https://developers.cloudflare.com/sandbox/concepts/sandboxes/
- https://developers.cloudflare.com/sandbox/concepts/containers/

Dynamic Workers:
- https://developers.cloudflare.com/dynamic-workers/
- https://developers.cloudflare.com/dynamic-workers/getting-started/
- https://developers.cloudflare.com/dynamic-workers/api-reference/
- https://developers.cloudflare.com/dynamic-workers/pricing/

Supplementary documentation corpus reference:
- https://github.com/cloudflare/cloudflare-docs
