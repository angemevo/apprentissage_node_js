const http = require('http');
const { text } = require('stream/consumers');

const serveur = http.createServer(function(requete, reponse) {
    console.log("Requête reçue : " + requete.url);
    
    reponse.writeHead(200, { 'content-type' : 'text/plain'});
    reponse.end('Bonjour depuis node');
});

serveur.listen(3000, function() {
    console.log('Serveur démarré sur http://localhost:3000')
});