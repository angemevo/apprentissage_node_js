const express = require('express');
const app = express();

// Base de données temporaire (en mémoire)
let notes = [
    { id: 1, titre: 'Course', contenu: 'Acheter du pain' },
    { id: 2, titre: 'Travail', contenu: 'Finir le projet' }
];

// Get /api/notes
app.get('/api/notes', function(req, res) {
    res.json(notes);
});

// Get /api/notes/:id
app.get('/api/notes/:id', function(req, res) {
    const id = parseInt(req.params.id)

    const note = notes.find(u => u.id === id);

    if (note) {
        res.json(note);
    } else {
        res.status(404).json({'message' : 'Note introuvable'})
    }
})

app.listen(3000, function() {
    console.log('API Notes sur http://localhost:3000');
});