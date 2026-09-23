const form = document.getElementById('login-form');
const emailForm = document.getElementById('email-form');
const emailField = document.getElementById('email-field');
const emailError = document.getElementById('email-message');
const passwordForm = document.getElementById('password-form');
const passwordField = document.getElementById('password-field');
const passwordError = document.getElementById('password-message');

form.addEventListener('submit', (event) => {
    function isInvalidEmail(email) {
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())) {
            return 'Email atau password salah';
        }

        if (!/@([a-zA-Z0-9-]+\.)*undip\.ac\.id$/.test(email.trim())) {
            return 'Email atau password salah';
        }

        return false;
    }

    function isInvalidPassword(password) {
        if (password.length < 8) {
            return 'Email atau password salah';
        }

        if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(password)) {
            return 'Email atau password salah';
        }

        return false;
    }

    if (isInvalidEmail(emailField.value) || isInvalidPassword(passwordField.value)) { 
        // Show error dengan generic message di kedua field meski hanya salah satu yang tidak valid
        event.preventDefault();

        emailForm.classList.remove('my-1');
        emailField.style.setProperty('border-color', 'var(--red)', 'important');
        emailError.textContent = 'Email atau password salah';
        emailError.classList.remove('d-none');

        passwordForm.classList.remove('my-1');
        passwordField.style.setProperty('border-color', 'var(--red)', 'important');
        passwordError.textContent = 'Email atau password salah';
        passwordError.classList.remove('d-none');
    } else {
        emailForm.classList.add('my-1');
        emailField.style.removeProperty('border-color');
        emailError.textContent = '';
        emailError.classList.add('d-none');

        passwordForm.classList.add('my-1');
        passwordField.style.removeProperty('border-color');
        passwordError.textContent = '';
        passwordError.classList.add('d-none');
    }
});