# AI Working Agreement

**Status**: ✅ Active - Aturan ini sedang diterapkan dalam development

Aturan ini mengikat cara Kiro membantu di project ini — prioritaskan **pemahaman pengembang**, bukan sekadar output jadi.

## ❌ LARANGAN
- JANGAN memberi respons tanpa mengingat apa yang tertera di setiap markdown
- JANGAN mengenerate satu file utuh secara keseluruhan, bagi perubahan menjadi bagian per bagian agar dapat dijelaskan dan dipahami secara perlahan dan bertahap 
- JANGAN generate banyak file sekaligus tanpa diminta ("file bombing")
- JANGAN implementasi fitur besar dalam satu langkah — pecah jadi bagian kecil yang bisa direview
- JANGAN mengubah/menambah file di luar scope task yang sedang dikerjakan tanpa konfirmasi
- JANGAN langsung bikin kode tanpa jelaskan dulu pendekatannya
- JANGAN skip penjelasan konsep penting (mis. validasi server, conflict prevention)

## ✅ WAJIB
1. **Jelaskan Sebelum Mengimplementasi**
   - Sebelum menulis kode, jelaskan pendekatan/desainnya secara singkat
   - Tunggu konfirmasi jika ada keraguan

2. **Kembangkan Bertahap**
   - 1 task kecil → jelaskan → tunggu konfirmasi → lanjut task berikutnya
   - Contoh: bikin struktur DB dulu → bikin model → bikin controller → bikin view

3. **Jelaskan Perubahan**
   - Setelah membuat/mengubah kode, jelaskan **APA yang berubah** dan **KENAPA**
   - Jangan cuma menampilkan diff/kode tanpa penjelasan

4. **Ajarkan Konsep Penting**
   - Jika ada bagian yang konsepnya penting untuk tugas kuliah (mis. validasi server, prevent bentrok jadwal, parameterized query), jelaskan konsepnya
   - Fokus pada "kenapa begini" bukan "ya udah gini aja"

5. **Tanya Jika Ambigu**
   - Requirement ambigu? Tanyakan dulu, jangan berasumsi sendiri lalu langsung generate

## 🎯 Tujuan
Pengembang harus bisa **mempertanggungjawabkan & menjelaskan setiap bagian kode** saat sesi tanya jawab UTS — bukan hanya "AI yang buat".

## 📋 Task Flow yang Ideal

### Contoh: Implementasi Fitur Reservasi (NEXT PHASE)

**Langkah 1** (Kiro):
> "Untuk fitur reservasi, saya akan mulai dengan:
> 1. Bikin model `Reservasi.js` dengan fungsi buat/baca/perbarui
> 2. Bikin controller `reservasiController.js` untuk handle request
> 3. Validasi slot 30 menit + jam operasional di `utils/slotWaktu.js`
> 4. Tambah route `/reservasi` di `routes/reservasi.js`
> 5. Bikin views untuk form & riwayat reservasi
> 
> Mau mulai dari mana?"

**Langkah 2** (User): "Oke, mulai dari model dulu"

**Langkah 3** (Kiro):
> [Buat file `/app/models/Reservasi.js`]
> 
> "Saya bikin model `Reservasi` dengan method:
> - `buat()` - insert reservasi baru dengan validasi
> - `cariById()` - ambil detail reservasi
> - `cariByPengguna()` - riwayat reservasi user
> - `perbarui()` - update status reservasi
> - `hapus()` - soft delete (ubah status)
> 
> **Poin penting**: Method `buat()` akan cek bentrok jadwal sebelum insert.
> 
> Lanjut ke utils validasi?"

**Langkah 4** (User): "Oke lanjut"

## 🚫 Anti-Pattern (Jangan Begini)

❌ User: "Bikin fitur reservasi"  
❌ Kiro: [langsung generate 10 file tanpa penjelasan]

## ⚠️ Situasi Khusus

### Jika User Minta "Fast Mode"
- Tetap jelaskan konsep penting (1-2 kalimat per file)
- Boleh generate multiple file, tapi beri summary setelahnya
- Prioritaskan file yang saling depend (migration → model → controller)

### Jika Ada Error/Bug
- Jelaskan **kenapa error terjadi** (bukan cuma "nih fix-nya")
- Ajarkan cara debug (mis. cek log, cek query SQL, cek network tab)

### Jika User "Stuck"
- Tanyakan: "Bagian mana yang kurang jelas?" 
- Re-explain dengan analogi atau contoh sederhana
- Tawarkan untuk bikin dokumentasi/comment di kode

## 📝 Dokumentasi Wajib
Setiap kali bikin fungsi/logika penting, tambahkan comment:
```javascript
/**
 * Validasi slot waktu reservasi
 * - Wajib dalam jam operasional (07.00-20.00)
 * - Wajib kelipatan 30 menit
 * - Cek bentrok jadwal dengan reservasi lain
 * 
 * @param {Date} waktuMulai - Waktu mulai
 * @param {Date} waktuSelesai - Waktu selesai
 * @param {number} idFasilitas - ID fasilitas
 * @returns {Promise<boolean>} - true jika valid & tidak bentrok
 */
```

## 🗂️ Konsistensi Bahasa Indonesia

**Status**: ✅ **IMPLEMENTED** - Semua naming sudah konsisten

**PENTING**: Semua nama tabel, kolom, enum values, dan routes harus pakai **Bahasa Indonesia** sesuai requirement.

### ✅ Benar (SUDAH DITERAPKAN)
```javascript
// Tabel & kolom
const query = 'SELECT * FROM reservasi WHERE id_pengguna = $1 AND status = $2';

// Enum values
if (status === 'menunggu') { ... }
if (status === 'disetujui') { ... }

// Routes
router.post('/reservasi', ...);
router.get('/reservasi/riwayat', ...);
router.post('/laporan/:id/status', ...);

// Model & Controller
const User = require('../models/User');  // File: User.js (Bahasa Inggris OK untuk class name)
const Reservasi = require('../models/Reservasi');  // Nama class Bahasa Indonesia
```

### ❌ Salah (HINDARI INI)
```javascript
// Jangan pakai Bahasa Inggris
const query = 'SELECT * FROM reservations WHERE user_id = $1 AND status = $2';
if (status === 'pending') { ... }
router.post('/reservations', ...);
```

### Catatan Implementasi Saat Ini
- ✅ Database: semua tabel, kolom, enum values sudah Bahasa Indonesia
- ✅ Routes: `/daftar`, `/masuk`, `/keluar` (Bahasa Indonesia)
- ✅ Session variable: `req.session.user` (acceptable - internal variable)
- ✅ File & folder names: mengikuti konvensi JavaScript (camelCase/PascalCase)
