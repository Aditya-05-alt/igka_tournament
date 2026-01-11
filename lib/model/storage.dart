class MatchHistoryStorage {
  // Stores all matches for all events
  static List<Map<String, dynamic>> completedMatches = [];

  static void addMatch({
    required String eventName,
    required int matchNumber,
    required int akaScore,
    required int aoScore,
    required String winner, // "AKA" or "AO"
  }) {
    completedMatches.add({
      'eventName': eventName,
      'matchNumber': matchNumber,
      'akaScore': akaScore,
      'aoScore': aoScore,
      'winner': winner,
      'timestamp': DateTime.now(),
    });
  }

  static List<Map<String, dynamic>> getMatchesForEvent(String eventName) {
    return completedMatches.where((m) => m['eventName'] == eventName).toList();
  }
}