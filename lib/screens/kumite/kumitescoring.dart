import 'dart:async';
import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kumite/kumitelog.dart';
import 'package:igka_tournament/model/storage.dart';

class KumiteMatchScreen extends StatefulWidget {
  final String eventName;
  final String tatamiName;
  final int matchNumber;
  final Duration matchDuration;

  const KumiteMatchScreen({
    super.key,
    required this.matchDuration,
    required this.eventName,
    required this.tatamiName,
    required this.matchNumber,
  });

  @override
  State<KumiteMatchScreen> createState() => _KumiteMatchScreenState();
}

class _KumiteMatchScreenState extends State<KumiteMatchScreen> {
  // --- STATE PERSISTENCE ---
  static final Map<String, int> _eventMatchCounters = {};

  // Score & Penalties
  int akaScore = 0;
  int aoScore = 0;
  bool isAkaSenshu = false;
  bool isAoSenshu = false;
  int akaWarnings = 0;
  int aoWarnings = 0;

  // Match State
  late int _currentMatchNumber;
  List<Map<String, dynamic>> matchLogs = [];
  Timer? _timer;
  late Duration _remainingTime;
  bool _isRunning = false;
  bool _isMatchOver = false;
  bool _hasMatchStarted = false;

  // --- NEW: Interaction Guard ---
// --- NEW: Interaction Guard ---
  // Buttons are enabled ONLY if:
  // 1. Match isn't over
  // 2. Time is on the clock
  // 3. Timer is NOT running (must be paused to score)
  // Update this getter
bool get _canInteract => 
    !_isMatchOver && 
    _remainingTime.inSeconds > 0 && 
    !_isRunning && 
    _hasMatchStarted; // <--- ADD THIS

  @override
  void initState() {
    super.initState();
    // Load saved match number or use default
    if (_eventMatchCounters.containsKey(widget.eventName)) {
      _currentMatchNumber = _eventMatchCounters[widget.eventName]!;
    } else {
      _currentMatchNumber = widget.matchNumber;
      _eventMatchCounters[widget.eventName] = _currentMatchNumber;
    }
    _remainingTime = widget.matchDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- LOGIC: Winner Calculation ---
  String _calculateWinnerName() {
    if (akaWarnings >= 4) return "AO";
    if (aoWarnings >= 4) return "AKA";
    if (akaScore - aoScore >= 8) return "AKA";
    if (aoScore - akaScore >= 8) return "AO";
    if (akaScore > aoScore) return "AKA";
    if (aoScore > akaScore) return "AO";
    if (isAkaSenshu) return "AKA (S)";
    if (isAoSenshu) return "AO (S)";
    return "HANTEI";
  }

  // --- UI Helper ---
  void _showStatus(String msg, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- LOGIC: Manual Senshu ---
  void _toggleSenshu(bool isAka) {
// Replace the top "if" block in all scoring functions with this:
if (!_canInteract) {
  if (!_hasMatchStarted) {
     _showStatus("Start the timer first", Colors.redAccent);
  } else if (_isRunning) {
     _showStatus("Pause timer to adjust score", Colors.orange);
  } else if (_isMatchOver) {
     _showStatus("Match is over", Colors.grey);
  }
  return;
}
    
    setState(() {
      if (isAka) {
        if (isAkaSenshu) {
          isAkaSenshu = false;
          _addLog("AKA", "SENSHU", "REMOVED", Colors.grey);
        } else {
          isAkaSenshu = true;
          isAoSenshu = false; // Mutual exclusion
          _addLog("AKA", "SENSHU", "AWARDED", Colors.red);
        }
      } else {
        if (isAoSenshu) {
          isAoSenshu = false;
          _addLog("AO", "SENSHU", "REMOVED", Colors.grey);
        } else {
          isAoSenshu = true;
          isAkaSenshu = false;
          _addLog("AO", "SENSHU", "AWARDED", Colors.blue);
        }
      }
    });
  }

  // --- LOGIC: End Match ---
  void _endMatchManually({String reason = "FORCED END"}) {
    setState(() {
      _isMatchOver = true;
      _timer?.cancel();
      _isRunning = false;
      _addLog("SYSTEM", reason, "--", Colors.red);
    });
    _showStatus("Match $_currentMatchNumber ended ($reason)", Colors.blueGrey.shade900);
  }

  // --- LOGIC: Reset ---
  Future<void> _handleReset() async {
    if (akaScore > 0 || aoScore > 0 || _isMatchOver || matchLogs.isNotEmpty) {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1111),
          title: const Text("Reset Match?", style: TextStyle(color: Colors.white)),
          content: const Text(
            "This will clear scores and move to the NEXT match number. Continue?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("RESET & NEXT"),
            ),
          ],
        ),
      );

