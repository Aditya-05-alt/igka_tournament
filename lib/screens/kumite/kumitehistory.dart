import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KumiteEventHistoryScreen extends StatelessWidget {
  // This eventName is the Doc ID (e.g., "Event_1_Tatami1")
  final String eventName; 

  const KumiteEventHistoryScreen({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsiveness
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "$eventName Results",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
      ),
      // 1. STREAM BUILDER to listen to Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('kumite_events')
            .doc(eventName)
            .collection('matches')
            .orderBy('matchNumber', descending: true) // Newest matches at top
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data", style: TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No matches recorded yet.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final matches = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              var data = matches[index].data() as Map<String, dynamic>;
              
              // Extract Data
              int matchNum = data['matchNumber'] ?? 0;
              int akaScore = data['akaScore'] ?? 0;
              int aoScore = data['aoScore'] ?? 0;
              String winner = data['winner'] ?? "Unknown";
              bool akaWon = winner.contains("AKA");

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
                    // MATCH NUMBER CIRCLE
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "$matchNum",
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
                            "AKA  $akaScore",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: width * 0.045, // Responsive Font
                              fontWeight: akaWon ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("-", style: TextStyle(color: Colors.white30)),
                          ),
                          // AO Score
                          Text(
                            "$aoScore  AO",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: width * 0.045, // Responsive Font
                              fontWeight: !akaWon ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // WINNER BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: akaWon ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: (akaWon ? Colors.red : Colors.blue).withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        winner,
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
          );
        },
      ),
    );
  }
}