import 'package:flutter/material.dart';
import 'package:igka_tournament/model/storage.dart';
 // Uncomment if in separate file

class KumiteEventHistoryScreen extends StatelessWidget {
  final String eventName;

  const KumiteEventHistoryScreen({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    // 1. Get matches only for this event
    final matches = MatchHistoryStorage.getMatchesForEvent(eventName);

    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "$eventName Results",
          style: const TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: matches.isEmpty
          ? const Center(
              child: Text(
                "No matches recorded yet.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                // Matches are stored in order, let's reverse to show newest first? 
                // Or keep index. Let's use the actual data.
                final match = matches[index];
                bool akaWon = match['winner'] == "AKA";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251818),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: akaWon ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      // MATCH NUMBER
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${match['matchNumber']}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // SCORES
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // AKA Score
                            Text(
                              "AKA  ${match['akaScore']}",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: akaWon ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("-", style: TextStyle(color: Colors.white30)),
                            ),
                            // AO Score
                            Text(
                              "${match['aoScore']}  AO",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: !akaWon ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // WINNER BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: akaWon ? Colors.red : Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          match['winner'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}