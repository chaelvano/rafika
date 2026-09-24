const express = require('express');
const router = express.Router();
const authController = require('../app/controllers/authController');
const { loginValidation, registerValidation, handleLoginValidationErrors, handleRegisterValidationErrors } = require('../app/middleware/validation');
const { registerLimiter, loginLimiter } = require('../app/middleware/rateLimiter');
const { isAuthenticated, isGuest } = require('../app/middleware/auth');

router.get('/daftar', 
    isGuest, 
    (req, res) => {
        res.render('register');
});

router.post('/daftar', 
    registerLimiter,
    registerValidation,
    handleRegisterValidationErrors, 
    authController.register
);

router.get('/masuk', 
    isGuest, 
    (req, res) => {
        res.render('login');
});

router.post('/masuk', 
    loginLimiter,
    loginValidation,
    handleLoginValidationErrors,
    authController.login
);

router.post('/keluar', 
    isAuthenticated, 
    authController.logout);

module.exports = router;