function isGuest(req, res, next) {
    if (req.session && req.session.user) {
        const user = req.session.user;

        if (user.role === 'admin') {
            return res.redirect('/admin');
        } else if (user.role === 'petugas') {
            return res.redirect('/petugas');
        } else {
            return res.redirect('/');
        }
    }
    
    return next();
}

// Allow guest (tidak login) dan user dengan role 'pengguna'
function isGuestOrUser(req, res, next) {
    if (!req.session || !req.session.user) {
        // guest - allowed
        return next();
    }
    
    const userRole = req.session.user.role;
    
    if (userRole === 'pengguna') {
        // pengguna  - allowed
        return next();
    } else if (userRole === 'petugas') {
        // petugas - redirect
        return res.redirect('/petugas');
    } else if (userRole === 'admin') {
        // admin - redirect
        return res.redirect('/admin');
    }
    
    // Fallback (should not happen)
    return res.status(403).render('error', {
        status: 403,
        errors: { message: 'Anda tidak memiliki hak akses' }
    });
}

function isAuthenticated(req, res, next) {
    if (req.session && req.session.user) {
        return next();
    }

    return res.redirect('/masuk');
}

function hasRole(...allowedRoles) {
    return (req, res, next) => {
        if (!req.session || !req.session.user) {
            return res.redirect('/masuk');
        }

        const userRole = req.session.user.role;

        if (!allowedRoles.includes(userRole)) {
            const errorStatus = 403;

            return res.status(403).render('error', {
                status: errorStatus,
                errors: { message: 'Anda tidak memiliki hak akses' }
            });
        }

        return next();
    }
}

module.exports = {
    isAuthenticated,
    isGuest,
    isGuestOrUser,
    hasRole
};