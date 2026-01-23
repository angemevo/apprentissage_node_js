import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/services/api_service.dart';

class NoteProvider with ChangeNotifier {
  final _api = ApiService();
  
  List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get erromessage => _errorMessage;

  /// Récupérer toutes les notes
  Future<void> fetchNote() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await _api.getNotes();
      _isLoading = false; 
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    } 
  } 

  /// Créer une note
  Future<bool> createNote({
    required String titre,
    required String contenu
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final note = await _api.createNote(
        titre: titre, 
        contenu: contenu
      );

      _notes.insert(0, note);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      
      return false;
    }
  }

  /// Modifier Note
  Future<bool> updatedNote({
    required String id,
    String? titre,
    String? contenu,
    bool? complete
  }) async {
    try {
      final updatedNote = await _api.updateNote(
        id: id,
        titre: titre,
        contenu: contenu,
        complete: complete,
      );

      final index = _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = updatedNote;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      
      return false;
    }
  }

  /// Supprimer une note 
  Future<bool> deletedNote({required String id}) async {
    try {
      await _api.delateNote(id);

      _notes.removeWhere((note) => note.id == id);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      
      return false;
    }
  }

  /// Effacer les erreurs
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}