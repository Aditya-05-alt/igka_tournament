import 'dart:async';
import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kumite/kumitelog.dart';

class KumiteMatchScreen extends StatefulWidget {
  final Duration matchDuration;
  const KumiteMatchScreen({super.key, this.matchDuration = Duration.zero});

  @override
  State<KumiteMatchScreen> createState() => _KumiteMatchScreenState();
}

class _KumiteMatchScreenState extends State<KumiteMatchScreen> {
  int akaScore = 0;
  int aoScore = 0;
  bool isAkaSenshu = false;
  bool isAoSenshu = false;
  int akaWarnings = 0;
  int aoWarnings = 0;
  List<Map<String, dynamic>> matchLogs = [];
  Timer? _timer;
  late Duration _remainingTime;
  bool _isRunning = false;
  bool _isMatchOver = false;
  bool _senshuAlreadyAwarded = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.matchDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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

  void _checkAndAwardSenshu(bool isAka) {
    if (_isMatchOver || _senshuAlreadyAwarded) return;

    if (!isAkaSenshu && !isAoSenshu) {
      setState(() {
        _senshuAlreadyAwarded = true;
        if (isAka) {
          isAkaSenshu = true;
          _addLog("AKA", "SENSHU AWARDED", "STAR", Colors.red);
        } else {
          isAoSenshu = true;
          _addLog("AO", "SENSHU AWARDED", "STAR", Colors.blue);
        }
      });
    }
  }

