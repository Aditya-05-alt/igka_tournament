import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables
  String _displayMode = 'Dark'; // Options: Light, Dark, Auto
  String _selectedTheme = 'Dojo Red'; // Options: Dojo Red, Spirit, Gold, Focus
  bool _highContrast = false;
  bool _reduceMotion = false;

  // Colors
  final Color _bgDark = const Color(0xFF0F0B0B); // Main Background
  final Color _cardDark = const Color(0xFF1E1212); // Card Background
  final Color _accentRed = const Color(0xFFFF0000); // Dojo Red
  final Color _textGrey = const Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: _bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Appearance", // You can change this to "Settings" if you prefer
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Display Mode ---
            const SizedBox(height: 10),
            const Text(
              "Display Mode",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            _buildDisplayModeSelector(),

            const SizedBox(height: 30),

            // --- Section 2: Dojo Theme ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Dojo Theme",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _selectedTheme,
                  style: TextStyle(color: _accentRed, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildThemeCircle("Dojo Red", _accentRed),
                _buildThemeCircle("Spirit", Colors.white),
                _buildThemeCircle("Gold", const Color(0xFFFFD700)),
                _buildThemeCircle("Focus", const Color(0xFF0055BB)),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Theme changes apply to buttons, accents, and active states.",
              style: TextStyle(color: _textGrey, fontSize: 12, height: 1.4),
            ),

            const SizedBox(height: 30),

            // --- Section 3: Accessibility ---
            const Text(
              "Accessibility",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: _cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildAccessTile(
                    icon: Icons.text_fields,
                    title: "Text Size",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Default", style: TextStyle(color: _textGrey, fontSize: 14)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, color: _textGrey, size: 14),
                      ],
                    ),
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.contrast,
                    title: "High Contrast",
                    value: _highContrast,
                    onChanged: (v) => setState(() => _highContrast = v),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.motion_photos_off_outlined,
                    title: "Reduce Motion",
                    value: _reduceMotion,
                    onChanged: (v) => setState(() => _reduceMotion = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                "Dojo Mobile App v1.0.4",
                style: TextStyle(color: _textGrey.withOpacity(0.5), fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildDisplayModeSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildModeOption("Light", Icons.wb_sunny_outlined),
          _buildModeOption("Dark", Icons.nightlight_round),
          _buildModeOption("Auto", Icons.brightness_auto),
        ],
      ),
    );
  }

  Widget _buildModeOption(String label, IconData icon) {
    bool isSelected = _displayMode == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _displayMode = label),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3E1F1F) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : _textGrey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : _textGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCircle(String label, Color color) {
    bool isSelected = _selectedTheme == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = label),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : _textGrey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1515),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _accentRed, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A1515),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _accentRed, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _accentRed,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Colors.white10,
      indent: 60,
      endIndent: 16,
    );
  }
}
