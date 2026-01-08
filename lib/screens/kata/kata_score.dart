import 'dart:async';
import 'package:flutter/material.dart';
import 'package:igka_tournament/screens/kata/kata_result.dart';

class KataScoringScreen extends StatefulWidget {
  const KataScoringScreen({super.key});

  @override
  State<KataScoringScreen> createState() => _KataScoringScreenState();
}

class _KataScoringScreenState extends State<KataScoringScreen> {
  // --- Updated: Initial score set to 0.0 and range adjusted ---
  double _currentScore = 0.0; 
  final double _minScore = 0.0;
  final double _maxScore = 10.0;

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_stopwatch.isRunning) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  String _formatTime() {
    final minutes = _stopwatch.elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

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
        title: const Text("Kata Scoring", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.history, color: Colors.red)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildParticipantCard(),
                  const SizedBox(height: 20),
                  _buildDynamicScoringCard(),
                  const SizedBox(height: 20),
                  _buildDynamicTimerCard(),
                ],
              ),
            ),
          ),
          _buildActionFooter(),
        ],
      ),
    );
  }

  Widget _buildParticipantCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF251818),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 3),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  // Using a placeholder image for Kenji Sato
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=abc'), 
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: const Text("AKA", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 15),
          const Text("Kenji Sato", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Bassai Dai • Black Belt", style: TextStyle(color: Colors.red, fontSize: 16)),
          const Text("EAGLE DOJO", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _buildDynamicScoringCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF251818),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("OVERALL SCORE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                child: const Text("0.0 - 10.0", style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _scoreControlButton(Icons.remove, () {
                if (_currentScore > _minScore) setState(() => _currentScore = (_currentScore - 0.1).clamp(0.0, 10.0));
              }, isMinus: true),
              Text(
                _currentScore.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w900),
              ),
              _scoreControlButton(Icons.add, () {
                if (_currentScore < _maxScore) setState(() => _currentScore = (_currentScore + 0.1).clamp(0.0, 10.0));
              }, isMinus: false),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbColor: Colors.red,
              activeTrackColor: Colors.red,
              inactiveTrackColor: Colors.white10,
              trackHeight: 4,
            ),
            child: Slider(
              value: _currentScore,
              min: _minScore,
              max: _maxScore,
              divisions: 100, // Provides 0.1 increments for the 0-10 range
              onChanged: (value) => setState(() => _currentScore = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTimerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF251818),
        borderRadius: BorderRadius.circular(20),
        border: const Border(left: BorderSide(color: Colors.red, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("PERFORMANCE TIME", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(_formatTime(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _stopwatch.reset()),
                icon: const Icon(Icons.refresh, color: Colors.grey),
              ),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => setState(() => _stopwatch.isRunning ? _stopwatch.stop() : _stopwatch.start()),
                icon: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(color: Color(0xFF1A0F0F)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Score", style: TextStyle(color: Colors.grey, fontSize: 18)),
              Text(_currentScore.toStringAsFixed(1), style: const TextStyle(color: Colors.red, fontSize: 48, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: 60,
                width: 80,
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  onPressed: () => setState(() => _currentScore = 0.0), 
                  icon: const Icon(Icons.refresh, color: Colors.white)
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KataResultScreen(),
                      ),
                    );
                  },
                  icon: const Text("Submit Score", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  label: const Icon(Icons.check_circle, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreControlButton(IconData icon, VoidCallback tap, {required bool isMinus}) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isMinus ? Colors.white.withOpacity(0.05) : Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: Colors.white, size: 35),
      ),
    );
  }
}