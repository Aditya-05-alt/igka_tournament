import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:igka_tournament/screens/home.dart';
import 'package:igka_tournament/screens/mainwrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- 1. CONTROLLERS & STATE ---
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true; // Tracks if password is hidden

  // Define the core colors
  static const Color karateRed = Color(0xFFD30000);
  static const Color darkText = Color(0xFF0F172A);
  static const Color borderGrey = Color(0xFFE2E8F0);

  // --- 2. FIREBASE LOGIN LOGIC ---
// --- 2. FIREBASE LOGIN LOGIC ---
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // A. Sign in with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // B. Check Firestore for User Data
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        DocumentSnapshot userDoc = await userDocRef.get();

        String finalTatami = "Tatami 1"; // Default starting value

       // Inside _login() method ...

        if (userDoc.exists) {
          // Case 1: User already exists, just load their data
          final data = userDoc.data() as Map<String, dynamic>;
          finalTatami = data['assignedTatami'] ?? "Tatami 1";
        } else {
          // Case 2: First time login - Setup the user
          
          String emailInput = _emailController.text.trim().toLowerCase();
          
          // FIX: Check for "tatami2" OR "admin2"
          if (emailInput.contains("admin2") || emailInput.contains("tatami2")) {
            finalTatami = "Tatami 2";
          }

          // Save to Firestore
          await userDocRef.set({
            'email': _emailController.text.trim(),
            'assignedTatami': finalTatami,
            'uid': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // C. Navigate with the correct Tatami
        if (mounted) {
           // We use MaterialPageRoute to pass the parameter directly, 
           // or you can update your AppRoutes to handle arguments.
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainWrapper(assignedTatami: finalTatami,)
            ),
          );
        }
      }

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed"), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/GosokuRyuLogo.jpg'),
                      fit: BoxFit.contain,
                    ),
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
                controller: _emailController, // <--- CHANGED
                keyboardType: TextInputType.emailAddress,
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
                    controller: _passwordController,
                    obscureText: _isObscured, // 1. Use the variable here
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      
                      // 2. Wrap the icon in an IconButton to make it clickable
                      suffixIcon: IconButton(
                        icon: Icon(
                          // 3.Color.fromARGB(255, 153, 141, 141)n based on state
                          _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          // 4. Toggle the state
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      
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
                child: Text(
                  "Forgot Password?", style: TextStyle(color: karateRed, fontWeight: FontWeight.bold)
                ),
              ),

              const SizedBox(height: 20),

              // --- LOG IN BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login, // <--- CHANGED
                  style: ElevatedButton.styleFrom(
                    backgroundColor: karateRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) // Show loading
                    : const Row(
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
              // const Row(
              //   children: [
              //     Expanded(child: Divider(color: borderGrey)),
              //     Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey))),
              //     Expanded(child: Divider(color: borderGrey)),
              //   ],
              // ),
              const SizedBox(height: 20),

              // --- CREATE ACCOUNT BUTTON ---
              // SizedBox(
              //   width: double.infinity,
              //   height: 60,
              //   child: OutlinedButton(
              //     onPressed: () {
              //      Navigator.pushReplacementNamed(context, AppRoutes.signup);
              //     },
              //     style: OutlinedButton.styleFrom(
              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              //       side: const BorderSide(color: borderGrey),
              //     ),
              //     child: const Text("Create New Account", style: TextStyle(color: darkText, fontSize: 16, fontWeight: FontWeight.w600)),
              //   ),
              // ),

              const SizedBox(height: 20),
              const Text(
                "© 2026 IGKA. All rights reserved.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.white,
      //   mini: true,
      //   child: const Icon(Icons.dark_mode_outlined, color: darkText),
      // ),
    );
  }
}