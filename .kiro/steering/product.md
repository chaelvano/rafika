# Product Overview

**Status Project**: Phase 1 ✅ Selesai (Auth & Foundation) | Phase 2 🚧 In Progress

**Nama Project**: Rafika - Sistem Reservasi & Pelaporan Fasilitas Kampus

Aplikasi web untuk mengelola penggunaan fasilitas kampus (ruang kelas, aula,
laboratorium, peralatan, lapangan). Dua alur utama:

1. **Reservasi** — pengguna mengecek ketersediaan & mengajukan reservasi
2. **Pelaporan** — pengguna melaporkan kerusakan/masalah fasilitas

Petugas dan admin memproses kedua alur secara terpusat.

## Aktor & Akses
| Aktor | Akses | Bisa Registrasi Mandiri? |
|---|---|---|
| **Pengunjung** | Lihat daftar fasilitas & status ketersediaan (tanpa detail) | - |
| **Pengguna** (mahasiswa/dosen/staf) | Ajukan reservasi, lapor kerusakan, lihat riwayat sendiri | ✅ Ya (butuh verifikasi admin) |
| **Petugas** | Approve/reject reservasi, kelola laporan, update status fasilitas | ❌ Tidak (dibuat langsung oleh admin) |
| **Admin** | Kelola master data, rekap, kelola user/petugas | ❌ Tidak (akun pertama manual, atau bikin sendiri) |

## Aturan Bisnis Utama

### 1. Jam Operasional & Slot Waktu
- Jam operasional: **07.00–20.00** (setiap hari)
- Slot reservasi tetap **30 menit** (07.00–07.30, 07.30–08.00, dst.)
- `waktu_mulai` & `waktu_selesai` **wajib** dalam jam operasional dan kelipatan 30 menit
- ⚠️ **Validasi ini WAJIB di server**, bukan hanya di kalender/tampilan client

### 2. Reservasi Same-Day Only
- Reservasi **harus dalam 1 hari yang sama** (tidak boleh cross-day/lintas hari)
- ✅ **Valid**: Reservasi 15.00–20.00 (hari yang sama)
- ❌ **Invalid**: Reservasi 15.00 hari ini sampai 12.00 besok
- Jika ingin reservasi cross-day, harus buat **2 reservasi terpisah**:
  - Reservasi 1: 15.00–20.00 (hari pertama)
  - Reservasi 2: 07.00–12.00 (hari kedua)

### 3. H-1 Booking Rule
- Reservasi harus dibuat **minimal 1 hari sebelum** tanggal penggunaan
- Contoh: Reservasi untuk 21 Sept 2026 harus dibuat paling lambat **20 Sept 2026 23:59**
- Jika reservasi masih status `menunggu` dan melewati deadline → **auto-reject** oleh sistem dengan alasan otomatis

### 2. Conflict Prevention
- Sistem harus **mencegah bentrok jadwal** pada fasilitas yang sama
- Validasi dilakukan di database level (query check overlap) + constraint
- Fasilitas dengan status "Dalam Perbaikan" tidak bisa direservasi
- Reservasi yang bentrok dengan reservasi lain (status `menunggu` atau `disetujui`) akan ditolak sistem

### 3. Status Reservasi
- **Menunggu** (default saat diajukan)
- **Disetujui** (disetujui petugas)
- **Ditolak** (ditolak petugas dengan alasan, atau **auto-reject** jika melewati H-1)
- **Dibatalkan** (dibatalkan pengguna sebelum waktu tertentu, atau petugas paksa cancel)
- **Selesai** (sudah lewat waktunya)

### 4. Status Laporan
- **Baru** (default saat dilaporkan)
- **Diproses** (petugas sedang menangani)
- **Selesai** (diperbaiki + ada catatan resolusi)
- **Ditolak** (bukan kerusakan valid, ada catatan)

### 5. Status Fasilitas
- **Aktif** (bisa direservasi)
- **Dalam Perbaikan** (terkait laporan, tidak bisa direservasi)
- **Nonaktif** (dinonaktifkan admin, tidak tampil di daftar)

