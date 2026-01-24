const songSharesList = document.getElementById('song-shares-list');
const chordSharesList = document.getElementById('chord-shares-list');
const token = localStorage.getItem('token');

document.addEventListener('DOMContentLoaded', async () => {
    if (!token) {
        window.location.href = '/login.html';
        return;
    }

    try {
        const res = await fetch('/api/shares/incoming', {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        const data = await res.json();
        if (res.ok) {
            renderShares(data.songShares, songSharesList, 'song');
            renderShares(data.chordShares, chordSharesList, 'chord');
        } else {
            alert(data.message);
        }
    } catch (error) {
        console.error(error);
        alert('An error occurred. Please try again.');
    }
});

function renderShares(shares, listElement, type) {
    listElement.innerHTML = '';
    shares.forEach(share => {
        const li = document.createElement('li');
        const payload = JSON.parse(share.payload);
        li.innerHTML = `
            <span>${payload.title || payload.name} from ${share.sender_user_id}</span>
            <button class="accept-share" data-id="${share.id}" data-type="${type}">Accept</button>
            <button class="reject-share" data-id="${share.id}" data-type="${type}">Reject</button>
        `;
        listElement.appendChild(li);
    });
}

document.addEventListener('click', async (e) => {
    if (e.target.classList.contains('accept-share') || e.target.classList.contains('reject-share')) {
        const shareId = e.target.dataset.id;
        const type = e.target.dataset.type;
        const action = e.target.classList.contains('accept-share') ? 'accept' : 'reject';

        try {
            const res = await fetch(`/api/shares/${shareId}/${action}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`
                },
                body: JSON.stringify({ type })
            });
            const data = await res.json();
            alert(data.message);
            if (res.ok) {
                window.location.reload();
            }
        } catch (error) {
            console.error(error);
            alert('An error occurred. Please try again.');
        }
    }
});