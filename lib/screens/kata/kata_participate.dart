import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kata/kata_events.dart';


class KataCategoriesScreen extends StatelessWidget {
  const KataCategoriesScreen({super.key});

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
        title: const Text("Kata Categories",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF251818),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search by style or belt level...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.tune, color: Colors.grey),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("BELT LEVELS",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
          ),

          const SizedBox(height: 15),

          // Grid of Square Tiles
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              crossAxisCount: 2, // Two tiles per row
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
          _buildSquareTile(
            context: context, // Add this line
            title: "Beginner",
            subtitle: "White to Orange",
            count: "12",
            icon: Icons.accessibility_new,
            color: Colors.white10,
          ),
          _buildSquareTile(
            context: context, // Added context
            title: "Intermediate",
            subtitle: "Green to Brown",
            count: "8",
            icon: Icons.sports_martial_arts,
            color: Colors.white10,
          ),
          _buildSquareTile(
            context: context, // Added context
            title: "Advanced",
            subtitle: "Black Belt +",
            count: "24",
            icon: Icons.military_tech,
            color: Colors.white10, 
          ),
          _buildSquareTile(
            context: context, // Added context
            title: "Team Kata",
            subtitle: "5 Active",
            count: "5",
            icon: Icons.groups,
            color: Colors.white10,
          ),
          _buildSquareTile(
            context: context, // Added context
            title: "Kobudo",
            subtitle: "Weapons",
            count: "3",
            icon: Icons.sports_kabaddi,
            color: Colors.white10,
              ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSquareTile({
    required BuildContext context, // Added context to access Navigator
    required String title,
    required String subtitle,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    bool isRed = color == Colors.red;
    
    // Wrapping the entire tile in GestureDetector for a better user experience
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KataEventsScreen(
              categoryName: title,
              eventCount: int.parse(count),
              // Logical prefix mapping
              categoryPrefix: (title == "Beginner") 
                  ? "1" 
                  : (title == "Intermediate") 
                      ? "2" 
                      : "3",
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isRed ? Colors.red : const Color(0xFF251818),
          borderRadius: BorderRadius.circular(25),
          // Added a slight border to standard tiles to match the UI style
          border: isRed ? null : Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 30),
                // The badge remains as a visual element
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRed ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isRed ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}