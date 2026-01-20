const jwt = require('jsonwebtoken');

const JWT_SECRET = 'votre_secret_super_securise_changez_moi_123';  

const authMiddleware = function(req, res, next) {
    try {
        // Récupérer le token du header
        const token = req.header('Authorization')?.replace('Bearer ', '');
        
        if (!token) {
            return res.status(401).json({ error: 'Authentification requise' });  // ✓ 401
        }

        // Vérifier le token
        const decoded = jwt.verify(token, JWT_SECRET);
        req.userId = decoded.userId;

        next();  // Continuer vers la route
        
    } catch (e) {
        return res.status(401).json({ error: 'Token invalide' });  // ✓ 401
    }
};

module.exports = authMiddleware;