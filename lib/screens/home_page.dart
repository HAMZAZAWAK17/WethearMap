import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/color_helper.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import 'map_page.dart';
import 'settings_page.dart';
import 'weather_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1e3c72),
                  Color(0xFF2a5298),
                  Color(0xFF7e22ce),
                  Color(0xFFc026d3),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône météo animée
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white10,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.white20,
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.cloudSun,
                              size: 120,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 50),

                          // Titre animé
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Météo',
                                  speed: const Duration(milliseconds: 200),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sous-titre
                          Text(
                            'Votre assistant météo personnel',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.white90,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 60),

                          // Indicateur de chargement ou bouton
                          if (_isCheckingLocation)
                            Column(
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Détection de votre position...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.white90,
                                  ),
                                ),
                              ],
                            )
                          else
                            _buildGlowingButton(context),
                          
                          const SizedBox(height: 40),

                          // Fonctionnalités
                          if (!_isCheckingLocation) _buildFeatures(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Bouton paramètres en haut à droite
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: AppColors.white20,
                child: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.gear,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFf093fb),
              Color(0xFFf5576c),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colorWithOpacity(const Color(0xFFf5576c), 0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Commencer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(width: 10),
            FaIcon(
              FontAwesomeIcons.arrowRight,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFeatureItem(FontAwesomeIcons.mapLocationDot, 'Carte\nInteractive'),
        _buildFeatureItem(FontAwesomeIcons.magnifyingGlass, 'Recherche\nVille'),
        _buildFeatureItem(FontAwesomeIcons.calendar, 'Prévisions\n3 Jours'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white15,
            border: Border.all(
              color: AppColors.white30,
              width: 2,
            ),
          ),
          child: FaIcon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white80,
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
