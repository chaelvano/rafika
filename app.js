require('dotenv').config();

const express = require('express');
const path = require('path');
const session = require('express-session');
const pgSession = require('connect-pg-simple')(session);
const pool = require('./config/db');
const sessionConfig = require('./config/session');

const app = express();
const PORT = process.env.PORT || 3000;

// View engine setup (EJS)
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Session middleware
app.use(require('express-session')(sessionConfig));

// Middleware untuk pass user session ke semua views
app.use((req, res, next) => {
  res.locals.user = req.session.user || null;

  next();
});

// Routes
app.use('/', require('./routes'));

// 404 handler
app.use((req, res) => {
  const errorStatus = 404;

  res.status(errorStatus).render('error', {
    status: errorStatus,
    errors: { message: 'Halaman yang Anda cari tidak ditemukan' }
  });
});

// Error handler
app.use((err, req, res, next) => {
  const errorStatus = err.status || 500;

  console.error(err.stack);

  res.status(errorStatus).render('error', {
    status: errorStatus,
    errors: process.env.NODE_ENV === 'development' ? err : { message: 'Terjadi kesalahan' }
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;
