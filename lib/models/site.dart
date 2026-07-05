class Site {
  final String id;
  final String nom;
  final String description;
  final String categorie;
  final String imageUrl;
  final double? latitude;
  final double? longitude;

  Site({
    required this.id,
    required this.nom,
    required this.description,
    required this.categorie,
    required this.imageUrl,
    this.latitude,
    this.longitude,
  });

  // Convertit un document Firestore en objet Site
  factory Site.fromMap(String id, Map<String, dynamic> data) {
    return Site(
      id: id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      categorie: data['categorie'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  // Convertit un objet Site en Map pour l'envoyer à Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'categorie': categorie,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}