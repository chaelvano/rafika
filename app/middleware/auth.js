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
    hasRole
};