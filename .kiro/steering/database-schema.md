# Database Schema Design

**Status**: ✅ Migration & Seed Selesai (001_initial_schema.sql, 001_initial_data.sql)

Schema PostgreSQL untuk Sistem Reservasi & Pelaporan Fasilitas Kampus.

## Entity Relationship Overview
```
pengguna (1) ----< (N) reservasi (N) >---- (1) fasilitas
pengguna (1) ----< (N) laporan (N) >---- (1) fasilitas
fasilitas (1) ----< (N) log_status_fasilitas
```

## Tabel Utama

### 1. `pengguna`
Menyimpan semua akun: pengguna, petugas, admin.

```sql
CREATE TABLE pengguna (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,  -- bcrypt hash
  role VARCHAR(20) NOT NULL CHECK (role IN ('pengguna', 'petugas', 'admin')),
  status VARCHAR(20) DEFAULT 'menunggu_verifikasi' CHECK (status IN ('menunggu_verifikasi', 'aktif', 'nonaktif')),
  -- Status 'menunggu_verifikasi' untuk pengguna baru registrasi, 'aktif' setelah admin verifikasi
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_pengguna_email ON pengguna(email);
CREATE INDEX idx_pengguna_role ON pengguna(role);
```

**Business Rules**:
- `pengguna`: hasil registrasi mandiri (status `menunggu_verifikasi` → admin verifikasi → `aktif`)
- `petugas`: dibuat langsung oleh admin (status `aktif`)
- `admin`: dibuat manual via seed atau oleh admin lain

---

### 2. `fasilitas`
Master data fasilitas kampus.

```sql
CREATE TYPE tipe_fasilitas AS ENUM ('ruang_kelas', 'aula', 'laboratorium', 'peralatan', 'lapangan');
CREATE TYPE status_fasilitas AS ENUM ('aktif', 'dalam_perbaikan', 'nonaktif');
CREATE TYPE lokasi_fasilitas AS ENUM ('Gedung A', 'Gedung E');

CREATE TABLE fasilitas (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(255) NOT NULL,
  tipe tipe_fasilitas NOT NULL,
  lokasi lokasi_fasilitas,
  kapasitas INT CHECK (kapasitas IS NULL OR kapasitas > 0),
  deskripsi TEXT,
  url_foto VARCHAR(500),  -- URL foto fasilitas (opsional)
  status status_fasilitas DEFAULT 'aktif',
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Constraint: kapasitas wajib untuk ruang_kelas, aula, laboratorium
  CONSTRAINT chk_kapasitas_required CHECK (
    (tipe IN ('ruang_kelas', 'aula', 'laboratorium') AND kapasitas IS NOT NULL)
    OR
    (tipe IN ('peralatan', 'lapangan') AND kapasitas IS NULL)
  ),
  
  -- Constraint: lokasi wajib untuk ruang_kelas, aula, laboratorium
  CONSTRAINT chk_lokasi_required CHECK (
    (tipe IN ('ruang_kelas', 'aula', 'laboratorium') AND lokasi IS NOT NULL)
    OR
    (tipe IN ('peralatan', 'lapangan') AND lokasi IS NULL)
  )
);

CREATE INDEX idx_fasilitas_tipe ON fasilitas(tipe);
CREATE INDEX idx_fasilitas_status ON fasilitas(status);
CREATE INDEX idx_fasilitas_lokasi ON fasilitas(lokasi);
```

**Business Rules**:
- Status `aktif`: bisa direservasi
- Status `dalam_perbaikan`: tidak bisa direservasi (terkait laporan)
- Status `nonaktif`: tidak tampil di daftar publik
- Kolom `kapasitas`: 
  - **WAJIB (NOT NULL)** untuk tipe: `ruang_kelas`, `aula`, `laboratorium`
  - **HARUS NULL** untuk tipe: `peralatan`, `lapangan`
- Kolom `lokasi`:
  - **WAJIB (NOT NULL)** untuk tipe: `ruang_kelas`, `aula`, `laboratorium`
  - **HARUS NULL** untuk tipe: `peralatan`, `lapangan`
  - Nilai yang diperbolehkan: 'Gedung A', 'Gedung E' (bisa ditambah sesuai kebutuhan)

---

### 3. `reservasi`
Data reservasi fasilitas oleh pengguna.

