# 📚 Steering Files - Sistem Reservasi & Pelaporan Fasilitas Kampus

**Status Project**: Phase 1 ✅ Selesai | Phase 2 🚧 In Progress | Phase 3 ⏳ Todo

Folder ini berisi dokumen konteks dan panduan untuk project Mata Kuliah PPK 2026.

## 📂 Daftar File

### Core Documents
1. **[product.md](./product.md)** — Product overview, aktor, aturan bisnis, fitur utama
2. **[tech.md](./tech.md)** — Technology stack (Express.js + EJS + PostgreSQL)
3. **[structure.md](./structure.md)** — Struktur folder project, konvensi penamaan
4. **[database-schema.md](./database-schema.md)** — Schema database lengkap + query examples

### Workflow & Process
5. **[ai-workflow.md](./ai-workflow.md)** — Aturan kerja sama dengan Kiro AI
6. **[development-checklist.md](./development-checklist.md)** — Checklist 3 minggu development
7. **[deployment.md](./deployment.md)** — Panduan deploy ke Railway

## 🚀 Quick Start

### 1. Baca Requirement
Baca [Proyek PPK 2026.md](../Proyek%20PPK%202026.md) di root folder untuk requirement lengkap.

### 2. Pahami Product
Baca [product.md](./product.md) untuk memahami:
- Aktor & akses
- Aturan bisnis (jam operasional, slot 30 menit, dll)
- Fitur per aktor

### 3. Setup Tech Stack
Baca [tech.md](./tech.md) untuk:
- Dependencies yang dibutuhkan
- Perintah install & run
- Timeline development

### 4. Design Database
Baca [database-schema.md](./database-schema.md) untuk:
- Schema tabel lengkap
- Indexes untuk performa
- Query examples

### 5. Ikuti Development Checklist
Baca [development-checklist.md](./development-checklist.md) untuk:
- Breakdown task per hari (3 minggu)
- Prioritas fitur
- Pre-demo checklist

### 6. Deploy ke Railway
Baca [deployment.md](./deployment.md) untuk:
- Setup Railway project
- Migration database
- Troubleshooting

## 🎯 Critical Success Factors

### Validasi Wajib (Poin Penting Tugas!)
- ✅ **DONE**: Database constraints untuk slot 30 menit & jam operasional
- ✅ **DONE**: Database constraints untuk same-day only & H-1 booking
- ⏳ TODO: Validasi **wajib di server** (utils/slotWaktu.js)
- ⏳ TODO: Sistem **cegah bentrok jadwal** pada fasilitas sama (query check overlap)

### Authentication & Authorization
- ✅ **DONE**: User registrasi mandiri → status menunggu_verifikasi
- ⏳ TODO: Admin verifikasi → status aktif → bisa login
- ✅ **DONE**: Petugas **tidak bisa** registrasi mandiri (dibuat oleh admin via seed)
- ✅ **DONE**: Pengunjung bisa lihat ketersediaan **tanpa login**

### Struktur Kode (Ketentuan Tugas)
- ✅ **DONE**: Pisah koneksi DB (`/config/db.js`)
- ✅ **DONE**: Pisah tampilan (`/views/*.ejs`)
- ✅ **DONE**: Pisah logika proses (`/app/controllers/`, `/app/models/`)
- ✅ **DONE**: Middleware terpisah (`/app/middleware/`)
- ✅ **DONE**: Reusable components (`/views/partials/`)

### Collaboration
- ✅ **DONE**: GitHub repo bersama (semua anggota commit)
- ✅ **DONE**: Commit message jelas (`feat:`, `fix:`, `refactor:`)
- ✅ **DONE**: Struktur folder sesuai ketentuan

## 📊 Current Project Status

### What's Done ✅
- Database schema & migrations complete dengan semua constraints
- Authentication system (register, login, logout) dengan bcrypt
- Role-based authorization middleware (isAuthenticated, hasRole)
- Rate limiting untuk auth endpoints
- Validation middleware dengan express-validator
- Public facility listing page
- Reusable UI components (navbar, textfield, table, 4 button variants)
- Error handling & 404 page
- Session management dengan PostgreSQL store
- Seed data: 4 akun test (1 admin, 1 petugas, 1 dosen, 1 mahasiswa) + 24 fasilitas + sample reservasi & laporan

