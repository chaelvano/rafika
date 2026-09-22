const User = require('../models/User');

exports.register = async (req, res) => {
    try {
        const { name, email, password, password_confirmation } = req.body;

        await User.register({ name, email, password });
        
        return res.redirect('/masuk');
    } catch (err) {
        const errorStatus = 500;

        console.error('Registration error: ', err);

        return res.status(errorStatus).render('error', {
            status: errorStatus,
            errors: { message: 'Terjadi kesalahan di server' }
        });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Login akan throw error jika gagal
        const user = await User.login({ email, password });

        // PENTING: Regenerate session ID untuk mencegah session fixation
        req.session.regenerate((err) => {
            if (err) {
                const errorStatus = 500;

                console.error('Session regeneration error:', err);

                return res.status(errorStatus).render('error', {
                    status: errorStatus,
                    errors: { message: 'Terjadi kesalahan di server' }
                });
            }

            req.session.user = user;

            if (user.role === 'admin') {
                return res.redirect('/admin');
            } else if (user.role === 'petugas') {
                return res.redirect('/petugas');
            } else {
                return res.redirect('/');
            }
        });
    } catch (err) {
        console.error('Login error: ', err);

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
};

exports.logout = (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            const errorStatus = 500;

            console.error('Logout error: ', err);
            
            return res.status(errorStatus).render('error', {
                status: errorStatus,
                errors: { message: 'Terjadi kesalahan di server' }
            });
        }

        return res.redirect('/');
    });
};