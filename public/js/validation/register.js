const form = document.getElementById('register-form');
const emailForm = document.getElementById('email-form');
const emailField = document.getElementById('email-field');
const emailError = document.getElementById('email-message');
const nameForm = document.getElementById('name-form');
const nameField = document.getElementById('name-field');
const nameError = document.getElementById('name-message');
const passwordForm = document.getElementById('password-form');
const passwordField = document.getElementById('password-field');
const passwordError = document.getElementById('password-message');
const confirmationForm = document.getElementById('confirmation-form');
const confirmationField = document.getElementById('confirmation-field');
const confirmationError = document.getElementById('confirmation-message');

form.addEventListener('submit', (event) => {
    function isInvalidEmail(email) {
        const trimmedEmail = email.trim();

        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(trimmedEmail)) {
            return 'Format email tidak valid';
        }

        if (!/@([a-zA-Z0-9-]+\.)*undip\.ac\.id$/.test(trimmedEmail)) {
            return 'Email harus menggunakan domain undip.ac.id';
        }

        return false;
    }

    function isInvalidName(name) {
        const trimmedName = name.trim();

        if (trimmedName.length < 1 || trimmedName.length > 255) {
            return 'Nama harus berisi 1-255 karakter';
        }

        if (!/^[a-zA-Z\s'.-]+$/.test(trimmedName)) {
            return 'Nama mengandung karakter yang tidak valid';
        }

        return false;
    }

    function isInvalidPassword(password) {
        if (password.length < 8) {
            return 'Password minimal berisi 8 karakter';
        }

        if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(password)) {
            return 'Password harus mengandung huruf kapital, huruf kecil, dan angka';
        }

        return false;
    }

    function isInvalidConfirmation(confirmation, password) {
        if (confirmation !== password) {
            return 'Password tidak cocok';
        }

        return false;
    }

    const emailMessage = isInvalidEmail(emailField.value);
    const nameMessage = isInvalidName(nameField.value);
    const passwordMessage = isInvalidPassword(passwordField.value);
    const confirmationMessage = isInvalidConfirmation(confirmationField.value, passwordField.value);

    if (emailMessage || nameMessage || passwordMessage || confirmationMessage) {
        event.preventDefault();

        if (emailMessage) {
            emailForm.classList.remove('my-1');
            emailField.style.setProperty('border-color', 'var(--red)', 'important');
            emailError.textContent = emailMessage;
            emailError.classList.remove('d-none');
        } else {
            emailForm.classList.add('my-1');
            emailField.style.removeProperty('border-color');
            emailError.textContent = '';
            emailError.classList.add('d-none')
        }

        if (nameMessage) {
            nameForm.classList.remove('my-1');
            nameField.style.setProperty('border-color', 'var(--red)', 'important');
            nameError.textContent = nameMessage;
            nameError.classList.remove('d-none');
        } else {
            nameForm.classList.add('my-1');
            nameField.style.removeProperty('border-color');
            nameError.textContent = '';
            nameError.classList.add('d-none')
        }

        if (passwordMessage) {
            passwordForm.classList.remove('my-1');
            passwordField.style.setProperty('border-color', 'var(--red)', 'important');
            passwordError.textContent = passwordMessage;
            passwordError.classList.remove('d-none');
        } else {
            passwordForm.classList.add('my-1');
            passwordField.style.removeProperty('border-color');
            passwordError.textContent = '';
            passwordError.classList.add('d-none')
        }

        if (confirmationMessage) {
            confirmationForm.classList.remove('my-1');
            confirmationField.style.setProperty('border-color', 'var(--red)', 'important');
            confirmationError.textContent = confirmationMessage;
            confirmationError.classList.remove('d-none');
        } else {
            confirmationForm.classList.add('my-1');
            confirmationField.style.removeProperty('border-color');
            confirmationError.textContent = '';
            confirmationError.classList.add('d-none')
        }
    }
});