```sql
CREATE TYPE status_reservasi AS ENUM ('menunggu', 'disetujui', 'ditolak', 'dibatalkan', 'selesai');

CREATE TABLE reservasi (
  id SERIAL PRIMARY KEY,
  id_fasilitas INT NOT NULL REFERENCES fasilitas(id) ON DELETE RESTRICT,
  id_pengguna INT NOT NULL REFERENCES pengguna(id) ON DELETE RESTRICT,
  waktu_mulai TIMESTAMP NOT NULL,
  waktu_selesai TIMESTAMP NOT NULL,
  tujuan TEXT NOT NULL,  -- Tujuan penggunaan
  status status_reservasi DEFAULT 'menunggu',
  alasan_penolakan TEXT,  -- Alasan jika status = 'ditolak' atau 'dibatalkan' (oleh petugas)
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Validasi: waktu_selesai harus setelah waktu_mulai
  CHECK (waktu_selesai > waktu_mulai),
  
  -- Validasi: reservasi harus dalam 1 hari yang sama (tidak boleh cross-day)
  CHECK (DATE(waktu_mulai) = DATE(waktu_selesai)),
  
  -- Validasi: jam operasional (07.00-20.00)
  CHECK (EXTRACT(HOUR FROM waktu_mulai) >= 7 AND EXTRACT(HOUR FROM waktu_selesai) <= 20),
  
  -- Validasi: slot 30 menit (menit harus 00 atau 30)
  CHECK (EXTRACT(MINUTE FROM waktu_mulai) IN (0, 30)),
  CHECK (EXTRACT(MINUTE FROM waktu_selesai) IN (0, 30)),
  
  -- Validasi: reservasi harus dibuat minimal H-1 (dibuat sebelum tanggal reservasi)
  CHECK (DATE(dibuat_pada) < DATE(waktu_mulai))
);

CREATE INDEX idx_reservasi_fasilitas ON reservasi(id_fasilitas);
CREATE INDEX idx_reservasi_pengguna ON reservasi(id_pengguna);
CREATE INDEX idx_reservasi_status ON reservasi(status);
CREATE INDEX idx_reservasi_waktu ON reservasi(waktu_mulai, waktu_selesai);
```

**Business Rules**:
- `menunggu`: menunggu approval petugas
- `disetujui`: disetujui, slot terkunci
- `ditolak`: ditolak petugas (ada alasan) atau **auto-reject** jika melewati H-1
- `dibatalkan`: dibatalkan pengguna sendiri atau petugas (ada alasan jika oleh petugas)
- `selesai`: sudah lewat waktu penggunaan (bisa auto-update via cron/trigger)

**Aturan Reservasi**:
1. **Same-day only**: Reservasi harus dalam 1 hari yang sama (tidak boleh cross-day)
   - ✅ Valid: 15.00-20.00 (hari yang sama)
   - ❌ Invalid: 15.00 hari ini - 12.00 besok (harus 2 reservasi terpisah)
2. **H-1 Booking**: Reservasi harus dibuat minimal 1 hari sebelum tanggal penggunaan
   - Contoh: Reservasi untuk 21 Sept 2026 harus dibuat paling lambat 20 Sept 2026 23:59
   - Jika status masih `menunggu` dan melewati deadline → **auto-reject** oleh sistem

**Conflict Prevention**: Dilakukan di aplikasi dengan query:
```sql
SELECT COUNT(*) FROM reservasi
WHERE id_fasilitas = $1
  AND status IN ('menunggu', 'disetujui')
  AND (
    (waktu_mulai < $3 AND waktu_selesai > $2)  -- overlap
  );
```
Jika hasil > 0, maka bentrok.

---

### 4. `laporan`
Laporan kerusakan/masalah fasilitas.

```sql
CREATE TYPE kategori_laporan AS ENUM ('kelengkapan', 'kebersihan', 'kerusakan', 'lainnya');
CREATE TYPE status_laporan AS ENUM ('baru', 'diproses', 'selesai', 'ditolak');

CREATE TABLE laporan (
  id SERIAL PRIMARY KEY,
  id_fasilitas INT NOT NULL REFERENCES fasilitas(id) ON DELETE RESTRICT,
  id_pengguna INT NOT NULL REFERENCES pengguna(id) ON DELETE RESTRICT,
  kategori kategori_laporan NOT NULL,
  deskripsi TEXT NOT NULL,
  url_foto VARCHAR(500),  -- Foto bukti (upload via multer)
  status status_laporan DEFAULT 'baru',
  catatan_resolusi TEXT,  -- Catatan resolusi saat status = 'selesai' atau 'ditolak'
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_laporan_fasilitas ON laporan(id_fasilitas);
CREATE INDEX idx_laporan_pengguna ON laporan(id_pengguna);
CREATE INDEX idx_laporan_status ON laporan(status);
```

