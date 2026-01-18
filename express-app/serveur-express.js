const express = require('express');
const app = express();

app.get('/', function(req, rep) {
    rep.send("Bonjour depuis Express ! ")
});

app.get('/about', function(req, rep) {
    rep.send("Page à propos")
});

app.get('/user/:nom', function(req, rep) {
    const nom = req.params.nom
    rep.send("Bonjour " + nom + ' !')
});

// Route qui retourne du JSON
app.get('/api/users', function(req, rep) {
    const users = [
        { id: 1, nom: 'Dupont', prenom: 'Jean' },
        { id: 2, nom: 'Martin', prenom: 'Marie' },
        { id: 3, nom: 'Durand', prenom: 'Paul' }
    ];

    rep.json(users)  // Conversion auto en Json
});

// Route qui renvoie un seule utilisateur 
app.get('/api/users/:id', function(req, rep) {
    const id = parseInt(req.params.id);

    const users = [
        { id: 1, nom: 'Dupont', prenom: 'Jean' },
        { id: 2, nom: 'Martin', prenom: 'Marie' },
        { id: 3, nom: 'Durand', prenom: 'Paul' }
    ];

    const user = users.find(u => u.id === id);

    if (user) {
        rep.json(user);
    } else {
        rep.status(404).json({'message' : 'Utilisateur inexistant'})
    }
})

app.listen(3000, function() {
    console.log('Serveur Express démarré sur http://localhost:3000');
    
})