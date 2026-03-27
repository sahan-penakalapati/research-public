-- NeoCloud Budget Ledger Schema (PostgreSQL)

create table if not exists budget_policies (
  policy_id text primary key,
  workspace_id text not null,
  agent_id text,
  environment text not null check (environment in ('dev', 'prod')),
  capability text,
  per_action_usd numeric(12,4) not null default 0,
  daily_usd numeric(12,4) not null default 0,
  monthly_usd numeric(12,4) not null default 0,
  overrun_tolerance_pct numeric(6,2) not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists budget_ledger_entries (
  entry_id text primary key,
  request_id text not null,
  task_id text,
  run_id text,
  workspace_id text not null,
  owner_id text not null,
  agent_id text not null,
  environment text not null check (environment in ('dev', 'prod')),
  capability text not null,
  entry_type text not null check (entry_type in (
    'reserve',
    'capture',
    'release',
    'adjustment',
    'block'
  )),
  amount_usd numeric(12,4) not null,
  currency text not null default 'USD',
  provider text,
  provider_ref text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_budget_entries_workspace_time
  on budget_ledger_entries (workspace_id, created_at desc);

create index if not exists idx_budget_entries_agent_time
  on budget_ledger_entries (agent_id, created_at desc);

create index if not exists idx_budget_entries_request
  on budget_ledger_entries (request_id);

create table if not exists budget_reservations (
  reservation_id text primary key,
  request_id text not null unique,
  workspace_id text not null,
  agent_id text not null,
  environment text not null check (environment in ('dev', 'prod')),
  capability text not null,
  reserved_usd numeric(12,4) not null,
  captured_usd numeric(12,4) not null default 0,
  released_usd numeric(12,4) not null default 0,
  status text not null check (status in ('active', 'captured', 'released', 'expired', 'cancelled')),
  expires_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_budget_reservations_status_expires
  on budget_reservations (status, expires_at);

-- Helper views
create or replace view v_budget_daily_usage as
select
  workspace_id,
  agent_id,
  environment,
  date_trunc('day', created_at) as day_bucket,
  sum(case
    when entry_type in ('capture', 'adjustment') then amount_usd
    when entry_type = 'release' then -amount_usd
    else 0
  end) as net_spend_usd
from budget_ledger_entries
group by 1,2,3,4;

create or replace view v_budget_monthly_usage as
select
  workspace_id,
  agent_id,
  environment,
  date_trunc('month', created_at) as month_bucket,
  sum(case
    when entry_type in ('capture', 'adjustment') then amount_usd
    when entry_type = 'release' then -amount_usd
    else 0
  end) as net_spend_usd
from budget_ledger_entries
group by 1,2,3,4;

-- Atomic reserve pattern (implementation note):
-- 1) begin transaction
-- 2) lock relevant policy row (FOR UPDATE)
-- 3) compute projected spend from views + active reservations
-- 4) if within limits: insert reservation + reserve ledger entry
-- 5) commit; else insert block entry and rollback/commit accordingly
