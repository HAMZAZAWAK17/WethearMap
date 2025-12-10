# 🌤️ Application Météo Flutter

Une magnifique application météo avec Google Maps et OpenWeatherMap API.

## ✨ Fonctionnalités

- 🏠 **Page d'accueil élégante** avec animations
- 🗺️ **Carte Google Maps interactive** pour explorer le monde
- 🔍 **Recherche de ville** avec suggestions rapides
- 📅 **Prévisions météo** sur 3 jours (aujourd'hui, demain, après-demain)
- 🎨 **Interface utilisateur premium** avec gradients dynamiques
- 🌡️ **Détails complets** : température, humidité, pression, vent
- 🎭 **Icônes météo** adaptées à chaque condition
- 🎬 **Animations fluides** et transitions élégantes

## 🚀 Installation

### 1. Prérequis

- Flutter SDK (version 3.9.2 ou supérieure)
- Android Studio ou VS Code
- Compte Google Cloud Platform (pour Google Maps)
- Compte OpenWeatherMap (pour les données météo)

### 2. Clés API

#### OpenWeatherMap API

1. Créez un compte sur [OpenWeatherMap](https://openweathermap.org/api)
2. Obtenez votre clé API gratuite
3. Ouvrez `lib/services/weather_service.dart`
4. Remplacez `YOUR_OPENWEATHER_API_KEY` par votre clé :

```dart
static const String apiKey = 'VOTRE_CLE_API_ICI';
```

#### Google Maps API

**Pour Android :**

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créez un nouveau projet ou sélectionnez un projet existant
3. Activez l'API "Maps SDK for Android"
4. Créez des identifiants (clé API)
5. Ouvrez `android/app/src/main/AndroidManifest.xml`
6. Ajoutez votre clé API dans la section `<application>` :

```xml
<manifest ...>
    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="VOTRE_CLE_GOOGLE_MAPS_ICI"/>
        ...
    </application>
</manifest>
```

**Pour iOS :**

1. Activez l'API "Maps SDK for iOS" dans Google Cloud Console
2. Ouvrez `ios/Runner/AppDelegate.swift`
3. Ajoutez votre clé API :

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("VOTRE_CLE_GOOGLE_MAPS_ICI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 3. Installation des dépendances

```bash
flutter pub get
```

### 4. Permissions Android

Les permissions nécessaires sont déjà configurées dans `android/app/src/main/AndroidManifest.xml` :

- Internet
- Localisation (fine et coarse)
- Accès à l'état du réseau

### 5. Lancement de l'application

```bash
flutter run
```

## 📱 Utilisation

### 🏠 Page d'accueil
- Appuyez sur "Commencer" pour accéder à la carte interactive

### 🗺️ Page Carte - 3 façons de trouver une ville

#### 1. **Recherche par nom** 🔍
- Tapez le nom de n'importe quelle ville dans le monde
- Appuyez sur Entrée ou cliquez sur la flèche
- La carte se déplace automatiquement vers la ville
- Un marqueur est placé sur la ville

**Exemples :** Paris, New York, Tokyo, London, Dubai, Sydney, etc.

#### 2. **Clic sur la carte** 🖱️
- **NOUVEAU !** Cliquez n'importe où sur la carte
- L'application trouve automatiquement le nom de la ville (géocodage inverse)
- Un marqueur est placé à cet endroit
- Le nom de la ville apparaît dans la barre de recherche
- Parfait pour explorer et découvrir de nouvelles villes !

#### 3. **Boutons de villes rapides** ⚡
- Cliquez sur un bouton (Paris, Lyon, Marseille, Nice, Bordeaux)
- Accès instantané aux villes françaises populaires

### 🌤️ Voir la météo
- Cliquez sur n'importe quel marqueur sur la carte
- L'application navigue vers la page météo de cette ville
- Consultez la météo actuelle avec tous les détails
- Faites défiler pour voir les prévisions sur 3 jours
- Utilisez le bouton de rafraîchissement pour actualiser

📖 **Pour plus de détails**, consultez le [Guide d'utilisation de la carte](MAP_USAGE_GUIDE.md)

## 🎨 Personnalisation

### Modifier les villes rapides

Modifiez `lib/screens/map_page.dart` dans la fonction `_buildQuickCities` :

```dart
final cities = ['Paris', 'Lyon', 'Marseille', 'Nice', 'Bordeaux'];
// Ajoutez vos villes préférées ici
```

**Note :** Grâce au géocodage Google Maps, vous n'avez plus besoin de définir manuellement les coordonnées. Le service trouve automatiquement n'importe quelle ville dans le monde !

### Modifier les couleurs

Les gradients sont définis dans `lib/utils/weather_helper.dart` dans la fonction `getWeatherGradient`.

## 🛠️ Technologies utilisées

- **Flutter** : Framework UI
- **Google Maps Flutter** : Carte interactive
- **HTTP** : Appels API
- **Font Awesome Flutter** : Icônes
- **Animated Text Kit** : Animations de texte
- **Shimmer** : Effet de chargement
- **Geolocator** : Géolocalisation
- **Geocoding** : Conversion adresse/coordonnées

## 📝 Structure du projet

```
lib/
├── main.dart                 # Point d'entrée
├── models/
│   └── weather_model.dart    # Modèles de données
├── screens/
│   ├── home_page.dart        # Page d'accueil
│   ├── map_page.dart         # Page carte
│   └── weather_page.dart     # Page météo
├── services/
│   ├── weather_service.dart  # Service API météo
│   └── geocoding_service.dart # Service géocodage Google Maps
├── utils/
│   ├── weather_helper.dart   # Fonctions utilitaires
│   └── color_helper.dart     # Couleurs et gradients
└── widgets/
    ├── weather_card.dart     # Carte de prévision
    └── weather_detail_item.dart # Détail météo
```

## 🐛 Dépannage

### Erreur "Ville non trouvée"

- Vérifiez l'orthographe de la ville
- Ajoutez la ville dans la liste prédéfinie (voir Personnalisation)

### Erreur API

- Vérifiez que votre clé OpenWeatherMap est valide
- Assurez-vous d'avoir une connexion Internet
- Attendez quelques minutes si vous venez de créer la clé

### Google Maps ne s'affiche pas

- Vérifiez que la clé API est correctement configurée
- Assurez-vous que l'API Maps SDK est activée
- Vérifiez les restrictions de la clé API

## 📄 Licence

Ce projet est sous licence MIT.

## 👨‍💻 Auteur

Créé avec ❤️ pour démontrer les capacités de Flutter

---

**Note** : N'oubliez pas de remplacer les clés API par vos propres clés avant de lancer l'application !
