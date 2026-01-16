// import 'dart:math'; // For random number generation
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igka_tournament/screens/kumite/kumitehistory.dart';
import 'package:igka_tournament/screens/kumite/kumitescoring.dart';

class KumiteEventsScreen extends StatefulWidget {
  // Receive the assigned Tatami from Home Screen
  final String? assignedTatami;

  const KumiteEventsScreen({
    super.key, 
    this.assignedTatami,
  });

  @override
  _KumiteEventsScreenState createState() => _KumiteEventsScreenState();
}

class _KumiteEventsScreenState extends State<KumiteEventsScreen> {
  final TextEditingController _eventController = TextEditingController();
  late String _currentTatami;

  @override
  void initState() {
    super.initState();
    // Default to the logged-in Tatami, or fallback to Tatami 1
    _currentTatami = widget.assignedTatami ?? 'Tatami 1';
  }

  // --- FIREBASE: Add Event ---
// --- FIREBASE: Add Event (Sequential) ---
  Future<void> _addEventToDb(String eventName) async {
    try {
      // 1. Count how many events currently exist for THIS Tatami
      // We use .get() to fetch the current list
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('kumite_events')
          .where('tatami', isEqualTo: _currentTatami)
          .get();
      
      // 2. Calculate the next number (Current Count + 1)
      int nextNumber = snapshot.docs.length + 1;

      // 3. Create a unique Sequential ID
      // Example Result: "Event_1_Tatami1", "Event_2_Tatami1"
      // We remove spaces from 'Tatami 1' to make it cleaner in the database
      String safeTatamiName = _currentTatami.replaceAll(' ', ''); 
      String sequentialId = "Event_${nextNumber}_$safeTatamiName";

      await FirebaseFirestore.instance
          .collection('kumite_events')
          .doc(sequentialId) // <--- Using the new ID here
          .set({
        'eventName': eventName,
        'tatami': _currentTatami,
        'isLocked': false,
        'idNumber': nextNumber, // Saving the number just in case you need it later
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error adding event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // --- FIREBASE: Lock Event ---
  Future<void> _lockEventInDb(String docId) async {
    await FirebaseFirestore.instance
        .collection('kumite_events')
        .doc(docId)
        .update({'isLocked': true});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Kumite Events ($_currentTatami)", // Show current Tatami
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Events",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          
          // --- STREAM BUILDER (Real-time Data) ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('kumite_events')
                  .where('tatami', isEqualTo: _currentTatami) // Filter by Tatami
                  // .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No events found.", style: TextStyle(color: Colors.white54)));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    String docId = docs[index].id;
                    String eName = data['eventName'] ?? 'Unknown';
                    bool isLocked = data['isLocked'] ?? false;
                    String fullEventId = "$eName - $_currentTatami";

                    return Container(
  margin: const EdgeInsets.symmetric(vertical: 8),
  padding: EdgeInsets.symmetric(
    vertical: height * 0.02,
    horizontal: width * 0.05,
  ),
  decoration: BoxDecoration(
    color: const Color(0xFF251818), // Dark card background
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // FIX: Added " - $_currentTatami" to match your screenshot
      Text(
        "Event $eName - $_currentTatami", 
        style: TextStyle(
          color: isLocked ? Colors.white54 : Colors.white,
          fontSize: 16,
          decoration: isLocked ? TextDecoration.lineThrough : null,
        ),
      ),
      Row(
        children: [
          // 1. Lock Icon (Red)
          IconButton(
            onPressed: () {
               if (isLocked) _showLockedMessage();
               else _confirmLockEvent(docId);
            },
            icon: Icon(
              isLocked ? Icons.lock : Icons.lock_open, // Shows lock when locked
              color: isLocked ? Colors.red : Colors.redAccent, // Red color
              size: 20,
            ),
          ),
          
          // 2. Refresh Icon (Blue)
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KumiteEventHistoryScreen(eventName: fullEventId),
                ),
              );
            },
            icon: const Icon(Icons.refresh_rounded, color: Colors.blue, size: 20),
          ),

          // 3. Arrow Icon (Orange)
          IconButton(
            onPressed: () {
              if (isLocked) {
                _showLockedMessage();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KumiteMatchScreen(
                      matchDuration: const Duration(minutes: 0),
                      eventName: fullEventId,
                      tatamiName: _currentTatami,
                      matchNumber: 1,
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: isLocked ? Colors.grey : Colors.orangeAccent,
              size: 20,
            ),
          ),
        ],
      ),
    ],
  ),
);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddEventDialog(context),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF251818),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Text("Add New Event", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _eventController,
                  style: const TextStyle(color: Colors.white),
                  // RESTRICTION: Max 4 Characters
                  maxLength: 4, 
                  decoration: InputDecoration(
                    hintText: "Event",
                    hintStyle: const TextStyle(color: Colors.grey),
                    counterStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF251818),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
                const SizedBox(height: 10),
                // DROPDOWN DISABLED (Fixed to Login Tatami)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _currentTatami,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                 _eventController.clear();
                 Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (_eventController.text.isNotEmpty) {
                  _addEventToDb(_eventController.text.toUpperCase());
                  _eventController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Event", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmLockEvent(String docId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF251818),
        title: const Text("End Event?", style: TextStyle(color: Colors.white)),
        content: const Text("This will lock the match screen.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Lock"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _lockEventInDb(docId);
    }
  }

  void _showLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event is locked!")));
  }
}