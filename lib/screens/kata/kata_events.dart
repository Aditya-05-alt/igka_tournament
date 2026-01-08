import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kata/katapartlist.dart';

class KataEventsScreen extends StatelessWidget {
  final String categoryName;
  final int eventCount;
  final String categoryPrefix; // e.g., "1" for Beginner, "2" for Intermediate

  const KataEventsScreen({
    super.key,
    required this.categoryName,
    required this.eventCount,
    required this.categoryPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("$categoryName Events",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "AVAILABLE HEATS ($eventCount)",
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: eventCount,
              itemBuilder: (context, index) {
                // Generates A, B, C, D... based on index
                String letter = String.fromCharCode(65 + (index % 26)); 
                String eventId = "$categoryPrefix$letter";

                return _buildEventCard(context, eventId);
              },
            ),
          ),
        ],
      ),
    );
  }

Widget _buildEventCard(BuildContext context, String eventId) {
    return GestureDetector(
      onTap: () {
        // Navigates to the Participants screen for the specific Heat/Event
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KataParticipantsScreen(eventId: eventId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF251818),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            // Event ID Badge (e.g., 1A, 2B)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                eventId,
                style: const TextStyle(
                    color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event $eventId",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Scheduled: 10:30 AM",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Navigation Indicator
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}