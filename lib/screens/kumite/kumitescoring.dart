import 'dart:async';
import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kumite/kumitelog.dart';

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

  @override
  void initState() {
    super.initState();
    _currentMatchNumber = widget.matchNumber;
    _remainingTime = widget.matchDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Helper for Toast/SnackBar messages
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

  // --- LOGIC: End Match ---
  void _endMatchManually({String reason = "FORCED END"}) {
    setState(() {
      _isMatchOver = true;
      _timer?.cancel();
      _isRunning = false;
      _addLog("SYSTEM", reason, "--", Colors.red);
    });

    _showStatus(
      "Match $_currentMatchNumber ended ($reason)",
      Colors.blueGrey.shade900,
    );
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

      if (confirm == true) {
        _performReset();
      }
    } else {
      _performReset();
    }
  }

  void _performReset() {
    setState(() {
      _currentMatchNumber++;
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

  // --- LOGIC: Scoring & Senshu ---
  void _updateScore(bool isAka, int value) {
    if (_isMatchOver) return;
    setState(() {
      if (isAka) {
        akaScore = (akaScore + value).clamp(0, 99);
        _addLog("AKA", "ADJUST", value > 0 ? "+$value" : "$value", Colors.red);
      } else {
        aoScore = (aoScore + value).clamp(0, 99);
        _addLog("AO", "ADJUST", value > 0 ? "+$value" : "$value", Colors.blue);
      }
      _calculateSenshu();
      _checkWinConditions();
    });
  }

  void _addPointLog(bool isAka, int pts, String action, Color accent) {
    if (_isMatchOver) return;
    setState(() {
      if (isAka) {
        akaScore += pts;
      } else {
        aoScore += pts;
      }
      _addLog(isAka ? "AKA" : "AO", action, "+$pts", accent);
      _calculateSenshu();
      _checkWinConditions();
    });
  }

  void _calculateSenshu() {
    // 1. If scores are equal, Senshu is lost.
    if (akaScore == aoScore) {
      if (isAkaSenshu || isAoSenshu) {
         _addLog("SYSTEM", "SENSHU LOST", "Equal Score", Colors.grey);
      }
      isAkaSenshu = false;
      isAoSenshu = false;
    } 
    // 2. If no one has Senshu, the leader gets it (First Point Rule)
    // Note: In WKF, if Senshu is lost (via equalizer), it is not re-awarded. 
    // However, if the score is 0-0, the first to score gets it.
    else if (!isAkaSenshu && !isAoSenshu) {
      // Only award if it was 0-0 before (implicit in flow) or if you want strict First Point logic:
      // Simple Logic: If leader has >0 and opponent has 0.
      if (akaScore > 0 && aoScore == 0) {
        isAkaSenshu = true;
        _addLog("AKA", "SENSHU", "Awarded", Colors.red);
      } else if (aoScore > 0 && akaScore == 0) {
        isAoSenshu = true;
        _addLog("AO", "SENSHU", "Awarded", Colors.blue);
      }
    }
  }

  void _checkWinConditions() {
    // 8 Point Gap Rule
    if ((akaScore - aoScore).abs() >= 8) {
      _endMatchManually(reason: "8-POINT GAP");
    }
  }

  // --- LOGIC: Warnings (Hansoku) ---
  void _updateWarning(bool isAka, int val) {
    setState(() {
      if (isAka) {
        akaWarnings = (akaWarnings + val).clamp(0, 4);
        _addLog("AKA", "PENALTY", "C$akaWarnings", Colors.red);
        if (akaWarnings == 4) _handleHansoku(true); // Aka disqualified
      } else {
        aoWarnings = (aoWarnings + val).clamp(0, 4);
        _addLog("AO", "PENALTY", "C$aoWarnings", Colors.blue);
        if (aoWarnings == 4) _handleHansoku(false); // Ao disqualified
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
    if (!_isRunning && _remainingTime.inSeconds == 0) {
      _showStatus("Please set a time first", Colors.redAccent);
      return;
    }

    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      _addLog("SYSTEM", "TIMER PAUSED", "YAME", Colors.orange);
    } else {
      setState(() {
        _isRunning = true;
        _isMatchOver = false;
      });
      _addLog("SYSTEM", "TIMER STARTED", "HAJIME", Colors.green);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime.inSeconds > 0) {
          setState(() => _remainingTime -= const Duration(seconds: 1));
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _isMatchOver = true;
          });
          _addLog("SYSTEM", "TIME UP", "00:00", Colors.grey);
          _showStatus("Time Up!", Colors.white);
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
    
    // Determine Winner Logic
    // 1. Disqualification (Hansoku)
    bool akaWinsByHansoku = aoWarnings == 4;
    bool aoWinsByHansoku = akaWarnings == 4;
    
    // 2. Score Logic (At End of Match)
    bool akaWinsByScore = _isMatchOver && !akaWinsByHansoku && !aoWinsByHansoku && 
        (akaScore > aoScore || (akaScore == aoScore && isAkaSenshu));
    
    bool aoWinsByScore = _isMatchOver && !akaWinsByHansoku && !aoWinsByHansoku && 
        (aoScore > akaScore || (aoScore == akaScore && isAoSenshu));

    // 3. Final Boolean for UI
    bool akaWins = akaWinsByHansoku || akaWinsByScore;
    bool aoWins = aoWinsByHansoku || aoWinsByScore;

    // 4. Hantei (Decision required if tied, no senshu, no hansoku)
    bool isHantei = _isMatchOver && akaScore == aoScore && !isAkaSenshu && !isAoSenshu && akaWarnings < 4 && aoWarnings < 4;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
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
                _controlBtn(Icons.play_arrow, Colors.green, _toggleTimer, active: !_isRunning && !_isMatchOver),
                _controlBtn(Icons.pause, Colors.orange, _toggleTimer, active: _isRunning && !_isMatchOver),
                _controlBtn(Icons.refresh, Colors.grey, _handleReset, active: true),
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
    // Allow interaction if match is not over, OR if we need to fix a mistake (admin override concept)
    // But typically buttons disable when match is over.
    bool canInteract = !_isMatchOver; 

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
            SizedBox(height: constraints.maxHeight * 0.03),
            _buildAvatar(accent, hasSenshu),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: accent, fontSize: 24, fontWeight: FontWeight.w900)),
            const Spacer(),
            _buildScoreRow(score, isAka, canInteract),
            const Text("POINTS", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
            const Spacer(),
            _scoreBtn("IPPON +3", Colors.black26, !canInteract ? null : () => _addPointLog(isAka, 3, "IPPON", accent)),
            _scoreBtn("WAZA +2", Colors.black26, !canInteract ? null : () => _addPointLog(isAka, 2, "WAZA-ARI", accent)),
            _scoreBtn("YUKO +1", Colors.black26, !canInteract ? null : () => _addPointLog(isAka, 1, "YUKO", accent)),
            const SizedBox(height: 15),
            _buildWarningRow(warnings, isAka, canInteract, accent),
            const Text("WARNINGS", style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
            SizedBox(height: constraints.maxHeight * 0.05),
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
              radius: 35,
              backgroundColor: accent.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.white24, size: 35)),
          if (hasSenshu)
            const Positioned(top: -5, right: -5, child: Icon(Icons.stars, color: Colors.yellow, size: 28)),
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
            icon: const Icon(Icons.remove_circle_outline, color: Colors.white24),
          ),
          Text("$score", style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: !canInteract ? null : () => _updateScore(isAka, 1),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white24),
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
              icon: const Icon(Icons.remove_circle_outline, color: Colors.white24, size: 20)),
          ...List.generate(
              4,
              (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < warnings ? accent : Colors.transparent,
                      border: Border.all(color: i < warnings ? accent : Colors.white24, width: 2)))),
          IconButton(
              onPressed: (!canInteract || (isAka ? akaWarnings : aoWarnings) == 4) ? null : () => _updateWarning(isAka, 1),
              icon: const Icon(Icons.add_circle_outline, color: Colors.white24, size: 20)),
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