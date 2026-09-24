-- =============================================
-- Seed Data: Data Awal untuk Testing
-- Database: rafika
-- =============================================

-- =============================================
-- PENGGUNA: Admin, Petugas, Pengguna Test
-- =============================================

-- Password untuk akun:
-- Admin: *Admin123
-- Petugas: *Petugas123
-- Dosen: *Dosen123
-- Mahasiswa: *Mahasiswa123

-- Generate hash dengan: node -e "console.log(require('bcrypt').hashSync('YOUR_PASSWORD', 10))"

INSERT INTO pengguna (nama, email, password_hash, role, status) VALUES
-- Admin
('Administrator Satu', 'admin1@faculties.undip.ac.id', '$2b$10$aFbVH15w9qAZHcX42M2uTex7BK/kQ.oHjKkb2W.7lPkEGqKTJtvdK', 'admin', 'aktif'),

-- Petugas (staff kampus)
('Petugas Satu', 'petugas1@faculties.undip.ac.id', '$2b$10$5B/qzOgzFtz1hBlKA.gcVOJGEFzO/55wzR28VmhplqulAieFvxkXS', 'petugas', 'aktif'),

-- Pengguna (mahasiswa & dosen - sudah terverifikasi untuk testing)
('Dosen Satu', 'dosen1@faculties.undip.ac.id', '$2b$10$H/yIbHHTCZ6qmSffHdzzUOw5M7f96yqsktIC2TEu4i.KleEdggW8y', 'pengguna', 'aktif'),
('Mahasiswa Satu', 'mahasiswa1@students.undip.ac.id', '$2b$10$TZOGtS3/ZjQQmB/XnIujd.RGdjRP52kkoLrDRbSYbG7Eew.ALnqtO', 'pengguna', 'menunggu_verifikasi');

-- =============================================
-- FASILITAS: Master Data
-- =============================================

