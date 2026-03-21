# AI-Driven Algo Trading Research Plan (Bank Nifty Futures)

Date: 2026-03-21
Prepared for: Sahan

## What you asked
You want to:
1) Build an AI-assisted (multi-LLM) algo research workflow.
2) Focus on Bank Nifty futures.
3) Detect market regime/environment first (using technical parameters like ATR, India VIX, volume), then switch to strategy class per regime.
4) Backtest approaches first before deployment.
5) Evaluate whether Karpathy-style autoresearch (via the autoresearch-genealogy repo pattern) is suitable for this use case without force-fitting.

This document gives a concrete Phase-1 blueprint.

--------------------------------------------------------------------------------
## 1) Direct answer: yes, use Bank Nifty futures as base in Phase 1

Instrument scope for Phase 1 (specific):
- Underlying: Bank Nifty index
- Trading instrument: Front-month Bank Nifty futures (NSE)
- Session: NSE normal market hours only
- Data bars for research:
  - Primary: 5-minute bars
  - Secondary: 15-minute bars
  - Daily bars for higher-timeframe filters

Why futures for Phase 1:
- Cleaner directional expression than options while building regime engine.
- Lower strategy complexity than combining spot + options greeks from day one.
- Easier to isolate whether regime classification itself has edge.

--------------------------------------------------------------------------------
## 2) Core architecture: regime -> strategy family -> risk engine

Your hypothesis is exactly right: one strategy rarely works across all windows.

So structure should be:
- Layer A: Regime classifier (deterministic, no LLM at runtime)
- Layer B: Strategy selector (maps regime to pre-backtested strategy family)
- Layer C: Execution/risk engine (slippage, cost, position sizing, kill switches)

LLMs should assist only with research/iteration/documentation, not live signal authority.

--------------------------------------------------------------------------------
## 3) Phase 1 regime model (specific, with ATR/VIX/volume)

Use a 3-state regime for first cycle:
- R1: Trend regime
- R2: Range/mean-reversion regime
- R3: High-volatility shock regime

### Features (start here)
1) Realized volatility proxy
- ATR_14 on 15m bars
- NATR_14 = ATR_14 / close
- Also use ATR percentile over trailing 60 sessions

2) Implied volatility context
- India VIX daily close (aligned to session date)
- VIX level percentile over trailing 252 trading days
- VIX 5-day slope (up/down)

3) Participation/liquidity
- Futures volume z-score (relative to 20-day intraday time-slice baseline)
- Optional: OI change if you ingest bhavcopy OI reliably

4) Trend structure
- ADX_14 (15m)
- Distance from VWAP (intraday)
- Distance from 20EMA/50EMA (15m)

5) Market state helpers
- Opening range width (first 30 mins)
- Gap size (today open vs previous settle)

### Initial deterministic rules (seed version, not final)
- R3 (High-vol shock):
  - VIX percentile >= 80 OR
  - NATR percentile >= 85 OR
  - volume z-score >= +2.0 with opening range width >= 1.5x median

- R1 (Trend):
  - ADX_14 >= 23
  - abs(price - VWAP) sustained > threshold for N bars
  - NATR percentile between 40 and 85

- R2 (Range):
  - ADX_14 <= 18
  - NATR percentile <= 45
  - VIX percentile < 70

Everything not classified cleanly -> "No-trade/uncertain" bucket.

Important: these thresholds are starting priors only. They must be tuned/validated via walk-forward.

--------------------------------------------------------------------------------
## 4) Strategy families mapped to regime

### For R1 (Trend)
Use one of:
- Opening range breakout with trend filter
- EMA pullback continuation
- VWAP trend continuation

### For R2 (Range)
Use one of:
- VWAP mean reversion with strict stop
- Bollinger/volatility band fade with trend filter blocking

### For R3 (High-vol shock)
Use one of:
- Reduced size momentum burst strategy with hard time-stop
- Or skip trading entirely if your historical expectancy is unstable in this regime

Do NOT mix all strategies all the time. Only activate regime-approved ones.

--------------------------------------------------------------------------------
## 5) Backtesting protocol (must be strict)

### Data split
- In-sample train: earliest 60%
- Validation: next 20%
- Test (holdout): final 20%

Then do walk-forward:
- Example: 6-month train, 2-month test rolling windows.

### Costs/slippage
For each backtest, include:
- Brokerage + exchange fees + taxes + stamp + STT assumptions
- Slippage model:
  - Base bps + volatility-dependent add-on
  - Extra slippage for first and last 30 minutes

### Risk controls in sim
- Max trades/day
- Max loss/day
- Max concurrent exposure
- Time-based forced exit near close
- Regime flip handling (exit or reduce)

