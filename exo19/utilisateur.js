let user = {
    nom : "Jean Dupont",
    age : 25,
    email : "jean@example.com",
    sePresenter() {
        return "Je m'appelle " + this.nom + ", j'ai " + this.age + " ans"
    } 
}

module.exports = user