**Business Rules**:
- `baru`: baru dilaporkan, belum ditangani
- `diproses`: petugas sedang menangani (fasilitas bisa set "dalam_perbaikan")
- `selesai`: diperbaiki, ada catatan resolusi
- `ditolak`: bukan kerusakan valid, ada catatan

---

### 5. `log_status_fasilitas` (Opsional - Audit Trail)
Tracking perubahan status fasilitas (terutama "dalam_perbaikan" ↔ "aktif").

```sql
CREATE TABLE log_status_fasilitas (
  id SERIAL PRIMARY KEY,
  id_fasilitas INT NOT NULL REFERENCES fasilitas(id) ON DELETE CASCADE,
  status_lama status_fasilitas,
  status_baru status_fasilitas NOT NULL,
  diubah_oleh INT REFERENCES pengguna(id) ON DELETE SET NULL,  -- Petugas/admin yang ubah
  id_laporan INT REFERENCES laporan(id) ON DELETE SET NULL,  -- Jika terkait laporan
  catatan TEXT,
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_log_status_fasilitas_fasilitas ON log_status_fasilitas(id_fasilitas);
```

**Use Case**: 
- Admin/petugas bisa lihat riwayat kapan fasilitas "dalam_perbaikan" dan siapa yang set
- Untuk rekap statistik frekuensi kerusakan

---

### 6. `session` (untuk express-session + connect-pg-simple)
Tabel otomatis dibuat oleh `connect-pg-simple` jika belum ada.

```sql
CREATE TABLE session (
  sid VARCHAR NOT NULL PRIMARY KEY,
  sess JSON NOT NULL,
  expire TIMESTAMP(6) NOT NULL
);

CREATE INDEX idx_session_expire ON session(expire);
```

---

## Indexes Summary
Untuk performa query (terutama filtering & join):

```sql
-- Pengguna
CREATE INDEX idx_pengguna_email ON pengguna(email);
CREATE INDEX idx_pengguna_role ON pengguna(role);

-- Fasilitas
CREATE INDEX idx_fasilitas_tipe ON fasilitas(tipe);
CREATE INDEX idx_fasilitas_status ON fasilitas(status);
CREATE INDEX idx_fasilitas_lokasi ON fasilitas(lokasi);

-- Reservasi
CREATE INDEX idx_reservasi_fasilitas ON reservasi(id_fasilitas);
CREATE INDEX idx_reservasi_pengguna ON reservasi(id_pengguna);
CREATE INDEX idx_reservasi_status ON reservasi(status);
CREATE INDEX idx_reservasi_waktu ON reservasi(waktu_mulai, waktu_selesai);

-- Laporan
CREATE INDEX idx_laporan_fasilitas ON laporan(id_fasilitas);
CREATE INDEX idx_laporan_pengguna ON laporan(id_pengguna);
CREATE INDEX idx_laporan_status ON laporan(status);
```

---

## Migration Files

**Status**: ✅ **Selesai & Tested**

File SQL di `/database/migrations/`:

### `001_initial_schema.sql` ✅
Schema lengkap sudah dibuat dengan struktur:
- ✅ Semua ENUM types (role_pengguna, status_pengguna, tipe_fasilitas, status_fasilitas, lokasi_fasilitas, status_reservasi, kategori_laporan, status_laporan)
- ✅ Tabel `pengguna` dengan indexes
- ✅ Tabel `fasilitas` dengan constraints dan indexes
- ✅ Tabel `reservasi` dengan validasi waktu dan indexes
- ✅ Tabel `laporan` dengan indexes
- ✅ Tabel `log_status_fasilitas` untuk audit trail
- ✅ Tabel `session` untuk express-session

**Catatan**: Semua constraint validasi sudah ada (jam operasional, slot 30 menit, same-day only, H-1 booking)

---

## Seed Data

**Status**: ✅ **Selesai & Tested**

