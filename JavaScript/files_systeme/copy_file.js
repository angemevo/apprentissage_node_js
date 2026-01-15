const fs = require('fs').promises

async function copierFichier(source, destination) {
    try {
        // Lecture du fichier source
        const dataSource = await fs.readFile(source, "utf8");

        // Ecrire le contenu de la source dans le fichier de destination
        await fs.writeFile(destination, dataSource);

        console.log("✓ Copie réussie : " + source + " → " + destination);

    } catch (e) {
        console.log("Erreur : " + e.message);
    }
}

copierFichier("notes.json", "copie_notes.json")