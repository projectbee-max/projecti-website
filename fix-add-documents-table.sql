-- KNOWLEDGE > Documents 에서 사용하는 테이블입니다.
create table if not exists documents (
  id uuid default gen_random_uuid() primary key,
  team text check (team in ('i','drone')) default 'i',
  title text not null,
  author text,
  content text,
  created_at timestamptz default now()
);
alter table documents enable row level security;
create policy "로그인 사용자는 documents 조회 가능" on documents for select using (auth.role() = 'authenticated');
create policy "editor/admin은 documents 수정 가능" on documents for all using (
  exists (select 1 from profiles where id = auth.uid() and role in ('admin','editor'))
);