  void _toggleTimer() {
    if (!_isRunning && _remainingTime.inSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please update the timer"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      _addLog("SYSTEM", "TIMER PAUSED", "--", Colors.orange);
    } else {
      setState(() {
        _isRunning = true;
        _isMatchOver = false;
      });
      _addLog("SYSTEM", "TIMER STARTED", "--", Colors.green);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime.inSeconds > 0) {
          setState(() => _remainingTime -= const Duration(seconds: 1));
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _isMatchOver = true;
          });
          _addLog("SYSTEM", "MATCH ENDED", "00:00", Colors.grey);
        }
      });
    }
  }

  String _formatTime(Duration d) =>
      "${d.inMinutes.remainder(60).toString().padLeft(2, "0")}:${d.inSeconds.remainder(60).toString().padLeft(2, "0")}";

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

  @override
  Widget build(BuildContext context) {
    bool isAtoshuBaraku = _remainingTime.inSeconds <= 15 && _remainingTime.inSeconds > 0;
    bool akaWins = _isMatchOver && (akaScore > aoScore || (akaScore == aoScore && isAkaSenshu));
    bool aoWins = _isMatchOver && (aoScore > akaScore || (aoScore == akaScore && isAoSenshu));

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
        centerTitle: true,
        title: const Text("KUMITE SCORING", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2)),
        actions: [
          TextButton(
            onPressed: (_isMatchOver || _remainingTime.inSeconds == 0)
                ? null
                : () => setState(() {
                      _isMatchOver = true;
                      _timer?.cancel();
                      _isRunning = false;
                      _addLog("SYSTEM", "FORCED END", "--", Colors.red);
                    }),
            child: Text("End Match",
                style: TextStyle(
                    color: (_isMatchOver || _remainingTime.inSeconds == 0) ? Colors.white24 : Colors.red,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1A1111),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _isMatchOver ? null : _showTimeEntryDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: isAtoshuBaraku ? Colors.red.withOpacity(0.2) : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isAtoshuBaraku ? Colors.red : Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Text(_formatTime(_remainingTime), style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900)),
                        if (isAtoshuBaraku) const Text("ATOSHI BARAKU", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _controlBtn(Icons.play_arrow, Colors.green, _toggleTimer, active: !_isRunning && !_isMatchOver),
                _controlBtn(Icons.pause, Colors.orange, _toggleTimer, active: _isRunning && !_isMatchOver),
                _controlBtn(Icons.refresh, Colors.grey, () {
                  setState(() {
                    _remainingTime = widget.matchDuration;
                    _isMatchOver = false;
                    _isRunning = false;
                    akaScore = 0; aoScore = 0; akaWarnings = 0; aoWarnings = 0;
                    isAkaSenshu = false; isAoSenshu = false;
                    _senshuAlreadyAwarded = false;
                    matchLogs.clear();
                  });
                }, active: _isMatchOver || (_remainingTime.inSeconds == 0 && akaScore == 0)),
                _controlBtn(Icons.history, Colors.blueAccent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => KumiteLogScreen(
                        logs: matchLogs,
                        akaTotal: akaScore,
                        aoTotal: aoScore,
                        onClear: () => setState(() => matchLogs.clear()),
                      )));
                }, active: true),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildFighterColumn("AKA", const Color(0xFF4A0000), Colors.red, true, akaWins),
                _buildFighterColumn("AO", const Color(0xFF001A4A), Colors.blue, false, aoWins),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlBtn(IconData icon, Color color, VoidCallback onTap, {bool active = true}) {
    return IconButton(
        onPressed: active ? onTap : null,
        icon: Icon(icon, color: active ? color : color.withOpacity(0.1), size: 30));
  }

  Widget _buildFighterColumn(String label, Color bg, Color accent, bool isAka, bool isWinner) {
    int score = isAka ? akaScore : aoScore;
    int warnings = isAka ? akaWarnings : aoWarnings;
    bool hasSenshu = isAka ? isAkaSenshu : isAoSenshu;

    bool canInteract = !_isMatchOver && _remainingTime.inSeconds > 0;

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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (!canInteract || _senshuAlreadyAwarded)
                  ? null
                  : () => setState(() {
                        _senshuAlreadyAwarded = true;
                        if (isAka) {
                          isAkaSenshu = true;
                          isAoSenshu = false;
                          _addLog("AKA", "SENSHU", "MANUAL", Colors.red);
                        } else {
                          isAoSenshu = true;
                          isAkaSenshu = false;
                          _addLog("AO", "SENSHU", "MANUAL", Colors.blue);
                        }
                      }),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: accent.withOpacity(0.2),
                      child: const Icon(Icons.person, color: Colors.white24, size: 40)),
                  if (hasSenshu) ...[
                    const Positioned(top: 0, right: 0, child: Icon(Icons.stars, color: Colors.yellow, size: 30)),
                    Positioned(
                      top: -5,
                      right: -5,
                      child: GestureDetector(
                        onTap: !canInteract
                            ? null
                            : () => setState(() {
                                  if (isAka) isAkaSenshu = false; else isAoSenshu = false;
                                  _addLog(isAka ? "AKA" : "AO", "SENSHU REMOVED", "CANCEL", Colors.orange);
                                }),
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.remove_circle, color: canInteract ? Colors.red : Colors.transparent, size: 20),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: accent, fontSize: 32, fontWeight: FontWeight.w900)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: !canInteract
                        ? null
                        : () => setState(() {
                              if (isAka) { akaScore--; _addLog("AKA", "ADJUST", "-1", Colors.red); } 
                              else { aoScore--; _addLog("AO", "ADJUST", "-1", Colors.blue); }
                            }),
                    icon: Icon(Icons.remove_circle_outline, color: canInteract ? Colors.white24 : Colors.transparent)),
                SizedBox(
                    width: 90,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("$score", style: const TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.bold)))),
                IconButton(
                    onPressed: !canInteract
                        ? null
                        : () => setState(() {
                              if (isAka) { akaScore++; _addLog("AKA", "ADJUST", "+1", Colors.red); _checkAndAwardSenshu(true); } 
                              else { aoScore++; _addLog("AO", "ADJUST", "+1", Colors.blue); _checkAndAwardSenshu(false); }
                            }),
                    icon: Icon(Icons.add_circle_outline, color: canInteract ? Colors.white24 : Colors.transparent)),
              ],
            ),
            const Text("POINTS", style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 2)),
            const SizedBox(height: 20),
            _scoreBtn("IPPON +3", Colors.black26, !canInteract ? null : () {
              setState(() => isAka ? akaScore += 3 : aoScore += 3);
              _addLog(isAka ? "AKA" : "AO", "IPPON", "+3", accent);
              _checkAndAwardSenshu(isAka);
            }),
            _scoreBtn("WAZA +2", Colors.black26, !canInteract ? null : () {
              setState(() => isAka ? akaScore += 2 : aoScore += 2);
              _addLog(isAka ? "AKA" : "AO", "WAZA-ARI", "+2", accent);
              _checkAndAwardSenshu(isAka);
            }),
            _scoreBtn("YUKO +1", Colors.black26, !canInteract ? null : () {
              setState(() => isAka ? akaScore += 1 : aoScore += 1);
              _addLog(isAka ? "AKA" : "AO", "YUKO", "+1", accent);
              _checkAndAwardSenshu(isAka);
            }),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: !canInteract
                  ? null
                  : () => setState(() {
                        if (isAka) { akaWarnings = (akaWarnings + 1) % 5; _addLog("AKA", "WARNING", "C$akaWarnings", Colors.red); } 
                        else { aoWarnings = (aoWarnings + 1) % 5; _addLog("AO", "WARNING", "C$aoWarnings", Colors.blue); }
                      }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < warnings ? accent : Colors.transparent,
                          border: Border.all(color: i < warnings ? accent : Colors.white24, width: 2)),
                    )),
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _scoreBtn(String text, Color color, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: onTap == null ? color.withOpacity(0.05) : color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: onTap == null ? 0 : 2,
          ),
          onPressed: onTap,
          child: Text(text, style: TextStyle(color: onTap == null ? Colors.white10 : Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
