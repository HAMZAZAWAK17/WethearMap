import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/storage_service.dart';
import '../models/weather_model_enhanced.dart';

/// Onglet Settings - Paramètres de l'application
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _selectedLanguage = 'Français';
  String _selectedUnit = '°C';
  String _selectedWindUnit = 'km/h';
  List<SavedCity> _favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final cities = await StorageService.getSavedCities();
    setState(() {
      _favoriteCities = cities;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1e3c72),
              Color(0xFF2a5298),
              Color(0xFF7e22ce),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildSection(
                  title: 'Apparence',
                  icon: FontAwesomeIcons.palette,
                  children: [
                    _buildThemeSetting(),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Préférences',
                  icon: FontAwesomeIcons.sliders,
                  children: [
                    _buildLanguageSetting(),
                    const SizedBox(height: 12),
                    _buildUnitSetting(),
                    const SizedBox(height: 12),
                    _buildWindUnitSetting(),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Villes Favorites',
                  icon: FontAwesomeIcons.locationDot,
                  children: [
                    _buildFavoriteCities(),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'À propos',
                  icon: FontAwesomeIcons.circleInfo,
                  children: [
                    _buildAboutItem('Version', '2.0.0'),
                    const SizedBox(height: 12),
                    _buildAboutItem('API', 'OpenWeatherMap'),
                    const SizedBox(height: 12),
                    _buildAboutItem('Développeur', 'Hamza'),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(
          Icons.settings_rounded,
          color: Colors.white,
          size: 32,
        ),
        SizedBox(width: 12),
        Text(
          'Paramètres',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.dark_mode_rounded, color: Colors.white70, size: 24),
                SizedBox(width: 12),
                Text(
                  'Mode Sombre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: const Color(0xFF56CCF2),
              activeTrackColor: const Color(0xFF2F80ED).withOpacity(0.5),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSetting() {
    return _buildDropdownSetting(
      icon: FontAwesomeIcons.language,
      label: 'Langue',
      value: _selectedLanguage,
      items: ['Français', 'English', 'العربية', 'Español'],
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value!;
        });
      },
    );
  }

  Widget _buildUnitSetting() {
    return _buildDropdownSetting(
      icon: FontAwesomeIcons.temperatureHalf,
      label: 'Unité de température',
      value: _selectedUnit,
      items: ['°C', '°F'],
      onChanged: (value) {
        setState(() {
          _selectedUnit = value!;
        });
      },
    );
  }

  Widget _buildWindUnitSetting() {
    return _buildDropdownSetting(
      icon: FontAwesomeIcons.wind,
      label: 'Unité de vent',
      value: _selectedWindUnit,
      items: ['km/h', 'mph', 'm/s'],
      onChanged: (value) {
        setState(() {
          _selectedWindUnit = value!;
        });
      },
    );
  }

  Widget _buildDropdownSetting({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FaIcon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF1a1a2e),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCities() {
    if (_favoriteCities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.location_city_rounded,
                color: Colors.white.withOpacity(0.5),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'Aucune ville favorite',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _favoriteCities.map((city) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF56CCF2),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  city.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.white70),
                onPressed: () async {
                  await StorageService.removeSavedCity(city.name);
                  _loadSettings();
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAboutItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
