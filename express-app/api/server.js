const express = require('express');
const cors = require('cors')
const connectDB = require('./config/database');
const Note = require('./models/Note');
const authRoute = require('./routes/auth');
const authMiddleware = require('./middleware/auth')

console.log('Type de authMiddleware:', typeof authMiddleware);
console.log('authMiddleware est une fonction ?', typeof authMiddleware === 'function');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

connectDB();

// Route d'authentification 
app.use('/api/auth', authRoute);    

// Création des notes
app.post('/api/notes', authMiddleware, async function (req, res) {
    try {
        const { titre, contenu } = req.body;

        // Validation 
        if (!titre || !contenu) {
            return res.status(400).json(
                {
                    error: 'Le titre et le contenu sont requis'
                }
            )
        }

        // créer une note 
        const note = new Note({
            titre: titre,
            contenu: contenu
        });

        // Sauvegarder dans mongo DB
        await note.save();

        res.status(201).json(note);
    } catch(e) {
        res.status(500).json({error : e.message})
    }
});

// Recuperations de toute les notes 
app.get('/api/notes', async function (req, res) {
    try {
        const notes = await Note.find();
        res.json(notes)
    } catch(e) {
        res.status(500).json({error : e.message})
    }
});

// Récupération d'une note
app.get('/api/notes/:id', async function (req, res) {
    try {
        const note = await Note.findById(req.params.id);

        if (!note) {
            return res.status(404).json({error : 'Aucune note existante'});
        };

        res.json(note);
    } catch(e) {
        res.status(500).json({error : e.message})
    }
});

// Modification d'une note 
app.put('/api/notes/:id', authMiddleware, async function(req, res) {
    try {
        const { titre, contenu, complete } = req.body;

        const note = await Note.findByIdAndUpdate(
            req.params.id,
            { titre, contenu, complete },
            {new: true, runValidators: true}
        );

        if (!note) {
            return res.status(404).json({error : 'Note non trouvé'})
        };

        res.json(note);
    } catch(e) {
        res.status(500).json({error : e.message})
    }
});

// Supprimer une note
app.delete('/api/notes/:id',authMiddleware, async function(req, res) {
    try {
        const note = await Note.findByIdAndDelete(req.params.id);

        if (!note) {
            return res.status(404).json({error : 'Note non trouvé'})
        };

        res.json({message : 'Note supprimé', note: note})
    } catch(e) {
        res.status(500).json({error : e.message})
    }
});

// Démarer le serveur 
app.listen(3000, function() {
    console.log('✓ Serveur démarré sur http://localhost:3000');
}) 