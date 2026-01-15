const notes = require('./notes');

async function test() {
    await notes.ajouterNote("Course", "Acheter du pain");
    await notes.ajouterNote("Travail", "Finir le projet Node.js");
    await notes.supprimerNotes(0);
    await notes.listerNotes();
}

test()