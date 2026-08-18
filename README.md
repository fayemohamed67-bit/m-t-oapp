# Météo en direct — Application Flutter

Application développée dans le cadre de l'examen de **Développement Mobile — L3 IAGE ISI 2026**.

L'application récupère la météo en temps réel de 5 villes (Dakar, Thiès,
Kaolack, Paris, Londres), affiche une jauge de progression animée pendant le
chargement, puis permet de consulter le détail de chaque ville sur une carte
interactive (OpenStreetMap).

## 👥 Membres du groupe

- Mohamed El Bachir Faye
- Younnoussa Bangoura

## ✨ Fonctionnalités

- Écran d'accueil avec message de bienvenue et bouton "Commencer".
- Jauge de progression circulaire animée, qui se remplit pendant les appels API.
- Récupération séquentielle de la météo de 5 villes via l'API OpenWeather (Retrofit + Dio).
- Messages d'attente dynamiques qui défilent pendant le chargement.
- Tableau interactif des 5 villes une fois le chargement terminé.
- Page de détail par ville : infos météo complètes + localisation exacte sur une carte OpenStreetMap.
- Gestion des erreurs réseau avec message clair et bouton "Réessayer".
- Mode clair et mode sombre (Material 3).
- La jauge se transforme en bouton "Recommencer" une fois remplie ; le bouton
  retour ramène à tout moment à l'écran d'accueil.

## 🏗️ Architecture du projet

```
lib/
├── main.dart                     # Point d'entrée, thème, chargement du .env
├── core/
│   ├── constants.dart            # Villes, messages, clé API
│   └── theme/app_theme.dart      # Thèmes clair / sombre
├── data/
│   ├── models/city_weather.dart  # Modèles (json_serializable)
│   ├── network/weather_api_client.dart  # Interface Retrofit
│   └── repository/weather_repository.dart # Appels API + gestion d'erreurs
├── providers/
│   ├── theme_provider.dart       # État du thème (Provider)
│   └── weather_provider.dart     # État de la jauge / des appels API
├── screens/
│   ├── home_screen.dart          # Écran d'accueil
│   ├── main_screen.dart          # Jauge + tableau des 5 villes
│   └── detail_screen.dart        # Détail météo + carte
└── widgets/
    ├── animated_gauge.dart       # Jauge animée -> bouton "Recommencer"
    ├── city_weather_tile.dart    # Ligne du tableau
    ├── error_view.dart           # Vue d'erreur + retry
    └── weather_icon.dart         # Pictogrammes météo
```

## 🚀 Installation et lancement

### 1. Prérequis

- Flutter SDK installé (`flutter doctor` sans erreur bloquante).
- Un compte [OpenWeather](https://openweathermap.org/api) (clé gratuite).
- Aucune clé n'est nécessaire pour la carte : elle utilise les tuiles
  [OpenStreetMap](https://www.openstreetmap.org/) via `flutter_map`, sans
  compte ni facturation à configurer.

### 2. Récupérer les dépendances

```bash
flutter pub get
```

### 3. Générer le code (Retrofit / json_serializable)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Configurer la clé météo

Copier `.env.example` en `.env` et coller ta clé OpenWeather :

```
OPENWEATHER_API_KEY=ta_cle_ici
```

⚠️ Le fichier `.env` ne doit **jamais** être commité (il est dans `.gitignore`).

### 5. Lancer l'application

```bash
flutter run
```

## 🔧 Stack technique

- **Flutter / Dart**
- **Provider** — gestion d'état
- **Dio + Retrofit** — appels API météo
- **json_serializable** — sérialisation des modèles
- **flutter_map + OpenStreetMap** — carte interactive (sans clé API)
- **flutter_dotenv** — gestion sécurisée de la clé API
