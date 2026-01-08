import 'package:flutter/material.dart';

class KataResultScreen extends StatelessWidget {
  const KataResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F), // Deep dark background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Success Header Section
            _buildSuccessHeader(),
            const SizedBox(height: 40),
            // Category Title and Badge
            _buildCategoryTitle(),
            const SizedBox(height: 20),
            // Leaderboard List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildResultTile(
                    rank: 1,
                    name: "Kenji Sato",
                    dojo: "Osaka Dojo",
                    score: "9.90",
                    isWinner: true,
                  ),
                  _buildResultTile(rank: 2, name: "Michael Ross", dojo: "London Karate Club", score: "9.75"),
                  _buildResultTile(rank: 3, name: "David Lee", dojo: "Seoul Central", score: "9.65"),
                  _buildResultTile(
                    rank: 4, 
                    name: "John Smith", 
                    dojo: "Just Added", 
                    score: "9.40", 
                    isNew: true
                  ),
                  _buildResultTile(rank: 5, name: "Sarah Connor", dojo: "LA Fitness", score: "8.90"),
                  _buildResultTile(rank: 6, name: "Emily Blunt", dojo: "London Dojo", score: "8.85"),
                ],
              ),
            ),
            // Bottom Action Button
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
            ],
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 20),
        const Text(
          "Score Submitted!",
          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "The leaderboard has been updated successfully.",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCategoryTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Men's Black Belt - Shotokan",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text("Finals", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile({
    required int rank,
    required String name,
    required String dojo,
    required String score,
    bool isWinner = false,
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF251818),
        borderRadius: BorderRadius.circular(20),
        border: isWinner ? Border.all(color: Colors.red, width: 1.5) : null,
      ),
      child: Row(
        children: [
          // Rank Circle
          CircleAvatar(
            radius: 18,
            backgroundColor: isWinner ? Colors.red : Colors.white10,
            child: Text("$rank", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          // User Avatar
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
          ),
          const SizedBox(width: 15),
          // Name and Dojo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    if (isNew) const Icon(Icons.history, color: Colors.red, size: 12),
                    if (isNew) const SizedBox(width: 4),
                    Text(
                      dojo, 
                      style: TextStyle(color: isNew ? Colors.red : Colors.grey, fontSize: 12)
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: TextStyle(
                  color: isWinner ? Colors.red : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("SCORE", style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Next Competitor", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}