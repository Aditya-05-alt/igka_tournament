import 'package:flutter/material.dart';
import 'package:igka_tournament/routes/app_routes.dart';

class DojoProfileScreen extends StatelessWidget {
  const DojoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.red, size: 30),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Adjusting top padding to 15 to bring the card higher
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 30),
        child: Center(
          child: _buildProfileCard(context),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Large Avatar
          const CircleAvatar(
            radius: 70,
            backgroundColor: Colors.red,
            child: CircleAvatar(
              radius: 66,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=11'),
            ),
          ),
          const SizedBox(height: 25),

          // Large Name
          const Text(
            "Sensei Kenji",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Large Subtitle
          const Text(
            "Black Belt 4th Dan",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Shotokan Karate-Do",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 40),
          const Divider(color: Colors.white10, thickness: 1.5),

          // Large Logout Button
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            onTap: () {
              // Logout Logic
            },
            leading: const Icon(Icons.logout, color: Colors.red, size: 32),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24),
          ),
        ],
      ),
    );
  }
}