import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Widget pour afficher une icône météo animée avec effet de pulsation
class AnimatedWeatherIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final bool animate;

  const AnimatedWeatherIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 100,
    this.animate = true,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return FaIcon(
        widget.icon,
        size: widget.size,
        color: widget.color,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Effet de lueur derrière l'icône
                Container(
                  width: widget.size * 1.5,
                  height: widget.size * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3 * _opacityAnimation.value),
                        blurRadius: 30 * _scaleAnimation.value,
                        spreadRadius: 10 * _scaleAnimation.value,
                      ),
                    ],
                  ),
                ),
                // L'icône elle-même
                FaIcon(
                  widget.icon,
                  size: widget.size,
                  color: widget.color,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
