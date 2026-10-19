-- ==========================================================
-- SCRIPT SETUP DATABASE SUPABASE - KARTU AKSI PANCASILA
-- ==========================================================
-- Cara pakai:
-- 1. Buka dashboard project di https://supabase.com
-- 2. Pilih menu "SQL Editor" di bilah kiri
-- 3. Klik "New Query", paste semua kode di bawah ini, lalu klik "Run"
-- ==========================================================

-- 1. Buat tabel kartu_pancasila untuk menyimpan data kartu absen 1-20
create table if not exists public.kartu_pancasila (
  id integer primary key,
  nama text default '',
  aksi text default '',
  sila text default '',
  nilai text default '',
  sig text default '',
  photo text default '',
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. Aktifkan Row Level Security (RLS)
alter table public.kartu_pancasila enable row level security;

-- 3. Berikan izin publik (anonim) agar guru dan murid bisa melihat dan mengisi kartu
drop policy if exists "Izin publik membaca kartu" on public.kartu_pancasila;
create policy "Izin publik membaca kartu"
  on public.kartu_pancasila
  for select
  using (true);

drop policy if exists "Izin publik menambah kartu" on public.kartu_pancasila;
create policy "Izin publik menambah kartu"
  on public.kartu_pancasila
  for insert
  with check (true);

drop policy if exists "Izin publik memperbarui kartu" on public.kartu_pancasila;
create policy "Izin publik memperbarui kartu"
  on public.kartu_pancasila
  for update
  using (true);

-- 4. Aktifkan Realtime Replication agar sinkronisasi langsung seperti Padlet
alter publication supabase_realtime add table public.kartu_pancasila;
