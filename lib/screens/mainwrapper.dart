import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/home.dart';
import 'package:igka_tournament/screens/profile/profile.dart'; 
import 'package:igka_tournament/screens/settings/settings.dart';
import 'package:igka_tournament/ui/navbar.dart';

class MainWrapper extends StatefulWidget {
  // Make this optional (String?) so it works even if null
  final String? assignedTatami;

  const MainWrapper({
    super.key, 
    this.assignedTatami, 
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0; 

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define screens inside build() to access 'widget.assignedTatami'
    final List<Widget> screens = [
      // Pass the data to the Home Screen
      DojoHomeScreen(assignedTatami: widget.assignedTatami), 
      const Placeholder(),
      const DojoProfileScreen(),
      const Placeholder(),
      const SettingsScreen()
    ];

    return Scaffold(
      extendBody: true, // Allows content to scroll behind the floating navbar
      backgroundColor: const Color(0xFF120C0C),
      body: screens[_selectedIndex], 
      bottomNavigationBar: DojoFloatingNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}