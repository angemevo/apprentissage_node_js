import 'dart:convert'; 
import 'package:http/http.dart' as http;
class ApiService {
  final String baseUrl = 'http://localhost:3000/api';

  // Récupérer toute les notes
  Future<List<dynamic>> getNotes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes')
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur de chargement');
    }
  }

  // Créer une note 
  Future<Map<String, dynamic>> createNote(String titre, String contenu) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type' : 'application/json'},
      body: json.encode(
        {
          'titre' : titre,
          'contenu': contenu
        }
      )
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur de création');
    }
  }

  // Supprimer une note
  Future<void> delateNote(String id) async {
    await http.delete(
      Uri.parse('$baseUrl/notes/$id')
    );
  }
}