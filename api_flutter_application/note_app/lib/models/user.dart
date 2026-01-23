class User {
  final String id;
  final String nom;
  final String email;

  User({
    required this.id, 
    required this.nom, 
    required this.email
  });

  // Convertir en Json -> User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      nom: json['nom'] ?? '',
      email: json['email'] ?? ''
    );
  }

  // Convertir User -> Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email
    };
  }
}