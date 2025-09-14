import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final String currentRoute;

  const CustomBottomNavigation({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0F0F0F),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.home_filled,
              label: 'Home',
              route: AppRouter.home,
              isActive: currentRoute == AppRouter.home,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.emoji_events,
              label: 'Ranking',
              route: AppRouter.gamification,
              isActive: currentRoute == AppRouter.gamification,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.smart_toy,
              label: 'Enjoy',
              route: AppRouter.chatAssistant,
              isActive: currentRoute == AppRouter.chatAssistant,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.description_outlined,
              label: 'Manifesto',
              route: AppRouter.manifesto,
              isActive: currentRoute == AppRouter.manifesto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String? route,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () {
        if (route != null && !isActive) {
          context.push(route);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFFAAAAAA),
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
