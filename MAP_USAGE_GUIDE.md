# 🗺️ Guide d'utilisation de la carte interactive

## Fonctionnalités disponibles

### 1. 🔍 Recherche de ville par nom

**Comment faire :**
1. Tapez le nom de n'importe quelle ville dans la barre de recherche
2. Appuyez sur Entrée ou cliquez sur le bouton flèche
3. La carte se déplace automatiquement vers la ville
4. Un marqueur est placé sur la ville

**Exemples de villes à rechercher :**
- Paris, France
- New York, USA
- Tokyo, Japan
- London, UK
- Dubai, UAE
- Sydney, Australia
- ... n'importe quelle ville dans le monde !

### 2. 🖱️ Clic sur la carte

**Comment faire :**
1. Cliquez n'importe où sur la carte
2. L'application utilise le géocodage inverse pour trouver le nom de la ville
3. Un marqueur est automatiquement placé à cet endroit
4. Le nom de la ville apparaît dans la barre de recherche

**Avantages :**
- Découvrir des villes en explorant la carte
- Pas besoin de connaître le nom exact de la ville
- Navigation intuitive

### 3. ⚡ Boutons de villes rapides

**Comment faire :**
1. Cliquez sur l'un des boutons de ville (Paris, Lyon, Marseille, Nice, Bordeaux)
2. La carte se déplace instantanément vers cette ville
3. Un marqueur est placé automatiquement

**Avantages :**
- Accès rapide aux villes françaises populaires
- Pas besoin de taper le nom

### 4. 🌤️ Voir la météo d'une ville

**Comment faire :**
1. Après avoir placé un marqueur (par recherche ou clic)
2. Cliquez sur le marqueur sur la carte
3. L'application navigue automatiquement vers la page météo de cette ville

**Informations affichées :**
- Température actuelle
- Conditions météo
- Prévisions
- Et plus encore !

## 🎯 Scénarios d'utilisation

### Scénario 1 : Recherche d'une ville connue
```
1. Tapez "Tokyo" dans la barre de recherche
2. Appuyez sur Entrée
3. La carte se déplace vers Tokyo
4. Cliquez sur le marqueur pour voir la météo de Tokyo
```

### Scénario 2 : Exploration de la carte
```
1. Zoomez et déplacez la carte vers une région qui vous intéresse
2. Cliquez sur un endroit sur la carte
3. L'application trouve automatiquement le nom de la ville
4. Cliquez sur le marqueur pour voir la météo
```

### Scénario 3 : Villes rapides
```
1. Cliquez sur le bouton "Marseille"
2. La carte se déplace instantanément vers Marseille
3. Cliquez sur le marqueur pour voir la météo de Marseille
```

## 🔧 Fonctionnalités techniques

### Géocodage (Nom → Coordonnées)
- Utilise l'API Google Geocoding
- Convertit les noms de villes en coordonnées GPS
- Supporte les villes du monde entier
- Gère les variations d'orthographe

### Géocodage inverse (Coordonnées → Nom)
- Convertit les coordonnées GPS en noms de villes
- Activé lors du clic sur la carte
- Extrait automatiquement le nom de la ville de l'adresse complète

### Indicateur de chargement
- Affiche un spinner pendant la recherche
- Message "Recherche de la ville..."
- Interface utilisateur réactive

## 💡 Astuces

1. **Zoom intelligent** : La carte zoome automatiquement à un niveau approprié pour chaque ville
2. **Un seul marqueur** : Chaque nouvelle recherche remplace le marqueur précédent pour garder la carte propre
3. **Nom dans la barre** : Le nom de la ville cliquée apparaît dans la barre de recherche
4. **Navigation fluide** : Animations douces lors du déplacement de la carte

## ⚠️ Limitations

- Nécessite une connexion Internet pour le géocodage
- Les zones très isolées peuvent ne pas avoir de nom de ville
- Le géocodage inverse peut retourner une adresse au lieu d'un nom de ville dans certains cas

## 🚀 Prochaines améliorations possibles

- [ ] Historique des villes recherchées
- [ ] Favoris de villes
- [ ] Affichage de plusieurs marqueurs simultanément
- [ ] Couches météo sur la carte (nuages, précipitations, etc.)
- [ ] Géolocalisation automatique de l'utilisateur
- [ ] Suggestions de villes pendant la saisie
