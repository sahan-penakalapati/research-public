# Clanker Cloud (clankercloud.ai) — Deep Research Brief
Date: 2026-03-25
Prepared for: Sahan

## TL;DR
Clanker Cloud positions itself as a local-first, agentic DevOps/infrastructure control plane: deploy from GitHub, inspect infra in natural language, operate across multi-cloud + Kubernetes, keep credentials local, and approve execution before changes.

The strongest credibility signals are:
- public open-source CLI repo (`bgdnvk/clanker`) with active commits, releases, and non-trivial scope
- explicit product pages for builders/DevOps/researchers
- a demo page with multiple workflow videos
- transparent "beta" language + terms that clearly put execution risk on customer side

Main diligence concern: marketing claims are broad versus currently verifiable production proof (compliance attestations, enterprise references, uptime guarantees, detailed architecture/security docs are not publicly documented in depth).

---

## 1) What the product is (positioning)
Core positioning from official site:
- "Local-first agentic infrastructure control plane"
- install in ~1 minute on macOS/Windows/Linux
- use existing credentials (no hosted credential custody requirement)
- human-approved execution flow for infra changes

Source evidence:
- homepage metadata, hero copy, and feature sections: https://clankercloud.ai/
- FAQ confirms local credential model and target personas: https://clankercloud.ai/faq

Observed target personas (explicitly segmented on site):
1. Builders/founders shipping vibe-coded or AI-generated apps to production
2. DevOps/SRE teams handling multi-cloud operations
3. AI research teams managing training/deployment infra

Sources:
- homepage nav and persona pages: https://clankercloud.ai/ , https://clankercloud.ai/vibe-coding-to-production , https://clankercloud.ai/ai-devops-for-teams , https://clankercloud.ai/ai-researchers

---

## 2) Product capabilities (publicly claimed)
### 2.1 Deployment + control workflows
Claimed capabilities:
- GitHub-to-deploy flow with inferred plan and approval gate
- plain-English infra querying
- multi-provider operations from one surface
- topology/health/cost visualization
- BYOK (bring your own model/API keys)
- BYOA (bring your own agents in Node/Python)

Sources:
- homepage capabilities section: https://clankercloud.ai/
- FAQ clarifications: https://clankercloud.ai/faq

### 2.2 Supported environments/providers (claimed)
Providers listed across pages:
- AWS, GCP, Azure
- Kubernetes
- Cloudflare, Hetzner, DigitalOcean
- GitHub workflows

Sources:
- homepage provider chips and copy: https://clankercloud.ai/
- FAQ provider answer: https://clankercloud.ai/faq

### 2.3 Evals page (interesting but currently self-published)
The `/evals` page publishes model ranking cards and benchmark-like scoring for infra tasks.
This is useful for product narrative, but should be treated as internal/vendor-produced evaluation until methodology reproducibility is independently validated.

Source:
- https://clankercloud.ai/evals

---

## 3) Pricing + commercial packaging (public)
Public pricing blocks on homepage:
- Beta: $0/mo
- Basic: $20/mo
- Pro: $30/mo
- Enterprise: custom

Notable Pro language includes:
- optional backend
- "models (coming soon)"
- nightly features
- partner discounts

Commercial interpretation:
- Low listed price points likely optimized for early adoption and feedback velocity
- Enterprise remains custom, suggesting evolving packaging for security/compliance demands

Source:
- https://clankercloud.ai/

---

## 4) Maturity signals from code/distribution footprint
## 4.1 Open-source CLI repo (strong signal)
Repository: `bgdnvk/clanker`
Observed via GitHub API:
- created: 2025-08-11
- stars: 218
- forks: 12
- open issues: 6
- updated recently (as of research date)
- language: Go
- MIT license

Source:
- https://api.github.com/repos/bgdnvk/clanker
- repo page: https://github.com/bgdnvk/clanker

### 4.2 Release history indicates active iteration
Observed release tags include:
- `v0.0.1-meet-your-maker` (2025-12)
- `v0.0.2` (2026-01)
- `v0.0.3` (2026-03)

Release notes for `v0.0.3` mention broad infra scope additions (k8s, GCP, Azure, Cloudflare, IAM, plan flows, etc.).

Source:
- https://api.github.com/repos/bgdnvk/clanker/releases?per_page=5

### 4.3 Distribution channel exists
Homebrew tap exists under `clankercloud/homebrew-tap` with formula and binary references (early versions).

Sources:
- https://github.com/clankercloud/homebrew-tap
- https://raw.githubusercontent.com/clankercloud/homebrew-tap/master/Formula/clanker.rb

