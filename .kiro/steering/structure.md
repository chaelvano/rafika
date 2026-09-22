# Project Structure

Struktur ini **bukan** acuan pasti, melainkan sebuah panduan. Jika dalam pengembangan perlu dilakukan perubahan, struktur proyek dapat disesuaikan.

```
rafika/
├── app.js                         # Express entry point
├── package.json
├── .env                           # Do not commit!
├── .env.example                   # Template for .env
├── .gitignore
├── README.md
│
├── /public                        # Static assets served by Express
│   ├── /css
│   │   └── style.css              # Custom styles (supplement Bootstrap)
│   ├── /js
│   │   ├── calendar.js            # Reservation calendar logic
│   │   ├── clientValidation.js    # Client-side validation
│   │   └── main.js                # Global client-side JavaScript
│   ├── /images
│   └── /uploads                    # Report photos uploaded through Multer
│
├── /app
│   ├── /controllers               # Request handling per module
│   │   ├── authController.js      # Register, login, logout (DONE)
│   │   ├── facilityController.js  # Facility CRUD (TODO)
│   │   ├── reservationController.js # Reservation management (TODO)
│   │   ├── reportController.js    # Report management (TODO)
│   │   ├── staffController.js     # Staff dashboard (TODO)
│   │   └── adminController.js     # Admin dashboard (TODO)
│   ├── /models                    # Database access and data operations
│   │   ├── User.js                # User model (DONE)
│   │   ├── Facility.js            # Facility model (TODO)
│   │   ├── Reservation.js         # Reservation model (TODO)
│   │   └── Report.js              # Report model (TODO)
│   └── /middleware                # Custom middleware
│       ├── auth.js                # Authentication and role checks (DONE)
│       ├── validation.js          # Express-validator rules (DONE)
│       └── rateLimiter.js         # Rate limiting for authentication (DONE)
│
├── /views                         # EJS templates
│   ├── /partials                  # Reusable components (DONE)
│   │   ├── _navbar.ejs            # Dynamic navbar by role
│   │   ├── _textField.ejs         # Reusable text input component
│   │   ├── _table.ejs             # Reusable table component
│   │   ├── _buttonSolid.ejs       # Primary button component
│   │   ├── _buttonOutline.ejs     # Secondary button component
│   │   ├── _buttonRed.ejs         # Danger button component
│   │   └── _buttonTransparent.ejs # Ghost button component
│   ├── login.ejs                  # Login page (DONE)
│   ├── register.ejs               # Registration page (DONE)
│   ├── facilities.ejs             # Facility list page (DONE)
│   ├── facility-detail.ejs        # Facility detail page (TODO)
│   ├── facility-manage.ejs        # Facility management page (TODO)
│   ├── history.ejs                # Reservation history page (TODO)
│   ├── report.ejs                 # Report page (TODO)
│   ├── staff.ejs                  # Staff dashboard (TODO)
│   └── admin.ejs                  # Admin dashboard (TODO)
│
├── /config
│   ├── db.js                      # PostgreSQL connection pool (DONE)
│   └── session.js                 # express-session configuration (DONE)
│
├── /database
│   ├── /migrations
│   │   └── 001_initial_schema.sql # Complete database schema (DONE)
│   └── /seeds
│       └── 001_initial_data.sql   # Initial test data (DONE)
│
├── /routes
│   ├── index.js                   # Main routes (DONE)
│   ├── auth.js                    # /daftar, /masuk, /keluar (DONE)
│   ├── facilities.js              # /fasilitas (landing page) (DONE)
│   ├── reservations.js            # /reservasi/* (TODO)
│   ├── reports.js                 # /laporan/* (TODO)
│   ├── staff.js                   # /petugas/* (TODO)
│   └── admin.js                   # /admin/* (TODO)
│
├── /utils
│   ├── timeSlot.js                # Time-slot validation, operational hours, and conflict checks (TODO)
│   ├── dateHelper.js              # Date formatting helpers (TODO)
│   └── fileUpload.js              # Multer configuration (TODO)
│
└── .kiro/
    ├── /steering                  # Project context documents
    │   ├── product.md
    │   ├── tech.md
    │   ├── structure.md
    │   ├── database-schema.md
    │   ├── deployment.md
    │   └── ai-workflow.md
    └── /specs                     # Requirements, design, and tasks per feature (optional)
```

