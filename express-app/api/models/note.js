const mongoose = require('mongoose')

const noteSchemas = new mongoose.Schema({
    titre: {
        type: String, 
        required : true,
        trim: true
    }, 
    
    contenu: {
        type: String,
        required: true,
        trim: true
    },

    complete: {
        type: Boolean,
        default: false
    },

}, {
    timestamps: true
});

const Note = mongoose.model('Note', noteSchemas);
module.exports = Note;