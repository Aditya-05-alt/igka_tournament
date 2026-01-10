import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this to use FilteringTextInputFormatter

import 'package:igka_tournament/screens/kumite/kumitescoring.dart';

class KumiteEventsScreen extends StatefulWidget {
  const KumiteEventsScreen({super.key});

  @override
  _KumiteEventsScreenState createState() => _KumiteEventsScreenState();
}

class _KumiteEventsScreenState extends State<KumiteEventsScreen> {
  List<String> events = []; // List to store event names
  String selectedTatami = 'Tatami 1'; // Default value for the dropdown
  TextEditingController eventController =
      TextEditingController(); // Controller for event name input

  void _addEvent(String event, String tatami) {
    setState(() {
      events.add("$event - $tatami"); // Combine event and tatami for display
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsiveness
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
          Padding(
            padding: EdgeInsets.all(width * 0.05), // Responsive padding
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ), // Responsive padding
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
            child: Text(
              "Events",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // List of Events
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ), // Responsive padding
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.02,
                    horizontal: width * 0.05,
                  ), // Responsive padding
                  decoration: BoxDecoration(
                    color: const Color(0xFF251818),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Event ${events[index]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              print("Rename pressed");
                            },
                            icon: const Icon(
                              Icons.textsms_outlined,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 
                          5),

                          IconButton(
                            onPressed: () {
                              print("Refresh pressed");
                            },
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 5),
                          IconButton(
  onPressed: () {
    // 1. Get the raw string, e.g., "1A - Tatami 1"
    String rawData = events[index]; 
    
    // 2. Split the data into Event and Tatami
    List<String> parts = rawData.split(" - ");
    String eName = parts[0]; // e.g., "1A"
    String tName = parts.length > 1 ? parts[1] : "Tatami 1";

    // 3. Navigate and pass the specific data
 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => KumiteMatchScreen(
      matchDuration: const Duration(minutes: 0),
      eventName: "Event - $eName", 
      tatamiName: tName,
      matchNumber: 1, // Start every event session at Match 1
    ),
  ),
);
  },
  icon: const Icon(
    Icons.arrow_forward_ios,
    color: Colors.orangeAccent,
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
        onPressed: () {
          // Show an AlertDialog when the FAB is clicked
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF251818),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: const Text(
                  "Add Event",
                  style: TextStyle(color: Colors.white),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Event Name TextField
                      TextField(
                        controller:
                            eventController, // Text controller for event input
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter event name...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                          
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3),
                            width: 10
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF251818),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'),
                          ), // Allows only alphabets and numbers
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Wrapping DropdownButton with a Container to add a border
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Adjust padding
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15), // Rounded corners
                              border: Border.all(
                                color: Colors.white, // Border color
                                width: 1.5, // Border width
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: selectedTatami,
                              dropdownColor: const Color(0xFF251818),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              style: const TextStyle(color: Colors.white),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTatami = newValue!; // Update selectedTatami when an option is chosen
                                });
                              },
                              items: <String>['Tatami 1', 'Tatami 2']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add the event with selected Tatami
                      String event = eventController.text;
                      if (event.isNotEmpty) {
                        _addEvent(
                          event,
                          selectedTatami,
                        ); // Add event with selected Tatami
                        Navigator.pop(context); // Close the dialog
                      }
                    },
                    child: const Text(
                      "Add Event",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
