# Guide de Dépannage - Recherche de Ville

## 🔍 Problème : "Ville non trouvée"

Si vous obtenez le message "Ville non trouvée" lors de la recherche, suivez ces étapes :

### Étape 1 : Vérifier les Logs

Lorsque vous recherchez une ville, l'application affiche maintenant des logs détaillés dans la console. Cherchez ces symboles :

- 🔍 Recherche de ville
- 📡 URL de la requête
- 📊 Code de statut HTTP
- 📦 Statut de la réponse
- ✅ Ville trouvée (succès)
- ❌ Aucun résultat
- 🚫 Requête refusée
- ⚠️ Statut inattendu
- 💥 Erreur

### Étape 2 : Vérifier votre Clé API Google Maps

**Le problème le plus courant est une clé API non configurée correctement.**

#### Vérifications à faire :

1. **La clé API est-elle valide ?**
   - Allez sur [Google Cloud Console](https://console.cloud.google.com/)
   - Vérifiez que votre clé API existe et est active

2. **Les APIs sont-elles activées ?**
   Vous devez activer ces 3 APIs :
   - ✅ **Geocoding API** (pour la recherche de villes)
   - ✅ **Maps SDK for Android**
   - ✅ **Places API** (optionnel mais recommandé)

3. **Les restrictions sont-elles correctes ?**
   - Allez dans votre clé API
   - Section "Restrictions relatives aux applications"
   - Choisissez "Applications Android"
   - Ajoutez votre package name : `com.example.meteo_app`
   - Ajoutez votre empreinte SHA-1

#### Comment obtenir votre empreinte SHA-1 :

```bash
# Dans le terminal, exécutez :
cd android
./gradlew signingReport

# Sur Windows :
cd android
gradlew.bat signingReport
```

Cherchez la ligne qui commence par `SHA1:` dans la section `debug`.

### Étape 3 : Activer la Geocoding API

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Sélectionnez votre projet
3. Menu ☰ → APIs & Services → Library
4. Cherchez "Geocoding API"
5. Cliquez sur "ENABLE" (Activer)

### Étape 4 : Vérifier les Quotas

1. Dans Google Cloud Console
2. Menu ☰ → APIs & Services → Dashboard
3. Cliquez sur "Geocoding API"
4. Vérifiez que vous n'avez pas dépassé les quotas gratuits

**Quotas gratuits :**
- 40 000 requêtes par mois
- Après : 0,005 $ par requête

### Étape 5 : Tester avec des Villes Simples

Essayez d'abord avec des villes très connues :
- Paris
- London
- New York
- Tokyo
- Casablanca

Si ces villes ne fonctionnent pas, c'est définitivement un problème de clé API.

### Étape 6 : Vérifier la Connexion Internet

L'application a besoin d'Internet pour :
- Rechercher les villes (Geocoding API)
- Afficher la carte (Google Maps)
- Obtenir la météo (OpenWeatherMap API)

### Étape 7 : Messages d'Erreur Courants

#### "REQUEST_DENIED"
```
🚫 Requête refusée - Vérifiez votre clé API
```
**Solution :** Votre clé API n'est pas valide ou la Geocoding API n'est pas activée.

#### "ZERO_RESULTS"
```
❌ Aucun résultat pour: [nom de ville]
```
**Solution :** La ville n'existe pas ou le nom est mal orthographié. Essayez :
- Sans accents : "Casablanca" au lieu de "Càsablanca"
- Nom complet : "Marrakech, Morocco"
- En anglais : "Morocco" au lieu de "Maroc"

#### "OVER_QUERY_LIMIT"
```
⚠️ Statut inattendu: OVER_QUERY_LIMIT
```
**Solution :** Vous avez dépassé le quota gratuit. Attendez demain ou activez la facturation.

### Étape 8 : Solution Temporaire - Utiliser les Villes Rapides

En attendant de résoudre le problème, utilisez les boutons de villes rapides :
- Paris
- Lyon
- Marseille
- Nice
- Bordeaux

Ces villes sont pré-configurées et devraient fonctionner.

### Étape 9 : Vérifier le Code de la Clé API

Ouvrez le fichier : `lib/services/geocoding_service.dart`

Ligne 7 :
```dart
static const String apiKey = 'VOTRE_CLE_API_ICI';
```

**Vérifications :**
- ✅ La clé est entre guillemets simples
- ✅ Pas d'espaces avant ou après
- ✅ La clé fait environ 39 caractères
- ✅ Commence par "AIza"

### Étape 10 : Tester Manuellement l'API

Testez votre clé API directement dans le navigateur :

```
https://maps.googleapis.com/maps/api/geocode/json?address=Casablanca&key=VOTRE_CLE_API
```

Remplacez `VOTRE_CLE_API` par votre vraie clé.

**Réponse attendue :**
```json
{
  "results": [
    {
      "formatted_address": "Casablanca, Morocco",
      "geometry": {
        "location": {
          "lat": 33.5731104,
          "lng": -7.5898434
        }
      }
    }
  ],
  "status": "OK"
}
```

**Si vous voyez "REQUEST_DENIED" :**
- La Geocoding API n'est pas activée
- Ou votre clé API n'est pas valide

## 🆘 Besoin d'Aide ?

Si rien ne fonctionne, vérifiez les logs dans la console Flutter et partagez-les pour un diagnostic plus précis.

### Comment voir les logs :

1. L'application doit être lancée avec `flutter run`
2. Dans le terminal, vous verrez les messages avec les émojis
3. Cherchez les lignes qui commencent par 🔍 ou ❌

## ✅ Checklist Rapide

- [ ] Geocoding API activée dans Google Cloud Console
- [ ] Clé API valide et copiée dans `geocoding_service.dart`
- [ ] Connexion Internet active
- [ ] Nom de ville correct (essayez "Paris" pour tester)
- [ ] Pas de quota dépassé
- [ ] Application relancée après modification de la clé API

## 🎯 Solution Rapide

**Si vous voulez juste tester l'application rapidement :**

1. Utilisez les boutons de villes rapides (Paris, Lyon, etc.)
2. Ou cliquez sur le bouton de localisation GPS 🎯
3. Ou cliquez directement sur la carte

Ces méthodes contournent la recherche textuelle et devraient fonctionner même si la Geocoding API a un problème.
