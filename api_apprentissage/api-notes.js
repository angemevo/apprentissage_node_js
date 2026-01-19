const express = require('express');
const { v4 : uuidv4} = require("uuid")
const app = express();

app.use(express.json());

// Base de données temporaire (en mémoire)
let notes = [
    { id: 1, titre: 'Course', contenu: 'Acheter du pain' },
    { id: 2, titre: 'Travail', contenu: 'Finir le projet' }
];

let nextId = 3;

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
});

// Post /api/notes
app.post('/api/notes', function(req, res) {
    const { titre, contenu } = req.body;

    // validation 
    if (!titre || !contenu) {
        return res.status(400).json({'message' : 'Le titre et le contenu sont requis'})
    };

    const newNote = {
        id : nextId++,
        titre: titre,
        contenu: contenu,
        date: new Date().toISOString()
    };

    notes.push(newNote);

    res.status(201).json(newNote)
});

// Put /api/note/:id
app.put('/api/notes/:id', function(req, res) {
    const id = parseInt(req.params.id);
    const { titre, contenu } = req.body;

    const note = notes.find(n => n.id === id);

    if (!note) {
        return res.status(404).json({'message' : 'Aucune note existante'})
    };

    if (titre !== undefined) note.titre = titre;
    if (contenu !== undefined) note.contenu = contenu;

    res.json(note);
});

// Delete api/note/:id
app.delete('/api/notes/:id', function(req, res) {
    const index = notes.findIndex(n => n.id === parseInt(req.params.id));

    if (index === -1) {
        return res.status(404).json({error : 'Note non trouvé'});
    };

    const deleted = notes.splice(index, 1)[0];
    res.json({message : 'Supprimé', notes : deleted})
})

app.listen(3000, function() {
    console.log('API Notes sur http://localhost:3000');
});