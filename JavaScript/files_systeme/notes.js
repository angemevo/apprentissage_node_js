const {v4 : uuidv4} = require("uuid");
const fs = require('fs').promises;

async function ajouterNote(titre, contenu) {
    let notes = [];

    try {

        try {
            const data = await fs.readFile("notes.json", "utf8");
            notes = JSON.parse(data);
        }catch (e) {
            notes = []
        }

        const note = {
            id : uuidv4(),
            titre,
            contenu,
            date : new Date().toISOString()
        }

        notes.push(note);

        await fs.writeFile(
            "notes.json",
            JSON.stringify(notes, null, 2)
        ); 

        console.log("Nouvelle note ajoutée");
        
    } catch (e) {
        console.log("Erreur : " + e.message);
    }
}


async function listerNotes() {
    try {
        const contenu = await fs.readFile("notes.json", 'utf8');
        const notes = JSON.parse(contenu);

        if (notes.length === 0) {
            console.log("Aucune note.");
            return;
        }

        console.log("\n=== NOTES ===");
        notes.forEach((note, index) => {
            console.log(`\n[${index}] ${note.titre}`);
            console.log(`    ${note.contenu}`);
            console.log(`    Date: ${new Date(note.date).toLocaleString()}`);
        });
    } catch (e) {
        console.log("Erreur : " + e.message);
    }
}

async function supprimerNotes(index) {
    try {
        const data = await fs.readFile("notes.json", "utf8");
        const notes = JSON.parse(data);
        
        if (index < 0 || index >= notes.length) {
            console.log("Index invalide");
            return;
        }
        const suppressionNote = notes.splice(index, 1)[0];
        
        await fs.writeFile(
            "notes.json",
            JSON.stringify(notes, null, 2)
        )

        console.log("Notes supprimé : " + suppressionNote.titre);
        

    } catch (e) {
        console.log("Erreur : " + e.message);
        
    }
}

module.exports = {
    ajouterNote,
    listerNotes,
    supprimerNotes
}