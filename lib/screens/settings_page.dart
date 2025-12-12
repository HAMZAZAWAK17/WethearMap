import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/storage_service.dart';
import '../utils/color_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoLocation = true;
  List<String> _favorites = [];
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final autoLoc = await StorageService.isAutoLocationEnabled();
    final favs = await StorageService.getFavoriteCities();
    final hist = await StorageService.getSearchHistory();

    setState(() {
      _autoLocation = autoLoc;
      _favorites = favs;
      _history = hist;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                  ]
                : [
                    const Color(0xFF1e3c72),
                    const Color(0xFF2a5298),
                    const Color(0xFF7e22ce),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête
              _buildHeader(context),

              // Contenu
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1e1e1e) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildSectionTitle('Apparence', isDark),
                      _buildThemeSwitch(themeProvider, isDark),
                      const SizedBox(height: 30),

                      _buildSectionTitle('Localisation', isDark),
                      _buildAutoLocationSwitch(isDark),
                      const SizedBox(height: 30),

                      _buildSectionTitle('Villes favorites', isDark),
                      _buildFavoritesList(isDark),
                      const SizedBox(height: 30),

                      _buildSectionTitle('Historique', isDark),
                      _buildHistoryList(isDark),
                      const SizedBox(height: 20),
                      _buildClearHistoryButton(isDark),
                      const SizedBox(height: 30),

                      _buildSectionTitle('À propos', isDark),
                      _buildAboutSection(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1e3c72)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            'Paramètres',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF1e3c72),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(ThemeProvider themeProvider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2a2a2a) : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3a3a3a) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(
              isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
              color: isDark ? Colors.amber : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode sombre',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  isDark ? 'Activé' : 'Désactivé',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (_) => themeProvider.toggleTheme(),
            activeColor: const Color(0xFF7e22ce),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoLocationSwitch(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2a2a2a) : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3a3a3a) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const FaIcon(
              FontAwesomeIcons.locationCrosshairs,
              color: Color(0xFF1e3c72),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Localisation automatique',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Détecter ma position au démarrage',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _autoLocation,
            onChanged: (value) async {
              await StorageService.setAutoLocationEnabled(value);
              setState(() {
                _autoLocation = value;
              });
            },
            activeColor: const Color(0xFF7e22ce),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(bool isDark) {
    if (_favorites.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2a2a2a) : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'Aucune ville favorite',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: _favorites.map((city) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2a2a2a) : Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.star,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  city,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.trash,
                  size: 16,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await StorageService.removeFavoriteCity(city);
                  _loadSettings();
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryList(bool isDark) {
    if (_history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2a2a2a) : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'Aucun historique',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: _history.take(5).map((city) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2a2a2a) : Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.clockRotateLeft,
                color: Color(0xFF7e22ce),
                size: 20,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  city,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildClearHistoryButton(bool isDark) {
    return ElevatedButton.icon(
      onPressed: _history.isEmpty
          ? null
          : () async {
              await StorageService.clearHistory();
              _loadSettings();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Historique effacé'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
      icon: const FaIcon(FontAwesomeIcons.trash, size: 16),
      label: const Text('Effacer l\'historique'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2a2a2a) : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const FaIcon(
            FontAwesomeIcons.cloudSun,
            size: 50,
            color: Color(0xFF7e22ce),
          ),
          const SizedBox(height: 15),
          Text(
            'Météo App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Application météo avec localisation GPS, recherche de villes et prévisions sur 3 jours.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