### 6. Pembatalan Reservasi
- Pengguna bisa batalkan sendiri jika status masih **Menunggu** atau **Disetujui** dan waktu penggunaan belum lewat
- Petugas bisa paksa cancel reservasi **Disetujui** (kondisi mendesak) dengan alasan
- Sistem akan **auto-reject** reservasi yang masih **Menunggu** dan melewati deadline H-1

### 7. Akun & Verifikasi
- Pengguna registrasi mandiri → status "Menunggu Verifikasi" → admin verifikasi → bisa login
- Petugas **tidak bisa** registrasi mandiri — akun dibuat langsung oleh admin
- Admin pertama: bikin manual via SQL seed, atau fitur "Inisialisasi Admin"

## Fitur Utama per Aktor

### Pengunjung (Tanpa Login)
✅ **DONE**: Lihat daftar fasilitas (foto, nama, tipe, lokasi, kapasitas)  
⏳ TODO: Filter fasilitas (tipe/lokasi/kapasitas)  
⏳ TODO: Lihat status ketersediaan per slot (tersedia/tidak) **tanpa detail pemohon**

**Catatan**: Kapasitas **harus NULL** untuk tipe `peralatan` dan `lapangan` (tidak relevan)  

### Pengguna (Login)
✅ **DONE**: Sistem autentikasi (register, login, logout)  
✅ **DONE**: Lihat daftar fasilitas  
⏳ TODO: Ajukan reservasi (pilih fasilitas, tanggal, slot waktu, tujuan)  
⏳ TODO: Lihat riwayat & status reservasi sendiri (detail lengkap)  
⏳ TODO: Batalkan reservasi sendiri (sebelum waktu tertentu)  
⏳ TODO: Laporkan kerusakan fasilitas (kategori, deskripsi, foto)  
⏳ TODO: Lihat status laporan sendiri  

### Petugas (Login)
✅ **DONE**: Sistem autentikasi  
⏳ TODO: Dashboard - antrian reservasi & laporan yang butuh tindakan  
⏳ TODO: Approve/reject reservasi (manual, sistem cegah bentrok jadwal)  
⏳ TODO: Batalkan reservasi yang sudah disetujui (kondisi mendesak + alasan)  
⏳ TODO: Kelola laporan - ubah status (baru → diproses → selesai/ditolak) + catatan resolusi  
⏳ TODO: Tandai fasilitas "Dalam Perbaikan" terkait laporan, kembalikan ke "Aktif"  

### Admin (Login)
✅ **DONE**: Sistem autentikasi  
⏳ TODO: Semua fitur petugas +  
⏳ TODO: Kelola master data fasilitas (tambah/edit/nonaktifkan)  
⏳ TODO: Daftarkan akun petugas langsung (tanpa registrasi mandiri)  
⏳ TODO: Daftarkan akun pengguna langsung (tanpa registrasi mandiri)  
⏳ TODO: Verifikasi/tolak akun pengguna dari registrasi mandiri  
⏳ TODO: Rekap okupansi & frekuensi kerusakan per fasilitas/lokasi  
⏳ TODO: Ekspor rekap (CSV/Excel/PDF)  

## Teknologi & Deployment
- **Backend**: Express.js + EJS
- **Database**: PostgreSQL (Railway)
- **Hosting**: Railway (auto-deploy dari GitHub)
- **Timeline**: 3 minggu development + presentasi UTS

## Success Metrics (untuk Demo)

**Completed** ✅:
1. ✅ User bisa registrasi → admin verifikasi → user login
2. ✅ Sistem authentication & authorization berfungsi (role-based access)
3. ✅ Public view fasilitas tersedia
4. ✅ Database schema lengkap dengan constraints
5. ✅ Reusable UI components (navbar, forms, tables, buttons)

**In Progress** 🚧:
6. User bisa lihat fasilitas & ajukan reservasi tanpa bentrok
7. Petugas bisa approve/reject reservasi
8. User bisa lapor kerusakan + upload foto
9. Petugas bisa ubah status fasilitas "Dalam Perbaikan"
10. Validasi slot 30 menit & jam operasional berfungsi di server

**Todo** ⏳:
11. Admin bisa lihat rekap okupansi & ekspor data
