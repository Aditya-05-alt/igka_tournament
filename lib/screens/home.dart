import 'package:flutter/material.dart';
import 'package:igka_tournament/routes/app_routes.dart';
import 'package:igka_tournament/ui/cards_details.dart';

class DojoHomeScreen extends StatelessWidget {
  const DojoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120C0C),
      // The AppBar remains here as it is specific to the Home view
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "I.G.K.A",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Row(
            children: [
              const Text(
                "Sensei Kenji",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Action for community/people icon
                },
                icon: const Icon(Icons.people_alt_outlined,
                    color: Colors.red, size: 26),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              // Kata Card
              const ModeSelectionCard(
                  category: "FORMS",
                  subTitle: "TECHNIQUE",
                  title: "KATA",
                  description: "Master the patterns of movement.",
                  footerLabel: "",
                  icon: Icons.accessibility_new,
                  imagePath: 'assets/images/bg-kata.jpg',
                  routeName: AppRoutes.kataParticipate),

              const SizedBox(height: 35),

              // Kumite Card
              const ModeSelectionCard(
                  category: "SPARRING",
                  subTitle: "COMBAT",
                  title: "KUMITE",
                  description: "Live sparring drills and strategy.",
                  footerLabel: "18:00 Today",
                  icon: Icons.sports_kabaddi,
                  imagePath: 'assets/images/kumite.jpg',
                  routeName: AppRoutes.kumiteSetupScreen),

              // This padding ensures content isn't hidden by the floating navbar 
              // that sits in the MainWrapper
              // const SizedBox(height: 140), 
            ],
          ),
        ),
      ),
    );
  }
}