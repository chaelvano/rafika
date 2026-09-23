-- =============================================
-- Migration: Initial Schema
-- Database: rafika 
-- Created: 2026-09-16
-- =============================================

-- Drop existing types if any (untuk re-run migration)
DROP TYPE IF EXISTS role_pengguna CASCADE;
DROP TYPE IF EXISTS status_pengguna CASCADE;
DROP TYPE IF EXISTS tipe_fasilitas CASCADE;
DROP TYPE IF EXISTS status_fasilitas CASCADE;
DROP TYPE IF EXISTS lokasi_fasilitas CASCADE;
DROP TYPE IF EXISTS status_reservasi CASCADE;
DROP TYPE IF EXISTS kategori_laporan CASCADE;
DROP TYPE IF EXISTS status_laporan CASCADE;

-- =============================================
-- CREATE ENUM TYPES
-- =============================================

-- ENUM untuk role pengguna
CREATE TYPE role_pengguna AS ENUM (
  'pengguna', -- Expand later => 'dosen', 'mahasiswa'
  'petugas',
  'admin'
);

-- ENUM untuk status pengguna
CREATE TYPE status_pengguna AS ENUM (
  'menunggu_verifikasi',
  'aktif',
  'nonaktif'
);

CREATE TYPE tipe_fasilitas AS ENUM (
  'ruang_kelas',
  'aula',
  'laboratorium',
  'peralatan',
  'lapangan'
);

CREATE TYPE status_fasilitas AS ENUM (
  'aktif',
  'dalam_perbaikan',
  'nonaktif'
);

CREATE TYPE lokasi_fasilitas AS ENUM (
  'Gedung A',
  'Gedung E'
);

CREATE TYPE status_reservasi AS ENUM (
  'menunggu',
  'disetujui',
  'ditolak',
  'dibatalkan',
  'selesai'
);

CREATE TYPE kategori_laporan AS ENUM (
  'kelengkapan',
  'kebersihan',
  'kerusakan',
  'lainnya'
);

CREATE TYPE status_laporan AS ENUM (
  'baru',
  'diproses',
  'selesai',
  'ditolak'
);

-- =============================================
-- TABLE: pengguna
-- Menyimpan semua akun (pengguna, petugas, admin)
-- =============================================

