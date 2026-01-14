const os = require('os');
let memoire = os.totalmem() / 1024 / 1024 / 1024;
let memoireArroindie = memoire.toFixed(2);

console.log("Plateforme : " + os.platform());
console.log("Architecture : " + os.arch());
console.log("Nombre de CPUs : " + os.cpus().length);
console.log("Mémoire Total : " + memoireArroindie + " Go");
console.log("Utilisateur : " + os.userInfo().username);
