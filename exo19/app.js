const user = require('./utilisateur.js');

Object.entries(user).forEach(([cle, valeur]) => {
    console.log(`${cle} : ${user[cle]}`);
});

console.log(user.sePresenter())

