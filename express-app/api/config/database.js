const mongoose = require('mongoose')

const connectDB = async function() {
    try {
        const uri = "mongodb+srv://DevNodeJs:zAF6HYNX1wshtJiZ@cluster0.k9dsvbk.mongodb.net/?appName=Cluster0";

        await mongoose.connect(uri);
        console.log('Connecté à MongoDB');
        
    } catch(erreur) {
        console.error("Erreur de connexion : ", erreur.message);
        process.exit(1)
    }
};

module.exports = connectDB;