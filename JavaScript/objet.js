let livre = {
    titre : "Node.js pour débutants",
    auteur : "John Doe",
    pages : 350,
    estLu : false,
}

for(let infosLivre in livre) {
    console.log(infosLivre + ": " + livre[infosLivre])
}

let compte = {
    solde : 1000,
    deposer(montant) {
        return this.solde += montant
    },
    retirer(montant) {
        return this.solde -= montant
    },
    afficherSolde() {
        console.log("le solde est de : " + this.solde);
        
    }
}

compte.deposer(500);
compte.afficherSolde(); 
compte.retirer(200);
compte.afficherSolde(); 

let etudiants = [
    {
        nom : "Mevo",
        prenom : "Ange-Gaël",
        notes : [18, 20, 16],
    },
    
    {
        nom : "Keke",
        prenom : "Axelle Rameaux",
        notes : [17, 15, 16],
    },

    {
        nom : "Seka",
        prenom : "Amanda Ruth",
        notes : [18, 14,13],
    }
]

function calculerMoyenne(notes) {
    let somme = 0;

    for(let note of notes) {
        somme += note;
    }
    return somme / notes.length
}


function afficherEtudiants(tableauEtudiants) {
    for(let etudiant of tableauEtudiants) {
        let moyenne = calculerMoyenne(etudiant.notes)
        // affichage du nom complet et de la moyenne 
        console.log("Nom complet : " + etudiant.nom + " " + etudiant.prenom + " / " + "Moyenne : " + moyenne + "/20");
    }
}

afficherEtudiants(etudiants)