## Konvensi Penamaan

### Database (PostgreSQL)

- **Tabel**: `snake_case`, **Bahasa Indonesia**, nama jamak
  - ✅ `pengguna`, `fasilitas`, `reservasi`, `laporan`
  - ❌ `users`, `facilities`, `reservations`, `reports`

- **Kolom**: `snake_case`, **Bahasa Indonesia**
  - ✅ `id_fasilitas`, `waktu_mulai`, `waktu_selesai`, `dibuat_pada`
  - ❌ `facility_id`, `start_time`, `end_time`, `created_at`

- **Enum values / stored values**: `snake_case`, **Bahasa Indonesia**
  - ✅ `'menunggu'`, `'disetujui'`, `'ditolak'`, `'dibatalkan'`, `'selesai'`
  - ❌ `'pending'`, `'approved'`, `'rejected'`, `'cancelled'`, `'completed'`

### Routes (Express)

- **Route file names**: lowercase, **Bahasa Inggris**
  - ✅ `auth.js`, `facilities.js`, `reservations.js`, `reports.js`
  - ❌ `autentikasi.js`, `fasilitas.js`, `reservasi.js`, `laporan.js`

- **URL paths**: lowercase, **Bahasa Indonesia**, RESTful
  - ✅ `/fasilitas`, `/reservasi/:id`, `/laporan/:id/status`
  - ❌ `/facilities`, `/reservations/:id`, `/reports/:id/status`

> URL paths merupakan bagian yang dapat dilihat pengguna, sehingga tetap menggunakan Bahasa Indonesia meskipun nama file route dan identifier JavaScript menggunakan Bahasa Inggris.

### Files & Folders (Application)

- **Application files and folders**: lowercase, **Bahasa Inggris**
  - ✅ `controllers`, `models`, `middleware`, `views`, `routes`, `utils`, `config`
  - ❌ `pengendali`, `model`, `middleware_kustom`, `tampilan`, `rute`, `utilitas`, `konfigurasi`

- **Controllers**: `camelCase`, **Bahasa Inggris**
  - ✅ `facilityController.js`, `reservationController.js`, `reportController.js`
  - ❌ `fasilitasController.js`, `reservasiController.js`, `laporanController.js`

- **Models**: `PascalCase`, **Bahasa Inggris**, singular
  - ✅ `User.js`, `Facility.js`, `Reservation.js`, `Report.js`
  - ❌ `Pengguna.js`, `Fasilitas.js`, `Reservasi.js`, `Laporan.js`

- **Views**: lowercase, **Bahasa Inggris**
  - ✅ `facility-detail.ejs`, `facility-manage.ejs`, `history.ejs`, `report.ejs`
  - ❌ `fasilitas-detail.ejs`, `kelola-fasilitas.ejs`, `riwayat.ejs`, `laporan.ejs`

- **Partials**: **Bahasa Inggris**
  - ✅ `_navbar.ejs`, `_textField.ejs`, `_buttonSolid.ejs`
  - ❌ `_bilahNavigasi.ejs`, `_kolomTeks.ejs`, `_tombolSolid.ejs`

- **Utils**: `camelCase`, **Bahasa Inggris**, descriptive
  - ✅ `timeSlot.js`, `dateHelper.js`, `fileUpload.js`
  - ❌ `slotWaktu.js`, `tanggalHelper.js`, `uploadFile.js`

### Variables, Functions, and Classes (JavaScript)

- **Variables**: `camelCase`, **Bahasa Inggris**
  - ✅ `facilityId`, `startTime`, `reservationStatus`
  - ✅ `facilityData`, `reservationList`
  - ❌ `idFasilitas`, `waktuMulai`, `statusReservasi`
  - ❌ `dataFasilitas`, `daftarReservasi`

- **Functions and methods**: `camelCase`, **Bahasa Inggris**
  - ✅ `create`, `getHistory`, `approve`, `reject`, `cancel`
  - ✅ `validateTimeSlot`, `checkScheduleConflict`
  - ❌ `buat`, `riwayat`, `setujui`, `tolak`, `batal`
  - ❌ `validasiSlotWaktu`, `cekBentrokJadwal`