INSERT INTO fasilitas (nama, tipe, lokasi, kapasitas, deskripsi, status) VALUES
-- Ruang Kelas
('Ruang A101', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'nonaktif'),
('Ruang A102', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'dalam_perbaikan'),
('Ruang A103', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A104', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A105', 'Ruang Kelas', 'Gedung A', 75, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A201', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A202', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A203', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A204', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A205', 'Ruang Kelas', 'Gedung A', 75, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A301', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A302', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A303', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A304', 'Ruang Kelas', 'Gedung A', 50, 'Ruang kelas dengan AC dan IFP', 'aktif'),
('Ruang A305', 'Ruang Kelas', 'Gedung A', 75, 'Ruang kelas dengan AC dan IFP', 'aktif'),

-- Aula
('Ruang E101', 'Aula', 'Gedung E', 200, 'Aula utama dengan AC dan sound system', 'aktif'),

-- Laboratorium
('Lab Komputer A', 'Laboratorium', 'Gedung E', 30, 'Lab komputer dengan 30 unit PC dan AC', 'nonaktif'),
('Lab Komputer B', 'Laboratorium', 'Gedung E', 30, 'Lab komputer dengan 30 unit PC dan AC', 'dalam_perbaikan'),
('Lab Komputer C', 'Laboratorium', 'Gedung E', 30, 'Lab komputer dengan 30 unit PC dan AC', 'aktif'),
('Lab Komputer D', 'Laboratorium', 'Gedung E', 30, 'Lab komputer dengan 30 unit PC dan AC', 'aktif'),

-- Peralatan (kapasitas dan lokasi tidak relevan, set NULL)
('Proyektor Epson EB-X41', 'Peralatan', NULL, NULL, 'Proyektor portabel', 'aktif'),
('Sound System Portable', 'Peralatan', NULL, NULL, 'Sound system portabel dengan wireless mic', 'aktif'),
('Camera Canon EOS 80D', 'Peralatan', NULL, NULL, 'Kamera DSLR untuk dokumentasi acara', 'aktif'),

-- Lapangan (kapasitas dan lokasi tidak relevan, set NULL)
('Lapangan Badminton', 'Lapangan', NULL, NULL, 'Lapangan badminton outdoor', 'nonaktif'),
('Lapangan Voli', 'Lapangan', NULL, NULL, 'Lapangan voli outdoor', 'dalam_perbaikan'),
('Lapangan Basket', 'Lapangan', NULL, NULL, 'Lapangan basket outdoor', 'aktif');

-- =============================================
-- RESERVASI: Sample Data (Opsional)
-- =============================================

-- Reservasi yang sudah disetujui (hari ini + 1, jam 09.00-10.00)
INSERT INTO reservasi (id_fasilitas, id_pengguna, waktu_mulai, waktu_selesai, tujuan, status) VALUES
(
  (SELECT id FROM fasilitas WHERE nama = 'Ruang A301' LIMIT 1),
  (SELECT id FROM pengguna WHERE email = 'dosen1@faculties.undip.ac.id' LIMIT 1),
  (CURRENT_DATE + INTERVAL '1 day' + INTERVAL '9 hours'),
  (CURRENT_DATE + INTERVAL '1 day' + INTERVAL '10 hours'),
  'Kuliah Pengembangan Platform Khusus',
  'disetujui'
);

-- Reservasi menunggu approval (hari ini + 2, jam 13.00-14.30)
INSERT INTO reservasi (id_fasilitas, id_pengguna, waktu_mulai, waktu_selesai, tujuan, status) VALUES
(
  (SELECT id FROM fasilitas WHERE nama = 'Ruang E101' LIMIT 1),
  (SELECT id FROM pengguna WHERE email = 'mahasiswa1@students.undip.ac.id' LIMIT 1),
  (CURRENT_DATE + INTERVAL '2 days' + INTERVAL '13 hours'),
  (CURRENT_DATE + INTERVAL '2 days' + INTERVAL '14 hours 30 minutes'),
  'Kegiatan UKM Keagamaan',
  'menunggu'
);

-- =============================================
-- LAPORAN: Sample Data (Opsional)
-- =============================================

-- Laporan baru
INSERT INTO laporan (id_fasilitas, id_pengguna, kategori, deskripsi, status) VALUES
(
  (SELECT id FROM fasilitas WHERE nama = 'Ruang A301' LIMIT 1),
  (SELECT id FROM pengguna WHERE email = 'mahasiswa1@students.undip.ac.id' LIMIT 1),
  'kerusakan',
  'AC tidak dapat menyala',
  'baru'
);

-- Laporan sedang diproses
INSERT INTO laporan (id_fasilitas, id_pengguna, kategori, deskripsi, status) VALUES
(
  (SELECT id FROM fasilitas WHERE nama = 'Lab Komputer C' LIMIT 1),
  (SELECT id FROM pengguna WHERE email = 'dosen1@faculties.undip.ac.id' LIMIT 1),
  'kelengkapan',
  'Jumlah kursi kurang 5 unit dari kapasitas',
  'diproses'
);

-- =============================================
-- SEED COMPLETE
-- =============================================

-- Tampilkan summary data yang dibuat
SELECT 'Pengguna' as tabel, COUNT(*) as jumlah FROM pengguna
UNION ALL
SELECT 'Fasilitas', COUNT(*) FROM fasilitas
UNION ALL
SELECT 'Reservasi', COUNT(*) FROM reservasi
UNION ALL
SELECT 'Laporan', COUNT(*) FROM laporan;

-- Tampilkan akun test
SELECT 
  nama, 
  email, 
  role, 
  status,
  CASE 
    WHEN email = 'admin1@faculties.undip.ac.id' THEN 'Password: *Admin123'
    WHEN email LIKE 'petugas%' THEN 'Password: *Petugas123'
    WHEN email LIKE 'dosen%' THEN 'Password: *Dosen123'
    WHEN email LIKE 'mahasiswa%' THEN 'Password: *Mahasiswa123'
  END as password_info
FROM pengguna
ORDER BY 
  CASE role
    WHEN 'admin' THEN 1
    WHEN 'petugas' THEN 2
    WHEN 'pengguna' THEN 3
  END,
  nama;
