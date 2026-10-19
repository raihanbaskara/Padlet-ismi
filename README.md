# 🇮🇩 Kartu Aksi Pancasila (Padlet-Style Real-time Board)

Platform kolaboratif kelas untuk pengisian **Kartu Aksi Pancasila** (Absen 1 - 20) secara *real-time* seperti Padlet. Terintegrasi dengan **Supabase** untuk database online & realtime sync, serta siap di-deploy secara instan ke **Vercel**.

---

## 🚀 Fitur Utama
- **Real-time Synchronized**: Setiap ada murid yang menyimpan kartu, tampilan di layar guru atau murid lain otomatis ter-update tanpa perlu refresh.
- **Tanda Tangan Digital (Canvas Paraf)**: Orang tua / siswa bisa langsung tanda tangan di layar HP / laptop.
- **Kompresi Foto Otomatis**: Foto aksi otomatis dikompres sebelum disimpan ke database agar cepat dan hemat kuota.
- **Unduh PNG**: Kartu aksi yang sudah lengkap bisa langsung diunduh dalam resolusi tinggi (2000x1414 PNG) ke galeri perangkat.
- **Desain Responsif & Ramah Mobile**: Menggunakan font Fredoka yang ramah anak sekolah dan tata letak dinamis (`cqw`).

---

## 🛠️ Panduan Setup (Supabase & Vercel)

### Langkah 1: Buat Project & Database di Supabase (Gratis)
1. Buka [https://supabase.com](https://supabase.com) dan masuk / buat akun.
2. Klik tombol **New Project**, beri nama project (misal: `padlet-pancasila`), lalu tentukan password database.
3. Setelah project siap, di bilah navigasi sebelah kiri, klik **SQL Editor**.
4. Klik **New Query**, lalu salin dan tempel kode berikut:

```sql
-- 1. Buat tabel kartu_pancasila
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

-- 3. Izin publik untuk membaca, menambah, dan memperbarui
create policy "Izin publik membaca kartu" on public.kartu_pancasila for select using (true);
create policy "Izin publik menambah kartu" on public.kartu_pancasila for insert with check (true);
create policy "Izin publik memperbarui kartu" on public.kartu_pancasila for update using (true);

-- 4. Aktifkan Realtime Replication
alter publication supabase_realtime add table public.kartu_pancasila;
```
5. Klik **Run** (tombol hijau di kanan bawah SQL Editor) sampai muncul pesan *Success*.

---

### Langkah 2: Hubungkan Kredensial ke `config.js`
1. Di dashboard Supabase, klik ikon **Project Settings** (ikon gerigi di bilah kiri bawah).
2. Pilih menu **API** (di bawah *Configuration*).
3. Salin **Project URL** dan **Project API Keys (`anon` / `public`)**.
4. Buka file [`config.js`](./config.js), lalu masukkan kredensial tersebut:

```javascript
window.SUPABASE_CONFIG = {
  url: 'https://xyzabcdefghijklm.supabase.co', // Ganti dengan URL project kamu
  anonKey: 'eyJhbGciOiJIUzI1NiIsIn...'        // Ganti dengan anon public key kamu
};
```
5. Simpan file `config.js`.

---

### Langkah 3: Deploy ke Vercel (Gratis & Langsung Dapat Link Web)
1. Buka [https://vercel.com](https://vercel.com) dan login menggunakan akun GitHub kamu.
2. Klik **Add New...** -> **Project**.
3. Pilih repository **`raihanbaskara/Padlet-ismi`** lalu klik **Import**.
4. Klik **Deploy** (tanpa perlu ubah pengaturan apa pun).
5. Dalam 1 menit, Vercel akan memberikan link web aktif (misal: `https://padlet-ismi.vercel.app`).
6. Bagikan link tersebut ke grup WhatsApp kelas / siswa! 🎉

---

## 📁 Struktur Berkas
- `index.html`: Halaman utama aplikasi (Entrypoint Vercel).
- `config.js`: Tempat menyimpan URL & API Key Supabase.
- `supabase_setup.sql`: Script SQL pembantu untuk membuat tabel database & realtime policy.
- `vercel.json`: Konfigurasi routing static web di Vercel.
- `Kartu Aksi Pancasila – Kelas.html`: Cadangan berkas orisinal (sudah diperbarui ke versi Supabase).