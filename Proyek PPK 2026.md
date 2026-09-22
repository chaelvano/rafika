# Project Mata Kuliah PPK (Pengembangan Platform Khusus) 2026 – Sistem Reservasi & Pelaporan Fasilitas Kampus

## 1. Ketentuan Umum

**Aturan Implementasi**
- **Authentication**: registrasi, login, logout
- **Struktur kode**: dipisah minimal antara koneksi DB, tampilan (HTML/view), dan logika proses
- **Validasi data**: dilakukan di sisi server *dan* client untuk form penting
- **UI/UX**: mudah digunakan

**Kolaborasi & Version Control**
- Wajib pakai repository GitHub/GitLab bersama
- Commit oleh semua anggota, dengan pesan commit jelas
- Struktur folder minimal: `/public`, `/app` (model/controller), `/views`, `/config`

**Pengumpulan**
- Durasi pengembangan: 3 Minggu
- Format: 1 file Word berisi:
  - Nama & NIM
  - Link Google Drive (source code, SQL, file pendukung)
  - Info setting untuk menjalankan program
  - Info login tiap actor/pengguna
  - Screenshot antarmuka + penjelasan singkat tiap fitur
- Dipresentasikan sebagai UTS
  - Presentasi mencakup: latar belakang, fitur utama, demo sistem, kendala
  - Alokasi: 10 menit presentasi + 10–15 menit tanya jawab

---

## 2. Deskripsi Project

Aplikasi web untuk mengelola penggunaan fasilitas kampus (ruang kelas, aula, laboratorium, peralatan, lapangan). Pengguna dapat mengecek ketersediaan dan mengajukan reservasi, serta melaporkan kerusakan/masalah pada fasilitas. Petugas dan admin memproses kedua alur (reservasi & laporan) secara terpusat.

### Ketentuan Waktu Reservasi
- Jam operasional: **07.00–20.00**
- Slot waktu tetap **30 menit** (07.00–07.30, 07.30–08.00, dst.)
- `start_time` & `end_time` wajib dalam jam operasional dan kelipatan 30 menit
- Validasi ini **wajib di server**, bukan hanya di kalender/tampilan

---

## 3. Aktor

| Aktor | Deskripsi |
|---|---|
| **Pengunjung** | Lihat daftar fasilitas & ketersediaan (tersedia/tidak), tanpa detail, tanpa login |
| **Pengguna** (mahasiswa/dosen/staf, login) | Ajukan reservasi, laporkan kerusakan fasilitas |
| **Petugas** | Proses antrian reservasi & laporan (approve/reject/cancel, resolusi laporan), update status fasilitas (termasuk "dalam perbaikan") |
| **Admin** | Kelola data master fasilitas, rekap lintas fasilitas, daftarkan akun petugas & pengguna langsung, verifikasi akun hasil registrasi mandiri |

---

## 4. User Story

| No | Aktor | User Story |
|---|---|---|
| 1 | Pengunjung/Pengguna | Melihat daftar fasilitas & status ketersediaan per slot waktu, tanpa detail pemohon/tujuan |
| 2 | Pengunjung/Pengguna | Mencari fasilitas berdasarkan tipe/lokasi/kapasitas |
| 3 | Pengguna | Mengajukan reservasi pada rentang waktu tertentu + tujuan penggunaan |
| 4 | Pengguna | Membatalkan reservasi sendiri sebelum batas waktu tertentu |
| 5 | Pengguna | Melihat riwayat & status reservasi sendiri, termasuk detail lengkap |
| 6 | Pengguna | Melaporkan kerusakan/masalah fasilitas (kategori, deskripsi, foto) |
| 7 | Pengguna | Melihat status laporan sendiri |
| 8 | Petugas | Melihat dashboard/antrian reservasi & laporan yang belum diproses |
| 9 | Petugas | Approve/reject reservasi manual; sistem cegah bentrok jadwal pada fasilitas sama |
| 10 | Petugas | Membatalkan reservasi yang sudah disetujui (kondisi mendesak) + alasan pembatalan |
| 11 | Petugas | Mengubah status laporan (baru/diproses/selesai/ditolak) + catatan resolusi saat ditutup |
| 12 | Petugas | Menandai fasilitas "dalam perbaikan" terkait laporan, kembalikan ke "aktif" setelah selesai |
| 13 | Admin | Mendaftarkan akun petugas langsung (tanpa registrasi mandiri) |
| 14 | Admin | Mendaftarkan akun pengguna langsung tanpa form registrasi mandiri |
| 15 | Admin | Verifikasi/tolak akun pengguna hasil registrasi mandiri sebelum bisa login |
| 16 | Admin | Kelola data fasilitas (tambah/edit/nonaktifkan) |
| 17 | Admin | Lihat & ekspor (CSV/Excel/PDF) rekap okupansi & frekuensi kerusakan per fasilitas/lokasi |

---

## 5. Hint Rancangan Database

- **Users**: nama, email, password, role
- **Facilities**: nama fasilitas, tipe, lokasi, kapasitas, deskripsi
- **Reservations**: nama pemesan, fasilitas dipesan, waktu penggunaan, status
- **Reports**: pelapor, fasilitas dilaporkan, kategori laporan, deskripsi, foto, status laporan

> Catatan: boleh menambah tabel/atribut lain jika diperlukan (mis. `facility_status_log`, `reservation_time_slots`, foreign key antar tabel di atas).
