const mongoose = require('mongoose')

const uri = "mongodb+srv://DevNodeJs:zAF6HYNX1wshtJiZ@cluster0.k9dsvbk.mongodb.net/?appName=Cluster0";

async function seConnecter() {
    try {
        await mongoose.connect(uri);
        console.log('Connecté à MongoDB Atlas');
        
        await mongoose.connection.close();
        console.log("Connexion fermé");
        
    } catch(erreur) {
        console.error("Erreur de connexion : ", erreur.message);
    }
}

seConnecter()