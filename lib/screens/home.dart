import 'package:flutter/material.dart';
import 'package:igka_tournament/routes/app_routes.dart';
import 'package:igka_tournament/screens/kumite/kumite_participate.dart';
import 'package:igka_tournament/ui/cards_details.dart';


class DojoHomeScreen extends StatelessWidget {
  // 1. Variable to hold the Tatami name
  final String? assignedTatami;

  const DojoHomeScreen({
    super.key,
    this.assignedTatami, // Constructor
  });

  @override
  Widget build(BuildContext context) {
    // 2. Get Screen Dimensions for Responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.05; // 5% of screen width

    return Scaffold(
      backgroundColor: const Color(0xFF120C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "I.G.K.A",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.06, // Responsive Font
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Row(
            children: [
              // 3. Display the dynamic Tatami name here
              Text(
                assignedTatami ?? 'Sensei Kenji', // Default if null
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05, // Responsive Font
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              IconButton(
                onPressed: () {
                  // Action for community/people icon
                },
                icon: Icon(
                  Icons.flight_class,
                  color: Colors.red,
                  size: screenWidth * 0.07,
                ),
              ),
            ],
          ),
          SizedBox(width: horizontalPadding / 2),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Responsive Padding
          padding: EdgeInsets.only(
            top: screenHeight * 0.02,
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: screenHeight * 0.1, // Extra space for Navbar
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.01),

              // --- KATA CARD ---
              const ModeSelectionCard(
                category: "FORMS",
                subTitle: "TECHNIQUE",
                title: "KATA",
                description: "Master the patterns of movement.",
                footerLabel: "",
                icon: Icons.accessibility_new,
                imagePath: 'assets/images/bg-kata.jpg',
                routeName: AppRoutes.kataParticipate,
              ),

              SizedBox(height: screenHeight * 0.04), // Responsive Spacing
             
                ModeSelectionCard(
                category: "SPARRING",
                subTitle: "COMBAT",
                title: "KUMITE",
                description: "Live sparring drills and strategy.",
                footerLabel: "18:00 Today",
                icon: Icons.sports_kabaddi,
                imagePath: 'assets/images/kumite.jpg',
                routeName: "", // Ignored because onTap is present
                
                // ADDED onTap directly here
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KumiteEventsScreen(
                        assignedTatami: assignedTatami, // Data passed correctly
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
