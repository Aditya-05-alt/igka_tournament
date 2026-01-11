import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igka_tournament/screens/kumite/kumitescoring.dart';
import 'package:igka_tournament/screens/kumite/kumitehistory.dart';

class KumiteEventsScreen extends StatefulWidget {
  const KumiteEventsScreen({super.key});

  @override
  _KumiteEventsScreenState createState() => _KumiteEventsScreenState();
}

class _KumiteEventsScreenState extends State<KumiteEventsScreen> {
  // CHANGED: List now stores Objects to track 'isLocked' status
  List<Map<String, dynamic>> events = [];
  
  String selectedTatami = 'Tatami 1';
  TextEditingController eventController = TextEditingController();

  void _addEvent(String eventName, String tatami) {
    setState(() {
      events.add({
        'name': eventName,
        'tatami': tatami,
        'isLocked': false, // Default is unlocked
      });
    });
  }

  // --- NEW: Lock Confirmation Dialog ---
  Future<void> _confirmLockEvent(int index) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF251818),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("End Event?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure want to end the event?\nThis will lock the match screen.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("End Event"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        events[index]['isLocked'] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event Ended. Matches locked.")),
      );
    }
  }

  // --- NEW: Message when tapping locked items ---
  void _showLockedMessage() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Event ended. View the history.", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        duration: Duration(seconds: 2),
      ),
    );
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
        title: const Text(
          "Kumite Events",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          // Padding(
          //   padding: EdgeInsets.all(width * 0.05),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          //     decoration: BoxDecoration(
          //       color: const Color(0xFF251818),
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: const TextField(
          //       style: TextStyle(color: Colors.white),
          //       decoration: InputDecoration(
          //         icon: Icon(Icons.search, color: Colors.grey),
          //         hintText: "Search by style or belt level...",
          //         hintStyle: TextStyle(color: Colors.grey),
          //         border: InputBorder.none,
          //         suffixIcon: Icon(Icons.tune, color: Colors.grey),
          //       ),
          //     ),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Events",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // List of Events
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                String eName = event['name'];
                String tName = event['tatami'];
                bool isLocked = event['isLocked'];
                String fullEventId = "Event - $eName";

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.05,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF251818),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Event $eName - $tName",
                        style: TextStyle(
                          color: isLocked ? Colors.white54 : Colors.white,
                          fontSize: 16,
                          decoration: isLocked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Row(
                        children: [
                          // --- LOCK BUTTON ---
                          IconButton(
                            onPressed: () {
                              if (isLocked) {
                                _showLockedMessage();
                              } else {
                                _confirmLockEvent(index);
                              }
                            },
                            icon: Icon(
                              isLocked ? Icons.lock : Icons.lock_open,
                              color: isLocked ? Colors.grey : Colors.redAccent,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 5),

                          // --- HISTORY/REFRESH BUTTON (Always Active) ---
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KumiteEventHistoryScreen(
                                    eventName: fullEventId,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 5),

                          // --- GO TO MATCH BUTTON (Conditional) ---
                          IconButton(
                            onPressed: () {
                              if (isLocked) {
                                // If locked, show message
                                _showLockedMessage();
                              } else {
                                // If unlocked, navigate to match
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KumiteMatchScreen(
                                      matchDuration: const Duration(minutes: 0),
                                      eventName: fullEventId,
                                      tatamiName: tName,
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

  // Dialog (Same as before but using the new list logic)
  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF251818),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text("Add Event", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: eventController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter event name...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF251818),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedTatami,
                  dropdownColor: const Color(0xFF251818),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  items: ['Tatami 1', 'Tatami 2'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedTatami = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (eventController.text.isNotEmpty) {
                  _addEvent(eventController.text, selectedTatami);
                  eventController.clear(); // Clear input
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Event", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}