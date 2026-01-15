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

async function executer() {
    try {
        let donnees = await lireEtTraiter();
        console.log("Lu " + donnees);

        let resultat = await sauvegarder();
        console.log(resultat);
        
    } catch (erreur) {
        console.log("Erreur : " + erreur);
    }
}

executer()

/// =======================================================================================================

function simulerTelechargement(fichier) {
    return new Promise((resolve, reject) => {
        console.log("Téléchargement de " + fichier + " en cours...");
        setTimeout(() => {
            let tailleFichier = Math.floor(Math.random() * 901) + 100;

            if (tailleFichier < 200) {
                reject("La taille du fichier est trop petit!") 
            } else {
                resolve(tailleFichier);
            }
        }, 2000)
    })
}

async function telechargerTout() {
    try {
        let taille1 = await simulerTelechargement("fichier1.txt");
        console.log("Taille fichier1 : " + taille1 + " Ko"); 

        let taille2 = await simulerTelechargement("fichier2.txt");
        console.log("Taille fichier2 : " + taille2 + " Ko"); 

        console.log("Tout à été télécharger");
    } catch (e) {
        console.log("Erreur : " + e);
    }
}

telechargerTout()