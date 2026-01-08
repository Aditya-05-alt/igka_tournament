import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/home.dart';
import 'package:igka_tournament/screens/profile/profile.dart'; // Ensure correct path
import 'package:igka_tournament/screens/settings/settings.dart';
// import 'package:igka_tournament/screens/settings.dart'; // Ensure correct path
import 'package:igka_tournament/ui/navbar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0; // 0 = Home, 2 = Profile, 4 = Settings

  // The list of screens to display as the "body"
  final List<Widget> _screens = [
    const DojoHomeScreen(),       // Index 0
    const Placeholder(),          // Index 1 (Gaps in your navbar logic)
    const DojoProfileScreen(),    // Index 2
    const Placeholder(),          // Index 3
    const SettingsScreen()          // Index 4 (Settings)
  ];

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial for floating navbar transparency
      backgroundColor: const Color(0xFF120C0C),
      // Display the screen based on the index
      body: _screens[_selectedIndex],
      bottomNavigationBar: DojoFloatingNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}