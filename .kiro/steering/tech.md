# Technology Stack

**Status Project**: Phase 1 ✅ Selesai | Phase 2 🚧 In Progress | Phase 3 ⏳ TODO

Stack dipilih untuk **fast delivery** dengan deployment di **Railway**.

## Backend
- **Runtime**: Node.js v18+ 
- **Framework**: Express.js v4
- **Template Engine**: EJS (Embedded JavaScript)
- **Database**: PostgreSQL v15+ (Railway plugin)
- **ORM/Query**: `pg` (node-postgres) — query builder sederhana, cepat dipahami
- **Auth**: express-session + connect-pg-simple (session di PostgreSQL)
- **Validation**: express-validator (server-side)
- **File Upload**: multer (untuk foto laporan kerusakan)
- **Environment**: dotenv

## Frontend
- **Styling**: Bootstrap 5.3 (via CDN) — UI cepat, responsive otomatis
- **Icons**: Bootstrap Icons (via CDN)
- **JavaScript**: Vanilla JS untuk validasi client-side & interaksi kalender
- **Calendar/Date Picker**: Flatpickr (untuk pilih tanggal & slot 30 menit)
- **Client Validation**: form validation Bootstrap + custom JS

## Database Schema Management
- **Migration**: SQL script manual di `/database/migrations/`
- **Seeding**: SQL script untuk data dummy di `/database/seeds/`
- Alasan: sederhana, mudah di-review untuk tugas kuliah

## Deployment (Railway)
- `Procfile` atau `railway.json` untuk start command
- Environment variables via Railway dashboard
- PostgreSQL plugin Railway (otomatis dapat `DATABASE_URL`)

## Security
- **Password**: bcrypt (hashing)
- **SQL Injection**: Parameterized queries (pg library)
- **XSS**: EJS auto-escape (default)
- **CSRF**: csurf middleware (opsional, untuk fast delivery bisa fase 2)
- **Rate Limiting**: express-rate-limit (untuk login/register)

## Struktur Folder (sesuai ketentuan tugas)

**Status**: ✅ Foundation selesai, 🚧 Core features in progress

```
/public          -> ✅ CSS, JS, images, uploaded files
/app
  /controllers   -> ✅ authController.js (DONE), TODO: fasilitas, reservasi, laporan
  /models        -> ✅ User.js (DONE), TODO: Fasilitas, Reservasi, Laporan
  /middleware    -> ✅ auth, validation, rateLimiter (DONE)
/views           -> ✅ login, register, facilities, error, partials (DONE)
  /partials      -> ✅ navbar, textField, table, buttons (DONE)
/config          -> ✅ db.js, session.js (DONE)
/database
  /migrations    -> ✅ 001_initial_schema.sql (DONE)
  /seeds         -> ✅ 001_initial_data.sql (DONE)
/routes          -> ✅ index.js, auth.js, facilities.js (DONE)
/utils           -> ⏳ TODO: slotWaktu, tanggalHelper, uploadFile
```

## Dependencies Utama
```json
{
  "express": "^4.18.0",
  "ejs": "^3.1.0",
  "pg": "^8.11.0",
  "express-session": "^1.17.0",
  "connect-pg-simple": "^9.0.0",
  "bcrypt": "^5.1.0",
  "express-validator": "^7.0.0",
  "multer": "^1.4.5-lts.1",
  "dotenv": "^16.0.0",
  "express-rate-limit": "^7.1.0"
}
```

## Perintah Umum

**Status**: ✅ Semua command sudah tested & working

```bash
# Install dependencies
npm install

# Setup database (manual execute SQL)
psql -U postgres -d rafika < database/migrations/001_initial_schema.sql
psql -U postgres -d rafika < database/seeds/001_initial_data.sql

# Development (✅ WORKING)
npm run dev          # nodemon app.js

# Production (Railway)
npm start            # node app.js

# Environment variables (.env) - ✅ CONFIGURED
DATABASE_URL=postgresql://user:pass@host:5432/dbname
SESSION_SECRET=random-secret-key-min-32-chars
NODE_ENV=development
PORT=3000
```

## Git Workflow
- Branch strategy: `main` (production), `dev` (development)
- Commit convention: `feat:`, `fix:`, `refactor:`, `docs:`

## Development Timeline (3 Minggu)

**Status Update** (September 22, 2026):

**Minggu 1**: ✅ **SELESAI** - Setup + Auth + Master Data Fasilitas  
- ✅ Setup project struktur
- ✅ Database schema & migrations
- ✅ Authentication system (register, login, logout)
- ✅ Role-based middleware (isAuthenticated, hasRole)
- ✅ Validation middleware & rate limiting
- ✅ Reusable UI components (navbar, textfield, table, buttons)
- ✅ Landing page fasilitas (public view)
- ✅ Error handling

**Minggu 2**: 🚧 **IN PROGRESS** - Reservasi + Pelaporan + Dashboard Petugas  
- ⏳ Model & Controller untuk Fasilitas, Reservasi, Laporan
- ⏳ Utils untuk validasi slot waktu & cek bentrok jadwal
- ⏳ Form reservasi + kalender slot
- ⏳ Riwayat reservasi user
- ⏳ Form laporan kerusakan + upload foto
- ⏳ Dashboard petugas (kelola reservasi & laporan)

**Minggu 3**: ⏳ **TODO** - Dashboard Admin + Testing + Dokumentasi + Deployment  
- ⏳ Dashboard admin (kelola user, verifikasi, rekap)
- ⏳ Export rekap (CSV/Excel)
- ⏳ Testing menyeluruh
- ⏳ Bug fixing
- ⏳ Dokumentasi lengkap
- ⏳ Deploy ke Railway
