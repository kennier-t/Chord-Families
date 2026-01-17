# Chord Families

A web application for visualizing, creating, and downloading guitar chord diagrams organized by musical families.

## Features

### 🎸 Browse Chord Families
- **7 Musical Families**: C, D, E, F, G, A, B
- Each family displays its related chords in an organized gallery
- Click any chord to view it in detail

### ✏️ Create Custom Chords
- **Interactive Canvas Editor**: Draw chords visually without traditional forms
- **Click on fret**: Add finger positions (cycles 1→2→3→4→remove)
- **Click above string**: Mark strings as not played (X)
- **Drag horizontally**: Create barre chords automatically
- **Unique names**: Validates chord names in real-time
- **Edit & Delete**: Full CRUD functionality for custom chords

### 🎼 Create and Manage Songs
- **Song Editor**: Create songs with metadata (Title, Date, Notes, Key, Capo, BPM, Effects)
- **Text Editor**: Paste or type song lyrics and chords (preserves formatting)
- **Chord Diagrams**: Select up to 8 chord diagrams to include with each song
- **Folders**: Organize songs into folders (many-to-many relationship)
- **PDF Export**: Download songs as formatted PDF documents
- **Full CRUD**: Create, edit, delete songs and folders

### 🎵 Generate Song Chord Sequences
- Select up to 8 chords for your song
- Generates a visual diagram of the entire chord progression
- Includes both original and custom chords

### 💾 Download Options
- **Individual chords**: PNG or SVG format
- **Complete families**: Downloads as ZIP file
- **Song sequences**: Export your chord progressions

## Getting Started

1. Open `index.html` in your web browser
2. Click on any family button (C, D, E, F, G, A, B) to explore chords
3. Click "Create Chord" to build your own custom chords
4. Click "Create Song" to create songs with lyrics and chord diagrams
5. Click "Songs" to manage your song library and folders
6. Use "Gen Song Chords" to create chord sequences

## Technologies

- **HTML5 Canvas** for interactive chord editing
- **Vanilla JavaScript** (no frameworks)
- **CSS3** for responsive design
- **localStorage** for data persistence
- **jsPDF** for PDF generation
- **SQL Server** database schema (optional backend)

## Database Setup (Optional)

If you want to connect to SQL Server instead of using localStorage:

1. Open SQL Server Management Studio
2. Run the script: `ChordFamilies-Database.sql`
3. Run the script: `ChordFamilies-Songs-Extension.sql`
4. Implement a backend API (Node.js, .NET, etc.)
5. Modify `dbService.js` and `songsService.js` to use API calls instead of localStorage

The app currently works standalone using browser localStorage - no backend required!

## How It Works

### Data Storage
- All chord data is stored in browser localStorage
- Original chords are protected and cannot be edited or deleted
- Custom chords are saved automatically and persist across sessions

### Chord Editor
- Canvas-based interface with 6 strings and 4 frets
- Interactive click and drag functionality
- Real-time visual feedback
- Validates finger positions and chord names

### Architecture
- `dbService.js`: Chord data layer (simulates SQL Server with localStorage)
- `songsService.js`: Songs data layer (localStorage)
- `chordEditor.js`: Interactive canvas chord editor
- `songEditor.js`: Song creation and editing
- `songsManager.js`: Songs and folders management
- `chordRenderer.js`: SVG/PNG rendering engine
- `songPDFGenerator.js`: PDF generation for songs
- `songChords.js`: Chord sequence generator
- `app.js`: Main application logic

## Project Structure

```
Chord-Families/
├── index.html              # Main page
├── app.js                  # Core application
├── chordData.js            # Chord data integration
├── chordRenderer.js        # Rendering engine
├── dbService.js            # Chord data service (localStorage)
├── songsService.js         # Songs data service (localStorage)
├── chordEditor.js          # Interactive chord editor
├── songEditor.js           # Song editor
├── songsManager.js         # Songs/folders manager
├── songPDFGenerator.js     # PDF generator
├── songChords.js           # Sequence generator
├── guitar-pattern.js       # Background pattern
├── styles.css              # Complete styling
├── ChordFamilies-Database.sql       # SQL Server schema
└── ChordFamilies-Songs-Extension.sql # Songs tables
```

## Browser Support

Works on all modern browsers that support:
- HTML5 Canvas
- localStorage API
- ES6 JavaScript

## License

Personal educational project.

---

**Note**: Custom chords are stored locally in your browser. Clear browser data will delete custom chords.
