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
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Toutes';
  bool _showFavoritesOnly = false;

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
    final userId = _authService.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Touristique - Matam'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: _showFavoritesOnly ? Colors.red : null,
            ),
            tooltip: 'Voir mes favoris',
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () => _authService.signOut(),
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
          // Filtres par catégorie
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
          if (_showFavoritesOnly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: const Icon(Icons.favorite, color: Colors.red, size: 18),
                  label: const Text('Affichage : Favoris uniquement'),
                  onDeleted: () => setState(() => _showFavoritesOnly = false),
                ),
              ),
            ),
          const SizedBox(height: 4),
          // Liste des sites
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _firestoreService.getFavoriteIds(userId),
              builder: (context, favSnapshot) {
                final favoriteIds = favSnapshot.data ?? [];

                return StreamBuilder<List<Site>>(
                  stream: _firestoreService.getSites(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur : ${snapshot.error}'));
                    }

                    var sites = snapshot.data ?? [];

                    if (_selectedCategory != 'Toutes') {
                      sites = sites
                          .where((site) => site.categorie == _selectedCategory)
                          .toList();
                    }

                    if (_searchQuery.isNotEmpty) {
                      sites = sites
                          .where((site) =>
                              site.nom.toLowerCase().contains(_searchQuery))
                          .toList();
                    }

                    if (_showFavoritesOnly) {
                      sites = sites
                          .where((site) => favoriteIds.contains(site.id))
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
                        final isFavorite = favoriteIds.contains(site.id);

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
                              child: const Icon(Icons.place,
                                  color: Colors.deepOrange),
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
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                _firestoreService.toggleFavorite(
                                    userId, site.id, isFavorite);
                              },
                            ),
                          ),
                        );
                      },
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