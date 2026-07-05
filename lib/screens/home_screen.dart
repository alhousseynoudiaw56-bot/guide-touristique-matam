import 'package:flutter/material.dart';
import '../models/site.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'site_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Touristique - Matam'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<Site>>(
        stream: firestoreService.getSites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final sites = snapshot.data ?? [];
          if (sites.isEmpty) {
            return const Center(
              child: Text('Aucun site pour le moment.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiteDetailScreen(site: site),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange.shade100,
                    child: const Icon(Icons.place, color: Colors.deepOrange),
                  ),
                  title: Text(
                    site.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(site.categorie,
                          style: TextStyle(color: Colors.deepOrange.shade700)),
                      const SizedBox(height: 4),
                      Text(site.description),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}