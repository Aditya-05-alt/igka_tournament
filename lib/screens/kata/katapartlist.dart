import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kata/kata_score.dart';

class KataParticipantsScreen extends StatelessWidget {
  final String eventId;

  const KataParticipantsScreen({super.key, required this.eventId});

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
        title: Text("Event $eventId Participants",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("START LIST",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                Text("4 Athletes", style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildParticipantTile(context, "Kenji Sato", "EAGLE DOJO", "Bassai Dai", true),
                _buildParticipantTile(context, "Hiroshi Tanaka", "TIGER CLAW", "Kanku Dai", false),
                _buildParticipantTile(context, "Takeshi Kovacs", "DRAGON GATE", "Seienchin", false),
                _buildParticipantTile(context, "Ren Yamamoto", "SHOGUN HQ", "Enpi", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantTile(BuildContext context, String name, String dojo, String kata, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF251818),
        borderRadius: BorderRadius.circular(20),
        border: isCurrent ? Border.all(color: Colors.red, width: 1) : Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white10,
          child: Text(name[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$dojo • $kata", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            if (isCurrent)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text("NEXT UP", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isCurrent ? Colors.red : Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          onPressed: () {
            // Redirect to the Scoring Screen we created earlier
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KataScoringScreen()),
            );
          },
          child: Text(isCurrent ? "SCORE" : "VIEW", 
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}