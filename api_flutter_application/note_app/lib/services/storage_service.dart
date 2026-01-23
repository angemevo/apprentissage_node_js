import 'package:note_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // singleton Pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  // Initialiser SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Sauvegarder le token
  Future<void> saveToken(String token) async {
    await _prefs?.setString(StorageKeys.token, token);
  }

  // Récupérer le token
  String? getToken()  {
    return _prefs?.getString(StorageKeys.token);
  }

  // Sauvegarder les données utilisateur
  Future<void> saveUserInfos(String id, String email, String nom) async {
    await _prefs?.setString(StorageKeys.userId, id);
    await _prefs?.setString(StorageKeys.userEmail, email);
    await _prefs?.setString(StorageKeys.userName, nom);
  }

  // Récupérer les donées utilisateurs
  Map<String, String?> getUserInfos() {
    return {
      'id': _prefs?.getString(StorageKeys.userId),
      'nom': _prefs?.getString(StorageKeys.userName),
      'email': _prefs?.getString(StorageKeys.userEmail),
    };
  }

  // Effacer toute les données (logout)
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Vérifier si l'utilisateur est connecté 
  bool isLoggedIn() {
    return getToken() != null;
  }
}