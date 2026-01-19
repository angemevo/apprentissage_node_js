const express = require('express');
const app = express();

// Get /api/add/:a/:b
app.get('/api/add/:a/:b', function(req, res) {
    const a = parseInt(req.params.a);
    const b = parseInt(req.params.b);

    if (isNaN(a) || isNaN(b)) {
        return res.status(400).json({error : 'Veuillez entrer des chiffres !'})
    }


    res.json({
        operation : "addition",
        a,
        b,
        resultat : a + b
    });
});

// Get /api/multiply/:a/:b 
app.get('/api/multiply/:a/:b', function(req, res) {
    const a = parseInt(req.params.a);
    const b = parseInt(req.params.b);

    if (isNaN(a) || isNaN(b)) {
        return res.status(400).json({error : 'Veuillez entrer des chiffres !'})
    }


    res.json({
        operation : "multiplication",
        a,
        b,
        resultat : a * b
    });
});

// Get /api/divide/:a/:b
app.get('/api/divide/:a/:b', function(req, res) {
    const a = parseInt(req.params.a);
    const b = parseInt(req.params.b);

    if (isNaN(a) || isNaN(b)) {
        return res.status(400).json({error : 'Veuillez entrer des chiffres !'})
    }

    if (b == 0) {
        return res.status(400).json({error : 'Impossible de diviser par 0'})
    }


    res.json({
        operation : "division",
        a,
        b,
        resultat : a / b
    });
})

app.listen(3000, function() {
    console.log('API Calculatrice sur http://localhost:3000');
})