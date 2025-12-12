# 🎯 Guide des Boutons et Navigation

## Page d'Accueil (HomePage)

### Boutons Disponibles

#### 1. 📍 Bouton de Localisation (En haut à gauche)
- **Icône**: Cible de localisation (crosshairs)
- **Fonction**: Détecte automatiquement votre position GPS
- **Action**: 
  - Cliquez pour détecter votre localisation
  - L'app affichera un indicateur de chargement
  - Vous serez redirigé vers la page météo de votre ville
- **Note**: Nécessite l'autorisation de localisation

#### 2. ⚙️ Bouton Paramètres (En haut à droite)
- **Icône**: Engrenage
- **Fonction**: Ouvre la page des paramètres
- **Action**: Cliquez pour accéder aux paramètres où vous pouvez :
  - Activer/désactiver le mode sombre
  - Gérer la localisation automatique
  - Voir vos villes favorites
  - Consulter l'historique de recherche
  - Effacer l'historique

#### 3. 🚀 Bouton "Commencer" (Au centre)
- **Fonction**: Ouvre la page de la carte
- **Action**: Cliquez pour accéder à la carte interactive
- **Note**: Visible uniquement si la détection automatique est désactivée ou échoue

### Fonctionnalités Automatiques

- **Détection Auto au Démarrage**: 
  - Si activée dans les paramètres (par défaut: OUI)
  - L'app détecte automatiquement votre position après 2 secondes
  - Vous êtes redirigé directement vers la météo de votre ville

---

## Page de la Carte (MapPage)

### Boutons Disponibles

#### 1. ← Bouton Retour (En haut à gauche)
- **Fonction**: Retour à la page d'accueil
- **Action**: Cliquez pour revenir en arrière

#### 2. 🔍 Barre de Recherche (En haut)
- **Fonction**: Rechercher une ville
- **Actions disponibles**:
  - **Icône Météo (☀️)**: Recherche et affiche directement la météo
  - **Icône Flèche (→)**: Recherche et centre la carte sur la ville

#### 3. 📍 Bouton Ma Position (À droite, en haut)
- **Icône**: Cible de localisation
- **Fonction**: Détecte votre position GPS
- **Action**:
  - Cliquez pour détecter votre localisation
  - La carte se centre sur votre position
  - Un marqueur est ajouté
  - La météo s'affiche automatiquement après 800ms

#### 4. 🗺️ Boutons Type de Carte (À droite, en bas)
- **Normal**: Vue carte standard
- **Satellite**: Vue satellite
- **Terrain**: Vue relief
- **Hybride**: Satellite + noms de lieux

### Villes Rapides
- **Fonction**: Accès rapide à des villes populaires
- **Villes**: Paris, Lyon, Marseille, Nice, Bordeaux
- **Action**: Cliquez sur une ville pour la rechercher

---

## Page Météo (WeatherPage)

### Boutons Disponibles

#### 1. ← Bouton Retour (En haut à gauche)
- **Fonction**: Retour à la page précédente

#### 2. ⭐ Bouton Favoris (En haut à droite)
- **Icône**: Étoile (vide ou pleine)
- **Fonction**: Ajouter/retirer des favoris
- **États**:
  - ☆ Étoile vide = Pas en favoris
  - ★ Étoile jaune = En favoris
- **Action**: Cliquez pour basculer

#### 3. 📤 Bouton Partage (En haut à droite)
- **Icône**: Icône de partage
- **Fonction**: Partager la météo
- **Action**: Cliquez pour ouvrir le menu de partage

#### 4. 🔄 Bouton Actualiser (En haut à droite)
- **Icône**: Flèches circulaires
- **Fonction**: Recharger les données météo
- **Action**: Cliquez pour actualiser

---

## Page Paramètres (SettingsPage)

### Sections Disponibles

#### 1. 🎨 Apparence
- **Mode Sombre**: Basculer entre thème clair et sombre

#### 2. 📍 Localisation
- **Localisation Automatique**: 
  - Activé: Détection auto au démarrage
  - Désactivé: Pas de détection auto

#### 3. ⭐ Villes Favorites
- **Liste**: Toutes vos villes favorites
- **Action**: Cliquez sur 🗑️ pour supprimer

#### 4. 📜 Historique
- **Liste**: Les 5 dernières recherches
- **Bouton**: "Effacer l'historique" pour tout supprimer

#### 5. ℹ️ À Propos
- Informations sur l'application
- Version actuelle

---

## 🎯 Scénarios d'Utilisation

### Scénario 1: Météo de Ma Position
1. Ouvrez l'app
2. Cliquez sur le bouton 📍 (en haut à gauche)
3. Acceptez la permission de localisation
4. La météo de votre ville s'affiche

### Scénario 2: Rechercher une Ville
1. Cliquez sur "Commencer"
2. Tapez le nom d'une ville dans la barre de recherche
3. Cliquez sur l'icône météo ☀️
4. La météo s'affiche

### Scénario 3: Ajouter aux Favoris
1. Affichez la météo d'une ville
2. Cliquez sur l'étoile ⭐ en haut à droite
3. La ville est ajoutée aux favoris
4. Consultez vos favoris dans Paramètres

### Scénario 4: Partager la Météo
1. Affichez la météo d'une ville
2. Cliquez sur l'icône de partage 📤
3. Choisissez l'application (WhatsApp, SMS, etc.)
4. Le message est pré-rempli avec les infos météo

### Scénario 5: Activer le Mode Sombre
1. Cliquez sur ⚙️ (paramètres)
2. Activez "Mode sombre"
3. L'app passe en thème sombre
4. Le choix est sauvegardé

---

## 💡 Astuces

- **Localisation Rapide**: Utilisez le bouton 📍 sur la page d'accueil pour un accès direct
- **Villes Rapides**: Sur la carte, utilisez les boutons de villes populaires
- **Historique**: Vos recherches sont automatiquement sauvegardées
- **Favoris**: Ajoutez vos villes préférées pour un accès rapide
- **Actualisation**: Tirez vers le bas ou cliquez sur 🔄 pour actualiser

---

## ⚠️ Résolution de Problèmes

### Le bouton de localisation ne fonctionne pas
- Vérifiez que la permission de localisation est accordée
- Vérifiez que le GPS est activé sur votre appareil
- Vérifiez votre connexion Internet

### Le bouton paramètres ne répond pas
- Redémarrez l'application
- Vérifiez que vous cliquez bien sur l'icône ⚙️ en haut à droite

### La détection automatique ne fonctionne pas
- Allez dans Paramètres
- Vérifiez que "Localisation Automatique" est activée
- Redémarrez l'application

---

**Version**: 1.0.0
**Dernière mise à jour**: 12 Décembre 2025
