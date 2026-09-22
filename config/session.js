const session = require('express-session');
const pgSession = require('connect-pg-simple')(session);
const pool = require('./db');

const sessionConfig = {
  store: new pgSession({
    pool: pool,
    tableName: 'session',
    createTableIfMissing: false // Sudah dibuat di migration
  }),
  secret: process.env.SESSION_SECRET, // Min 32 karakter
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production', // HTTPS only di production
    httpOnly: true, // Prevent XSS - cookie tidak bisa diakses via JavaScript
    maxAge: 24 * 60 * 60 * 1000, // 24 jam
    sameSite: 'strict' // CSRF protection
  }
};

module.exports = sessionConfig;