- **Classes**: `PascalCase`, **Bahasa Inggris**
  - ✅ `User`, `Facility`, `Reservation`, `Report`
  - ❌ `Pengguna`, `Fasilitas`, `Reservasi`, `Laporan`

- **Constants**: `UPPER_SNAKE_CASE`, **Bahasa Inggris**
  - ✅ `OPERATIONAL_HOUR_START`, `OPERATIONAL_HOUR_END`
  - ✅ `SLOT_DURATION_MINUTES` (value: `30`)
  - ❌ `JAM_OPERASIONAL_MULAI`, `DURASI_SLOT_MENIT`

- **Database identifiers and stored values** remain in Bahasa Indonesia when they are part of the PostgreSQL schema or database-defined values:
  - ✅ `id_fasilitas`, `id_pengguna`, `waktu_mulai`, `status`
  - ✅ `'pengguna'`, `'petugas'`, `'admin'`, `'menunggu'`
  - These are database/application values, not JavaScript naming conventions.

- **User-facing text** remains in Bahasa Indonesia:
  - ✅ `Slot waktu tidak valid`
  - ✅ `Jadwal bentrok dengan reservasi lain`
  - ✅ `Terjadi kesalahan`
  - ❌ `Invalid time slot`
  - ❌ `Schedule conflicts with another reservation`
  - ❌ `An error occurred`

## Prioritas File untuk Fast Delivery

**Phase 1** (Minggu 1 - Foundation): ✅ **SELESAI**

```text
app.js                                      ✅
config/db.js, config/session.js             ✅
routes/auth.js, routes/facilities.js        ✅
app/controllers/authController.js           ✅
app/models/User.js                           ✅
app/middleware/auth.js                       ✅
app/middleware/validation.js                ✅
app/middleware/rateLimiter.js               ✅
database/migrations/001_initial_schema.sql  ✅
database/seeds/001_initial_data.sql         ✅
views/login.ejs, views/register.ejs         ✅
views/facilities.ejs                        ✅
views/error.ejs                              ✅
views/partials/*.ejs (components)            ✅
public/css/style.css                         ✅
public/js/calendar.js                        ✅
public/js/clientValidation.js               ✅
```

**Phase 2** (Minggu 2 - Core Features): 🚧 **IN PROGRESS**

```text
routes/reservations.js, routes/reports.js
app/controllers/facilityController.js, reservationController.js, reportController.js
app/models/Facility.js, Reservation.js, Report.js
utils/timeSlot.js, utils/dateHelper.js, utils/fileUpload.js
views/facility-detail.ejs, views/facility-manage.ejs
views/history.ejs, views/report.ejs
```

**Phase 3** (Minggu 3 - Admin & Finalisasi): ⏳ **TODO**

```text
routes/staff.js, routes/admin.js
app/controllers/staffController.js, adminController.js
views/staff.ejs, views/admin.ejs
Testing, bug fixing, and documentation
```

## Contoh Mapping Route ke Controller

### Route: `/routes/reservations.js`

```javascript
const express = require('express');

const router = express.Router();

const reservationController = require('../app/controllers/reservationController');
const { isAuthenticated, hasRole } = require('../app/middleware/auth');

// User: create a reservation
router.post(
  '/reservasi',
  isAuthenticated,
  hasRole('pengguna'),
  reservationController.create
);

// User: view their own reservation history
router.get(
  '/reservasi/riwayat',
  isAuthenticated,
  hasRole('pengguna'),
  reservationController.getHistory
);

// User: cancel their own reservation
router.post(
  '/reservasi/:id/batal',
  isAuthenticated,
  hasRole('pengguna'),
  reservationController.cancel
);

// Staff: manage reservations
router.get(
  '/petugas/reservasi',
  isAuthenticated,
  hasRole('petugas', 'admin'),
  reservationController.manageView
);

router.post(
  '/petugas/reservasi/:id/setujui',
  isAuthenticated,
  hasRole('petugas', 'admin'),
  reservationController.approve
);

router.post(
  '/petugas/reservasi/:id/tolak',
  isAuthenticated,
  hasRole('petugas', 'admin'),
  reservationController.reject
);

router.post(
  '/petugas/reservasi/:id/batalkan',
  isAuthenticated,
  hasRole('petugas', 'admin'),
  reservationController.cancel
);

module.exports = router;
```

