const { Pool } = require('pg');

/**
 * Pool koneksi PostgreSQL
 * Menggunakan DATABASE_URL dari environment variables
 */
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Contoh untuk development local, bisa override:
  // host: 'localhost',
  // port: 5432,
  // database: 'rafika',
  // user: 'postgres',
  // password: 'password',
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Test koneksi saat pertama kali load
pool.on('connect', () => {
  console.log('Database connected');
});

pool.on('error', (err) => {
  console.error('Database connection error:', err);
});

module.exports = pool;
