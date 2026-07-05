import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/site.dart';

class FirestoreService {
  final CollectionReference _sitesRef =
      FirebaseFirestore.instance.collection('sites');

  final CollectionReference _favorisRef =
      FirebaseFirestore.instance.collection('favoris');

  // Récupère la liste des sites en temps réel
  Stream<List<Site>> getSites() {
    return _sitesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Site.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Récupère en temps réel la liste des ID de sites favoris d'un utilisateur
  Stream<List<String>> getFavoriteIds(String userId) {
    return _favorisRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return <String>[];
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || data['siteIds'] == null) return <String>[];
      return List<String>.from(data['siteIds']);
    });
  }

  // Ajoute ou retire un site des favoris de l'utilisateur
  Future<void> toggleFavorite(String userId, String siteId, bool isCurrentlyFavorite) async {
    final docRef = _favorisRef.doc(userId);
    if (isCurrentlyFavorite) {
      await docRef.set({
        'siteIds': FieldValue.arrayRemove([siteId])
      }, SetOptions(merge: true));
    } else {
      await docRef.set({
        'siteIds': FieldValue.arrayUnion([siteId])
      }, SetOptions(merge: true));
    }
  }
}