### Metrics to track (minimum)
- CAGR and max drawdown
- Sharpe/Sortino
- Win rate + payoff ratio
- Profit factor
- Regime-wise expectancy (critical)
- Stability of parameters across windows

### Statistical checks
- Bootstrap confidence intervals for expectancy
- Reality check for overfitting (parameter sensitivity)
- Purged split logic where needed to avoid leakage

--------------------------------------------------------------------------------
## 6) Multi-LLM setup (recommended practical use)

Use LLMs as research assistants with role separation:
- LLM-A (Researcher): proposes hypotheses/feature variants.
- LLM-B (Skeptic): tries to break assumptions; checks leakage, overfitting, microstructure blind spots.
- LLM-C (Implementer): converts approved logic to backtest code/tests.

Decision authority remains deterministic:
- Only backtest engine outputs and predefined acceptance gates decide promotion.

Suggested promotion gate from Phase 1 to paper trading:
- Positive net expectancy on holdout
- Max DD within predefined risk budget
- Regime-wise performance not concentrated in one short window
- Sensitivity checks pass (not fragile to tiny parameter changes)

--------------------------------------------------------------------------------
## 7) Repo review: mattprusak/autoresearch-genealogy

Repo reviewed:
- https://github.com/mattprusak/autoresearch-genealogy

What it is:
- A structured autoresearch framework using prompt loops with:
  - Goal
  - Metric
  - Direction
  - Verify
  - Guard rails
  - Iterations
  - Protocol

Key strength for your use case:
- The "Goal/Metric/Verify/Guard" structure is highly transferable to quant research loops.
- It enforces explicit iterative process and prevents vague idea drift.

Why it should NOT be directly copied as-is:
- Genealogy verification is source-consistency based.
- Trading verification must be performance + leakage + cost + robustness based.
- You need a deterministic backtest compiler-like layer, which this repo does not provide.

Conclusion:
- Adopt the autoresearch loop pattern.
- Do not adopt domain content directly.
- Build a quant-specific variant where "Verify" is backtest + statistical robustness checks.

--------------------------------------------------------------------------------
## 8) Can Karpathy-style autoresearch be adopted here?

Yes, with guard rails.

Good fit:
- Hypothesis generation and iterative refinement.
- Fast exploration of feature and regime definitions.

Bad fit (if misused):
- Letting LLMs directly infer tradable edge without hard backtest verification.
- Letting LLM propose changing labels/targets post-hoc to improve apparent metrics.

Recommended adaptation:
- Keep autoresearch in research loop only.
- Backtester + validation harness is final arbiter.
- Every iteration writes a machine-readable experiment card:
  - data range
  - features used
  - strategy logic hash
  - costs/slippage assumptions
  - train/val/test metrics
  - pass/fail reason

--------------------------------------------------------------------------------
## 9) Concrete Phase-1 execution plan (4 weeks)

Week 1: Data + baseline infra
- Build continuous Bank Nifty futures dataset (5m/15m/daily)
- Add India VIX daily series
- Build feature pipeline for ATR/NATR/VIX percentile/volume z-score/ADX/VWAP distance
- Build reproducible backtest harness with cost/slippage model

Week 2: Regime classifier v1 + seed strategies
- Implement deterministic 3-state regime engine
- Implement 1 strategy per regime (simple, interpretable)
- Run first walk-forward and holdout tests

Week 3: Robustness + ablation
- Threshold sweeps
- Remove one feature at a time to test dependence
- Add no-trade regime threshold for uncertain states

Week 4: Candidate selection + paper-trade readiness
- Choose top 1-2 robust models
- Freeze parameters
- Run shadow/paper execution for operational validation
- Decide go/no-go for Phase 2

--------------------------------------------------------------------------------
## 10) Suggested acceptance criteria for end of Phase 1

Minimum:
- Holdout net expectancy > 0 after all costs
- Max drawdown acceptable for your risk budget
- At least two regimes show stable edge contribution
- Parameter sensitivity not brittle
- Daily loss controls proven in simulation

If these are not met:
- Do not go live.
- Iterate on regime definitions or lower strategy complexity.

--------------------------------------------------------------------------------
## 11) Recommendation summary

1) Yes, Bank Nifty futures is the right Phase-1 base.
2) Start with ATR + India VIX + volume + ADX/VWAP context exactly as you suggested.
3) Keep regime model deterministic first; avoid black-box classifier in Phase 1.
4) Use multi-LLM for research roles only; keep execution and model promotion fully rule-based.
5) Adopt Karpathy/autoresearch loop structure, but only with a strict quant verification harness.

