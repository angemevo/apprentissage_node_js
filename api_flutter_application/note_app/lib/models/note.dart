class Note {
  final String id;
  final String titre;
  final String contenu;
  final bool complete;
  final DateTime createdeAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.titre, 
    required this.contenu, 
    this.complete = false, 
    required this.createdeAt, 
    required this.updatedAt
  });

  // Convertir Json -> Note
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? json['_id'] ?? '',
      titre: json['titre'] ?? '', 
      contenu: json['contenu'] ?? '', 
      complete: json['complete'] ?? false,
      createdeAt: DateTime.parse(json['createdAt']), 
      updatedAt: DateTime.parse(json['updatedAt'])
    );
  }

  // Convertir Note -> Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'complete': complete,
      'createdeAt': createdeAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String()
    };
  }

  // Créer une copie avec modification
  Note copyWith({
    String? id,
    String? titre,
    String? contenu,
    bool? complete,
    DateTime? createdeAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id, 
      titre: titre ?? this.titre, 
      contenu: contenu ?? this.contenu, 
      complete: complete ?? this.complete,
      createdeAt: createdeAt ?? this.createdeAt, 
      updatedAt: updatedAt ?? this.updatedAt
    );
  }
}