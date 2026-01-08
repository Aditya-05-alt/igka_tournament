import 'package:flutter/material.dart';

class ModeSelectionCard extends StatelessWidget {
  final String category;
  final String subTitle;
  final String title;
  final String description;
  final String footerLabel;
  final IconData icon;
  final String imagePath;
  // 1. Add a VoidCallback or a String for the route
  final String routeName; 

  const ModeSelectionCard({
    super.key,
    required this.category,
    required this.subTitle,
    required this.title,
    required this.description,
    required this.footerLabel,
    required this.icon,
    required this.imagePath,
    required this.routeName, // Require the route name
  });

  @override
  Widget build(BuildContext context) {
    return Card( // Use Card to provide a clean boundary for the splash effect
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        onTap: () {
          // 2. Navigate using the named route
          Navigator.pushNamed(context, routeName);
        },
        borderRadius: BorderRadius.circular(28),
        splashColor: Colors.white10,
        child: Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), 
                BlendMode.darken,
              ),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category, 
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.arrow_outward, color: Colors.white, size: 24),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(icon, color: Colors.white.withOpacity(0.7), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    subTitle, 
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7), 
                      fontSize: 14, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Text(
                title, 
                style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900),
              ),
              Text(
                description, 
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
              ),
              const SizedBox(height: 15),
              if (footerLabel.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        footerLabel, 
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}