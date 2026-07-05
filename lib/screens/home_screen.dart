import 'package:flutter/material.dart';
import '../models/site.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'site_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Toutes';

  final List<String> _categories = [
    'Toutes',
    'Nature',
    'Artisanat',
    'Patrimoine',
    'Culture',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un site...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.deepOrange.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Filtres par catégorie (chips horizontaux)
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Liste des sites filtrés
          Expanded(
            child: StreamBuilder<List<Site>>(
              stream: _firestoreService.getSites(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }

                var sites = snapshot.data ?? [];

                // Filtre par catégorie
                if (_selectedCategory != 'Toutes') {
                  sites = sites
                      .where((site) => site.categorie == _selectedCategory)
                      .toList();
                }

                // Filtre par texte recherché (dans le nom)
                if (_searchQuery.isNotEmpty) {
                  sites = sites
                      .where((site) =>
                          site.nom.toLowerCase().contains(_searchQuery))
                      .toList();
                }

                if (sites.isEmpty) {
                  return const Center(
                    child: Text('Aucun site ne correspond à votre recherche.'),
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
                              builder: (context) =>
                                  SiteDetailScreen(site: site),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrange.shade100,
                          child:
                              const Icon(Icons.place, color: Colors.deepOrange),
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
                                style: TextStyle(
                                    color: Colors.deepOrange.shade700)),
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
          ),
        ],
      ),
    );
  }
}