const express = require('express');
const router = express.Router();

// Import sub-routes
const authRoutes = require('./auth');
const facilitiesRoutes = require('./facilities');

// Mount sub-routes (tanpa prefix, langsung di root)
// PENTING: Urutan mounting matters! Specific routes dulu, generic routes terakhir
router.use('/', authRoutes);       // Handle /daftar, /masuk, /keluar (specific)
router.use('/', facilitiesRoutes);  // Handle / (generic, harus terakhir)

module.exports = router;