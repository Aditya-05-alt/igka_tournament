import 'package:flutter/material.dart';
import 'package:igka_tournament/routes/app_routes.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Define the core colors from the image
  static const Color karateRed = Color(0xFFD30000);
  static const Color darkText = Color(0xFF0F172A);
  static const Color lightGrey = Color(0xFFF8FAFC);
  static const Color borderGrey = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Optional: Add a subtle dot pattern background here using a CustomPainter
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              // --- LOGO SECTION ---
              Center(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/GosokuRyuLogo.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Using a simple icon/text to represent the logo in the image
                    
                    
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: darkText),
              ),
              const Text(
                "ENTER THE DOJO",
                style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 1.2),
              ),

              const SizedBox(height: 40),

              // --- EMAIL FIELD ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("EMAIL ADDRESS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkText)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "sensei@dojo.com",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- PASSWORD FIELD ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("PASSWORD", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkText)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey, size: 20),
                  hintText: "••••••••",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: borderGrey),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?", style: TextStyle(color: karateRed, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),

              // --- LOG IN BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: karateRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("LOG IN", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.login, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(color: borderGrey)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey))),
                  Expanded(child: Divider(color: borderGrey)),
                ],
              ),
              const SizedBox(height: 20),

              // --- CREATE ACCOUNT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton(
                  onPressed: () {
                 Navigator.pushReplacementNamed(context, AppRoutes.signup);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    side: const BorderSide(color: borderGrey),
                  ),
                  child: const Text("Create New Account", style: TextStyle(color: darkText, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "© 2025 IGKA. All rights reserved.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        mini: true,
        child: const Icon(Icons.dark_mode_outlined, color: darkText),
      ),
    );
  }
}