---

## 5) Company context and team signals
Public company site (`novlabs.ai`) links directly to:
- Clanker Cloud web product
- Clanker CLI GitHub

Stated framing:
- "AI Systems Engineering research lab"
- vision focused on agentic systems engineering and infra operations abstraction

Team page publicly lists:
- CEO: Bogdan Novykov
- CTO: Nash Rafeeq

Sources:
- https://novlabs.ai/
- https://novlabs.ai/mission/
- https://novlabs.ai/team/
- LinkedIn org link present on site footer: https://www.linkedin.com/company/novlabs

---

## 6) Demo and proof artifacts
Demo page includes multiple embedded YouTube demos around:
- public lambda creation/deletion
- EKS create/status/delete flows
- early alpha topology/Kubernetes views

Video IDs found on demo page:
- kGzREATqqgI
- 9GFRA-W3az0
- -ab9LOvXeJo
- Je7Hr8AOSWQ
- I4kCiwYdnOg
- 1P64vH2_w2E
- wXE3ZBFY5Qo
- pNO7tBooITU

Source:
- https://clankercloud.ai/demo
- YouTube oEmbed metadata for the above IDs

Interpretation:
- confirms end-to-end product storytelling and workflow intent
- still not equivalent to independent production case studies/SLA proofs

---

## 7) Security/compliance and risk posture (based on public docs)
What is clearly stated:
- credentials remain on user machine (local-first model)
- users are responsible for reviewing approved actions
- beta software may be incomplete/unstable
- users bear responsibility for resulting outages, costs, and exposure

Source:
- FAQ: https://clankercloud.ai/faq
- Terms: https://clankercloud.ai/terms

What is not clearly evidenced publicly (at time of research):
- SOC 2 / ISO 27001 reports
- formal data-processing addendum details
- public incident history
- enterprise reference architecture docs

Practical conclusion:
- security narrative is promising for credential custody minimization
- operational/legal risk transfer to customer is explicit in terms

---

## 8) Competitive landscape (quick strategic view)
Likely adjacent categories:
1. Agentic DevOps assistants
2. Infrastructure-as-code + orchestration tooling
3. Multi-cloud control plane/observability consoles
4. AI coding-to-prod orchestration tools

Clanker Cloud differentiator (claimed):
- local-first + approval-gated execution + multi-cloud + agentic interaction

Potential moat if executed well:
- rich local context ingestion + safe action orchestration
- fast, opinionated workflows from repo to running infra

Potential fragility:
- broad scope early (many providers + many personas)
- trust/compliance barriers in larger orgs
- incumbent overlap (GitHub/AWS/GCP-native + IaC ecosystem)

---

## 9) Diligence checklist before serious adoption
If evaluating for production use, request:
1. Security architecture whitepaper (key management, telemetry, update channel)
2. Threat model and permission boundary model
3. Audit logs and action replay guarantees
4. Rollback guarantees for "apply" workflows
5. Terraform/IaC interoperability specifics (import, drift, state handling)
6. Model-provider isolation and prompt/data retention behavior
7. Customer references and incident response SLA
8. Enterprise compliance roadmap and timeline

---

## 10) Confidence rating
Overall confidence in this brief: Medium.
- High confidence: official website claims, pricing, terms language, repo/release metadata.
- Medium confidence: inferred product maturity and strategic interpretation.
- Lower confidence: independent third-party market validation (limited clean external search signal for the exact brand term).

---

## Sources (primary)
- https://clankercloud.ai/
- https://clankercloud.ai/faq
- https://clankercloud.ai/demo
- https://clankercloud.ai/terms
- https://clankercloud.ai/vibe-coding-to-production
- https://clankercloud.ai/ai-devops-for-teams
- https://clankercloud.ai/ai-researchers
- https://clankercloud.ai/evals
- https://novlabs.ai/
- https://novlabs.ai/mission/
- https://novlabs.ai/team/
- https://github.com/bgdnvk/clanker
- https://api.github.com/repos/bgdnvk/clanker
- https://api.github.com/repos/bgdnvk/clanker/releases?per_page=5
- https://api.github.com/repos/bgdnvk/clanker/issues?state=open&per_page=10
- https://github.com/clankercloud/homebrew-tap
- https://raw.githubusercontent.com/clankercloud/homebrew-tap/master/Formula/clanker.rb

---

## Notes on methodology
- This report prioritizes verifiable primary artifacts (official pages + public repository metadata).
- Search engine recall for exact keyword combinations was noisy due the generic term "clanker", so independent third-party coverage appears limited/less discoverable at this time.