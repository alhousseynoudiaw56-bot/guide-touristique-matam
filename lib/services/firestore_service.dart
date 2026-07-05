import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/site.dart';

class FirestoreService {
  final CollectionReference _sitesRef =
      FirebaseFirestore.instance.collection('sites');

  // Récupère la liste des sites en temps réel
  Stream<List<Site>> getSites() {
    return _sitesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Site.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}