# 🗺️ Google Maps Integration

## Configuration

La clé API Google Maps a été configurée dans l'application :

### Clé API
```
AIzaSyDpzM3RwHngFx6Js3qpFEACTT3urCgsEcQ
```

### Fichiers configurés

1. **Android** : `android/app/src/main/AndroidManifest.xml`
   - La clé API est configurée dans les métadonnées de l'application

2. **iOS** : `ios/Runner/AppDelegate.swift`
   - La clé API est initialisée au démarrage de l'application

3. **Service de géocodage** : `lib/services/geocoding_service.dart`
   - Service pour convertir les noms de villes en coordonnées GPS
   - Service pour convertir les coordonnées GPS en noms de villes

## Fonctionnalités

### 1. Recherche de ville
- Tapez n'importe quel nom de ville dans la barre de recherche
- L'API Google Maps Geocoding trouvera automatiquement les coordonnées
- La carte se déplacera vers la ville recherchée
- Un marqueur sera placé sur la ville

### 2. Villes rapides
- Boutons de raccourci pour les villes françaises populaires :
  - Paris
  - Lyon
  - Marseille
  - Nice
  - Bordeaux

### 3. Affichage de la météo
- Cliquez sur un marqueur pour voir la météo de cette ville
- Navigation automatique vers la page météo

## APIs utilisées

### Google Maps SDK
- **Android** : Maps SDK for Android
- **iOS** : Maps SDK for iOS
- Affichage de la carte interactive

### Google Geocoding API
- Conversion nom de ville → coordonnées GPS
- Conversion coordonnées GPS → nom de ville
- Recherche de n'importe quelle ville dans le monde

## Permissions

### Android
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS
Les permissions de localisation sont gérées automatiquement par le SDK.

## Utilisation

1. **Lancer l'application**
2. **Naviguer vers la page Map**
3. **Rechercher une ville** :
   - Tapez le nom dans la barre de recherche
   - Ou cliquez sur un bouton de ville rapide
4. **Voir la météo** :
   - Cliquez sur le marqueur
   - L'application navigue vers la page météo

## Limitations

- La clé API doit avoir les APIs suivantes activées :
  - Maps SDK for Android
  - Maps SDK for iOS
  - Geocoding API
  
- Pour la production, ajoutez des restrictions à votre clé API :
  - Restrictions d'application (package Android, Bundle ID iOS)
  - Restrictions d'API (limitez aux APIs nécessaires)

## Sécurité

⚠️ **Important** : Pour la production, ne stockez jamais les clés API directement dans le code.

Utilisez plutôt :
- Variables d'environnement
- Fichiers de configuration non versionnés
- Services de gestion de secrets (Firebase Remote Config, etc.)
