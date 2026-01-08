// function attendreEtAfficher(message, delai, callback) {
//     console.log("En attente...");

//     setTimeout(function() {
//         console.log(message);
//         callback();
//     }, delai);
// }

// console.log("=== DEBUT ===");

// attendreEtAfficher("Message après 1 seconde", 1000, function() {
//     console.log("Callback 1");
// });

// attendreEtAfficher("Message après 3 secondes", 3000, function() {
//     console.log("Callback 2");
// });

// console.log("=== FIN (s'affiche immédiatement) ===");


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

// simulerTelechargement("base_node.js", function(tailleFichier) {
//     console.log("le fichier fait " + tailleFichier + " Ko");
// })