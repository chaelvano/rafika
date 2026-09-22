const { body, validationResult } = require('express-validator');
const User = require('../models/User');

// Validasi login
const loginValidation = [
    body('email')
        .trim().isEmail().bail()
        .normalizeEmail(),
    body('password')
        .trim().isLength({ min: 8 })
];

// Validasi register
const registerValidation = [
    body('email')
        .trim().isEmail().withMessage('Format email tidak valid').bail()
        .normalizeEmail().custom((value) => {
            // Validasi domain email harus @*.undip.ac.id
            // Terima: user@undip.ac.id, user@students.undip.ac.id, user@foo.undip.ac.id
            // Tolak: user@barundip.ac.id, user@gmail.com
            const emailRegex = /@([a-zA-Z0-9-]+\.)*undip\.ac\.id$/;
            
            if (!emailRegex.test(value)) {
                throw new Error('Email harus menggunakan domain undip.ac.id');
            }

            return true;
        }).bail()
        .custom(async (value) => {
            try {
                const existingUser = await User.findByEmail(value);
                
                if (existingUser) {
                    throw new Error('Email sudah terdaftar');
                }

                return true;
            } catch (err) {
                if (err.message === 'Email sudah terdaftar') {
                    throw err;
                }

                console.error(err.message);

                throw new Error('Terjadi kesalahan saat memeriksa email');
            }
        }),
    body('name')
        .trim().notEmpty().withMessage('Nama tidak boleh kosong').bail()
        .isLength({ min: 1, max: 255 }).withMessage('Nama harus berisi 1-255 karakter').bail()
        .escape(), // Prevent XSS
    body('password')
        .trim().isLength({ min: 8 }).withMessage('Password minimal berisi 8 karakter').bail()
        .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/).withMessage('Password harus mengandung huruf kapital, huruf kecil, dan angka'),
    body('confirmation')
        .trim().custom((value, { req }) => value === req.body.password).withMessage('Password tidak cocok')
];

// Middleware untuk memeriksa validation result
const handleLoginValidationErrors = (req, res, next) => {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        return res.status(401).render('login', {
            errors: {
                email: 'Email atau password salah',
                password: 'Email atau password salah'
            },
            oldInput: {
                email: req.body.email
            }
        });
    }

    next();
};

const handleRegisterValidationErrors = (req, res, next) => {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        if (errors.array().some(err => err.msg === 'Terjadi kesalahan saat memeriksa email')) {
            const errorStatus = 500;
            
            return res.status(errorStatus).render('error', {
                status: errorStatus,
                errors: { message: 'Terjadi kesalahan di server' }
            });
        }

        const errorsByField = {};

        errors.array().forEach(err => {
            if (!errorsByField[err.path]) {
                errorsByField[err.path] = err.msg;
            }
        });

        return res.status(400).render('register', {
            errors: errorsByField,
            oldInput: {
                email: req.body.email,
                name: req.body.name
            }
        });
    }

    next();
};

module.exports = {
    loginValidation,
    registerValidation,
    handleLoginValidationErrors,
    handleRegisterValidationErrors
};
