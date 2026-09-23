const bcrypt = require('bcrypt');
const pool = require('../../config/db');

class User {
    static async register({ name, email, password, role='pengguna' }) {
        const passwordHash = await bcrypt.hash(password, 10);

        const query = `
            INSERT INTO pengguna (nama, email, password_hash, role, status)
            VALUES ($1, $2, $3, $4, 'menunggu_verifikasi')
            RETURNING id, nama, email, role, status, dibuat_pada;
        `;

        const result = await pool.query(query, [name, email, passwordHash, role]);

        return result.rows[0];
    }

    static async login({ email, password }) {
        const user = await this.findByEmail(email);

        if (!user) {
            throw new Error('Email atau password salah');
        }

        const isPasswordMatch = await bcrypt.compare(password, user.password_hash);

        if (!isPasswordMatch) {
            throw new Error('Email atau password salah');
        }

        if (user.status === 'menunggu_verifikasi') {
            throw new Error('Akun belum diverifikasi');
        } else if (user.status === 'nonaktif') {
            throw new Error('Akun telah dinonaktifkan');
        }

        const { password_hash: _, ...userWithoutPassword } = user;

        return userWithoutPassword;
    }

    // findById()
    
    static async findByEmail(email) {
        const query = `
            SELECT * FROM pengguna
            WHERE email = $1;
        `;

        const result = await pool.query(query, [email]);

        return result.rows[0] || null;
    }

    // findByStatus()
    // verify()
    // create()
}

module.exports = User;