### Next Priority 🚧
- Models: Fasilitas, Reservasi, Laporan
- Controllers: fasilitas, reservasi, laporan
- Utils: slotWaktu.js (validasi), tanggalHelper.js, uploadFile.js
- Views: form reservasi, riwayat, form laporan
- Calendar/date picker integration (Flatpickr)

### Pending ⏳
- Dashboard petugas
- Dashboard admin
- Export rekap (CSV/Excel)
- Deployment ke Railway

---

## 🔗 External Resources

### Documentation
- [Express.js Docs](https://expressjs.com/)
- [EJS Docs](https://ejs.co/)
- [node-postgres Docs](https://node-postgres.com/)
- [Railway Docs](https://docs.railway.app/)

### Libraries
- [express-validator](https://express-validator.github.io/docs/)
- [bcrypt](https://www.npmjs.com/package/bcrypt)
- [multer](https://www.npmjs.com/package/multer)
- [Flatpickr](https://flatpickr.js.org/) (date picker)
- [Bootstrap 5.3](https://getbootstrap.com/docs/5.3/)

## 🤝 Team Collaboration

### Git Workflow
```bash
# Buat branch untuk fitur baru
git checkout -b feat/nama-fitur

# Commit dengan pesan jelas
git add .
git commit -m "feat: tambah validasi slot 30 menit"

# Push ke GitHub
git push origin feat/nama-fitur

# Merge ke main setelah review (atau langsung di GitHub)
git checkout main
git merge feat/nama-fitur
git push origin main
```

### Progress Tracking
**Week 1** ✅ DONE (Sep 15-21, 2026):
- Setup project struktur
- Database schema & migrations complete
- Authentication system (register, login, logout)
- Public facility listing
- Reusable UI components

**Week 2** 🚧 IN PROGRESS (Sep 22-28, 2026):
- Facility management (CRUD)
- Reservation system
- Report system
- Staff dashboard

**Week 3** ⏳ TODO (Sep 29 - Oct 5, 2026):
- Admin dashboard
- Data export features
- Testing & bug fixes
- Documentation & deployment

### Daily Standup (di grup)
Setiap hari, share:
1. Kemarin mengerjakan: ...
2. Hari ini akan mengerjakan: ...
3. Ada blocker? ...

### Code Review (opsional tapi bagus)
- Sebelum merge ke `main`, minta 1 anggota review kode
- Pastikan kode bisa dijelaskan saat presentasi

## 🎓 Preparing for UTS Presentation

### What to Prepare
1. **PPT Slides** (max 10 slide):
   - Latar belakang
   - Fitur utama (dengan screenshot)
   - Tech stack + alasan
   - Demo live
   - Kendala & solusi
2. **Live Demo** (Railway URL)
3. **Backup Screenshots** (jika Railway down)
4. **File Word** (dokumentasi lengkap):
   - Nama & NIM anggota
   - Link Google Drive (source code + SQL)
   - Info setting + login tiap actor
   - Screenshot + penjelasan tiap fitur

### Q&A Preparation
Antisipasi pertanyaan tentang:
- Cara cegah SQL injection? (parameterized queries)
- Cara validasi slot 30 menit? (check di server + constraint DB)
- Cara cegah bentrok jadwal? (query check overlap)
- Kenapa pakai session bukan JWT? (sesuai requirement + simpel)
- Bagian mana yang paling challenging? (honest answer + solusi)

### Role Assignment for Demo
- **Person 1** (Admin): kelola fasilitas, verifikasi user, lihat rekap
- **Person 2** (Petugas): approve/reject reservasi, kelola laporan
- **Person 3** (User): ajukan reservasi, lapor kerusakan

## 📞 Need Help?

### Tanya ke Kiro AI
Kiro sudah baca semua file ini dan siap bantu. Contoh:
- "Kiro, buatkan migration untuk tabel reservations"
- "Kiro, jelaskan cara validasi slot 30 menit"
- "Kiro, bantu debug error ini: ..."

### Ikuti AI Workflow
Baca [ai-workflow.md](./ai-workflow.md) untuk:
- Aturan kerja sama dengan Kiro
- Task flow yang ideal
- Anti-pattern yang harus dihindari

---

**Last Updated**: September 22, 2026  
**Project Status**: Phase 1 Complete ✅ | Phase 2 In Progress 🚧  
**Project Duration**: 3 Minggu  
**Tech Stack**: Express.js + EJS + PostgreSQL  
**Deployment**: Railway  
**Deadline**: Presentasi UTS (Early October 2026)