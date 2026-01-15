const fs = require('fs').promises

async function lireFichier() {
    try {
        const contenu = await fs.readFile('data.txt', 'utf8');
        console.log(contenu);
    } catch (e) {
        console.log("Erreur : " + e.message);
    }
}

lireFichier()

// async function ecrireFichier() {
//     try {
//         await fs.writeFile('Output.txt', 'Bonjour depuis Node !');
//         console.log("Le fichier à été créer avec succès !")
//     } catch (e) {
//         console.log("Erreur : " + e.message);
        
//     }
// }

// ecrireFichier();

async function ajouterContenu() {
    try {
        await fs.appendFile('Output.txt', '\nNouvelle ligne ajouté !');
        console.log("Contenu ajouté !")
    } catch (e) {
        console.log("Erreur : " + e.message);
        
    }
}

ajouterContenu();