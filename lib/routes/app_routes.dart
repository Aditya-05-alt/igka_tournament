import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kata/kata_participate.dart';
import 'package:igka_tournament/screens/kumite/kumite_participate.dart';
import 'package:igka_tournament/screens/login.dart';
import 'package:igka_tournament/screens/settings/settings.dart';
import 'package:igka_tournament/screens/signup.dart';
import 'package:igka_tournament/screens/kata/kata_score.dart';
import 'package:igka_tournament/screens/profile/profile.dart';
import 'package:igka_tournament/screens/profile/editscreen.dart';
import 'package:igka_tournament/screens/mainwrapper.dart';
import 'package:igka_tournament/screens/kumite/kumiteentry.dart';



class AppRoutes {
  // Route Names
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String test = '/test';
  static const String kataScoring = '/kata_scoring';
  static const String kataParticipate = '/kata_participate';

  static const String kumiteSetupScreen = '/kumite_setup';
  static const String kumiteScoreScreen = '/kumite_score';
  static const String kumiteLogScreen = '/kumite_log';
  static const String kumiteEventsScreen = '/kumite_events';

  // New Placeholders for Navbar targets
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';

  static const String settings = '/settings';

  // Route Map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      home: (context) => const MainWrapper(), // Points to the wrapper now
      // Keep individual routes for direct navigation if needed
      kataScoring: (context) => const KataScoringScreen(),
      kataParticipate: (context) => const KataCategoriesScreen(),

      kumiteSetupScreen: (context) => const KumiteSetupScreen(),
      // kumiteScoreScreen: (context) => const KumiteMatchScreen(),
      kumiteEventsScreen: (context) => const KumiteEventsScreen(),
    

      // Temporary: Pointing to Home until you build these screens
      profile: (context) => const DojoProfileScreen(),
      editProfile: (context) => const EditProfileScreen(),

      // editprofile:(context) => const EditProfileScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
}
