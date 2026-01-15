const notes = [12, 20, 15, 17, 18]

for (let note of notes) {
    console.log(note);
}

function calculMoyenne(tableauNote) {
    let somme = 0;

    for(let note of tableauNote) {
        somme += note
    }
    
    const moyenne = somme / tableauNote.length;
    return moyenne;
}

function trouverMax(tableauNote) {
    let nombreMax = tableauNote[0];

    for(let i = 0; i < tableauNote.length; i++) {
        if(tableauNote[i] > nombreMax) {
            nombreMax = tableauNote[i]
        } 
    }

    return nombreMax
}

calculMoyenne(notes)

trouverMax(notes)
