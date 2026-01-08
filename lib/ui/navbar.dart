import 'package:flutter/material.dart';

class DojoFloatingNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DojoFloatingNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Color Palette matches your dark Dojo theme
  static const Color _navBg = Color(0xFF1E1E1E);
  static const Color _activeRed = Color(0xFFFF1717);
  static const Color _inactiveGrey = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30), // Floating effect
      height: 70,
      decoration: BoxDecoration(
        color: _navBg.withOpacity(0.95),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home Item (Index 0)
          _buildNavItem(0, Icons.grid_view_rounded, "Home"),
          
          // Profile Item (Index 2 - Middle)
          _buildProfileItem(2), 
          
          // Settings Item (Index 4)
          _buildNavItem(4, Icons.settings_outlined, "Settings"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? _activeRed : _inactiveGrey,
              size: 26,
            ),
            // Indicator Dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(top: 6),
              height: 4,
              width: isActive ? 4 : 0,
              decoration: const BoxDecoration(
                color: _activeRed,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(int index) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? _activeRed : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF333333),
          child: Icon(
            Icons.person, 
            color: isActive ? Colors.white : _inactiveGrey, 
            size: 22
          ),
        ),
      ),
    );
  }
}