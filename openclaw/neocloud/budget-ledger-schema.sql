-- NeoCloud Budget Ledger Schema (PostgreSQL)

create table if not exists budget_accounts (
  account_id text primary key,
  owner_id text not null,
  environment text not null check (environment in ('dev','prod')),
  daily_limit_usd numeric(12,2) not null,
  monthly_limit_usd numeric(12,2) not null,
  per_action_limit_usd numeric(12,2) not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists budget_ledger_entries (
  entry_id bigserial primary key,
  account_id text not null references budget_accounts(account_id),
  request_id text not null,
  task_id text,
  agent_id text not null,
  capability text not null,
  entry_type text not null check (entry_type in (
    'reserve',
    'capture',
    'release',
    'block'
  )),
  amount_usd numeric(12,4) not null check (amount_usd >= 0),
  currency text not null default 'USD',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_budget_entries_account_time
  on budget_ledger_entries(account_id, created_at desc);

create index if not exists idx_budget_entries_request
  on budget_ledger_entries(request_id);

create table if not exists budget_reservations (
  reservation_id text primary key,
  account_id text not null references budget_accounts(account_id),
  request_id text not null unique,
  agent_id text not null,
  capability text not null,
  estimated_usd numeric(12,4) not null check (estimated_usd >= 0),
  status text not null check (status in ('active','captured','released','expired')),
  created_at timestamptz not null default now(),
  expires_at timestamptz not null,
  settled_at timestamptz
);

create index if not exists idx_budget_reservations_account_status
  on budget_reservations(account_id, status);

create or replace view v_budget_daily_spend as
select
  account_id,
  date_trunc('day', created_at) as day,
  sum(amount_usd) as captured_usd
from budget_ledger_entries
where entry_type = 'capture'
group by account_id, date_trunc('day', created_at);

create or replace view v_budget_monthly_spend as
select
  account_id,
  date_trunc('month', created_at) as month,
  sum(amount_usd) as captured_usd
from budget_ledger_entries
where entry_type = 'capture'
group by account_id, date_trunc('month', created_at);
