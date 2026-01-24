const profileForm = document.getElementById('profile-form');
const passwordForm = document.getElementById('password-form');
const token = localStorage.getItem('token');

document.addEventListener('DOMContentLoaded', async () => {
    if (!token) {
        window.location.href = '/login.html';
    }

    try {
        const res = await fetch('/api/users/me', {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        const user = await res.json();
        if (res.ok) {
            profileForm.username.value = user.username;
            profileForm.email.value = user.email;
            profileForm.first_name.value = user.first_name;
            profileForm.last_name.value = user.last_name;
            profileForm.language_pref.value = user.language_pref;
        } else {
            alert(user.message);
            window.location.href = '/login.html';
        }
    } catch (error) {
        console.error(error);
        alert('An error occurred. Please try again.');
        window.location.href = '/login.html';
    }
});

profileForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = profileForm.username.value;
    const email = profileForm.email.value;
    const first_name = profileForm.first_name.value;
    const last_name = profileForm.last_name.value;
    const language_pref = profileForm.language_pref.value;

    try {
        const res = await fetch('/api/users/me', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({ username, email, first_name, last_name, language_pref })
        });
        const data = await res.json();
        alert(data.message || 'Profile updated successfully');
    } catch (error) {
        console.error(error);
        alert('An error occurred. Please try again.');
    }
});

passwordForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const password = passwordForm.new_password.value;

    try {
        const res = await fetch('/api/users/me/password', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({ password })
        });
        const data = await res.json();
        alert(data.message || 'Password changed successfully');
    } catch (error) {
        console.error(error);
        alert('An error occurred. Please try again.');
    }
});