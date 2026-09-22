# Deployment Guide - Railway

Panduan deploy aplikasi Express.js + PostgreSQL ke Railway.

## Prerequisites
- Akun Railway (https://railway.app)
- GitHub repository project ini
- PostgreSQL database ready (via Railway plugin)

## Langkah-Langkah Deploy

### 1. Setup Railway Project
```bash
# Login Railway CLI (opsional, bisa via web UI juga)
npm i -g @railway/cli
railway login
```

### 2. Push ke GitHub
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/USERNAME/REPO.git
git push -u origin main
```

### 3. Connect Railway ke GitHub
1. Buka https://railway.app/new
2. Pilih "Deploy from GitHub repo"
3. Authorize Railway akses ke repo
4. Select repository project ini

### 4. Add PostgreSQL Plugin
1. Di Railway dashboard → "New" → "Database" → "Add PostgreSQL"
2. Railway otomatis generate `DATABASE_URL` di environment variables
3. Catat credentials (atau langsung pakai `DATABASE_URL`)

### 5. Configure Environment Variables
Di Railway dashboard → project → Variables, tambahkan:
```
DATABASE_URL=postgresql://... (sudah auto-generate dari plugin)
SESSION_SECRET=random-secret-key-min-32-chars-gunakan-generator
NODE_ENV=production
PORT=3000
```

**Generate SESSION_SECRET**:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 6. Setup Build & Start Commands
Railway otomatis detect `package.json`, tapi pastikan ada:

**package.json**:
```json
{
  "scripts": {
    "start": "node app.js",
    "dev": "nodemon app.js"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

Atau buat `railway.json`:
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "node app.js",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### 7. Run Database Migrations
Ada 2 cara:

**Cara 1**: Manual via Railway PostgreSQL dashboard
1. Railway dashboard → PostgreSQL → "Data" tab
2. Copy-paste isi file SQL dari `/database/migrations/`
3. Execute

**Cara 2**: Via Railway CLI (lokal)
```bash
# Install Railway CLI
railway login
railway link  # Link ke project Railway

# Connect ke PostgreSQL Railway
railway run psql $DATABASE_URL -f database/migrations/001_initial_schema.sql
railway run psql $DATABASE_URL -f database/seeds/001_data_awal.sql
```

**Cara 3**: Script di `package.json` (run once manual)
```json
{
  "scripts": {
    "migrate": "node scripts/migrate.js"
  }
}
```

Buat `scripts/migrate.js`:
```javascript
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function migrate() {
  const sql = fs.readFileSync(path.join(__dirname, '../database/migrations/001_initial_schema.sql'), 'utf8');
  await pool.query(sql);
  console.log('Migration success');
  process.exit(0);
}

migrate().catch(err => {
  console.error(err);
  process.exit(1);
});
```

Run via Railway:
```bash
railway run npm run migrate
```

### 8. Verify Deployment
1. Railway otomatis generate public URL (mis. `https://your-app.up.railway.app`)
2. Buka URL tersebut di browser
3. Test: registrasi → login → fitur utama

### 9. Auto-Deploy Setup
Railway otomatis re-deploy setiap ada push ke branch `main` (GitHub).

**Tips**: Gunakan branch `dev` untuk development, merge ke `main` hanya saat siap demo.

## Environment Variables Summary

| Variable | Contoh | Keterangan |
|---|---|---|
| `DATABASE_URL` | `postgresql://user:pass@host:5432/db` | Auto-generate dari Railway plugin |
| `SESSION_SECRET` | `a1b2c3d4...` (min 32 char) | Generate via `crypto.randomBytes(32)` |
| `NODE_ENV` | `production` | Untuk optimasi Express |
| `PORT` | `3000` | Railway otomatis set (optional) |

## Troubleshooting

### Error: "Cannot connect to database"
- Cek `DATABASE_URL` di environment variables Railway
- Pastikan PostgreSQL plugin sudah active

### Error: "Session store not available"
- Pastikan `connect-pg-simple` terinstall
- Cek tabel `session` sudah dibuat (ada di migration)

### Error: "Port already in use"
- Railway otomatis set port via `process.env.PORT`
- Pastikan `app.js` pakai: `const PORT = process.env.PORT || 3000;`

### Migration Gagal
- Cek syntax SQL (pakai PostgreSQL syntax, bukan MySQL)
- Jalankan migration manual via Railway dashboard → PostgreSQL → Data tab

### Upload File Tidak Jalan
- Railway ephemeral filesystem: file upload hilang saat re-deploy
- Solusi: pakai Cloudinary atau AWS S3 untuk production
- Untuk demo/tugas kuliah: upload lokal acceptable (re-upload setiap deploy)

## Monitoring & Logs
```bash
# Lihat logs real-time
railway logs

# Restart service
railway restart
```

Di Railway dashboard juga ada tab "Deployments" untuk lihat history & logs.

## Checklist Pre-Demo
- [ ] Database migrations berhasil
- [ ] Seed data (dummy accounts) sudah masuk
- [ ] Environment variables set dengan benar
- [ ] Akun admin/petugas/user test bisa login
- [ ] Fitur reservasi & pelaporan berfungsi
- [ ] Upload foto laporan berfungsi (atau disable jika issue)
- [ ] URL public Railway sudah dicatat untuk presentasi

## Cost Estimate (Railway Free Tier)
- Free tier: $5 credit/month
- PostgreSQL: ~$5/month (bisa pakai credit)
- Web service: free (500 hours/month cukup untuk demo)
- **Total**: Gratis untuk 1 bulan demo, cukup untuk UTS