CREATE TABLE pengguna (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,  -- bcrypt hash
  role role_pengguna NOT NULL,
  status status_pengguna DEFAULT 'menunggu_verifikasi' NOT NULL,
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Indexes untuk pengguna
CREATE INDEX idx_pengguna_role ON pengguna(role);
CREATE INDEX idx_pengguna_status ON pengguna(status);

COMMENT ON TABLE pengguna IS 'Tabel pengguna sistem (pengguna, petugas, admin)';
COMMENT ON COLUMN pengguna.status IS 'menunggu_verifikasi = registrasi mandiri belum diverifikasi admin';

-- =============================================
-- TABLE: fasilitas
-- Master data fasilitas kampus
-- =============================================

CREATE TABLE fasilitas (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(255) NOT NULL,
  tipe tipe_fasilitas NOT NULL,
  lokasi lokasi_fasilitas,
  kapasitas INT CHECK (kapasitas IS NULL OR kapasitas > 0),
  deskripsi TEXT,
  url_foto VARCHAR(500),
  status status_fasilitas DEFAULT 'aktif' NOT NULL,
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  
  -- Constraint: kapasitas hanya untuk ruang_kelas, aula, laboratorium
  CONSTRAINT chk_kapasitas_required CHECK (
    (tipe IN ('ruang_kelas', 'aula', 'laboratorium') AND kapasitas IS NOT NULL)
    OR
    (tipe IN ('peralatan', 'lapangan') AND kapasitas IS NULL)
  ),
  
  -- Constraint: lokasi hanya untuk ruang_kelas, aula, laboratorium
  CONSTRAINT chk_lokasi_required CHECK (
    (tipe IN ('ruang_kelas', 'aula', 'laboratorium') AND lokasi IS NOT NULL)
    OR
    (tipe IN ('peralatan', 'lapangan') AND lokasi IS NULL)
  )
);

-- Indexes untuk fasilitas
CREATE INDEX idx_fasilitas_tipe ON fasilitas(tipe);
CREATE INDEX idx_fasilitas_status ON fasilitas(status);
CREATE INDEX idx_fasilitas_lokasi ON fasilitas(lokasi);

COMMENT ON TABLE fasilitas IS 'Master data fasilitas kampus';
COMMENT ON COLUMN fasilitas.kapasitas IS 'Kapasitas: WAJIB untuk ruang_kelas/aula/laboratorium, HARUS NULL untuk peralatan/lapangan';
COMMENT ON COLUMN fasilitas.lokasi IS 'Lokasi: WAJIB untuk ruang_kelas/aula/laboratorium, HARUS NULL untuk peralatan/lapangan';
COMMENT ON COLUMN fasilitas.status IS 'aktif = bisa direservasi, dalam_perbaikan = tidak bisa direservasi';

-- =============================================
-- TABLE: reservasi
-- Data reservasi fasilitas oleh pengguna
-- =============================================

CREATE TABLE reservasi (
  id SERIAL PRIMARY KEY,
  id_fasilitas INT NOT NULL REFERENCES fasilitas(id) ON DELETE RESTRICT,
  id_pengguna INT NOT NULL REFERENCES pengguna(id) ON DELETE RESTRICT,
  waktu_mulai TIMESTAMP NOT NULL,
  waktu_selesai TIMESTAMP NOT NULL,
  tujuan TEXT NOT NULL,
  status status_reservasi DEFAULT 'menunggu' NOT NULL,
  alasan_penolakan TEXT,
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  
  -- Constraint: waktu_selesai harus setelah waktu_mulai
  CONSTRAINT chk_waktu_valid CHECK (waktu_selesai > waktu_mulai),
  
  -- Constraint: reservasi harus dalam 1 hari yang sama (tidak boleh cross-day)
  CONSTRAINT chk_same_day CHECK (DATE(waktu_mulai) = DATE(waktu_selesai)),
  
  -- Constraint: jam operasional (07.00-20.00)
  CONSTRAINT chk_jam_operasional CHECK (
    waktu_mulai::time >= TIME '07:00' AND
    waktu_selesai::time <= TIME '20:00'
  ),
  
  -- Constraint: slot 30 menit (menit harus 00 atau 30)
  CONSTRAINT chk_slot_30_menit CHECK (
    EXTRACT(MINUTE FROM waktu_mulai) IN (0, 30) AND
    EXTRACT(MINUTE FROM waktu_selesai) IN (0, 30)
  ),
  
  -- Constraint: reservasi harus dibuat minimal H-1 (dibuat sebelum tanggal reservasi)
  CONSTRAINT chk_booking_h_minus_1 CHECK (
    DATE(dibuat_pada) < DATE(waktu_mulai)
  )
);

-- Indexes untuk reservasi
CREATE INDEX idx_reservasi_fasilitas ON reservasi(id_fasilitas);
CREATE INDEX idx_reservasi_pengguna ON reservasi(id_pengguna);
CREATE INDEX idx_reservasi_status ON reservasi(status);
CREATE INDEX idx_reservasi_waktu ON reservasi(waktu_mulai, waktu_selesai);

COMMENT ON TABLE reservasi IS 'Data reservasi fasilitas';
COMMENT ON COLUMN reservasi.alasan_penolakan IS 'Diisi jika status = ditolak atau dibatalkan oleh petugas';
COMMENT ON COLUMN reservasi.waktu_mulai IS 'Reservasi harus dalam 1 hari yang sama (tidak boleh cross-day)';
COMMENT ON COLUMN reservasi.dibuat_pada IS 'Reservasi harus dibuat minimal H-1 sebelum tanggal penggunaan';

-- =============================================
-- TABLE: laporan
-- Laporan kerusakan/masalah fasilitas
-- =============================================

CREATE TABLE laporan (
  id SERIAL PRIMARY KEY,
  id_fasilitas INT NOT NULL REFERENCES fasilitas(id) ON DELETE RESTRICT,
  id_pengguna INT NOT NULL REFERENCES pengguna(id) ON DELETE RESTRICT,
  kategori kategori_laporan NOT NULL,
  deskripsi TEXT NOT NULL,
  url_foto VARCHAR(500),
  status status_laporan DEFAULT 'baru' NOT NULL,
  catatan_resolusi TEXT,
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  diperbarui_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Indexes untuk laporan
CREATE INDEX idx_laporan_fasilitas ON laporan(id_fasilitas);
CREATE INDEX idx_laporan_pengguna ON laporan(id_pengguna);
CREATE INDEX idx_laporan_status ON laporan(status);

COMMENT ON TABLE laporan IS 'Laporan kerusakan/masalah fasilitas';
COMMENT ON COLUMN laporan.catatan_resolusi IS 'Diisi saat status = selesai atau ditolak';

-- =============================================
-- TABLE: log_status_fasilitas (Audit Trail)
-- Tracking perubahan status fasilitas
-- =============================================

CREATE TABLE log_status_fasilitas (
  id SERIAL PRIMARY KEY,
  id_fasilitas INT NOT NULL REFERENCES fasilitas(id) ON DELETE CASCADE,
  status_lama status_fasilitas,
  status_baru status_fasilitas NOT NULL,
  diubah_oleh INT REFERENCES pengguna(id) ON DELETE SET NULL,
  id_laporan INT REFERENCES laporan(id) ON DELETE SET NULL,
  catatan TEXT,
  dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Indexes untuk log_status_fasilitas
CREATE INDEX idx_log_status_fasilitas_fasilitas ON log_status_fasilitas(id_fasilitas);
CREATE INDEX idx_log_status_fasilitas_tanggal ON log_status_fasilitas(dibuat_pada);

COMMENT ON TABLE log_status_fasilitas IS 'Audit trail perubahan status fasilitas';

-- =============================================
-- TABLE: session (untuk express-session)
-- Tabel session dikelola otomatis oleh connect-pg-simple
-- =============================================

CREATE TABLE session (
  sid VARCHAR NOT NULL PRIMARY KEY,
  sess JSON NOT NULL,
  expire TIMESTAMP(6) NOT NULL
);

CREATE INDEX idx_session_expire ON session(expire);

COMMENT ON TABLE session IS 'Session storage untuk express-session';

-- =============================================
-- TRIGGERS: Auto-update diperbarui_pada
-- =============================================

-- Function untuk update timestamp
CREATE OR REPLACE FUNCTION update_diperbarui_pada()
RETURNS TRIGGER AS $$
BEGIN
  NEW.diperbarui_pada = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger untuk tabel pengguna
CREATE TRIGGER trg_pengguna_diperbarui_pada
  BEFORE UPDATE ON pengguna
  FOR EACH ROW
  EXECUTE FUNCTION update_diperbarui_pada();

-- Trigger untuk tabel fasilitas
CREATE TRIGGER trg_fasilitas_diperbarui_pada
  BEFORE UPDATE ON fasilitas
  FOR EACH ROW
  EXECUTE FUNCTION update_diperbarui_pada();

-- Trigger untuk tabel reservasi
CREATE TRIGGER trg_reservasi_diperbarui_pada
  BEFORE UPDATE ON reservasi
  FOR EACH ROW
  EXECUTE FUNCTION update_diperbarui_pada();

-- Trigger untuk tabel laporan
CREATE TRIGGER trg_laporan_diperbarui_pada
  BEFORE UPDATE ON laporan
  FOR EACH ROW
  EXECUTE FUNCTION update_diperbarui_pada();

-- =============================================
-- FUNCTION: Auto-reject reservasi yang melewati H-1
-- =============================================

CREATE OR REPLACE FUNCTION auto_reject_expired_reservations()
RETURNS void AS $$
BEGIN
  UPDATE reservasi
  SET 
    status = 'ditolak',
    alasan_penolakan = 'Reservasi tidak disetujui sampai batas waktu H-1 (otomatis ditolak sistem)',
    diperbarui_pada = CURRENT_TIMESTAMP
  WHERE 
    status = 'menunggu'
    AND DATE(waktu_mulai) <= CURRENT_DATE;  -- Tanggal reservasi sudah lewat atau hari ini
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION auto_reject_expired_reservations() IS 'Menolak otomatis reservasi yang masih pending melewati deadline H-1';

-- NOTE: Function ini perlu dipanggil secara berkala (via cron job atau scheduler)
-- Contoh: Jalankan setiap hari jam 00:01
-- Atau bisa dipanggil manual: SELECT auto_reject_expired_reservations();

-- =============================================
-- MIGRATION COMPLETE
-- =============================================

-- Verifikasi tabel yang dibuat
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
