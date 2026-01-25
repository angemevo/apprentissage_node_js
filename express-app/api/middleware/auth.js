const jwt = require('jsonwebtoken');

const JWT_SECRET = 'votre_secret_super_securise_changez_moi_123';

const authMiddleware = function(req, res, next) {
    try {
        console.log('🟣 Middleware auth appelé');
        console.log('🟣 Headers reçus:', req.headers);
        console.log('🟣 Authorization header:', req.header('Authorization'));
        
        // Récupérer le token du header
        const token = req.header('Authorization')?.replace('Bearer ', '');
        
        console.log('🟣 Token extrait:', token);
        console.log('🟣 Token length:', token ? token.length : 0);
        
        if (!token) {
            console.log('🔴 Pas de token !');
            return res.status(401).json({ error: 'Authentification requise' });
        }

        // Vérifier le token
        console.log('🟣 Tentative de vérification avec secret:', JWT_SECRET);
        const decoded = jwt.verify(token, JWT_SECRET);
        console.log('🟣 Token décodé:', decoded);
        
        req.userId = decoded.userId;

        next();
        
    } catch (error) {
        console.log('🔴 Erreur vérification token:', error.message);
        return res.status(401).json({ error: 'Token invalide' });
    }
};

module.exports = authMiddleware;