File SQL di `/database/seeds/`:

### `001_initial_data.sql` ✅
Data awal sudah dibuat dengan:

**Akun Pengguna** (4 akun):
- ✅ 1 Admin: `admin1@faculties.undip.ac.id` (status: aktif)
- ✅ 1 Petugas: `petugas1@faculties.undip.ac.id` (status: aktif)
- ✅ 1 Dosen: `dosen1@faculties.undip.ac.id` (status: aktif)
- ✅ 1 Mahasiswa: `mahasiswa1@students.undip.ac.id` (status: menunggu_verifikasi)

**Fasilitas** (24 unit):
- ✅ 12 Ruang Kelas (Gedung A) - berbagai status (aktif, nonaktif, dalam_perbaikan)
- ✅ 1 Aula (Gedung E) - aktif
- ✅ 4 Laboratorium Komputer (Gedung E) - berbagai status
- ✅ 4 Peralatan (proyektor, sound system, camera) - aktif
- ✅ 3 Lapangan (badminton, voli, basket) - berbagai status

**Data Sample**:
- ✅ 2 Reservasi (1 disetujui, 1 menunggu) untuk testing approval flow
- ✅ 2 Laporan (1 baru, 1 diproses) untuk testing report handling

**Password Pattern**: `*[Role]123`
- Admin: `*Admin123`
- Petugas: `*Petugas123`
- Dosen: `*Dosen123`
- Mahasiswa: `*Mahasiswa123`

---

## Query Examples

### 1. Cek Bentrok Jadwal
```sql
SELECT COUNT(*) FROM reservasi
WHERE id_fasilitas = $1
  AND status IN ('menunggu', 'disetujui')
  AND (
    (waktu_mulai < $3 AND waktu_selesai > $2)
  );
```

### 2. Lihat Ketersediaan Fasilitas per Hari
```sql
SELECT 
  f.id, f.nama, f.tipe, f.lokasi,
  COALESCE(
    json_agg(
      json_build_object(
        'waktu_mulai', r.waktu_mulai, 
        'waktu_selesai', r.waktu_selesai, 
        'status', r.status
      ) ORDER BY r.waktu_mulai
    ) FILTER (WHERE r.id IS NOT NULL), 
    '[]'
  ) AS reservasi_list
FROM fasilitas f
LEFT JOIN reservasi r ON f.id = r.id_fasilitas 
  AND DATE(r.waktu_mulai) = $1  -- Tanggal tertentu
  AND r.status IN ('menunggu', 'disetujui')
WHERE f.status = 'aktif'
GROUP BY f.id;
```

### 3. Rekap Okupansi Fasilitas (untuk Admin)
```sql
SELECT 
  f.nama, 
  COUNT(r.id) AS total_reservasi,
  SUM(EXTRACT(EPOCH FROM (r.waktu_selesai - r.waktu_mulai)) / 3600) AS total_jam_terpakai
FROM fasilitas f
LEFT JOIN reservasi r ON f.id = r.id_fasilitas 
  AND r.status = 'disetujui'
  AND r.waktu_mulai BETWEEN $1 AND $2  -- Range tanggal
GROUP BY f.id, f.nama
ORDER BY total_reservasi DESC;
```

### 4. Rekap Frekuensi Kerusakan (untuk Admin)
```sql
SELECT 
  f.nama, 
  COUNT(l.id) AS total_laporan,
  COUNT(l.id) FILTER (WHERE l.status = 'selesai') AS laporan_selesai
FROM fasilitas f
LEFT JOIN laporan l ON f.id = l.id_fasilitas
WHERE l.dibuat_pada BETWEEN $1 AND $2  -- Range tanggal
GROUP BY f.id, f.nama
ORDER BY total_laporan DESC;
```

---

## Notes
- **Enum types**: Gunakan PostgreSQL ENUM untuk type-safety di database level
- **Foreign Keys**: Semua FK pakai `ON DELETE RESTRICT` kecuali audit logs (bisa `CASCADE` atau `SET NULL`)
- **Timestamps**: Pakai `CURRENT_TIMESTAMP` untuk auto-populate
- **Validation**: Constraint di database + validasi di aplikasi (double-check)
- **Nama Bahasa Indonesia**: Konsisten dengan istilah di requirement (pengguna, fasilitas, reservasi, laporan)
