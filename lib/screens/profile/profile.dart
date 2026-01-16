import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. Add Firestore Import

class DojoProfileScreen extends StatelessWidget {
  const DojoProfileScreen({super.key});

  // 2. Remove the constructor parameter since we will fetch it live

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
      );
    }
  }

  // 3. Helper to fetch user data
  Future<DocumentSnapshot> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No user logged in");
    
    // Assumes your collection is named 'users' and the Doc ID is the User UID
    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: Center(
          // 4. Wrap with FutureBuilder to get the data
          child: FutureBuilder<DocumentSnapshot>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: Colors.red);
              }

              if (snapshot.hasError) {
                return const Text("Error loading profile", style: TextStyle(color: Colors.white));
              }

              // Default to "Unknown" if data is missing
              String tatamiName = "Unknown Tatami";
              
              if (snapshot.hasData && snapshot.data!.exists) {
                var data = snapshot.data!.data() as Map<String, dynamic>;
                // FETCH 'assignedTatami' from the database
                tatamiName = data['assignedTatami'] ?? "Tatami 1"; 
              }

              return _buildProfileCard(context, width, height, tatamiName);
            },
          ),
        ),
      ),
    );
  }

  // 5. Update method to accept tatamiName string
  Widget _buildProfileCard(BuildContext context, double width, double height, String tatamiName) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: height * 0.05, 
        horizontal: width * 0.05
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: width * 0.18,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            child: CircleAvatar(
              radius: width * 0.17,
              backgroundColor: const Color(0xFF251818),
              child: Icon(
                Icons.grid_view_rounded,
                size: width * 0.15,
                color: Colors.red,
              ),
            ),
          ),
          SizedBox(height: height * 0.03),

          // Display the Fetched Tatami Name
          Text(
            tatamiName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.08,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: const Text(
              "Active Session",
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: height * 0.05),
          const Divider(color: Colors.white10, thickness: 1.5),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            onTap: () => _handleLogout(context),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: Colors.red, size: 28),
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 20),
          ),
        ],
      ),
    );
  }
}