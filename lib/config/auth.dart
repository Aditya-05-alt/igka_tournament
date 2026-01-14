import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance of Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- 1. Get Current User ---
  // Useful to check who is logged in (e.g., to display their email)
  User? get currentUser => _auth.currentUser;

  // --- 2. Auth State Stream ---
  // Useful for main.dart to listen if user logs in or out automatically
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // --- 3. Sign In Function ---
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Throw the specific error message from Firebase (e.g., "Wrong Password")
      throw e.message ?? "An unknown error occurred during login.";
    } catch (e) {
      throw "An error occurred. Please try again.";
    }
  }

  // --- 4. Sign Out Function ---
  Future<void> signOut() async {
    await _auth.signOut();
  }
}