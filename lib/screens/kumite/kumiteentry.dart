import 'package:flutter/material.dart';
import 'package:igka_tournament/routes/app_routes.dart';

class KumiteSetupScreen extends StatefulWidget {
  const KumiteSetupScreen({super.key});

  @override
  State<KumiteSetupScreen> createState() => _KumiteSetupScreenState();
}

class _KumiteSetupScreenState extends State<KumiteSetupScreen> {
  // 1. Define controllers to capture user input
  final TextEditingController _akaController = TextEditingController();
  final TextEditingController _aoController = TextEditingController();

  @override
  void dispose() {
    _akaController.dispose();
    // _aoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.05),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "KUMITE SETUP",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // --- AKA (RED) SECTION ---
            _buildFighterSection(
              label: "AKA (RED)",
              color: Colors.red,
              isRightAligned: false,
              glowColor: Colors.redAccent.withOpacity(0.3),
              controller: _akaController, // Pass controller
            ),

            const SizedBox(height: 20),
            
            // --- VS DIVIDER ---
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.white10, thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF1E1414),
                    child: Text(
                      "VS",
                      style: TextStyle(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white10, thickness: 1)),
              ],
            ),

            const SizedBox(height: 20),

            // --- AO (BLUE) SECTION ---
            _buildFighterSection(
              label: "AO (BLUE)",
              color: Colors.blue,
              isRightAligned: true,
              glowColor: Colors.blueAccent.withOpacity(0.3),
              controller: _aoController, // Pass controller
            ),

            const Spacer(),

            // --- START MATCH BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                 Navigator.pushNamed(context, AppRoutes.kumiteScoreScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  elevation: 5,
                  shadowColor: Colors.redAccent.withOpacity(0.5),
                ),
                child: const Text(
                  "START MATCH",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFighterSection({
    required String label,
    required Color color,
    required bool isRightAligned,
    required Color glowColor,
    required TextEditingController controller, // Added controller param
  }) {
    return Column(
      crossAxisAlignment: isRightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Badge Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isRightAligned) Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 8),
              if (isRightAligned) Icon(Icons.circle, color: color, size: 12),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Fighter Input Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1414),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 15,
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(
            children: [
              if (!isRightAligned)
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
              if (!isRightAligned) const SizedBox(width: 15),
              
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: isRightAligned ? TextAlign.end : TextAlign.start,
                  keyboardType: TextInputType.name, // Opens keyboard with name letters
                  textCapitalization: TextCapitalization.words, // Auto capitals names
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Fighter Name",
                    hintStyle: const TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                    // Subtitle effect
                    label: Text(
                      "ENTER NAME",
                      style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              
              if (isRightAligned) const SizedBox(width: 15),
              if (isRightAligned)
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
            ],
          ),
        ),
      ],
    );
  }
}