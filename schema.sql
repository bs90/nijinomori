-- Supabase schema for nijinomori album photo selection tool
-- Run this in Supabase SQL Editor once

create table if not exists nijinomori_selections (
  id bigserial primary key,
  page_name text not null,
  child_name text not null,
  created_at timestamptz default now()
);

-- Count kind: 'normal' = 従来のカウント（全出演）, 'good' = ◎良い顔（正面・センター）
alter table nijinomori_selections add column if not exists kind text not null default 'normal';

create index if not exists idx_nijinomori_selections_page on nijinomori_selections(page_name);
create index if not exists idx_nijinomori_selections_child on nijinomori_selections(child_name);
create index if not exists idx_nijinomori_selections_kind on nijinomori_selections(kind);

alter table nijinomori_selections enable row level security;

-- Drop old anon policy if exists
drop policy if exists "anon_all_nijinomori_selections" on nijinomori_selections;

-- Allow only authenticated users (signed-in via Supabase Auth)
drop policy if exists "auth_all_nijinomori_selections" on nijinomori_selections;
create policy "auth_all_nijinomori_selections"
  on nijinomori_selections
  for all
  to authenticated
  using (true)
  with check (true);
