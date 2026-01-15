const fs = require("fs").promises;

async function countFileStats(filePath) {
  try {
    const content = await fs.readFile(filePath, "utf-8");

    const characters = content.length;

    const words = content
      .trim()
      .split(/\s+/)
      .filter(Boolean)
      .length;

    const lines = content === ""
      ? 0
      : content.split("\n").length;

    console.log("Statistiques du fichier :");
    console.log("Caractères :", characters);
    console.log("Mots :", words);
    console.log("Lignes :", lines);
  } catch (error) {
    console.log("Erreur :", error.message);
  }
}

countFileStats("copie_notes.json")