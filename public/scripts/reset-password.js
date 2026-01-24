const form = document.getElementById('reset-password-form');

form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = form.email.value;

    try {
        const res = await fetch('/api/auth/forgot-password', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email })
        });
        const data = await res.json();
        alert(data.message);
    } catch (error) {
        console.error(error);
        alert('An error occurred. Please try again.');
    }
});