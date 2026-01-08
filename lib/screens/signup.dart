import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isChecked = false;

  // Design Constants based on uploaded image
  final Color _backgroundColorStart = const Color(0xFF8E7F57); // Dark gold/brown
  final Color _backgroundColorEnd = const Color(0xFFEFE9D8);   // Light gold/white
  final Color _redColor = const Color(0xFFD32F2F);             // Martial Arts Red
  final Color _textColor = const Color(0xFF1A1A1A);
  final Color _labelColor = const Color(0xFF4A4A4A);
  final Color _borderColor = const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background matching the design
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_backgroundColorStart, _backgroundColorEnd],
            stops: const [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildFormCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Header with Logo, Title, and Subtitle
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/GosokuRyuLogo.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
        ),
        const SizedBox(height: 20),
        Text(
          "DOJO SIGNUP",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: _textColor,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Begin your journey to mastery",
          style: TextStyle(fontSize: 16, color: _labelColor),
        ),
      ],
    );
  }

  // The central white card containing all inputs
  Widget _buildFormCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("Full Name", "John Doe", Icons.person_outline, false),
            const SizedBox(height: 20),
            _buildInputField("Email Address", "you@example.com", Icons.email_outlined, false),
            const SizedBox(height: 20),
            _buildInputField("Password", "••••••••", Icons.lock_outline, true),
            const SizedBox(height: 20),
            _buildInputField("Confirm Password", "••••••••", Icons.lock_reset_outlined, true),
            const SizedBox(height: 20),
            
            // Terms and Conditions checkbox
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isChecked,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    activeColor: _redColor,
                    onChanged: (val) => setState(() => _isChecked = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: _labelColor, fontSize: 14),
                      children: [
                        const TextSpan(text: "I agree to the "),
                        TextSpan(text: "Terms", style: TextStyle(color: _redColor, fontWeight: FontWeight.bold)),
                        const TextSpan(text: " and "),
                        TextSpan(text: "Privacy Policy", style: TextStyle(color: _redColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Primary Signup Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _redColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("SIGN UP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ", style: TextStyle(color: _labelColor)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())), // Example navigation back to login
                  child: Text("Sign in", style: TextStyle(color: _redColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String placeholder, IconData icon, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textColor)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.text,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _redColor),
            ),
          ),
        ),
      ],
    );
  }
}