import 'package:flutter/material.dart';
import '../models/site.dart';

class SiteDetailScreen extends StatelessWidget {
  final Site site;

  const SiteDetailScreen({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(site.nom),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du site
            Image.network(
              site.imageUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 180,
                color: Colors.deepOrange.shade50,
                child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge catégorie
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      site.categorie,
                      style: TextStyle(
                        color: Colors.deepOrange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nom du site
                  Text(
                    site.nom,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Description complète
                  Text(
                    site.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  // Coordonnées GPS si disponibles
                  if (site.latitude != null && site.longitude != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.deepOrange),
                        const SizedBox(width: 8),
                        Text(
                          '${site.latitude!.toStringAsFixed(4)}, ${site.longitude!.toStringAsFixed(4)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}