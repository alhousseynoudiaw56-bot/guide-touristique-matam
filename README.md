# 🗺️ Guide Touristique - Matam

Application mobile Flutter présentant les principaux sites touristiques de la région de **Matam** (Sénégal), développée dans le cadre d'une formation au développement mobile.

## 📱 Description

Guide Touristique - Matam permet aux utilisateurs de découvrir et explorer les sites touristiques de la région de Matam : sites naturels, villages artisanaux, patrimoine culturel et historique. L'application propose une authentification utilisateur, la recherche et le filtrage des sites par catégorie, ainsi qu'un système de favoris personnalisé.

## ✨ Fonctionnalités

- **Authentification** : inscription et connexion par email/mot de passe (Firebase Authentication)
- **Liste des sites touristiques** : affichage en temps réel depuis Cloud Firestore
- **Détail d'un site** : image, description complète, catégorie, coordonnées GPS
- **Recherche** : recherche instantanée par nom de site
- **Filtrage par catégorie** : Nature, Artisanat, Patrimoine, Culture
- **Favoris** : ajout/suppression de sites favoris, propre à chaque utilisateur, avec vue dédiée
- **Déconnexion** sécurisée

## 🛠️ Technologies utilisées

| Catégorie | Technologie |
|---|---|
| Framework | Flutter (Dart) |
| Authentification | Firebase Authentication |
| Base de données | Cloud Firestore |
| Gestion de version | Git & GitHub |
| Images | URLs externes (Pexels) |

## 📂 Structure du projet
lib/
├── main.dart                    # Point d'entrée, initialisation Firebase, gestion de l'état de connexion
├── firebase_options.dart        # Configuration Firebase générée par FlutterFire CLI
├── models/
│   └── site.dart                # Modèle de données d'un site touristique
├── screens/
│   ├── login_screen.dart        # Écran de connexion / inscription
│   ├── home_screen.dart         # Liste des sites (recherche, filtres, favoris)
│   └── site_detail_screen.dart  # Détail complet d'un site
└── services/
├── auth_service.dart        # Gestion de l'authentification Firebase
└── firestore_service.dart   # Accès aux données Firestore (sites et favoris)

## 🚀 Installation et lancement

### Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé
- Un compte Firebase avec un projet configuré
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) installé

### Étapes

1. Cloner le dépôt
```bash
git clone https://github.com/alhousseynoudiaw56-bot/guide-touristique-matam.git
cd guide-touristique-matam
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Configurer Firebase (si vous utilisez votre propre projet Firebase)
```bash
flutterfire configure
```

4. Lancer l'application
```bash
flutter run
```

## 🗄️ Modèle de données (Firestore)

**Collection `sites`**

| Champ | Type | Description |
|---|---|---|
| nom | string | Nom du site touristique |
| description | string | Description détaillée |
| categorie | string | Nature / Artisanat / Patrimoine / Culture |
| imageUrl | string | URL de l'image du site |
| latitude | double | Coordonnée GPS |
| longitude | double | Coordonnée GPS |

**Collection `favoris`**

| Champ | Type | Description |
|---|---|---|
| siteIds | array | Liste des ID de sites favoris de l'utilisateur (document identifié par l'UID utilisateur) |

## 👤 Auteur

Projet réalisé par **Alhousseynou Diaw** dans le cadre d'une formation au développement mobile Flutter/Firebase.

## 📄 Licence

Projet académique — usage éducatif.