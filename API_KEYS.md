# 🔑 Configuration des clés API

## Instructions de configuration

### 1. OpenWeatherMap API

1. Créez un compte sur [OpenWeatherMap](https://openweathermap.org/api)
2. Obtenez votre clé API gratuite
3. Ouvrez `lib/services/weather_service.dart`
4. Remplacez `YOUR_OPENWEATHER_API_KEY` par votre clé :

```dart
static const String apiKey = 'VOTRE_CLE_API_ICI';
```

### 2. Google Maps API

**✅ Clé API configurée : AIzaSyDpzM3RwHngFx6Js3qpFEACTT3urCgsEcQ**

#### Pour Android :

1. ✅ Configuré dans `android/app/src/main/AndroidManifest.xml`
2. La clé API est déjà en place

#### Pour iOS :

1. ✅ Configuré dans `ios/Runner/AppDelegate.swift`
2. La clé API est déjà en place

## ⚠️ Important

- Ne partagez JAMAIS vos clés API publiquement
- Ajoutez des restrictions à vos clés API dans Google Cloud Console
- Pour la production, utilisez des variables d'environnement

## 🧪 Test

Pour tester sans clés API :
- L'application affichera une erreur pour la météo
- La carte Google Maps ne s'affichera pas correctement
- Utilisez les villes prédéfinies dans `map_page.dart`
