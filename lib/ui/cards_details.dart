import 'package:flutter/material.dart';

class ModeSelectionCard extends StatelessWidget {
  final String category;
  final String subTitle;
  final String title;
  final String description;
  final String footerLabel;
  final IconData icon;
  final String imagePath;
  final String routeName;
  
  // 1. Add this optional callback
  final VoidCallback? onTap; 

  const ModeSelectionCard({
    super.key,
    required this.category,
    required this.subTitle,
    required this.title,
    required this.description,
    required this.footerLabel,
    required this.icon,
    required this.imagePath,
    required this.routeName,
    this.onTap, // 2. Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        // 3. FIX THE LOGIC: Check for onTap first!
        onTap: () {
          if (onTap != null) {
            // Priority 1: Run the custom code (Navigation with data)
            onTap!();
          } else if (routeName.isNotEmpty) {
            // Priority 2: Run standard navigation
            Navigator.pushNamed(context, routeName);
          }
        },
        splashColor: Colors.white10,
        child: Container(
          // ... (Rest of your Container/Decoration code remains exactly the same) ...
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
              // ... (Your UI Row/Text code remains exactly the same) ...
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Icons.arrow_outward, color: Colors.white, size: 24),
                ],
              ),
              const Spacer(),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
              Text(description, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
              // ... etc ...
            ],
          ),
        ),
      ),
    );
  }
}