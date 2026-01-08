function simulerTelechargement(fichier) {
    return new Promise(function(resolved, rejected) {
        console.log("Télélchargement de " + fichier + " en cours...");
        setTimeout(function() {
            let tailleFichier = Math.floor(Math.random() * 901) +100
            
            if (tailleFichier < 200) {
                rejected("Erreur le fichier est trop petit")
            } else {
                resolved(tailleFichier)
            }
        }, 2000) 

    })
}


simulerTelechargement("Sans_elle.mp4")
    .then(function(tailleFichier) {
        console.log("Téléchargement réussie : " + tailleFichier + " Ko")
    })
    .catch(function(erreur) {
        console.log(erreur)
    })

    

function lireEtTraiter() {
    return new Promise(function(resolve, reject) {
        console.log("Lecture en cours...");
        setTimeout(function() {
            let donnees = "Donnée du fichier";
            resolve(donnees);
        }, 2000)
    })
}

function sauvegarder() {
    return new Promise(function(resolve, reject) {
        console.log("Sauvegarde du fichier en cours...");

        setTimeout(function() {
            resolve("Données sauvegardées")
        }, 1000)
    })
}

lireEtTraiter()
    .then(function(donnees) {
        console.log("Lu : " + donnees);
        return sauvegarder(donnees);
    })
    .then(function(resultat) {
        console.log(resultat);
    })
    .catch(function(erreur) {
        console.log("Erreur : " + erreur);
    });