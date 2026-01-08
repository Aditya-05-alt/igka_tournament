import 'package:flutter/material.dart';

class KumiteLogScreen extends StatelessWidget {
  final List<Map<String, dynamic>> logs;
  final int akaTotal;
  final int aoTotal;
  final VoidCallback onClear;

  const KumiteLogScreen({
    super.key,
    required this.logs,
    required this.akaTotal,
    required this.aoTotal,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "MATCH LOGS",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Summary Stats Container
          Container(
            padding: EdgeInsets.all(screenWidth * 0.05), // Dynamic padding
            color: const Color(0xFF1A1111),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat("AKA", "$akaTotal", Colors.red),
                Container(width: 1, height: screenHeight * 0.05, color: Colors.white10),
                _buildSummaryStat("AO", "$aoTotal", Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Logs List View
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text("No actions recorded yet", style: TextStyle(color: Colors.white24)),
                  )
                : ListView.builder(
                    itemCount: logs.length,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Dynamic padding
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1111),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                          gradient: LinearGradient(
                            stops: const [0.02, 0.02],
                            colors: [log['color'], const Color(0xFF1A1111)],
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              log['time'],
                              style: const TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log['fighter'],
                                  style: TextStyle(color: log['color'], fontWeight: FontWeight.w900, fontSize: 12),
                                ),
                                Text(
                                  log['action'],
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              log['points'],
                              style: TextStyle(color: log['color'], fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Clear Log History Button
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), // Dynamic padding
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.08, // Dynamic height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D1919),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  onClear();
                  Navigator.pop(context);
                },
                child: const Text(
                  "CLEAR LOG HISTORY",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
      ],
    );
  }
}