Perhatikan bahwa method seperti `getHistory`, `approve`, `reject`, dan `cancel` menggunakan Bahasa Inggris karena merupakan identifier JavaScript. Sebaliknya, URL seperti `/reservasi/riwayat`, `/setujui`, dan `/tolak` tetap menggunakan Bahasa Indonesia karena bersifat user-facing.

### Controller: `/app/controllers/reservationController.js`

```javascript
const Reservation = require('../models/Reservation');
const { validateTimeSlot, checkScheduleConflict } = require('../utils/timeSlot');

exports.create = async (req, res) => {
  try {
    const { id_fasilitas, waktu_mulai, waktu_selesai, tujuan } = req.body;
    const id_pengguna = req.session.user.id;

    // Validate 30-minute slot and operational hours
    if (!validateTimeSlot(waktu_mulai, waktu_selesai)) {
      return res.status(400).json({ error: 'Slot waktu tidak valid' });
    }

    // Check for schedule conflicts
    const hasConflict = await checkScheduleConflict(
      id_fasilitas,
      waktu_mulai,
      waktu_selesai
    );

    if (hasConflict) {
      return res.status(409).json({
        error: 'Jadwal bentrok dengan reservasi lain'
      });
    }

    await Reservation.create({
      id_fasilitas,
      id_pengguna,
      waktu_mulai,
      waktu_selesai,
      tujuan
    });

    res.redirect('/reservasi/riwayat');
  } catch (error) {
    console.error(error);
    res.status(500).send('Terjadi kesalahan');
  }
};

// Other methods: getHistory(), approve(), reject(), cancel(), etc.
```

`id_fasilitas`, `id_pengguna`, `waktu_mulai`, dan `waktu_selesai` tetap menggunakan Bahasa Indonesia karena merupakan nama kolom database dan request field yang mengikuti schema/form. Sebaliknya, `Reservation`, `validateTimeSlot`, `checkScheduleConflict`, dan method controller menggunakan Bahasa Inggris.

### Model: `/app/models/Reservation.js`

```javascript
const pool = require('../../config/db');

class Reservation {
  static async create({
    id_fasilitas,
    id_pengguna,
    waktu_mulai,
    waktu_selesai,
    tujuan
  }) {
    const query = `
      INSERT INTO reservasi (
        id_fasilitas,
        id_pengguna,
        waktu_mulai,
        waktu_selesai,
        tujuan,
        status
      )
      VALUES ($1, $2, $3, $4, $5, 'menunggu')
      RETURNING *
    `;

    const result = await pool.query(query, [
      id_fasilitas,
      id_pengguna,
      waktu_mulai,
      waktu_selesai,
      tujuan
    ]);

    return result.rows[0];
  }

  // Other methods: getHistory(), approve(), reject(), cancel(), etc.
}

module.exports = Reservation;
```

## Notes Penting

- **Konsistensi bahasa**: gunakan Bahasa Inggris untuk seluruh identifier internal aplikasi, termasuk nama file, folder, class, variable, function, method, dan constants.
- **User-facing content**: gunakan Bahasa Indonesia untuk URL, label, pesan error, teks UI, dan konten frontend yang dilihat pengguna.
- **Database**: gunakan Bahasa Indonesia untuk nama tabel, nama kolom, enum/stored values, dan identifier lain yang merupakan bagian dari schema PostgreSQL.
- **Jangan menerjemahkan identifier database di dalam kode JavaScript** jika identifier tersebut memang berasal dari schema atau request field. Gunakan nama database tersebut apa adanya saat berinteraksi dengan database.
- **Naming convention**:
  - `camelCase` untuk variable, function, dan method JavaScript.
  - `PascalCase` untuk class dan model.
  - `UPPER_SNAKE_CASE` untuk constants.
  - `snake_case` untuk identifier database.
  - lowercase dan Bahasa Inggris untuk nama file/folder aplikasi yang tidak user-facing.
