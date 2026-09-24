# Sistem Reservasi & Pelaporan Fasilitas Kampus

Project Mata Kuliah PPK (Pengembangan Platform Khusus) 2026

## 📋 Deskripsi

Aplikasi web untuk mengelola penggunaan fasilitas kampus (ruang kelas, aula, laboratorium, peralatan, lapangan). Pengguna dapat mengecek ketersediaan dan mengajukan reservasi, serta melaporkan kerusakan/masalah pada fasilitas.

## 🛠️ Tech Stack

- **Backend**: Node.js + Express.js
- **Template Engine**: EJS
- **Database**: PostgreSQL
- **Session**: express-session + connect-pg-simple
- **Auth**: bcrypt (password hashing)
- **Deployment**: Railway

## 📦 Installation

### Prerequisites
- Node.js v18+
- PostgreSQL v15+
- npm atau yarn

### Setup Local

1. **Clone repository**
```bash
git clone https://github.com/chaelvano/rafika.git
cd rafika
```

2. **Install dependencies**
```bash
npm install
```

3. **Setup environment variables**
```bash
# Copy .env.example ke .env
copy .env.example .env

# Edit .env dengan konfigurasi lokal Anda
```

4. **Setup database**
```bash
# Buat database PostgreSQL
createdb rafika

# Atau via psql
psql -U postgres
CREATE DATABASE rafika;
\q

# Run migrations
psql -U postgres -d rafika -f database/migrations/001_initial_schema.sql

# Run seeds (data awal)
psql -U postgres -d rafika -f database/seeds/001_data_awal.sql
```

5. **Generate SESSION_SECRET**
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```
Copy hasilnya ke `.env` sebagai `SESSION_SECRET`

6. **Run development server**
```bash
npm run dev
```

Server akan berjalan di `http://localhost:3000`

## 🗂️ Project Structure

```
rafika/
├── app/
│   ├── controllers/     # Logika bisnis per modul
│   ├── models/          # Query database & business logic
│   └── middleware/      # Auth, validation, error handling
├── config/              # Database & session configuration
├── database/
│   ├── migrations/      # Schema SQL
│   └── seeds/           # Data awal
├── public/              # Static assets (CSS, JS, images, uploads)
├── routes/              # Express routes
├── utils/               # Helper functions
├── views/               # EJS templates
└── app.js               # Entry point
```

## 👥 Akun Test (Setelah Seed)

Setelah menjalankan seed data (`001_initial_data.sql`), tersedia akun berikut:

| Role | Nama | Email | Password | Status |
|---|---|---|---|---|
| **Admin** | Administrator Satu | admin1@faculties.undip.ac.id | `*Admin123` | aktif |
| **Petugas** | Petugas Satu | petugas1@faculties.undip.ac.id | `*Petugas123` | aktif |
| **Pengguna** (Dosen) | Dosen Satu | dosen1@faculties.undip.ac.id | `*Dosen123` | aktif |
| **Pengguna** (Mahasiswa) | Mahasiswa Satu | mahasiswa1@students.undip.ac.id | `*Mahasiswa123` | menunggu_verifikasi |

**Catatan**: Akun mahasiswa1 memiliki status `menunggu_verifikasi` untuk testing approval flow oleh admin.

## 🚀 Deployment (Railway)

Lihat panduan lengkap di `.kiro/steering/deployment.md`

## 📝 Development Timeline

- **Minggu 1**: Setup + Auth + Master Data Fasilitas
- **Minggu 2**: Reservasi + Pelaporan + Dashboard Petugas
- **Minggu 3**: Dashboard Admin + Testing + Dokumentasi + Deployment

## 🤝 Contributing

Lihat `.kiro/steering/ai-workflow.md` untuk aturan development dengan Kiro AI.

## 📄 License

ISC
