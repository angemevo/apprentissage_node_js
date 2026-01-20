const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,  // ✓ CORRIGÉ : lowercase (tout minuscule)
        trim: true
    },

    password: {
        type: String,
        required: true,
        minlength: 6
    },

    nom: {
        type: String,
        required: true,
        trim: true
    }
}, {
    timestamps: true
});

// Hasher le mot de passe avant de le sauvegarder
userSchema.pre('save', async function() {  // ✓ CORRIGÉ : PAS de next en paramètre
    if (!this.isModified('password')) return;  // ✓ CORRIGÉ : Juste return (sans next)
    
    this.password = await bcrypt.hash(this.password, 10);
    // ✓ CORRIGÉ : PAS de next() à la fin
});

// Vérifier le mot de passe 
userSchema.methods.comparePassword = async function(candidatePassword) {
    return await bcrypt.compare(candidatePassword, this.password);
}; 

const User = mongoose.model('User', userSchema);
module.exports = User;