      if (confirm == true) _performReset();
    } else {
      _performReset();
    }
  }

  void _performReset() {
    MatchHistoryStorage.addMatch(
      eventName: widget.eventName,
      matchNumber: _currentMatchNumber,
      akaScore: akaScore,
      aoScore: aoScore,
      winner: _calculateWinnerName(),
    );
    setState(() {
      _currentMatchNumber++;
      _hasMatchStarted = false;
      _eventMatchCounters[widget.eventName] = _currentMatchNumber;
      _remainingTime = widget.matchDuration;
      _isMatchOver = false;
      _isRunning = false;
      akaScore = 0;
      aoScore = 0;
      akaWarnings = 0;
      aoWarnings = 0;
      isAkaSenshu = false;
      isAoSenshu = false;
      matchLogs.clear();
    });
    _showStatus("New Match Ready: M-$_currentMatchNumber", Colors.green);
  }

  // --- LOGIC: Logging ---
  void _addLog(String fighter, String action, String points, Color color) {
    setState(() {
      matchLogs.insert(0, {
        "time": _formatTime(_remainingTime),
        "fighter": fighter,
        "action": action,
        "points": points,
        "color": color,
      });
    });
  }

  // --- LOGIC: Scoring ---
  void _updateScore(bool isAka, int value) {
    // Replace the top "if" block in all scoring functions with this:
if (!_canInteract) {
  if (!_hasMatchStarted) {
     _showStatus("Start the timer first", Colors.redAccent);
  } else if (_isRunning) {
     _showStatus("Pause timer to adjust score", Colors.orange);
  } else if (_isMatchOver) {
     _showStatus("Match is over", Colors.grey);
  }
  return;
}
    setState(() {
      if (isAka) {
        akaScore = (akaScore + value).clamp(0, 99);
        _addLog("AKA", "ADJUST", value > 0 ? "+$value" : "$value", Colors.red);
      } else {
        aoScore = (aoScore + value).clamp(0, 99);
        _addLog("AO", "ADJUST", value > 0 ? "+$value" : "$value", Colors.blue);
      }
      _checkWinConditions();
    });
  }

  void _addPointLog(bool isAka, int pts, String action, Color accent) {
   // Replace the top "if" block in all scoring functions with this:
if (!_canInteract) {
  if (!_hasMatchStarted) {
     _showStatus("Start the timer first", Colors.redAccent);
  } else if (_isRunning) {
     _showStatus("Pause timer to adjust score", Colors.orange);
  } else if (_isMatchOver) {
     _showStatus("Match is over", Colors.grey);
  }
  return;
}
    setState(() {
      if (isAka) akaScore += pts; else aoScore += pts;
      _addLog(isAka ? "AKA" : "AO", action, "+$pts", accent);
      _checkWinConditions();
    });
  }

  void _checkWinConditions() {
    if ((akaScore - aoScore).abs() >= 8) {
      _endMatchManually(reason: "8-POINT GAP");
    }
  }

  // --- LOGIC: Warnings (Hansoku) ---
  void _updateWarning(bool isAka, int val) {
   // Replace the top "if" block in all scoring functions with this:
if (!_canInteract) {
  if (!_hasMatchStarted) {
     _showStatus("Start the timer first", Colors.redAccent);
  } else if (_isRunning) {
     _showStatus("Pause timer to adjust score", Colors.orange);
  } else if (_isMatchOver) {
     _showStatus("Match is over", Colors.grey);
  }
  return;
}
    setState(() {
      if (isAka) {
        akaWarnings = (akaWarnings + val).clamp(0, 4);
        _addLog("AKA", "PENALTY", "C$akaWarnings", Colors.red);
        
        // Rule: Senshu voided at 3 warnings (Hansoku Chui)
        if (akaWarnings >= 3 && isAkaSenshu) {
          isAkaSenshu = false;
          _addLog("AKA", "SENSHU", "VOIDED (W)", Colors.orange);
        }
        if (akaWarnings == 4) _handleHansoku(true);
      } else {
        aoWarnings = (aoWarnings + val).clamp(0, 4);
        _addLog("AO", "PENALTY", "C$aoWarnings", Colors.blue);
        
        if (aoWarnings >= 3 && isAoSenshu) {
          isAoSenshu = false;
          _addLog("AO", "SENSHU", "VOIDED (W)", Colors.orange);
        }
        if (aoWarnings == 4) _handleHansoku(false);
      }
    });
  }

  void _handleHansoku(bool isAkaDisqualified) {
    _isMatchOver = true;
    _isRunning = false;
    _timer?.cancel();
    String winner = isAkaDisqualified ? "AO" : "AKA";
    _addLog(winner, "WINNER", "HANSOKU", isAkaDisqualified ? Colors.blue : Colors.red);
    _showStatus("HANSOKU! $winner Wins.", isAkaDisqualified ? Colors.blue : Colors.red);
  }

  // --- LOGIC: Timer ---
