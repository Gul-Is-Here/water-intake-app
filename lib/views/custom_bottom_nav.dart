import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/water_controller.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;  // Changed from RxInt to int

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WaterController waterController = Get.find();

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home,
            label: 'Home',
            index: 0,
            isSelected: currentIndex == 0,
            onTap: () => waterController.changeTabIndex(0),
          ),
          _NavItem(
            icon: Icons.history,
            label: 'History',
            index: 1,
            isSelected: currentIndex == 1,
            onTap: () => waterController.changeTabIndex(1),
          ),
          _NavItem(
            icon: Icons.analytics,
            label: 'Stats',
            index: 2,
            isSelected: currentIndex == 2,
            onTap: () => waterController.changeTabIndex(2),
          ),
          _NavItem(
            icon: Icons.settings,
            label: 'Settings',
            index: 3,
            isSelected: currentIndex == 3,
            onTap: () => waterController.changeTabIndex(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.openSans(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}