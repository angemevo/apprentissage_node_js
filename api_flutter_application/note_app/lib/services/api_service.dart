import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:note_app/config/constants.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/services/storage_service.dart';
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _storage = StorageService();

  // =========================================
  // Authentification
  // =========================================

  /// Incription
  Future<Map<String, dynamic>> register ({
    required String email,
    required String nom,
    required String password
  }) async {
    try {
      print('🔵 URL: ${ApiConstants.baseUrl}${ApiConstants.register}');  // ✓ AJOUTÉ
      print('🔵 Body AVANT encode: email=$email, nom=$nom, password=$password, length=${password.length}');


      final bodyMap = {
        'email': email,
        'password': password,
        'nom': nom,
      };
      
      print('🔵 Body Map: $bodyMap');  // ✓ AJOUTÉ
      
      final encodedBody = json.encode(bodyMap);
      print('🔵 Body APRÈS encode: $encodedBody');  


      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email' : email,
          'password' : password,
          'nom' : nom
        })
      );

      
      print('🔵 Status Code: ${response.statusCode}');  // ✓ AJOUTÉ
      print('🔵 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        print('🟢 Token reçu: ${data['token']}');

        // Sauvegarder le token et les infos User
        await _storage.saveToken(data['token']);
        await _storage.saveUserInfos(
          data['user']['id'],
          data['user']['email'],
          data['user']['nom'],
        );

        final savedToken = _storage.getToken();
        print('🟢 Token sauvegardé: $savedToken');
        print('🟢 Tokens identiques? ${data['token'] == savedToken}');

        return data;
      } else {
        final error = json.decode(response.body);
        print('🔴 Erreur backend: ${error}'); 
        throw Exception(error[error] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      print('🔴 Exception complète: $e');
      throw Exception('Erreur de connexion : $e');
    }
  }


  /// Connexion
  Future<Map<String, dynamic>> login ({
    required String email,
    required String password
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {'Content-Type' : 'application/json'},
        body: json.encode({
          'email' : email,
          'password' : password,
        })
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Sauvegarder le token et les infos User
        await _storage.saveToken(data['token']);
        await _storage.saveUserInfos(
          data['user']['id'],
          data['user']['email'],
          data['user']['nom']
        );

        return data;
      } else {
        final error = json.decode(response.body);
        print('🔴 Erreur backend: ${error}'); 
        throw Exception(error[error] ?? 'Erreur lors de la connexion');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Deconnexion
  Future<void> logout() async{
    await _storage.clearAll();
  }

  // =========================================
  // Gestion des notes
  // =========================================

  /// Headers avec authentification  
  Map<String, String> _getAuthHeader() {
    final token = _storage.getToken();

    print('🔵 Token récupéré pour requête: $token');
    print('🔵 Token est null? ${token == null}');
  
    return {
      'Content-Type' : 'application/json',
      'Authorization' : 'Bearer $token',
    };
  } 

  // Récupérer toute les notes
  Future<List<Note>> getNotes() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notes}')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Note.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des notes');
      }
    } catch(e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Récupérer une note par id
  Future<Note> getNoteById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notes}/$id')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Note.fromJson(data);
      } else {
        throw Exception('Note non trouvée');
      }
    } catch(e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Créer une note 
  Future<Note> createNote({required String titre, required String contenu}) async {
    try {
      final headers = _getAuthHeader();
      print('🔵 Headers envoyés: $headers');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notes}'),
        headers: headers,
        body: json.encode(
          {
            'titre' : titre,
            'contenu': contenu
          }
        )
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('🔵 Response: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Note.fromJson(data);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erreur lors de la création');
      }
    } catch (e) {
      print('🔴 Erreur backend: ${e}'); 
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Modifier une Note
  Future<Note> updateNote({
    required String id,
    String? titre,
    String? contenu,
    bool? complete
  }) async {
    try {
      final body = <String, dynamic>{};
      if (titre != null) body['titre'] = titre;
      if (contenu != null) body['contenu'] = contenu;
      if (complete != null) body['complete'] = complete;

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notes}/$id'),
        headers: _getAuthHeader(),
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Note.fromJson(data);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erreur lors de la modification');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Supprimer une note
  Future<void> delateNote(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.notes}/$id'),
        headers: _getAuthHeader(),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erreur lors de la suppression');
      }
    }catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}