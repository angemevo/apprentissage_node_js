const express = require('express');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const router = express.Router();

const JWT_SECRET = 'votre_secret_super_securise_changez_moi_123';

// Inscription
router.post('/register', async function(req, res) {
    try {
        const { email, nom, password } = req.body;

        // vérifier si l'utilisateur existe déja 
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ error : 'Email déja utilisé' })
        }

        // Création de l'utilisateur
        const user = new User({ email, password, nom });
        await user.save();

        // Créer un JWT token
        const token = jwt.sign(
            { userId : user._id },
            JWT_SECRET,
            { expiresIn : '7d' }
        )

        res.status(201).json({
            message : 'Utilisateur crée',
            token: token,
            user : {
                id : user._id,
                email : user.email,
                nom : user.nom
            }
        });
    } catch (e) {
        res.status(500).json({ error : e.message })
    }
});

// Connexion 
router.post('/login', async function(req, res) {
    try {
        const { email, password } = req.body

        // Trouver l'utilisateur
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(401).json({ error : 'Email ou mot de passe incorrect'})
        }

        // Vérifier le mot de passe
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({ error : 'Email ou mot de passe incorrect'})
        };

        // Créer un JWT Token
        const token = jwt.sign(
            { userId : user._id },
            JWT_SECRET,
            { expiresIn : '7d'}
        );

        res.json({
            message: 'Connexion réussie',
            token: token,
            user: {
                id: user._id,
                nom: user.nom,
                email: user.email
            }
        });
    } catch (e) {
        res.status(500).json({ error : e.message})
    }
});

// Récuperer Tous les Users
router.get('/allUser', async function(req, res) {
    try {
        const users = await User.find();
        res.json(users);
    } catch(e) {
        res.status(500).json({error : e.message})
    }
});

module.exports = router