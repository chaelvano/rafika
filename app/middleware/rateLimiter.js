require('dotenv').config();

const rateLimit = require('express-rate-limit');

// Rate limiter untuk login - max. 5 percobaan per 1 menit
const loginLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 menit
  max: 5, // 5 percobaan
  message: 'Terlalu banyak percobaan. Silakan coba lagi setelah 1 menit.',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Skip successful logins dari counter
  skip: () => process.env.NODE_ENV === 'development' // No limit saat development
});

// Rate limiter untuk register - max. 5 percobaan per 15 menit
const registerLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 menit
  max: 5, // 5 percobaan
  message: 'Terlalu banyak percobaan. Silakan coba lagi setelah 15 menit.',
  standardHeaders: true,
  legacyHeaders: false,
  skip: () => process.env.NODE_ENV === 'development' // No limit saat development
});

module.exports = { loginLimiter, registerLimiter };
