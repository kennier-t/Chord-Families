const SongsManager = (function() {
    'use strict';
    
    let currentFolderId = null;
    
    function initialize() {
        document.getElementById('open-songs-btn').addEventListener('click', openSongsView);
        document.getElementById('close-songs-modal').addEventListener('click', closeSongsModal);
        document.getElementById('create-new-folder-btn').addEventListener('click', createNewFolder);
        document.getElementById('create-new-song-btn').addEventListener('click', () => {
            SongEditor.openEditor();
        });
        document.getElementById('back-to-folders-btn').addEventListener('click', showFoldersView);
    }
    
    function openSongsView() {
        document.getElementById('songs-modal').classList.remove('hidden');
        showFoldersView();
    }
    
    function closeSongsModal() {
        document.getElementById('songs-modal').classList.add('hidden');
    }
    
    function showFoldersView() {
        currentFolderId = null;
        document.getElementById('folders-view').classList.remove('hidden');
        document.getElementById('songs-list-view').classList.add('hidden');
        refreshFoldersList();
    }
    
    function showSongsListView(folderId) {
        currentFolderId = folderId;
        const folder = SONGS_SERVICE.getAllFolders().find(f => f.id === folderId);
        document.getElementById('folder-title').textContent = folder ? folder.name : 'All Songs';
        document.getElementById('folders-view').classList.add('hidden');
        document.getElementById('songs-list-view').classList.remove('hidden');
        refreshSongsList(folderId);
    }
    
    function refreshFoldersList() {
        const container = document.getElementById('folders-list');
        const folders = SONGS_SERVICE.getAllFolders();
        
        container.innerHTML = '';
        
        if (folders.length === 0) {
            container.innerHTML = '<div class="empty-message">No folders yet. Create one to organize your songs!</div>';
            return;
        }
        
        folders.forEach(folder => {
            const songs = SONGS_SERVICE.getSongsByFolder(folder.id);
            const item = document.createElement('div');
            item.className = 'folder-item';
            item.innerHTML = `
                <div class="folder-info" onclick="SongsManager.showSongsListView(${folder.id})">
                    <h3>${folder.name}</h3>
                    <span class="song-count">${songs.length} song${songs.length !== 1 ? 's' : ''}</span>
                </div>
                <button class="delete-folder-btn" onclick="SongsManager.deleteFolder(${folder.id})">Delete</button>
            `;
            container.appendChild(item);
        });
    }
    
    function refreshSongsList(folderId) {
        const container = document.getElementById('songs-list');
        const songs = folderId ? SONGS_SERVICE.getSongsByFolder(folderId) : SONGS_SERVICE.getAllSongs();
        
        container.innerHTML = '';
        
        if (songs.length === 0) {
            container.innerHTML = '<div class="empty-message">No songs in this folder. Create your first song!</div>';
            return;
        }
        
        songs.forEach(song => {
            const item = document.createElement('div');
            item.className = 'song-item';
            item.innerHTML = `
                <div class="song-info">
                    <h3>${song.title}</h3>
                    <div class="song-meta">
                        ${song.songKey ? `Key: ${song.songKey}` : ''} 
                        ${song.capo ? `• Capo: ${song.capo}` : ''}
                        ${song.bpm ? `• BPM: ${song.bpm}` : ''}
                    </div>
                </div>
                <div class="song-actions">
                    <button class="action-btn" onclick="SongsManager.editSong(${song.id})">Edit</button>
                    <button class="action-btn" onclick="SongsManager.downloadSongPDF(${song.id})">PDF</button>
                    <button class="action-btn delete-btn" onclick="SongsManager.deleteSong(${song.id})">Delete</button>
                </div>
            `;
            container.appendChild(item);
        });
    }
    
    function createNewFolder() {
        const name = prompt('Enter folder name:');
        if (name && name.trim()) {
            SONGS_SERVICE.createFolder(name.trim());
            refreshFoldersList();
        }
    }
    
    function deleteFolder(folderId) {
        if (confirm('Delete this folder? Songs will not be deleted, only removed from this folder.')) {
            SONGS_SERVICE.deleteFolder(folderId);
            refreshFoldersList();
        }
    }
    
    function editSong(songId) {
        SongEditor.openEditor(songId);
    }
    
    async function downloadSongPDF(songId) {
        const song = SONGS_SERVICE.getSongById(songId);
        if (!song) {
            alert('Song not found');
            return;
        }
        
        const chordIds = SONGS_SERVICE.getSongChordDiagrams(songId);
        await SongPDFGenerator.downloadPDF(song, chordIds, `${song.title}.pdf`);
    }
    
    function deleteSong(songId) {
        const song = SONGS_SERVICE.getSongById(songId);
        if (confirm(`Delete song "${song.title}"?`)) {
            SONGS_SERVICE.deleteSong(songId);
            refreshSongsList(currentFolderId);
        }
    }
    
    document.addEventListener('DOMContentLoaded', initialize);
    
    return {
        openSongsView,
        closeSongsModal,
        showFoldersView,
        showSongsListView,
        createNewFolder,
        deleteFolder,
        editSong,
        downloadSongPDF,
        deleteSong,
        refreshFoldersList,
        refreshSongsList
    };
})();
