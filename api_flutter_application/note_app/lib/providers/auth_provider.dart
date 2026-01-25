import 'package:flutter/material.dart';
import 'package:note_app/models/user.dart';
import 'package:note_app/services/api_service.dart';
import 'package:note_app/services/storage_service.dart';

class AuthProvider with ChangeNotifier{
  final _api = ApiService();
  final _storage = StorageService();

  bool _isLoading = false;
  bool _isAuthenticated = false;
  User? _currentUser;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  // Vérifier si l'utilisateur est deja connecté (au demarage de l'appli)
  Future<void> checkAuthStatus() async {
    _isAuthenticated = _storage.isLoggedIn();

    if (_isAuthenticated) {
      final userInfos = _storage.getUserInfos();
      _currentUser = User(
        id: userInfos['id'] ?? '',
        nom: userInfos['nom'] ?? '',
        email: userInfos['email'] ?? '',
      );
    }

    notifyListeners();
  }

  /// Inscription
  Future<bool> register({
    required String email,
    required String password,
    required String nom
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('🟡 AuthProvider reçoit - email: $email, nom: $nom, password: $password, length: ${password.length}');

    try {
      final data = await _api.register(
        email: email, 
        nom: nom, 
        password: password
      );

      _currentUser = User.fromJson(data['user']);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  /// Connexion
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.login(
        email: email,
        password: password,
      );

      _currentUser = User.fromJson(data['user']);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      
      return false;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await _api.logout();

    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Effacer les erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