void _toggleTimer() {
    // 1. Validation: Cannot start if time is 0 and not running
    if (!_isRunning && _remainingTime.inSeconds == 0) {
      _showStatus("Please set a time first", Colors.redAccent);
      return;
    }

    if (_isRunning) {
      // 2. Pause Logic
      _timer?.cancel();
      setState(() => _isRunning = false);
      _addLog("SYSTEM", "TIMER PAUSED", "YAME", Colors.orange);
    } else {
      // 3. Start Logic
      setState(() {
      _isRunning = true;
      _isMatchOver = false;
      _hasMatchStarted = true;
      });
      _addLog("SYSTEM", "TIMER STARTED", "HAJIME", Colors.green);
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime.inSeconds > 0) {
          setState(() => _remainingTime -= const Duration(seconds: 1));
        } else {
          // 4. Time Up Logic
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _isMatchOver = true;
          });

          // --- NEW LOGIC: Calculate Winner & Color ---
          String winner = _calculateWinnerName();
          Color statusColor;
          String statusMsg;

          if (winner.contains("AKA")) {
            statusColor = Colors.red;
            statusMsg = "Time Up! AKA Wins";
          } else if (winner.contains("AO")) {
            statusColor = Colors.blue;
            statusMsg = "Time Up! AO Wins";
          } else {
            // HANTEI (Draw/Decision)
            statusColor = Colors.amber;
            statusMsg = "Time Up! HANTEI (Decision)";
          }

          _addLog("SYSTEM", "TIME UP", "00:00", Colors.grey);
          
          // Show the specific winner toast
          _showStatus(statusMsg, statusColor);
        }
      });
    }
  }

  String _formatTime(Duration d) =>
      "${d.inMinutes.remainder(60).toString().padLeft(2, "0")}:${d.inSeconds.remainder(60).toString().padLeft(2, "0")}";

  // --- UI BUILD ---
  @override
  Widget build(BuildContext context) {
    bool isAtoshuBaraku = _remainingTime.inSeconds <= 15 && _remainingTime.inSeconds > 0;
    
    // Win Conditions
    bool akaWinsByHansoku = aoWarnings == 4;
    bool aoWinsByHansoku = akaWarnings == 4;
    bool akaWinsByScore = _isMatchOver && !akaWinsByHansoku && !aoWinsByHansoku && 
        (akaScore > aoScore || (akaScore == aoScore && isAkaSenshu));
    bool aoWinsByScore = _isMatchOver && !akaWinsByHansoku && !aoWinsByHansoku && 
        (aoScore > akaScore || (aoScore == akaScore && isAoSenshu));
    bool akaWins = akaWinsByHansoku || akaWinsByScore;
    bool aoWins = aoWinsByHansoku || aoWinsByScore;
    bool isHantei = _isMatchOver && akaScore == aoScore && !isAkaSenshu && !isAoSenshu && akaWarnings < 4 && aoWarnings < 4;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B0B),
      appBar: AppBar(backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "${widget.eventName} | Match-$_currentMatchNumber",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: (_isMatchOver || _remainingTime.inSeconds == 0) ? null : () => _endMatchManually(),
            child: Text(
              "End Match",
              style: TextStyle(
                color: (_isMatchOver || _remainingTime.inSeconds == 0) ? Colors.white24 : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // HANTEI BANNER
          if (isHantei)
            Container(
              width: double.infinity,
              color: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Text(
                "HANTEI (JUDGE DECISION REQUIRED)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
            
          // Timer Control Bar
          Container(
            color: const Color(0xFF1A1111),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _isMatchOver ? null : _showTimeEntryDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: isAtoshuBaraku ? Colors.red.withOpacity(0.2) : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isAtoshuBaraku ? Colors.red : Colors.white10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_remainingTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (isAtoshuBaraku)
                          const Text(
                            "ATOSHI BARAKU",
                            style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),
                _controlBtn(Icons.play_arrow, Colors.green, _toggleTimer, active: !_isRunning && !_isMatchOver && _remainingTime.inSeconds > 0),
                _controlBtn(Icons.pause, Colors.orange, _toggleTimer, active: _isRunning && !_isMatchOver),
                _controlBtn(Icons.save_alt_outlined, Colors.grey, _handleReset, active: true),
                _controlBtn(Icons.history, Colors.blueAccent, _navigateToLogs, active: true),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    _buildFighterColumn("AKA", const Color(0xFF4A0000), Colors.red, true, akaWins, constraints),
                    _buildFighterColumn("AO", const Color(0xFF001A4A), Colors.blue, false, aoWins, constraints),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER METHODS ---

  Widget _buildFighterColumn(String label, Color bg, Color accent, bool isAka, bool isWinner, BoxConstraints constraints) {
    int score = isAka ? akaScore : aoScore;
    int warnings = isAka ? akaWarnings : aoWarnings;
    bool hasSenshu = isAka ? isAkaSenshu : isAoSenshu;
    // Use the guard variable here
    bool canInteract = _canInteract; 

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          border: isWinner
              ? Border.all(color: const Color.fromARGB(255, 162, 255, 210), width: 5)
              : Border(left: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.5)),
        ),
        child: Column(
          children: [
            SizedBox(height: constraints.maxHeight * 0.02),
            _buildAvatar(accent, hasSenshu),
            Text(label, style: TextStyle(color: accent, fontSize: 22, fontWeight: FontWeight.w900)),
            const Spacer(),
            
            // --- MANUAL SENSHU BUTTONS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: canInteract ? () => _toggleSenshu(isAka) : null, 
                  icon: Icon(hasSenshu ? Icons.remove_circle : Icons.add_circle, color: canInteract ? Colors.white24 : Colors.transparent, size: 20)
                ),
                GestureDetector(
                  onTap: canInteract ? () => _toggleSenshu(isAka) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: hasSenshu ? Colors.amber : Colors.white10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "SENSHU", 
                      style: TextStyle(
                        color: hasSenshu ? Colors.black : (canInteract ? Colors.white38 : Colors.white10), 
                        fontWeight: FontWeight.bold, 
                        fontSize: 10
                      )
                    ),
                  ),
                ),
              ],
            ),
            
            _buildScoreRow(score, isAka, canInteract),
            const Text("POINTS", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
            const Spacer(),
            _scoreBtn("IPPON +3", Colors.black26, !canInteract ? null : () => _addPointLog(isAka, 3, "IPPON", accent)),
            _scoreBtn("WAZA +2", Colors.black26, !canInteract ? null : () => _addPointLog(isAka, 2, "WAZA-ARI", accent)),
            _scoreBtn("YUKO +1", Colors.black26, !canInteract ? null : () => _addPointLog(isAka, 1, "YUKO", accent)),
            const SizedBox(height: 10),
            _buildWarningRow(warnings, isAka, canInteract, accent),
            const Text("WARNINGS", style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
            SizedBox(height: constraints.maxHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Color accent, bool hasSenshu) {
    return FittedBox(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
              radius: 30,
              backgroundColor: accent.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.white24, size: 30)),
          if (hasSenshu)
            const Positioned(top: -5, right: -5, child: Icon(Icons.stars, color: Colors.amber, size: 24)),
        ],
      ),
    );
  }

  Widget _buildScoreRow(int score, bool isAka, bool canInteract) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: !canInteract ? null : () => _updateScore(isAka, -1),
            icon: Icon(Icons.remove_circle_outline, color: canInteract ? Colors.white24 : Colors.white10),
          ),
          Text("$score", style: TextStyle(color: canInteract ? Colors.white : Colors.white24, fontSize: 70, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: !canInteract ? null : () => _updateScore(isAka, 1),
            icon: Icon(Icons.add_circle_outline, color: canInteract ? Colors.white24 : Colors.white10),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningRow(int warnings, bool isAka, bool canInteract, Color accent) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: (!canInteract || (isAka ? akaWarnings : aoWarnings) == 0) ? null : () => _updateWarning(isAka, -1),
              icon: Icon(Icons.remove_circle_outline, color: canInteract ? Colors.white24 : Colors.white10, size: 20)),
          ...List.generate(
              4,
              (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < warnings ? accent : Colors.transparent,
                      border: Border.all(color: i < warnings ? accent : (canInteract ? Colors.white24 : Colors.white10), width: 2)))),
          IconButton(
              onPressed: (!canInteract || (isAka ? akaWarnings : aoWarnings) == 4) ? null : () => _updateWarning(isAka, 1),
              icon: Icon(Icons.add_circle_outline, color: canInteract ? Colors.white24 : Colors.white10, size: 20)),
        ],
      ),
    );
  }

  Widget _controlBtn(IconData icon, Color color, VoidCallback onTap, {bool active = true}) {
    return IconButton(
      onPressed: active ? onTap : null,
      icon: Icon(icon, color: active ? color : color.withOpacity(0.1), size: 30),
    );
  }

  Widget _scoreBtn(String text, Color color, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: SizedBox(
        width: double.infinity,
        height: 35,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: onTap == null ? color.withOpacity(0.05) : color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            elevation: 0,
          ),
          onPressed: onTap,
          child: Text(text,
              style: TextStyle(color: onTap == null ? Colors.white10 : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Future<void> _showTimeEntryDialog() async {
    if (_isRunning || _isMatchOver) return;
    final minController = TextEditingController();
    final secController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1111),
        title: const Text("Enter Match Time", style: TextStyle(color: Colors.white)),
        content: Row(
          children: [
            Expanded(child: _buildTimeInputField(minController, "Min")),
            const Text(" : ", style: TextStyle(color: Colors.white, fontSize: 24)),
            Expanded(child: _buildTimeInputField(secController, "Sec")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                int mins = int.tryParse(minController.text) ?? 0;
                int secs = int.tryParse(secController.text) ?? 0;
                _remainingTime = Duration(minutes: mins, seconds: secs);
                _isMatchOver = false;
              });
              Navigator.pop(context);
            },
            child: const Text("SET"),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
      ),
    );
  }

  void _navigateToLogs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KumiteLogScreen(
          logs: matchLogs,
          akaTotal: akaScore,
          aoTotal: aoScore,
          onClear: () => setState(() => matchLogs.clear()),
        ),
      ),
    );
  }
}